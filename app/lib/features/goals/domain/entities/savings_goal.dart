import 'package:equatable/equatable.dart';

import '../../../../core/money/money.dart';

class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    required this.deadline,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final Money target;
  final Money saved;
  final DateTime deadline;
  final DateTime updatedAt;

  /// 0..1, capped so over-saving still renders a full ring.
  double get progress => target.isZero ? 0 : (saved.minor / target.minor).clamp(0, 1).toDouble();

  bool get isComplete => saved >= target;

  Money get remaining => isComplete ? Money.zero(currency: target.currency) : target - saved;

  /// Whole months left before the deadline, never less than one so the
  /// suggestion below stays finite for overdue goals.
  int monthsLeft(DateTime now) {
    final months = (deadline.year - now.year) * 12 + deadline.month - now.month - (deadline.day < now.day ? 1 : 0);
    return months < 1 ? 1 : months;
  }

  /// How much to put aside each month to finish on time, rounded up to the paisa.
  Money suggestedMonthlyContribution(DateTime now) {
    final months = monthsLeft(now);
    return Money((remaining.minor + months - 1) ~/ months, currency: target.currency);
  }

  bool isOverdue(DateTime now) => !isComplete && deadline.isBefore(now);

  SavingsGoal copyWith({String? name, Money? target, Money? saved, DateTime? deadline, DateTime? updatedAt}) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      target: target ?? this.target,
      saved: saved ?? this.saved,
      deadline: deadline ?? this.deadline,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, target, saved, deadline, updatedAt];
}
