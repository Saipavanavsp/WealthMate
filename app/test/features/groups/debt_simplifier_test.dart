import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/core/collections/max_heap.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/features/groups/domain/algorithms/debt_simplifier.dart';
import 'package:wealthmate/features/groups/domain/algorithms/split_calculator.dart';
import 'package:wealthmate/features/groups/domain/entities/group_entities.dart';

GroupExpense expense(String paidBy, int amount, Map<String, int> shares) {
  return GroupExpense(
    id: 'e-$paidBy-$amount',
    groupId: 'g',
    description: 'test',
    amount: Money(amount),
    paidBy: paidBy,
    splitType: SplitType.custom,
    shares: shares,
    occurredAt: DateTime(2026),
  );
}

/// Applies the transfers to the balances; a correct result leaves everyone at zero.
Map<String, int> applyTransfers(Map<String, int> balances, List<Transfer> transfers) {
  final result = Map.of(balances);
  for (final t in transfers) {
    result[t.from] = result[t.from]! + t.amountMinor;
    result[t.to] = result[t.to]! - t.amountMinor;
  }
  return result;
}

void main() {
  const simplifier = DebtSimplifier();

  group('MaxHeap', () {
    test('pops in descending order', () {
      final heap = MaxHeap<int>((a, b) => a.compareTo(b));
      for (final v in [5, 1, 9, 3, 7, 7, 2]) {
        heap.push(v);
      }
      expect(heap.peek, 9);
      final out = <int>[];
      while (heap.isNotEmpty) {
        out.add(heap.pop());
      }
      expect(out, [9, 7, 7, 5, 3, 2, 1]);
    });

    test('throws when empty', () {
      final heap = MaxHeap<int>((a, b) => a.compareTo(b));
      expect(heap.pop, throwsStateError);
      expect(() => heap.peek, throwsStateError);
    });
  });

  group('DebtSimplifier.simplify', () {
    test('empty and all-zero balances need no transfers', () {
      expect(simplifier.simplify({}), isEmpty);
      expect(simplifier.simplify({'a': 0, 'b': 0, 'c': 0}), isEmpty);
    });

    test('one creditor with many debtors', () {
      final balances = {'a': 300, 'b': -100, 'c': -100, 'd': -100};
      final transfers = simplifier.simplify(balances);
      expect(transfers, hasLength(3));
      expect(transfers.every((t) => t.to == 'a' && t.amountMinor == 100), isTrue);
      expect(applyTransfers(balances, transfers).values.every((v) => v == 0), isTrue);
    });

    test('one debtor with many creditors', () {
      final balances = {'a': -600, 'b': 100, 'c': 200, 'd': 300};
      final transfers = simplifier.simplify(balances);
      expect(transfers, hasLength(3));
      // Largest creditor is paid first.
      expect(transfers.first, const Transfer(from: 'a', to: 'd', amountMinor: 300));
    });

    test('circular debts cancel out completely', () {
      // a owes b, b owes c, c owes a, all 500.
      final balances = DebtSimplifier.balances(
        memberIds: ['a', 'b', 'c'],
        expenses: [
          expense('b', 500, {'a': 500}),
          expense('c', 500, {'b': 500}),
          expense('a', 500, {'c': 500}),
        ],
        settlements: const [],
      );
      expect(balances.values.every((v) => v == 0), isTrue);
      expect(simplifier.simplify(balances), isEmpty);
    });

    test('uses at most n - 1 transfers and settles everyone', () {
      final balances = {'a': 500, 'b': 250, 'c': -400, 'd': -200, 'e': -150};
      final transfers = simplifier.simplify(balances);
      expect(transfers.length, lessThanOrEqualTo(4));
      expect(applyTransfers(balances, transfers).values.every((v) => v == 0), isTrue);
      expect(transfers.every((t) => t.amountMinor > 0), isTrue);
    });

    test('is deterministic for equal amounts', () {
      final balances = {'b': 100, 'a': 100, 'c': -100, 'd': -100};
      expect(simplifier.simplify(balances), simplifier.simplify(Map.of(balances)));
    });

    test('handles a large random group in n - 1 transfers or fewer', () {
      final balances = <String, int>{};
      var sum = 0;
      for (var i = 0; i < 199; i++) {
        final v = (i * 7919) % 2001 - 1000;
        balances['m$i'] = v;
        sum += v;
      }
      balances['last'] = -sum;
      final transfers = simplifier.simplify(balances);
      expect(transfers.length, lessThanOrEqualTo(balances.length - 1));
      expect(applyTransfers(balances, transfers).values.every((v) => v == 0), isTrue);
    });
  });

  group('DebtSimplifier.balances', () {
    test('counts payments, shares and settlements', () {
      final balances = DebtSimplifier.balances(
        memberIds: ['you', 'ravi', 'priya'],
        expenses: [
          expense('you', 900, {'you': 300, 'ravi': 300, 'priya': 300}),
        ],
        settlements: [
          Settlement(
            id: 's',
            groupId: 'g',
            fromMember: 'ravi',
            toMember: 'you',
            amount: const Money(300),
            occurredAt: DateTime(2026),
          ),
        ],
      );
      expect(balances, {'you': 300, 'ravi': 0, 'priya': -300});
      expect(balances.values.reduce((a, b) => a + b), 0);
    });
  });

  group('SplitCalculator', () {
    test('equal split covers the full amount', () {
      final shares = SplitCalculator.equal(const Money(1000), ['a', 'b', 'c']);
      expect(shares, {'a': 334, 'b': 333, 'c': 333});
    });

    test('splits by weights and skips zero weights', () {
      final shares = SplitCalculator.byShares(const Money(1000), {'a': 2, 'b': 1, 'c': 1, 'd': 0});
      expect(shares, {'a': 500, 'b': 250, 'c': 250});
    });

    test('rejects empty splits', () {
      expect(() => SplitCalculator.equal(const Money(100), []), throwsArgumentError);
      expect(() => SplitCalculator.byShares(const Money(100), {'a': 0}), throwsArgumentError);
    });
  });
}
