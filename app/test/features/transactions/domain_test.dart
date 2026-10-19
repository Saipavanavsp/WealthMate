import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/features/transactions/domain/analytics/spending_analytics.dart';
import 'package:wealthmate/features/transactions/domain/categorisation/category_rules.dart';
import 'package:wealthmate/features/transactions/domain/entities/categories.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';
import 'package:wealthmate/features/transactions/domain/recurring/recurring_scheduler.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('CategoryRuleEngine', () {
    final engine = CategoryRuleEngine.withDefaults();

    test('matches common Indian merchants', () {
      expect(engine.categorise('Swiggy Order #123'), Categories.food);
      expect(engine.categorise('UBER *TRIP'), Categories.transport);
      expect(engine.categorise('Amazon Pay'), Categories.shopping);
      expect(engine.categorise('Airtel Postpaid'), Categories.bills);
      expect(engine.categorise('Apollo Pharmacy'), Categories.health);
      expect(engine.categorise('Netflix.com'), Categories.entertainment);
    });

    test('matches at word starts only', () {
      expect(engine.categorise('Kuber Traders'), Categories.other);
    });

    test('falls back for unknown or empty merchants', () {
      expect(engine.categorise('Random Shop'), Categories.other);
      expect(engine.categorise('   '), Categories.other);
    });

    test('learned rules win over keywords', () {
      final learned = LearnedMerchantRule();
      final engine = CategoryRuleEngine.withDefaults(learned: learned);
      expect(engine.categorise('Amazon'), Categories.shopping);
      learned.learn('  AMAZON ', Categories.groceries);
      expect(engine.categorise('amazon'), Categories.groceries);
      expect(learned.mappings, {'amazon': Categories.groceries});
    });

    test('custom rules can be chained', () {
      final engine = CategoryRuleEngine([
        KeywordRule('Pets', ['petco', 'vet']),
      ], fallback: 'Misc');
      expect(engine.categorise('Petco store'), 'Pets');
      expect(engine.categorise('Bakery'), 'Misc');
    });
  });

  group('RecurringScheduler', () {
    var counter = 0;
    final scheduler = RecurringScheduler(newId: () => 'new-${counter++}');

    setUp(() => counter = 0);

    test('does nothing for one-off or not-yet-due entries', () {
      expect(scheduler.dueOccurrences(tx(), DateTime(2027)), isEmpty);
      final template = tx(at: DateTime(2026, 10), recurrence: Recurrence.monthly);
      expect(scheduler.dueOccurrences(template, DateTime(2026, 10, 20)), isEmpty);
    });

    test('creates each missed monthly occurrence and moves the flag to the latest', () {
      final template = tx(at: DateTime(2026, 7, 1, 9), recurrence: Recurrence.monthly);
      final result = scheduler.dueOccurrences(template, DateTime(2026, 10, 2));

      expect(result.map((e) => e.occurredAt), [
        DateTime(2026, 7, 1, 9),
        DateTime(2026, 8, 1, 9),
        DateTime(2026, 9, 1, 9),
        DateTime(2026, 10, 1, 9),
      ]);
      expect(result.first.id, 't1');
      expect(result.where((e) => e.isRecurring), [result.last]);

      // Running again from the new template finds nothing more to do.
      expect(scheduler.dueOccurrences(result.last, DateTime(2026, 10, 2)), isEmpty);
    });

    test('weekly series', () {
      final template = tx(at: DateTime(2026, 10), recurrence: Recurrence.weekly);
      final result = scheduler.dueOccurrences(template, DateTime(2026, 10, 16));
      expect(result.length, 3);
      expect(result.last.occurredAt, DateTime(2026, 10, 15));
    });

    test('clamps month ends', () {
      expect(RecurringScheduler.nextDate(DateTime(2026, 1, 31), Recurrence.monthly), DateTime(2026, 2, 28));
      expect(RecurringScheduler.nextDate(DateTime(2026, 12, 15), Recurrence.monthly), DateTime(2027, 1, 15));
    });
  });

  group('SpendingAnalytics', () {
    final now = DateTime(2026, 10, 19);
    final data = [
      tx(id: '1', amount: 1000, at: DateTime(2026, 10, 2)),
      tx(id: '2', amount: 3000, category: 'Rent', at: DateTime(2026, 10, 3)),
      tx(id: '3', amount: 5000, type: TransactionType.income, category: 'Salary', at: DateTime(2026, 10)),
      tx(id: '4', amount: 700, at: DateTime(2026, 9, 15)),
      tx(id: '5', amount: 999, at: DateTime(2025)),
    ];

    test('monthly totals cover the requested window, oldest first', () {
      final months = SpendingAnalytics.monthlyTotals(data, now, months: 3);
      expect(months.map((m) => m.start), [DateTime(2026, 8), DateTime(2026, 9), DateTime(2026, 10)]);
      expect(months.last.expenseMinor, 4000);
      expect(months.last.incomeMinor, 5000);
      expect(months.last.netMinor, 1000);
      expect(months[1].expenseMinor, 700);
      expect(months.first.expenseMinor, 0);
    });

    test('weekly totals bucket by Monday', () {
      final weeks = SpendingAnalytics.weeklyTotals(data, now, weeks: 3);
      expect(weeks.last.start, DateTime(2026, 10, 19));
      expect(weeks[1].start, DateTime(2026, 10, 12));
      expect(weeks.every((w) => w.start.weekday == DateTime.monday), isTrue);
    });

    test('category breakdown is sorted with shares', () {
      final breakdown = SpendingAnalytics.categoryBreakdown(data, from: DateTime(2026, 10), to: now);
      expect(breakdown.map((c) => c.category), ['Rent', 'Food']);
      expect(breakdown.first.share, 0.75);
    });

    test('summarise bundles everything', () {
      final summary = SpendingAnalytics.summarise(AnalyticsRequest(data, now));
      expect(summary.monthly, hasLength(6));
      expect(summary.weekly, hasLength(8));
      expect(summary.byCategory, isNotEmpty);
    });
  });
}
