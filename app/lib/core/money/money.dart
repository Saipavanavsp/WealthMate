import 'package:intl/intl.dart';

/// An amount of money stored as an integer number of minor units (paise for INR).
///
/// Using integers avoids the rounding drift you get with doubles
/// (0.1 + 0.2 != 0.3), which matters once amounts are summed thousands of times.
/// Instances are immutable and two values are equal when amount and currency match.
final class Money implements Comparable<Money> {
  const Money(this.minor, {this.currency = 'INR'});

  const Money.zero({this.currency = 'INR'}) : minor = 0;

  /// Parses user input such as "1,250.5" or "99". Returns null for anything
  /// that isn't a non-negative amount with at most two decimal places.
  static Money? tryParse(String input, {String currency = 'INR'}) {
    final cleaned = input.replaceAll(',', '').trim();
    final match = RegExp(r'^(\d{1,12})(?:\.(\d{1,2}))?$').firstMatch(cleaned);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final paise = int.parse((match.group(2) ?? '0').padRight(2, '0'));
    return Money(rupees * 100 + paise, currency: currency);
  }

  final int minor;
  final String currency;

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;
  bool get isPositive => minor > 0;

  /// Major units as a double. Only for display maths such as chart heights,
  /// never for arithmetic that gets stored.
  double get major => minor / 100;

  Money operator +(Money other) {
    _checkCurrency(other);
    return Money(minor + other.minor, currency: currency);
  }

  Money operator -(Money other) {
    _checkCurrency(other);
    return Money(minor - other.minor, currency: currency);
  }

  Money operator -() => Money(-minor, currency: currency);

  Money operator *(num factor) => Money((minor * factor).round(), currency: currency);

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  Money abs() => Money(minor.abs(), currency: currency);

  /// Splits into [parts] amounts that always add back up to this value.
  ///
  /// ₹100 split three ways gives 33.34, 33.33, 33.33: the leftover paise go
  /// to the first parts so nothing is lost or invented.
  List<Money> split(int parts) {
    if (parts <= 0) throw ArgumentError.value(parts, 'parts', 'must be positive');
    return allocate(List.filled(parts, 1));
  }

  /// Splits proportionally to [weights] using the largest remainder method.
  List<Money> allocate(List<int> weights) {
    if (weights.isEmpty || weights.any((w) => w < 0)) {
      throw ArgumentError.value(weights, 'weights', 'must be non-empty and non-negative');
    }
    final total = weights.fold<int>(0, (sum, w) => sum + w);
    if (total == 0) throw ArgumentError.value(weights, 'weights', 'must not all be zero');

    final shares = <int>[];
    final remainders = <(int index, int remainder)>[];
    var allocated = 0;
    for (var i = 0; i < weights.length; i++) {
      final exact = minor * weights[i];
      final share = exact ~/ total;
      shares.add(share);
      remainders.add((i, exact.remainder(total)));
      allocated += share;
    }

    remainders.sort((a, b) => b.$2.compareTo(a.$2) != 0 ? b.$2.compareTo(a.$2) : a.$1.compareTo(b.$1));
    var leftover = minor - allocated;
    for (var i = 0; leftover > 0; i++, leftover--) {
      shares[remainders[i % remainders.length].$1]++;
    }
    return [for (final share in shares) Money(share, currency: currency)];
  }

  String format({String? locale, bool compact = false}) {
    final formatter = compact
        ? NumberFormat.compactSimpleCurrency(locale: locale ?? 'en_IN', name: currency, decimalDigits: 0)
        : NumberFormat.simpleCurrency(locale: locale ?? 'en_IN', name: currency);
    return formatter.format(major);
  }

  /// Plain decimal string ("1250.50") for CSV and form fields.
  String toDecimalString() {
    final sign = minor < 0 ? '-' : '';
    final value = minor.abs();
    return '$sign${value ~/ 100}.${(value % 100).toString().padLeft(2, '0')}';
  }

  void _checkCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Cannot combine $currency with ${other.currency}');
    }
  }

  @override
  int compareTo(Money other) {
    _checkCurrency(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => '$currency ${toDecimalString()}';
}
