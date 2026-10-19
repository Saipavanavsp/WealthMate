import 'package:equatable/equatable.dart';

import '../../goals/domain/entities/savings_goal.dart';
import '../../transactions/domain/entities/transaction_entry.dart';

enum HealthBand { excellent, good, fair, needsAttention }

class ScoreComponent extends Equatable {
  const ScoreComponent({required this.points, required this.maxPoints, required this.value});

  final double points;
  final int maxPoints;

  /// The raw measurement behind the points (a rate, a change, or a progress fraction).
  final double? value;

  @override
  List<Object?> get props => [points, maxPoints, value];
}

class HealthScore extends Equatable {
  const HealthScore({required this.savings, required this.trend, required this.goals});

  /// Savings rate over the last three full months. Value = rate (0.25 = 25%).
  final ScoreComponent savings;

  /// Last month's spending against the average of the three months before it.
  /// Value = relative change (0.10 = spent 10% more).
  final ScoreComponent trend;

  /// Average progress across active goals. Value = 0..1, or null with no goals.
  final ScoreComponent goals;

  int get score => (savings.points + trend.points + goals.points).round().clamp(0, 100);

  HealthBand get band => switch (score) {
    >= 80 => HealthBand.excellent,
    >= 60 => HealthBand.good,
    >= 40 => HealthBand.fair,
    _ => HealthBand.needsAttention,
  };

  @override
  List<Object?> get props => [savings, trend, goals];
}

/// Scores financial health from 0 to 100.
///
///  * Savings rate, 40 points: (income - spending) / income over the last three
///    full months. 30% or more earns all 40; zero or negative earns 0; linear between.
///  * Spending trend, 30 points: last month vs the average of the three before.
///    A drop of 10% or more earns all 30, a rise of 30% or more earns 0, linear
///    between, so holding steady earns 22.5.
///  * Goal progress, 30 points: average saved/target across goals. With no goals
///    this is a neutral 15, so new users aren't penalised.
///
/// Missing data is scored neutrally rather than as zero.
class HealthScoreCalculator {
  const HealthScoreCalculator();

  static const savingsMax = 40;
  static const trendMax = 30;
  static const goalsMax = 30;
  static const targetSavingsRate = 0.30;

  HealthScore calculate({
    required List<TransactionEntry> transactions,
    required List<SavingsGoal> goals,
    required DateTime now,
  }) {
    // monthTotals[0] is last full month, [1] the one before, and so on.
    final income = List.filled(4, 0);
    final spend = List.filled(4, 0);
    final currentMonth = now.year * 12 + now.month;
    for (final t in transactions) {
      final index = currentMonth - (t.occurredAt.year * 12 + t.occurredAt.month) - 1;
      if (index < 0 || index > 3) continue;
      if (t.isExpense) {
        spend[index] += t.amount.minor;
      } else {
        income[index] += t.amount.minor;
      }
    }

    return HealthScore(
      savings: _savings(income.take(3).fold(0, _sum), spend.take(3).fold(0, _sum)),
      trend: _trend(spend[0], spend.skip(1)),
      goals: _goals(goals),
    );
  }

  ScoreComponent _savings(int income, int spend) {
    if (income == 0) {
      return ScoreComponent(points: spend == 0 ? savingsMax / 2 : 0, maxPoints: savingsMax, value: null);
    }
    final rate = (income - spend) / income;
    final points = (rate / targetSavingsRate).clamp(0, 1) * savingsMax;
    return ScoreComponent(points: points.toDouble(), maxPoints: savingsMax, value: rate);
  }

  ScoreComponent _trend(int lastMonth, Iterable<int> previous) {
    final withData = previous.where((v) => v > 0).toList();
    if (withData.isEmpty || lastMonth == 0) {
      return const ScoreComponent(points: trendMax * 0.75, maxPoints: trendMax, value: null);
    }
    final average = withData.fold(0, _sum) / withData.length;
    final change = (lastMonth - average) / average;
    // -10% -> 1.0, +30% -> 0.0
    final fraction = ((0.30 - change) / 0.40).clamp(0, 1).toDouble();
    return ScoreComponent(points: fraction * trendMax, maxPoints: trendMax, value: change);
  }

  ScoreComponent _goals(List<SavingsGoal> goals) {
    if (goals.isEmpty) return const ScoreComponent(points: goalsMax / 2, maxPoints: goalsMax, value: null);
    final average = goals.map((g) => g.progress).fold(0.0, (a, b) => a + b) / goals.length;
    return ScoreComponent(points: average * goalsMax, maxPoints: goalsMax, value: average);
  }

  static int _sum(int a, int b) => a + b;
}
