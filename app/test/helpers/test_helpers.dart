import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:wealthmate/core/database/app_database.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/core/sync/sync_remote_data_source.dart';
import 'package:wealthmate/features/goals/domain/entities/savings_goal.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';

AppDatabase inMemoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

TransactionEntry tx({
  String id = 't1',
  int amount = 10000,
  TransactionType type = TransactionType.expense,
  String category = 'Food',
  String? merchant,
  DateTime? at,
  Recurrence recurrence = Recurrence.none,
}) {
  final when = at ?? DateTime(2026, 10, 10);
  return TransactionEntry(
    id: id,
    type: type,
    amount: Money(amount),
    category: category,
    merchant: merchant,
    occurredAt: when,
    recurrence: recurrence,
    updatedAt: when,
  );
}

/// A transaction as the server would send it.
extension RemoteJson on TransactionEntry {
  Map<String, dynamic> toRemoteJson(int updatedAt) => {
    'id': id,
    'type': type.name,
    'amountMinor': amount.minor,
    'currency': amount.currency,
    'category': category,
    'merchant': merchant,
    'note': note,
    'occurredAt': occurredAt.millisecondsSinceEpoch,
    'recurrence': recurrence.name,
    'updatedAt': updatedAt,
    'deleted': false,
  };
}

SavingsGoal goal({String id = 'g1', int target = 100000, int saved = 0, DateTime? deadline}) {
  return SavingsGoal(
    id: id,
    name: 'Goal $id',
    target: Money(target),
    saved: Money(saved),
    deadline: deadline ?? DateTime(2027, 4),
    updatedAt: DateTime(2026),
  );
}

/// In-memory stand-in for the backend's sync endpoints, applying the same
/// last-write-wins rule, so sync tests exercise real conflict behaviour.
class FakeSyncServer implements SyncRemoteDataSource {
  final Map<String, Map<String, Map<String, dynamic>>> tables = {};
  final Map<String, int> _seqOf = {};
  int _seq = 0;
  int pushCalls = 0;
  bool offline = false;

  /// Simulates an edit made on another device.
  void serverWrite(String entity, Map<String, dynamic> record) {
    final table = tables.putIfAbsent(entity, () => {});
    table[record['id'] as String] = record;
    _seqOf['$entity/${record['id']}'] = ++_seq;
  }

  @override
  Future<List<PushResult>> push(List<OutboxEntry> entries) async {
    if (offline) throw Exception('offline');
    pushCalls++;
    return [for (final e in entries) _apply(e.id, e.entity, jsonDecode(e.payload) as Map<String, dynamic>)];
  }

  PushResult _apply(int changeId, String entity, Map<String, dynamic> record) {
    if ((record['amountMinor'] as int? ?? 0) < 0) {
      return PushResult(changeId: changeId, status: PushStatus.rejected, reason: 'negative amount');
    }
    final table = tables.putIfAbsent(entity, () => {});
    final existing = table[record['id']];
    if (existing != null && (existing['updatedAt'] as int) >= (record['updatedAt'] as int)) {
      return PushResult(changeId: changeId, status: PushStatus.conflict, record: existing);
    }
    serverWrite(entity, record);
    return PushResult(changeId: changeId, status: PushStatus.applied, record: record);
  }

  @override
  Future<PullResponse> pull(int since) async {
    if (offline) throw Exception('offline');
    final changes = <String, List<Map<String, dynamic>>>{};
    for (final MapEntry(key: entity, value: rows) in tables.entries) {
      for (final row in rows.values) {
        if (_seqOf['$entity/${row['id']}']! > since) changes.putIfAbsent(entity, () => []).add(row);
      }
    }
    return PullResponse(changes: changes, cursor: _seq);
  }
}
