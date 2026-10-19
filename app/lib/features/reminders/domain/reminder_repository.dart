import 'bill_reminder.dart';

abstract interface class ReminderRepository {
  Stream<List<BillReminder>> watchAll();

  /// Inserts or updates, schedules the notification, and returns the stored reminder.
  Future<BillReminder> save(BillReminder reminder);

  Future<void> delete(BillReminder reminder);
}

/// Wraps local notifications so the rest of the app (and tests) don't depend
/// on the plugin directly.
abstract interface class ReminderNotifier {
  Future<void> initialise();

  Future<void> scheduleMonthly(BillReminder reminder);

  Future<void> cancel(int reminderId);
}
