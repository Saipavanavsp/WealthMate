import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/core/database/app_database.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/core/sync/sync_engine.dart';
import 'package:wealthmate/core/sync/sync_handler.dart';
import 'package:wealthmate/core/sync/sync_queue.dart';
import 'package:wealthmate/core/sync/synced_writer.dart';
import 'package:wealthmate/features/transactions/data/transaction_repository_impl.dart';
import 'package:wealthmate/features/transactions/domain/recurring/recurring_scheduler.dart';

import '../helpers/test_helpers.dart';

void main() {
  late AppDatabase db;
  late SyncQueueStore queue;
  late SyncHandlers handlers;
  late FakeSyncServer server;
  late SyncEngine engine;
  late TransactionRepositoryImpl repo;
  var clock = DateTime(2026, 10, 10, 12);

  setUp(() {
    db = inMemoryDatabase();
    queue = SyncQueueStore(db);
    handlers = SyncHandlers(db);
    server = FakeSyncServer();
    engine = SyncEngine(db: db, queue: queue, remote: server, handlers: handlers.byEntity, batchSize: 2);
    clock = DateTime(2026, 10, 10, 12);
    repo = TransactionRepositoryImpl(
      db: db,
      writer: SyncedWriter(db, queue),
      handlers: handlers,
      scheduler: RecurringScheduler(newId: () => 'r'),
      clock: () => clock,
    );
  });

  tearDown(() => db.close());

  group('SyncQueueStore', () {
    test('keeps FIFO order and coalesces edits to the same record', () async {
      await queue.enqueue('transactions', 'a', {'v': 1});
      await queue.enqueue('transactions', 'b', {'v': 1});
      await queue.enqueue('transactions', 'a', {'v': 2});

      final batch = await queue.nextBatch();
      expect(batch.map((e) => e.recordId), ['a', 'b']);
      expect(batch.first.payload, '{"v":2}');
      expect(batch.first.revision, 2);
    });

    test('acknowledge keeps an entry that was edited while in flight', () async {
      await queue.enqueue('transactions', 'a', {'v': 1});
      final inFlight = (await queue.nextBatch()).single;
      await queue.enqueue('transactions', 'a', {'v': 2});

      expect(await queue.acknowledge(inFlight), isFalse);
      expect((await queue.nextBatch()).single.payload, '{"v":2}');
    });

    test('failed entries stop being retried after max attempts', () async {
      await queue.enqueue('transactions', 'a', {'v': 1});
      for (var i = 0; i < SyncQueueStore.maxAttempts; i++) {
        await queue.markFailed((await queue.nextBatch()).single, 'bad');
      }
      expect(await queue.nextBatch(), isEmpty);
      expect(await queue.failedEntries(), hasLength(1));
    });

    test('watchPendingCount follows the queue', () async {
      final counts = <int>[];
      final sub = queue.watchPendingCount().listen(counts.add);
      await pumpEventQueue();
      await queue.enqueue('transactions', 'a', {});
      await pumpEventQueue();
      await sub.cancel();
      expect(counts, [0, 1]);
    });
  });

  group('SyncEngine', () {
    test('pushes local writes in batches and empties the queue', () async {
      for (var i = 0; i < 5; i++) {
        await repo.save(tx(id: 't$i', amount: 100 + i));
      }
      final report = await engine.sync();

      expect(report.pushed, 5);
      expect(server.pushCalls, 3, reason: 'batch size is 2');
      expect(server.tables['transactions'], hasLength(5));
      expect(await queue.nextBatch(), isEmpty);
    });

    test('pulls remote changes and advances the cursor', () async {
      server.serverWrite('transactions', tx(id: 'remote', amount: 4200).toRemoteJson(1000));
      final first = await engine.sync();
      expect(first.pulled, 1);
      expect((await repo.findById('remote'))!.amount, const Money(4200));

      final second = await engine.sync();
      expect(second.pulled, 0, reason: 'nothing new since the saved cursor');
    });

    test('server copy wins when it is newer (push conflict)', () async {
      await repo.save(tx(id: 'x', amount: 100));
      server.serverWrite('transactions', tx(id: 'x', amount: 999).toRemoteJson(clock.millisecondsSinceEpoch + 1));

      final report = await engine.sync();
      expect(report.conflicts, 1);
      expect((await repo.findById('x'))!.amount, const Money(999));
      expect(await queue.nextBatch(), isEmpty);
    });

    test('a newer local edit survives a pull of an older server row', () async {
      server.serverWrite('transactions', tx(id: 'x', amount: 1).toRemoteJson(1));
      await repo.save(tx(id: 'x', amount: 500));
      server.offline = true;
      await expectLater(engine.sync(), throwsException);
      server.offline = false;

      await engine.sync();
      expect((await repo.findById('x'))!.amount, const Money(500));
      expect(server.tables['transactions']!['x']!['amountMinor'], 500);
    });

    test('rejected changes are kept for inspection instead of blocking the queue', () async {
      await queue.enqueue('transactions', 'bad', tx(id: 'bad').toRemoteJson(1)..['amountMinor'] = -1);
      await repo.save(tx(id: 'good'));

      final report = await engine.sync();
      expect(report.rejected, 1);
      expect(report.pushed, 1);
      expect((await queue.failedEntries()).isEmpty, isTrue, reason: 'one failure is below the retry limit');
      expect((await queue.nextBatch()).single.recordId, 'bad');
    });

    test('deletes travel as tombstones', () async {
      await repo.save(tx(id: 'gone'));
      await engine.sync();
      clock = clock.add(const Duration(minutes: 1));
      await repo.delete('gone');
      await engine.sync();

      expect(server.tables['transactions']!['gone']!['deleted'], isTrue);
      expect(await repo.findById('gone'), isNull);
    });

    test('concurrent calls share one run', () async {
      await repo.save(tx(id: 'a'));
      final runs = await Future.wait([engine.sync(), engine.sync()]);
      expect(identical(runs[0], runs[1]) || runs[0] == runs[1], isTrue);
      expect(server.pushCalls, 1);
    });
  });
}
