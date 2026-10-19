import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/money/money.dart';
import '../../../core/sync/sync_handler.dart';
import '../../../core/sync/synced_writer.dart';
import '../domain/algorithms/debt_simplifier.dart';
import '../domain/entities/group_entities.dart';
import '../domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl({
    required AppDatabase db,
    required SyncedWriter writer,
    required SyncHandlers handlers,
    required String Function() newId,
    DebtSimplifier simplifier = const DebtSimplifier(),
    DateTime Function()? clock,
  }) : _db = db,
       _writer = writer,
       _handlers = handlers,
       _newId = newId,
       _simplifier = simplifier,
       _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SyncedWriter _writer;
  final SyncHandlers _handlers;
  final String Function() _newId;
  final DebtSimplifier _simplifier;
  final DateTime Function() _clock;

  int get _now => _clock().millisecondsSinceEpoch;

  /// Re-runs [load] whenever any group table changes. Group screens combine
  /// four tables, so this is simpler than merging four separate watch streams.
  Stream<T> _watchGroupTables<T>(Future<T> Function() load) async* {
    yield await load();
    final updates = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.groups, _db.groupMembers, _db.groupExpenses, _db.settlements]),
    );
    await for (final _ in updates) {
      yield await load();
    }
  }

  @override
  Stream<List<GroupSummary>> watchGroups() => _watchGroupTables(_loadSummaries);

  Future<List<GroupSummary>> _loadSummaries() async {
    final groups =
        await (_db.select(_db.groups)
              ..where((g) => g.deleted.equals(false))
              ..orderBy([(g) => OrderingTerm.desc(g.updatedAt)]))
            .get();
    final members = await (_db.select(_db.groupMembers)..where((m) => m.deleted.equals(false))).get();
    final expenses = await (_db.select(_db.groupExpenses)..where((e) => e.deleted.equals(false))).get();

    // One pass each over members and expenses: O(g + m + e) instead of a query per group.
    final memberCounts = <String, int>{};
    for (final m in members) {
      memberCounts.update(m.groupId, (c) => c + 1, ifAbsent: () => 1);
    }
    final totals = <String, int>{};
    for (final e in expenses) {
      totals.update(e.groupId, (t) => t + e.amountMinor, ifAbsent: () => e.amountMinor);
    }

    return [
      for (final g in groups)
        GroupSummary(
          group: _group(g),
          memberCount: memberCounts[g.id] ?? 0,
          totalSpent: Money(totals[g.id] ?? 0, currency: g.currency),
        ),
    ];
  }

  @override
  Stream<GroupDetails?> watchDetails(String groupId) => _watchGroupTables(() => _loadDetails(groupId));

  Future<GroupDetails?> _loadDetails(String groupId) async {
    final row = await (_db.select(
      _db.groups,
    )..where((g) => g.id.equals(groupId) & g.deleted.equals(false))).getSingleOrNull();
    if (row == null) return null;

    final memberRows = await (_db.select(
      _db.groupMembers,
    )..where((m) => m.groupId.equals(groupId) & m.deleted.equals(false))).get();
    final expenseRows =
        await (_db.select(_db.groupExpenses)
              ..where((e) => e.groupId.equals(groupId) & e.deleted.equals(false))
              ..orderBy([(e) => OrderingTerm.desc(e.occurredAt)]))
            .get();
    final settlementRows =
        await (_db.select(_db.settlements)
              ..where((s) => s.groupId.equals(groupId) & s.deleted.equals(false))
              ..orderBy([(s) => OrderingTerm.desc(s.occurredAt)]))
            .get();

    final members = [for (final m in memberRows) GroupMember(id: m.id, groupId: m.groupId, name: m.name)];
    final expenses = [for (final e in expenseRows) _expense(e)];
    final settlements = [for (final s in settlementRows) _settlement(s)];
    final balances = DebtSimplifier.balances(
      memberIds: members.map((m) => m.id),
      expenses: expenses,
      settlements: settlements,
    );

    return GroupDetails(
      group: _group(row),
      members: members,
      expenses: expenses,
      settlements: settlements,
      balances: balances,
      transfers: _simplifier.simplify(balances),
    );
  }

  @override
  Future<Result<String>> createGroup(String name, List<String> memberNames) async {
    final names = memberNames.map((n) => n.trim()).where((n) => n.isNotEmpty).toList();
    if (name.trim().isEmpty) return const Err(ValidationFailure('Give the group a name'));
    if (names.length < 2) return const Err(ValidationFailure('A group needs at least two members'));

    final groupId = _newId();
    final now = _now;
    try {
      await _writer.batch(() async {
        await _writer.save(
          _handlers.groups,
          GroupRow(id: groupId, name: name.trim(), currency: 'INR', updatedAt: now, deleted: false),
        );
        for (final memberName in names) {
          await _writer.save(
            _handlers.groupMembers,
            GroupMemberRow(id: _newId(), groupId: groupId, name: memberName, updatedAt: now, deleted: false),
          );
        }
      });
      return Ok(groupId);
    } catch (_) {
      return const Err(StorageFailure());
    }
  }

  @override
  Future<Result<void>> addMember(String groupId, String name) async {
    if (name.trim().isEmpty) return const Err(ValidationFailure('Enter a name'));
    return _guard(
      () => _writer.save(
        _handlers.groupMembers,
        GroupMemberRow(id: _newId(), groupId: groupId, name: name.trim(), updatedAt: _now, deleted: false),
      ),
    );
  }

  @override
  Future<Result<void>> addExpense({
    required String groupId,
    required String description,
    required Money amount,
    required String paidBy,
    required SplitType splitType,
    required Map<String, int> shares,
  }) async {
    if (description.trim().isEmpty) return const Err(ValidationFailure('Add a description'));
    if (!amount.isPositive) return const Err(ValidationFailure('Amount must be greater than zero'));
    final total = shares.values.fold(0, (a, b) => a + b);
    if (shares.isEmpty || total != amount.minor) {
      return const Err(ValidationFailure('Shares must add up to the full amount'));
    }

    return _guard(
      () => _writer.save(
        _handlers.groupExpenses,
        GroupExpenseRow(
          id: _newId(),
          groupId: groupId,
          description: description.trim(),
          amountMinor: amount.minor,
          paidBy: paidBy,
          splitType: splitType.name,
          shares: jsonEncode(shares),
          occurredAt: _now,
          updatedAt: _now,
          deleted: false,
        ),
      ),
    );
  }

  @override
  Future<Result<void>> deleteExpense(GroupExpense expense) async {
    final row = await (_db.select(_db.groupExpenses)..where((e) => e.id.equals(expense.id))).getSingleOrNull();
    if (row == null) return const Err(ValidationFailure('Expense not found'));
    return _guard(() => _writer.save(_handlers.groupExpenses, row.copyWith(deleted: true, updatedAt: _now)));
  }

  @override
  Future<Result<void>> recordSettlement({
    required String groupId,
    required String from,
    required String to,
    required Money amount,
  }) async {
    if (from == to) return const Err(ValidationFailure('Pick two different members'));
    if (!amount.isPositive) return const Err(ValidationFailure('Amount must be greater than zero'));
    return _guard(
      () => _writer.save(
        _handlers.settlements,
        SettlementRow(
          id: _newId(),
          groupId: groupId,
          fromMember: from,
          toMember: to,
          amountMinor: amount.minor,
          occurredAt: _now,
          updatedAt: _now,
          deleted: false,
        ),
      ),
    );
  }

  @override
  Future<Result<void>> deleteGroup(String groupId) async {
    final row = await (_db.select(_db.groups)..where((g) => g.id.equals(groupId))).getSingleOrNull();
    if (row == null) return const Err(ValidationFailure('Group not found'));
    return _guard(() => _writer.save(_handlers.groups, row.copyWith(deleted: true, updatedAt: _now)));
  }

  Future<Result<void>> _guard(Future<void> Function() write) async {
    try {
      await write();
      return const Ok(null);
    } catch (_) {
      return const Err(StorageFailure());
    }
  }

  Group _group(GroupRow r) {
    return Group(
      id: r.id,
      name: r.name,
      currency: r.currency,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
    );
  }

  GroupExpense _expense(GroupExpenseRow r) {
    final shares = (jsonDecode(r.shares) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int));
    return GroupExpense(
      id: r.id,
      groupId: r.groupId,
      description: r.description,
      amount: Money(r.amountMinor),
      paidBy: r.paidBy,
      splitType: SplitType.values.byName(r.splitType),
      shares: shares,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(r.occurredAt),
    );
  }

  Settlement _settlement(SettlementRow r) {
    return Settlement(
      id: r.id,
      groupId: r.groupId,
      fromMember: r.fromMember,
      toMember: r.toMember,
      amount: Money(r.amountMinor),
      occurredAt: DateTime.fromMillisecondsSinceEpoch(r.occurredAt),
    );
  }
}
