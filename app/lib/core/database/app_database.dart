import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Local SQLite database and the app's single source of truth.
///
/// Screens never read from the network directly: they watch queries on this
/// database, and the sync engine keeps it in step with the server.
@DriftDatabase(
  tables: [Transactions, Goals, Groups, GroupMembers, GroupExpenses, Settlements, BillReminders, SyncQueue, SyncMeta],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Wipes everything, used on sign out so the next user starts clean.
  Future<void> clearAll() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'wealthmate',
      // The Workmanager isolate opens the same file; sharing avoids lock contention.
      native: const DriftNativeOptions(shareAcrossIsolates: true),
      web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js')),
    );
  }
}
