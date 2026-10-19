import '../entities/transaction_entry.dart';

/// Generates the occurrences of recurring transactions that have come due.
///
/// The most recent occurrence of a series is the one carrying the recurrence
/// flag; when a new occurrence is created the flag moves to it. Running the
/// scheduler twice is therefore harmless: the second run sees the new
/// occurrence, which isn't due yet.
class RecurringScheduler {
  const RecurringScheduler({required this.newId});

  final String Function() newId;

  /// For [template], returns the updated template (flag cleared) plus every
  /// occurrence due on or before [now]. Returns an empty list if nothing is due.
  List<TransactionEntry> dueOccurrences(TransactionEntry template, DateTime now) {
    if (!template.isRecurring) return const [];

    final result = <TransactionEntry>[];
    var previous = template;
    var next = nextDate(template.occurredAt, template.recurrence);
    while (!next.isAfter(now)) {
      result.add(previous.copyWith(recurrence: Recurrence.none, updatedAt: now));
      previous = template.copyWith(id: newId(), occurredAt: next, updatedAt: now);
      next = nextDate(next, template.recurrence);
    }
    if (result.isEmpty) return const [];
    // result[0] is the old template with its flag cleared; the last occurrence keeps the flag.
    return [...result, previous];
  }

  /// Adds one period. Monthly dates are clamped, so 31 Jan -> 28/29 Feb -> 28/29 Mar.
  static DateTime nextDate(DateTime from, Recurrence recurrence) {
    switch (recurrence) {
      case Recurrence.weekly:
        return from.add(const Duration(days: 7));
      case Recurrence.monthly:
        final year = from.month == 12 ? from.year + 1 : from.year;
        final month = from.month == 12 ? 1 : from.month + 1;
        final lastDay = DateTime(year, month + 1, 0).day;
        final day = from.day > lastDay ? lastDay : from.day;
        return DateTime(year, month, day, from.hour, from.minute);
      case Recurrence.none:
        return from;
    }
  }
}
