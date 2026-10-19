import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/features/health_score/domain/health_score_calculator.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';

import '../../helpers/test_helpers.dart';

void main() {
  const calculator = HealthScoreCalculator();
  final now = DateTime(2026, 10, 19);

  /// Income and spending for one month, [monthsAgo] full months back.
  List<TransactionEntry> month(int monthsAgo, {required int income, required int spend}) {
    final at = DateTime(now.year, now.month - monthsAgo, 10);
    return [
      if (income > 0) tx(id: 'i$monthsAgo', type: TransactionType.income, amount: income, category: 'Salary', at: at),
      if (spend > 0) tx(id: 's$monthsAgo', amount: spend, at: at),
    ];
  }

  test('no data at all scores neutrally', () {
    final score = calculator.calculate(transactions: const [], goals: const [], now: now);
    expect(score.savings.points, 20);
    expect(score.trend.points, 22.5);
    expect(score.goals.points, 15);
    expect(score.score, 58);
  });

  test('30% savings rate earns the full 40 points', () {
    final txs = [for (var m = 1; m <= 3; m++) ...month(m, income: 100000, spend: 70000)];
    final score = calculator.calculate(transactions: txs, goals: const [], now: now);
    expect(score.savings.value, closeTo(0.30, 1e-9));
    expect(score.savings.points, closeTo(40, 1e-9));
  });

  test('spending more than income earns no savings points', () {
    final txs = [for (var m = 1; m <= 3; m++) ...month(m, income: 50000, spend: 60000)];
    final score = calculator.calculate(transactions: txs, goals: const [], now: now);
    expect(score.savings.points, 0);
  });

  test('the current partial month is ignored', () {
    final txs = [...month(0, income: 0, spend: 999999), ...month(1, income: 100000, spend: 85000)];
    final score = calculator.calculate(transactions: txs, goals: const [], now: now);
    expect(score.savings.value, closeTo(0.15, 1e-9));
    expect(score.savings.points, closeTo(20, 1e-9));
  });

  test('spending trend rewards cutting back and penalises jumps', () {
    List<TransactionEntry> history(int lastMonthSpend) => [
      ...month(1, income: 100000, spend: lastMonthSpend),
      ...month(2, income: 100000, spend: 50000),
      ...month(3, income: 100000, spend: 50000),
      ...month(4, income: 100000, spend: 50000),
    ];

    final steady = calculator.calculate(transactions: history(50000), goals: const [], now: now);
    expect(steady.trend.points, closeTo(22.5, 1e-9));

    final cut = calculator.calculate(transactions: history(45000), goals: const [], now: now);
    expect(cut.trend.points, closeTo(30, 1e-9));

    final jump = calculator.calculate(transactions: history(65000), goals: const [], now: now);
    expect(jump.trend.points, closeTo(0, 1e-9));
  });

  test('goal progress is averaged and capped per goal', () {
    final score = calculator.calculate(
      transactions: const [],
      goals: [
        goal(id: 'a', target: 1000, saved: 500),
        goal(id: 'b', target: 1000, saved: 5000),
      ],
      now: now,
    );
    expect(score.goals.value, closeTo(0.75, 1e-9));
    expect(score.goals.points, closeTo(22.5, 1e-9));
  });

  test('score bands', () {
    final great = [for (var m = 1; m <= 4; m++) ...month(m, income: 100000, spend: m == 1 ? 40000 : 60000)];
    final score = calculator.calculate(transactions: great, goals: [goal(target: 1000, saved: 1000)], now: now);
    expect(score.score, 100);
    expect(score.band, HealthBand.excellent);
  });
}
