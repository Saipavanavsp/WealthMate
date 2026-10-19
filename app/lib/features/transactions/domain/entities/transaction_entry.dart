import 'package:equatable/equatable.dart';

import '../../../../core/money/money.dart';

enum TransactionType { expense, income }

enum Recurrence { none, weekly, monthly }

/// A single income or expense. Named `TransactionEntry` to avoid clashing
/// with database transactions.
class TransactionEntry extends Equatable {
  const TransactionEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.occurredAt,
    required this.updatedAt,
    this.merchant,
    this.note,
    this.recurrence = Recurrence.none,
  });

  final String id;
  final TransactionType type;
  final Money amount;
  final String category;
  final String? merchant;
  final String? note;
  final DateTime occurredAt;
  final Recurrence recurrence;
  final DateTime updatedAt;

  bool get isExpense => type == TransactionType.expense;
  bool get isRecurring => recurrence != Recurrence.none;

  /// Negative for expenses, positive for income.
  Money get signedAmount => isExpense ? -amount : amount;

  String get title => (merchant?.isNotEmpty ?? false) ? merchant! : category;

  TransactionEntry copyWith({
    String? id,
    TransactionType? type,
    Money? amount,
    String? category,
    String? merchant,
    String? note,
    DateTime? occurredAt,
    Recurrence? recurrence,
    DateTime? updatedAt,
  }) {
    return TransactionEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      recurrence: recurrence ?? this.recurrence,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, type, amount, category, merchant, note, occurredAt, recurrence, updatedAt];
}
