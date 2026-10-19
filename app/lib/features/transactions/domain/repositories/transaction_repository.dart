import '../../../../core/error/result.dart';
import '../entities/transaction_entry.dart';

abstract interface class TransactionRepository {
  /// Newest first. Emits again whenever the local database changes.
  Stream<List<TransactionEntry>> watchAll();

  Stream<List<TransactionEntry>> watchRecent({int limit = 5});

  Future<List<TransactionEntry>> getBetween(DateTime from, DateTime to);

  Future<TransactionEntry?> findById(String id);

  Future<Result<void>> save(TransactionEntry entry);

  Future<Result<void>> delete(String id);

  /// Creates any recurring transactions that have come due. Returns how many were added.
  Future<int> generateDueRecurring(DateTime now);
}
