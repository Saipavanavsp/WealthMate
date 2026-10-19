import 'package:equatable/equatable.dart';

import '../entities/transaction_entry.dart';

class PeriodTotal extends Equatable {
  const PeriodTotal({required this.start, required this.incomeMinor, required this.expenseMinor});

  final DateTime start;
  final int incomeMinor;
  final int expenseMinor;

  int get netMinor => incomeMinor - expenseMinor;

  @override
  List<Object?> get props => [start, incomeMinor, expenseMinor];
}

class CategoryTotal extends Equatable {
  const CategoryTotal({required this.category, required this.amountMinor, required this.share});

  final String category;
  final int amountMinor;

  /// Fraction of total spending in the range, 0..1.
  final double share;

  @override
  List<Object?> get props => [category, amountMinor, share];
}

class SpendingSummary extends Equatable {
  const SpendingSummary({required this.monthly, required this.weekly, required this.byCategory});

  static const empty = SpendingSummary(monthly: [], weekly: [], byCategory: []);

  final List<PeriodTotal> monthly;
  final List<PeriodTotal> weekly;
  final List<CategoryTotal> byCategory;

  @override
  List<Object?> get props => [monthly, weekly, byCategory];
}

/// Input for [SpendingAnalytics.summarise], bundled so it can be sent to an isolate.
class AnalyticsRequest {
  const AnalyticsRequest(this.transactions, this.now, {this.months = 6, this.weeks = 8});

  final List<TransactionEntry> transactions;
  final DateTime now;
  final int months;
  final int weeks;
}

/// Chart aggregations. Pure functions with no Flutter dependency, so they
/// can run in a background isolate via `compute`.
///
/// Every aggregation is a single pass over the transactions with hash-map
/// buckets keyed by period, so it is O(n) time and O(b) extra space for b
/// buckets, instead of filtering the whole list once per bar (O(n * b)).
abstract final class SpendingAnalytics {
  static SpendingSummary summarise(AnalyticsRequest request) {
    final now = request.now;
    final monthStart = DateTime(now.year, now.month);
    return SpendingSummary(
      monthly: monthlyTotals(request.transactions, now, months: request.months),
      weekly: weeklyTotals(request.transactions, now, weeks: request.weeks),
      byCategory: categoryBreakdown(request.transactions, from: monthStart, to: now),
    );
  }

  static List<PeriodTotal> monthlyTotals(List<TransactionEntry> transactions, DateTime now, {int months = 6}) {
    final starts = [for (var i = months - 1; i >= 0; i--) DateTime(now.year, now.month - i)];
    int key(DateTime d) => d.year * 12 + d.month;
    final buckets = {for (final s in starts) key(s): _Bucket()};

    for (final t in transactions) {
      buckets[key(t.occurredAt)]?.add(t);
    }
    return [for (final s in starts) buckets[key(s)]!.toTotal(s)];
  }

  /// Weeks start on Monday.
  static List<PeriodTotal> weeklyTotals(List<TransactionEntry> transactions, DateTime now, {int weeks = 8}) {
    final thisWeek = startOfWeek(now);
    final starts = [for (var i = weeks - 1; i >= 0; i--) DateTime(thisWeek.year, thisWeek.month, thisWeek.day - 7 * i)];
    final buckets = {for (final s in starts) s: _Bucket()};

    for (final t in transactions) {
      buckets[startOfWeek(t.occurredAt)]?.add(t);
    }
    return [for (final s in starts) buckets[s]!.toTotal(s)];
  }

  /// Expense totals per category between [from] and [to], largest first.
  /// Sorting is O(c log c) for c categories, which is tiny next to n.
  static List<CategoryTotal> categoryBreakdown(
    List<TransactionEntry> transactions, {
    required DateTime from,
    required DateTime to,
  }) {
    final totals = <String, int>{};
    var sum = 0;
    for (final t in transactions) {
      if (!t.isExpense || t.occurredAt.isBefore(from) || t.occurredAt.isAfter(to)) continue;
      totals.update(t.category, (v) => v + t.amount.minor, ifAbsent: () => t.amount.minor);
      sum += t.amount.minor;
    }
    final result = [
      for (final MapEntry(:key, :value) in totals.entries)
        CategoryTotal(category: key, amountMinor: value, share: sum == 0 ? 0 : value / sum),
    ]..sort((a, b) => b.amountMinor.compareTo(a.amountMinor));
    return result;
  }

  static DateTime startOfWeek(DateTime date) => DateTime(date.year, date.month, date.day - (date.weekday - 1));
}

class _Bucket {
  int income = 0;
  int expense = 0;

  void add(TransactionEntry t) {
    if (t.isExpense) {
      expense += t.amount.minor;
    } else {
      income += t.amount.minor;
    }
  }

  PeriodTotal toTotal(DateTime start) => PeriodTotal(start: start, incomeMinor: income, expenseMinor: expense);
}
