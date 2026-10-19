import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'sync_handler.dart';
import 'sync_queue.dart';

/// The one place repositories write synced data through.
///
/// The row and its outbox entry are written in a single transaction, so a
/// crash can never leave a local change that the server will not hear about.
class SyncedWriter {
  SyncedWriter(this._db, this._queue);

  final AppDatabase _db;
  final SyncQueueStore _queue;

  Future<void> save<T extends Table, D extends DataClass>(SyncHandler<T, D> handler, D row) {
    return _db.transaction(() async {
      await handler.write(_db, row);
      await _queue.enqueue(handler.entity, handler.idOf(row), handler.toPayload(row));
    });
  }

  Future<void> saveAll<T extends Table, D extends DataClass>(SyncHandler<T, D> handler, Iterable<D> rows) {
    return _db.transaction(() async {
      for (final row in rows) {
        await save(handler, row);
      }
    });
  }

  /// Runs several saves atomically, e.g. a group plus its members.
  Future<R> batch<R>(Future<R> Function() work) => _db.transaction(work);
}
