import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_handler.dart';
import '../../../core/sync/sync_queue.dart';
import '../../../core/sync/synced_writer.dart';
import '../../transactions/data/transaction_repository_impl.dart';
import '../../transactions/domain/recurring/recurring_scheduler.dart';

const recurringTaskName = 'wealthmate.recurring';

/// Entry point for Workmanager. It runs in a fresh background isolate, so it
/// opens its own database connection instead of using the app's DI graph.
@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task != recurringTaskName) return true;
    final db = AppDatabase();
    try {
      final repo = TransactionRepositoryImpl(
        db: db,
        writer: SyncedWriter(db, SyncQueueStore(db)),
        handlers: SyncHandlers(db),
        scheduler: RecurringScheduler(newId: const Uuid().v4),
      );
      final created = await repo.generateDueRecurring(DateTime.now());
      debugPrint('Background task created $created recurring transactions');
      return true;
    } catch (e) {
      debugPrint('Background task failed: $e');
      return false;
    } finally {
      await db.close();
    }
  });
}

/// Registers the twice-daily background job on Android. iOS needs BGTaskScheduler
/// setup in AppDelegate as well, so there the same work runs on app start instead.
Future<void> registerBackgroundTasks() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
  await Workmanager().initialize(backgroundDispatcher);
  await Workmanager().registerPeriodicTask(
    recurringTaskName,
    recurringTaskName,
    frequency: const Duration(hours: 12),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
