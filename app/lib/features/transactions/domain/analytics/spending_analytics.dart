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
/// Every aggregation is a single pass over the transactions. Period charts
/// place each item by binary search over b period boundaries, so they cost
/// O(n log b) time and O(b) space, instead of filtering the whole list once
/// per bar (O(n * b)). Category totals use a hash map: O(n) plus an
/// O(c log c) sort over the c categories.
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
    // months + 1 boundaries: the start of each month plus the end of the last one.
    final bounds = [for (var i = months - 1; i >= -1; i--) DateTime(now.year, now.month - i)];
    return _bucketed(transactions, bounds);
  }

  /// Weeks start on Monday.
  static List<PeriodTotal> weeklyTotals(List<TransactionEntry> transactions, DateTime now, {int weeks = 8}) {
    final thisWeek = startOfWeek(now);
    final bounds = [
      for (var i = weeks - 1; i >= -1; i--) DateTime(thisWeek.year, thisWeek.month, thisWeek.day - 7 * i),
    ];
    return _bucketed(transactions, bounds);
  }

  /// Sums transactions into the periods between consecutive [bounds].
  ///
  /// Each transaction is placed by binary search on the boundaries' epoch
  /// milliseconds. An earlier version built a local DateTime per transaction
  /// (to read year/month/weekday) and was over 400x slower at 50k rows, because
  /// every local DateTime construction does a timezone lookup. See
  /// docs/performance.md.
  static List<PeriodTotal> _bucketed(List<TransactionEntry> transactions, List<DateTime> bounds) {
    final edges = [for (final b in bounds) b.millisecondsSinceEpoch];
    final income = List.filled(bounds.length - 1, 0);
    final expense = List.filled(bounds.length - 1, 0);

    for (final t in transactions) {
      final i = _bucketIndex(edges, t.occurredAt.millisecondsSinceEpoch);
      if (i < 0) continue;
      if (t.isExpense) {
        expense[i] += t.amount.minor;
      } else {
        income[i] += t.amount.minor;
      }
    }
    return [
      for (var i = 0; i < bounds.length - 1; i++)
        PeriodTotal(start: bounds[i], incomeMinor: income[i], expenseMinor: expense[i]),
    ];
  }

  /// Index i such that edges[i] <= value < edges[i + 1], or -1 when outside.
  static int _bucketIndex(List<int> edges, int value) {
    if (value < edges.first || value >= edges.last) return -1;
    var low = 0;
    var high = edges.length - 2;
    while (low < high) {
      final mid = (low + high + 1) >> 1;
      if (edges[mid] <= value) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return low;
  }

  /// Expense totals per category between [from] and [to], largest first.
  /// Sorting is O(c log c) for c categories, which is tiny next to n.
  static List<CategoryTotal> categoryBreakdown(
    List<TransactionEntry> transactions, {
    required DateTime from,
    required DateTime to,
  }) {
    final totals = <String, int>{};
    final fromMs = from.millisecondsSinceEpoch;
    final toMs = to.millisecondsSinceEpoch;
    var sum = 0;
    for (final t in transactions) {
      final at = t.occurredAt.millisecondsSinceEpoch;
      if (!t.isExpense || at < fromMs || at > toMs) continue;
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
