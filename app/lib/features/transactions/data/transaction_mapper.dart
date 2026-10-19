import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../domain/entities/transaction_entry.dart';

extension TransactionRowMapper on TransactionRow {
  TransactionEntry toEntity() {
    return TransactionEntry(
      id: id,
      type: TransactionType.values.byName(type),
      amount: Money(amountMinor, currency: currency),
      category: category,
      merchant: merchant,
      note: note,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(occurredAt),
      recurrence: Recurrence.values.byName(recurrence),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }
}

extension TransactionEntryMapper on TransactionEntry {
  TransactionRow toRow({bool deleted = false}) {
    return TransactionRow(
      id: id,
      type: type.name,
      amountMinor: amount.minor,
      currency: amount.currency,
      category: category,
      merchant: merchant,
      note: note,
      occurredAt: occurredAt.millisecondsSinceEpoch,
      recurrence: recurrence.name,
      updatedAt: updatedAt.millisecondsSinceEpoch,
      deleted: deleted,
    );
  }
}
