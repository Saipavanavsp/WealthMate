import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../database/app_database.dart';
import 'sync_handler.dart';
import 'sync_queue.dart';
import 'sync_remote_data_source.dart';

class SyncReport extends Equatable {
  const SyncReport({this.pushed = 0, this.conflicts = 0, this.rejected = 0, this.pulled = 0});

  final int pushed;
  final int conflicts;
  final int rejected;
  final int pulled;

  @override
  List<Object?> get props => [pushed, conflicts, rejected, pulled];
}

/// Two-phase sync: push the outbox, then pull everything newer than the
/// last cursor.
///
/// Conflict strategy is last-write-wins on `updatedAt`:
///  * Push: the server applies a change only if it is strictly newer than its
///    copy. Otherwise it answers `conflict` with its copy, which we store locally.
///  * Pull: a remote row overwrites the local one unless the local row has a
///    pending change with a newer `updatedAt`; that change wins on the next push.
///
/// Only one sync runs at a time. A call made while one is running gets the
/// same future instead of starting a second, overlapping run.
class SyncEngine {
  SyncEngine({
    required AppDatabase db,
    required SyncQueueStore queue,
    required SyncRemoteDataSource remote,
    required Map<String, SyncHandler<Table, DataClass>> handlers,
    this.batchSize = 100,
  }) : _db = db,
       _queue = queue,
       _remote = remote,
       _handlers = handlers;

  final AppDatabase _db;
  final SyncQueueStore _queue;
  final SyncRemoteDataSource _remote;
  final Map<String, SyncHandler<Table, DataClass>> _handlers;
  final int batchSize;

  static const _cursorKey = 'pull_cursor';

  Future<SyncReport>? _running;

  bool get isRunning => _running != null;

  Future<SyncReport> sync() {
    return _running ??= _run().whenComplete(() => _running = null);
  }

  Future<SyncReport> _run() async {
    final push = await _pushAll();
    final pulled = await _pull();
    return SyncReport(pushed: push.pushed, conflicts: push.conflicts, rejected: push.rejected, pulled: pulled);
  }

  Future<SyncReport> _pushAll() async {
    var pushed = 0;
    var conflicts = 0;
    var rejected = 0;
    final seen = <int>{};

    while (true) {
      // Skip entries already handled in this run (e.g. re-queued by an edit
      // made mid-push) so a busy user can't keep the loop going forever.
      final batch = (await _queue.nextBatch(limit: batchSize)).where((e) => !seen.contains(e.id)).toList();
      if (batch.isEmpty) break;
      seen.addAll(batch.map((e) => e.id));

      final results = await _remote.push(batch);
      final byId = {for (final e in batch) e.id: e};

      await _db.transaction(() async {
        for (final result in results) {
          final entry = byId[result.changeId];
          if (entry == null) continue;
          switch (result.status) {
            case PushStatus.applied:
              pushed++;
              await _queue.acknowledge(entry);
            case PushStatus.conflict:
              conflicts++;
              // Only take the server copy if nothing newer was queued meanwhile.
              if (await _queue.acknowledge(entry) && result.record != null) {
                await _applyRemote(entry.entity, result.record!, force: true);
              }
            case PushStatus.rejected:
              rejected++;
              await _queue.markFailed(entry, result.reason ?? 'Rejected by server');
          }
        }
      });
    }
    return SyncReport(pushed: pushed, conflicts: conflicts, rejected: rejected);
  }

  Future<int> _pull() async {
    final since = await _readCursor();
    final response = await _remote.pull(since);
    var applied = 0;
    await _db.transaction(() async {
      for (final MapEntry(key: entity, value: records) in response.changes.entries) {
        for (final record in records) {
          if (await _applyRemote(entity, record)) applied++;
        }
      }
      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(SyncMetaCompanion.insert(key: _cursorKey, value: '${response.cursor}'));
    });
    return applied;
  }

  /// Writes a server record locally. Returns false if the local copy won.
  Future<bool> _applyRemote(String entity, Map<String, dynamic> record, {bool force = false}) async {
    final handler = _handlers[entity];
    if (handler == null) return false;

    final id = record['id'] as String;
    if (!force && await _queue.hasPending(entity, id)) {
      final localUpdatedAt = await handler.localUpdatedAt(_db, id);
      if (localUpdatedAt != null && localUpdatedAt > (record['updatedAt'] as int)) return false;
    }
    await handler.write(_db, handler.rowFromApi(record));
    return true;
  }

  Future<int> _readCursor() async {
    final row = await (_db.select(_db.syncMeta)..where((m) => m.key.equals(_cursorKey))).getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }
}
