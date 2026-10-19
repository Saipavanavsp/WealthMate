import '../../../../core/collections/max_heap.dart';
import '../entities/group_entities.dart';

/// Turns a group's net balances into a short list of "who pays whom".
///
/// Greedy with two max-heaps: repeatedly match the person owed the most with
/// the person who owes the most and settle min(credit, debt). Each round
/// clears at least one person, so n people need at most n - 1 transfers,
/// compared with up to n(n - 1)/2 if every pairwise debt were paid separately.
///
/// Time: O(n log n). Building the heaps is n pushes, and each of the at most
/// n - 1 rounds does a constant number of heap operations.
/// Space: O(n) for the heaps and the result.
///
/// The true minimum is NP-hard (it needs splitting people into zero-sum
/// subgroups, which is a subset-sum problem). Greedy is optimal or within a few
/// transfers of it for realistic group sizes, and it's what most expense apps use.
class DebtSimplifier {
  const DebtSimplifier();

  List<Transfer> simplify(Map<String, int> balances) {
    // Ties are broken by member id so the output is deterministic and testable.
    int byAmount(_Party a, _Party b) {
      final diff = a.amount.compareTo(b.amount);
      return diff != 0 ? diff : b.member.compareTo(a.member);
    }

    final creditors = MaxHeap<_Party>(byAmount);
    final debtors = MaxHeap<_Party>(byAmount);
    for (final MapEntry(key: member, value: amount) in balances.entries) {
      if (amount > 0) creditors.push(_Party(member, amount));
      if (amount < 0) debtors.push(_Party(member, -amount));
    }

    final transfers = <Transfer>[];
    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final creditor = creditors.pop();
      final debtor = debtors.pop();
      final amount = creditor.amount < debtor.amount ? creditor.amount : debtor.amount;
      transfers.add(Transfer(from: debtor.member, to: creditor.member, amountMinor: amount));

      if (creditor.amount > amount) creditors.push(_Party(creditor.member, creditor.amount - amount));
      if (debtor.amount > amount) debtors.push(_Party(debtor.member, debtor.amount - amount));
    }
    return transfers;
  }

  /// Net balance per member: what they paid, minus their shares, adjusted for
  /// settlements already made. The values always sum to zero. O(e * m + s).
  static Map<String, int> balances({
    required Iterable<String> memberIds,
    required Iterable<GroupExpense> expenses,
    required Iterable<Settlement> settlements,
  }) {
    final result = {for (final id in memberIds) id: 0};
    void add(String id, int delta) => result[id] = (result[id] ?? 0) + delta;

    for (final expense in expenses) {
      add(expense.paidBy, expense.amount.minor);
      expense.shares.forEach((member, share) => add(member, -share));
    }
    for (final s in settlements) {
      add(s.fromMember, s.amount.minor);
      add(s.toMember, -s.amount.minor);
    }
    return result;
  }
}

class _Party {
  const _Party(this.member, this.amount);
  final String member;
  final int amount;
}
