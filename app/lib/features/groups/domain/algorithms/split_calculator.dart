import '../../../../core/money/money.dart';

/// Works out each member's share of an expense. Shares always add up to the
/// full amount; leftover paise from rounding go to the first members.
abstract final class SplitCalculator {
  static Map<String, int> equal(Money amount, List<String> memberIds) {
    if (memberIds.isEmpty) throw ArgumentError('Pick at least one member to split with');
    final parts = amount.split(memberIds.length);
    return {for (var i = 0; i < memberIds.length; i++) memberIds[i]: parts[i].minor};
  }

  /// Splits by relative weights, e.g. {a: 2, b: 1, c: 1} gives a half and
  /// b and c a quarter each. Members with weight 0 are left out.
  static Map<String, int> byShares(Money amount, Map<String, int> weights) {
    final included = weights.entries.where((e) => e.value > 0).toList();
    if (included.isEmpty) throw ArgumentError('Give at least one member a share');
    final parts = amount.allocate([for (final e in included) e.value]);
    return {for (var i = 0; i < included.length; i++) included[i].key: parts[i].minor};
  }
}
