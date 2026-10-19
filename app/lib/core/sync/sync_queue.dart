import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Read/write access to the outbox table.
///
/// Ordering guarantee: entries are handed out in insertion (id) order, and an
/// edit to a record that is already queued keeps that record's original slot.
/// So a record is never pushed before anything that was created before it.
///
/// Complexity: enqueue is one indexed upsert, O(log n). Taking a batch is an
/// index range scan, O(k + log n) for k entries.
class SyncQueueStore {
  SyncQueueStore(this._db);

  final AppDatabase _db;

  static const maxAttempts = 5;

  /// Adds or replaces the pending change for ([entity], [recordId]).
  /// Call this inside the same transaction as the local write.
  Future<void> enqueue(String entity, String recordId, Map<String, Object?> payload) {
    final table = _db.syncQueue;
    return _db
        .into(table)
        .insert(
          SyncQueueCompanion.insert(
            entity: entity,
            recordId: recordId,
            payload: jsonEncode(payload),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
          onConflict: DoUpdate.withExcluded(
            (old, excluded) => SyncQueueCompanion.custom(
              payload: excluded.payload,
              revision: old.revision + const Constant(1),
              attempts: const Constant(0),
              lastError: const Constant(null),
            ),
            target: [table.entity, table.recordId],
          ),
        );
  }

  Future<List<OutboxEntry>> nextBatch({int limit = 100}) {
    final table = _db.syncQueue;
    return (_db.select(table)
          ..where((e) => e.attempts.isSmallerThanValue(maxAttempts))
          ..orderBy([(e) => OrderingTerm.asc(e.id)])
          ..limit(limit))
        .get();
  }

  /// Removes an entry after the server accepted it. If the record was edited
  /// again while the push was in flight the revision won't match, so the
  /// newer change stays queued.
  Future<bool> acknowledge(OutboxEntry entry) async {
    final table = _db.syncQueue;
    final removed = await (_db.delete(
      table,
    )..where((e) => e.id.equals(entry.id) & e.revision.equals(entry.revision))).go();
    return removed > 0;
  }

  Future<void> markFailed(OutboxEntry entry, String error) {
    final table = _db.syncQueue;
    return (_db.update(table)..where((e) => e.id.equals(entry.id) & e.revision.equals(entry.revision))).write(
      SyncQueueCompanion(attempts: Value(entry.attempts + 1), lastError: Value(error)),
    );
  }

  Future<bool> hasPending(String entity, String recordId) async {
    final table = _db.syncQueue;
    final row = await (_db.select(
      table,
    )..where((e) => e.entity.equals(entity) & e.recordId.equals(recordId))).getSingleOrNull();
    return row != null;
  }

  Stream<int> watchPendingCount() {
    final table = _db.syncQueue;
    final count = table.id.count();
    return (_db.selectOnly(table)..addColumns([count])).map((row) => row.read(count) ?? 0).watchSingle();
  }

  /// Entries that hit [maxAttempts] and are no longer retried automatically.
  Future<List<OutboxEntry>> failedEntries() {
    final table = _db.syncQueue;
    return (_db.select(table)..where((e) => e.attempts.isBiggerOrEqualValue(maxAttempts))).get();
  }
}
