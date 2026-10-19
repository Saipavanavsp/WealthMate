// Compares the single-pass chart aggregation with the naive "filter the whole
// list once per bar" approach it replaced.
//
//   dart run tool/analytics_benchmark.dart
// ignore_for_file: avoid_print
import 'dart:math';

import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/features/transactions/domain/analytics/spending_analytics.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';

void main() {
  final now = DateTime(2026, 10, 19);
  final random = Random(7);
  const categories = ['Food', 'Groceries', 'Transport', 'Shopping', 'Bills', 'Rent'];

  for (final size in [1000, 10000, 50000]) {
    final data = List.generate(size, (i) {
      final at = now.subtract(Duration(hours: random.nextInt(24 * 365)));
      return TransactionEntry(
        id: '$i',
        type: random.nextInt(10) == 0 ? TransactionType.income : TransactionType.expense,
        amount: Money(100 + random.nextInt(500000)),
        category: categories[random.nextInt(categories.length)],
        occurredAt: at,
        updatedAt: at,
      );
    });

    final current = _time(() => SpendingAnalytics.summarise(AnalyticsRequest(data, now, months: 12, weeks: 12)));
    final firstDraft = _time(() => _dateTimeKeyedSummary(data, now, months: 12, weeks: 12));
    final naive = _time(() => _naiveSummary(data, now, months: 12, weeks: 12));
    print(
      '${size.toString().padLeft(6)} transactions | '
      'current ${current.toStringAsFixed(2).padLeft(6)} ms | '
      'filter per bucket ${naive.toStringAsFixed(2).padLeft(7)} ms | '
      'DateTime per item ${firstDraft.toStringAsFixed(2).padLeft(8)} ms',
    );
  }
}

/// Median of several runs after a warm-up, in milliseconds.
double _time(void Function() body) {
  for (var i = 0; i < 3; i++) {
    body();
  }
  final runs = <double>[];
  for (var i = 0; i < 9; i++) {
    final watch = Stopwatch()..start();
    body();
    runs.add(watch.elapsedMicroseconds / 1000);
  }
  runs.sort();
  return runs[runs.length ~/ 2];
}

/// The first single-pass draft: hash buckets keyed by values read from each
/// transaction's local DateTime. Correct, but every local DateTime construction
/// and field read does a timezone lookup, which dominated the run time.
void _dateTimeKeyedSummary(List<TransactionEntry> data, DateTime now, {required int months, required int weeks}) {
  int key(DateTime d) => d.year * 12 + d.month;
  final monthly = {for (var i = months - 1; i >= 0; i--) key(DateTime(now.year, now.month - i)): 0};
  final thisWeek = SpendingAnalytics.startOfWeek(now);
  final weekly = {
    for (var i = weeks - 1; i >= 0; i--) DateTime(thisWeek.year, thisWeek.month, thisWeek.day - 7 * i): 0,
  };
  for (final t in data) {
    final m = key(t.occurredAt);
    if (monthly.containsKey(m)) monthly[m] = monthly[m]! + t.amount.minor;
    final w = SpendingAnalytics.startOfWeek(t.occurredAt);
    if (weekly.containsKey(w)) weekly[w] = weekly[w]! + t.amount.minor;
  }
}

/// The textbook approach: one full scan per bar and per category.
void _naiveSummary(List<TransactionEntry> data, DateTime now, {required int months, required int weeks}) {
  for (var i = months - 1; i >= 0; i--) {
    final start = DateTime(now.year, now.month - i);
    final end = DateTime(now.year, now.month - i + 1);
    data
        .where((t) => !t.occurredAt.isBefore(start) && t.occurredAt.isBefore(end))
        .fold(0, (s, t) => s + t.amount.minor);
  }
  final week = SpendingAnalytics.startOfWeek(now);
  for (var i = weeks - 1; i >= 0; i--) {
    final start = DateTime(week.year, week.month, week.day - 7 * i);
    final end = start.add(const Duration(days: 7));
    data
        .where((t) => !t.occurredAt.isBefore(start) && t.occurredAt.isBefore(end))
        .fold(0, (s, t) => s + t.amount.minor);
  }
  final monthStart = DateTime(now.year, now.month);
  for (final category in data.map((t) => t.category).toSet()) {
    data
        .where((t) => t.category == category && t.isExpense && !t.occurredAt.isBefore(monthStart))
        .fold(0, (s, t) => s + t.amount.minor);
  }
}
