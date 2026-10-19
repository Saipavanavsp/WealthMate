import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/features/reminders/domain/bill_reminder.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('SavingsGoal', () {
    final now = DateTime(2026, 10, 19);

    test('progress and remaining', () {
      final g = goal(saved: 25000);
      expect(g.progress, 0.25);
      expect(g.remaining, const Money(75000));
      expect(g.isComplete, isFalse);
    });

    test('over-saving caps progress and leaves nothing remaining', () {
      final g = goal(target: 1000, saved: 1500);
      expect(g.progress, 1);
      expect(g.remaining, const Money(0));
      expect(g.isComplete, isTrue);
    });

    test('suggested monthly contribution rounds up', () {
      final g = goal(deadline: DateTime(2027, 1, 19));
      expect(g.monthsLeft(now), 3);
      expect(g.suggestedMonthlyContribution(now), const Money(33334));
    });

    test('a goal due this month or overdue asks for the remainder at once', () {
      final overdue = goal(target: 5000, saved: 1000, deadline: DateTime(2026, 9));
      expect(overdue.isOverdue(now), isTrue);
      expect(overdue.monthsLeft(now), 1);
      expect(overdue.suggestedMonthlyContribution(now), const Money(4000));
    });
  });

  group('BillReminder', () {
    const reminder = BillReminder(title: 'Rent', amount: Money(100), dayOfMonth: 5);

    test('next due date rolls over to next month once passed', () {
      expect(reminder.nextDue(DateTime(2026, 10)), DateTime(2026, 10, 5, 9));
      expect(reminder.nextDue(DateTime(2026, 10, 6)), DateTime(2026, 11, 5, 9));
      expect(reminder.nextDue(DateTime(2026, 12, 20)), DateTime(2027, 1, 5, 9));
    });

    test('days until due', () {
      expect(reminder.daysUntilDue(DateTime(2026, 10, 3, 18)), 2);
      expect(reminder.daysUntilDue(DateTime(2026, 10, 5, 8)), 0);
    });
  });
}
