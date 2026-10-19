import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/sync/sync_handler.dart';
import '../../../core/sync/synced_writer.dart';
import '../domain/entities/transaction_entry.dart';
import '../domain/recurring/recurring_scheduler.dart';
import '../domain/repositories/transaction_repository.dart';
import 'transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({
    required AppDatabase db,
    required SyncedWriter writer,
    required SyncHandlers handlers,
    required RecurringScheduler scheduler,
    DateTime Function()? clock,
  }) : _db = db,
       _writer = writer,
       _scheduler = scheduler,
       _clock = clock ?? DateTime.now,
       _handler = handlers.transactions;

  final AppDatabase _db;
  final SyncedWriter _writer;
  final RecurringScheduler _scheduler;
  final DateTime Function() _clock;
  final SyncHandler<$TransactionsTable, TransactionRow> _handler;

  SimpleSelectStatement<$TransactionsTable, TransactionRow> _live() {
    return _db.select(_db.transactions)
      ..where((t) => t.deleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
  }

  @override
  Stream<List<TransactionEntry>> watchAll() {
    return _live().watch().map((rows) => [for (final r in rows) r.toEntity()]);
  }

  @override
  Stream<List<TransactionEntry>> watchRecent({int limit = 5}) {
    return (_live()..limit(limit)).watch().map((rows) => [for (final r in rows) r.toEntity()]);
  }

  @override
  Future<List<TransactionEntry>> getBetween(DateTime from, DateTime to) async {
    final query = _live()
      ..where((t) => t.occurredAt.isBetweenValues(from.millisecondsSinceEpoch, to.millisecondsSinceEpoch));
    return [for (final r in await query.get()) r.toEntity()];
  }

  @override
  Future<TransactionEntry?> findById(String id) async {
    final row = await (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id) & t.deleted.equals(false))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<Result<void>> save(TransactionEntry entry) async {
    if (!entry.amount.isPositive) return const Err(ValidationFailure('Amount must be greater than zero'));
    try {
      await _writer.save(_handler, entry.copyWith(updatedAt: _clock()).toRow());
      return const Ok(null);
    } catch (e, s) {
      debugPrint('Saving transaction failed: $e\n$s');
      return const Err(StorageFailure());
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    final existing = await findById(id);
    if (existing == null) return const Err(ValidationFailure('Transaction not found'));
    try {
      await _writer.save(_handler, existing.copyWith(updatedAt: _clock()).toRow(deleted: true));
      return const Ok(null);
    } catch (e) {
      return const Err(StorageFailure());
    }
  }

  @override
  Future<int> generateDueRecurring(DateTime now) async {
    final templates = await (_db.select(
      _db.transactions,
    )..where((t) => t.deleted.equals(false) & t.recurrence.isNotValue(Recurrence.none.name))).get();

    var created = 0;
    await _writer.batch(() async {
      for (final template in templates) {
        final updates = _scheduler.dueOccurrences(template.toEntity(), now);
        for (final entry in updates) {
          await _writer.save(_handler, entry.toRow());
        }
        if (updates.isNotEmpty) created += updates.length - 1;
      }
    });
    return created;
  }
}
