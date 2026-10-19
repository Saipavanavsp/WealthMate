import 'package:drift/drift.dart';

/// Columns shared by every table that syncs with the server.
/// Timestamps are epoch milliseconds to match the API exactly.
mixin SyncColumns on Table {
  TextColumn get id => text()();
  IntColumn get updatedAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TransactionRow')
@TableIndex(name: 'idx_transactions_occurred_at', columns: {#occurredAt})
class Transactions extends Table with SyncColumns {
  TextColumn get type => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get category => text()();
  TextColumn get merchant => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get occurredAt => integer()();
  TextColumn get recurrence => text().withDefault(const Constant('none'))();
}

@DataClassName('GoalRow')
class Goals extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get targetMinor => integer()();
  IntColumn get savedMinor => integer().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get deadline => integer()();
}

@DataClassName('GroupRow')
class Groups extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
}

@DataClassName('GroupMemberRow')
@TableIndex(name: 'idx_group_members_group', columns: {#groupId})
class GroupMembers extends Table with SyncColumns {
  TextColumn get groupId => text()();
  TextColumn get name => text()();
}

@DataClassName('GroupExpenseRow')
@TableIndex(name: 'idx_group_expenses_group', columns: {#groupId})
class GroupExpenses extends Table with SyncColumns {
  TextColumn get groupId => text()();
  TextColumn get description => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get paidBy => text()();
  TextColumn get splitType => text()();

  /// JSON object of memberId -> owed amount in minor units.
  TextColumn get shares => text()();
  IntColumn get occurredAt => integer()();
}

@DataClassName('SettlementRow')
@TableIndex(name: 'idx_settlements_group', columns: {#groupId})
class Settlements extends Table with SyncColumns {
  TextColumn get groupId => text()();
  TextColumn get fromMember => text()();
  TextColumn get toMember => text()();
  IntColumn get amountMinor => integer()();
  IntColumn get occurredAt => integer()();
}

/// Bill reminders only live on the device, so they don't carry sync columns.
@DataClassName('BillReminderRow')
class BillReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get amountMinor => integer()();
  IntColumn get dayOfMonth => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

/// Outbox of local changes waiting to be pushed.
///
/// The autoincrement [id] gives a strict FIFO order. There is at most one
/// row per record: a second edit to the same record overwrites the payload
/// and bumps [revision] but keeps the original position in the queue.
@DataClassName('OutboxEntry')
@TableIndex(name: 'idx_sync_queue_record', columns: {#entity, #recordId}, unique: true)
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get recordId => text()();
  TextColumn get payload => text()();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAt => integer()();
}

/// Small key/value store for sync bookkeeping such as the pull cursor.
@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
