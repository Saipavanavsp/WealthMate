import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Knows how to move one table's rows to and from the sync API.
///
/// Drift row classes already serialise to camelCase JSON that matches the API,
/// so most tables need no custom mapping. Group expenses override the hooks
/// because `shares` is stored as a JSON string but sent as an object.
class SyncHandler<T extends Table, D extends DataClass> {
  SyncHandler({
    required this.entity,
    required this.table,
    required this.fromJson,
    Map<String, Object?> Function(Map<String, Object?> json)? toApi,
    Map<String, Object?> Function(Map<String, Object?> json)? fromApi,
  }) : _toApi = toApi ?? _identity,
       _fromApi = fromApi ?? _identity;

  /// Entity name used by the server, e.g. `groupExpenses`.
  final String entity;
  final TableInfo<T, D> table;
  final D Function(Map<String, dynamic> json) fromJson;
  final Map<String, Object?> Function(Map<String, Object?> json) _toApi;
  final Map<String, Object?> Function(Map<String, Object?> json) _fromApi;

  static Map<String, Object?> _identity(Map<String, Object?> json) => json;

  Map<String, Object?> toPayload(D row) => _toApi(row.toJson());

  D rowFromApi(Map<String, Object?> json) => fromJson(_fromApi(json));

  String idOf(D row) => row.toJson()['id']! as String;

  Future<int?> localUpdatedAt(AppDatabase db, String id) async {
    final row = await db
        .customSelect(
          'SELECT updated_at FROM ${table.actualTableName} WHERE id = ?',
          variables: [Variable.withString(id)],
          readsFrom: {table},
        )
        .getSingleOrNull();
    return row?.read<int>('updated_at');
  }

  Future<void> write(AppDatabase db, D row) {
    return db.into(table).insertOnConflictUpdate(row as Insertable<D>);
  }
}

/// Typed handlers for every synced table.
class SyncHandlers {
  SyncHandlers(AppDatabase db)
    : transactions = SyncHandler(entity: 'transactions', table: db.transactions, fromJson: TransactionRow.fromJson),
      goals = SyncHandler(entity: 'goals', table: db.goals, fromJson: GoalRow.fromJson),
      groups = SyncHandler(entity: 'groups', table: db.groups, fromJson: GroupRow.fromJson),
      groupMembers = SyncHandler(entity: 'groupMembers', table: db.groupMembers, fromJson: GroupMemberRow.fromJson),
      groupExpenses = SyncHandler(
        entity: 'groupExpenses',
        table: db.groupExpenses,
        fromJson: GroupExpenseRow.fromJson,
        toApi: (json) => {...json, 'shares': jsonDecode(json['shares']! as String)},
        fromApi: (json) => {...json, 'shares': jsonEncode(json['shares'])},
      ),
      settlements = SyncHandler(entity: 'settlements', table: db.settlements, fromJson: SettlementRow.fromJson);

  final SyncHandler<$TransactionsTable, TransactionRow> transactions;
  final SyncHandler<$GoalsTable, GoalRow> goals;
  final SyncHandler<$GroupsTable, GroupRow> groups;
  final SyncHandler<$GroupMembersTable, GroupMemberRow> groupMembers;
  final SyncHandler<$GroupExpensesTable, GroupExpenseRow> groupExpenses;
  final SyncHandler<$SettlementsTable, SettlementRow> settlements;

  /// Keyed by the entity name the server uses.
  Map<String, SyncHandler<Table, DataClass>> get byEntity => {
    for (final h in <SyncHandler<Table, DataClass>>[
      transactions,
      goals,
      groups,
      groupMembers,
      groupExpenses,
      settlements,
    ])
      h.entity: h,
  };
}
