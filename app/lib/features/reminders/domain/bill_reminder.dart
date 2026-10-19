import 'package:equatable/equatable.dart';

import '../../../core/money/money.dart';

class BillReminder extends Equatable {
  const BillReminder({
    required this.title,
    required this.amount,
    required this.dayOfMonth,
    this.id,
    this.enabled = true,
  }) : assert(dayOfMonth >= 1 && dayOfMonth <= 28, 'Use days 1-28 so every month has the date');

  /// Null until the reminder is stored.
  final int? id;
  final String title;
  final Money amount;

  /// Limited to 1..28 so the reminder fires every month, including February.
  final int dayOfMonth;
  final bool enabled;

  /// Next due date at 9am, today included if it hasn't passed yet.
  DateTime nextDue(DateTime now) {
    final thisMonth = DateTime(now.year, now.month, dayOfMonth, 9);
    return thisMonth.isBefore(now) ? DateTime(now.year, now.month + 1, dayOfMonth, 9) : thisMonth;
  }

  int daysUntilDue(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = nextDue(now);
    return DateTime(due.year, due.month, due.day).difference(today).inDays;
  }

  BillReminder copyWith({int? id, String? title, Money? amount, int? dayOfMonth, bool? enabled}) {
    return BillReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, dayOfMonth, enabled];
}
