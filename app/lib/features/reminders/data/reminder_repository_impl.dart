import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../domain/bill_reminder.dart';
import '../domain/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._db, this._notifier);

  final AppDatabase _db;
  final ReminderNotifier _notifier;

  @override
  Stream<List<BillReminder>> watchAll() {
    final query = _db.select(_db.billReminders)..orderBy([(r) => OrderingTerm.asc(r.dayOfMonth)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<BillReminder> save(BillReminder reminder) async {
    final companion = BillRemindersCompanion(
      id: reminder.id == null ? const Value.absent() : Value(reminder.id!),
      title: Value(reminder.title.trim()),
      amountMinor: Value(reminder.amount.minor),
      dayOfMonth: Value(reminder.dayOfMonth),
      enabled: Value(reminder.enabled),
    );
    final id = await _db.into(_db.billReminders).insertOnConflictUpdate(companion);
    final saved = reminder.copyWith(id: reminder.id ?? id);

    if (saved.enabled) {
      await _notifier.scheduleMonthly(saved);
    } else {
      await _notifier.cancel(saved.id!);
    }
    return saved;
  }

  @override
  Future<void> delete(BillReminder reminder) async {
    if (reminder.id == null) return;
    await (_db.delete(_db.billReminders)..where((r) => r.id.equals(reminder.id!))).go();
    await _notifier.cancel(reminder.id!);
  }

  BillReminder _toEntity(BillReminderRow row) {
    return BillReminder(
      id: row.id,
      title: row.title,
      amount: Money(row.amountMinor),
      dayOfMonth: row.dayOfMonth,
      enabled: row.enabled,
    );
  }
}
