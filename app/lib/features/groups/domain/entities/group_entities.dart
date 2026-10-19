import 'package:equatable/equatable.dart';

import '../../../../core/money/money.dart';

class Group extends Equatable {
  const Group({required this.id, required this.name, required this.currency, required this.updatedAt});

  final String id;
  final String name;
  final String currency;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, name, currency, updatedAt];
}

class GroupMember extends Equatable {
  const GroupMember({required this.id, required this.groupId, required this.name});

  final String id;
  final String groupId;
  final String name;

  @override
  List<Object?> get props => [id, groupId, name];
}

enum SplitType { equal, custom }

class GroupExpense extends Equatable {
  const GroupExpense({
    required this.id,
    required this.groupId,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splitType,
    required this.shares,
    required this.occurredAt,
  });

  final String id;
  final String groupId;
  final String description;
  final Money amount;
  final String paidBy;
  final SplitType splitType;

  /// memberId -> owed amount in minor units. Always sums to [amount].
  final Map<String, int> shares;
  final DateTime occurredAt;

  @override
  List<Object?> get props => [id, groupId, description, amount, paidBy, splitType, shares, occurredAt];
}

class Settlement extends Equatable {
  const Settlement({
    required this.id,
    required this.groupId,
    required this.fromMember,
    required this.toMember,
    required this.amount,
    required this.occurredAt,
  });

  final String id;
  final String groupId;
  final String fromMember;
  final String toMember;
  final Money amount;
  final DateTime occurredAt;

  @override
  List<Object?> get props => [id, groupId, fromMember, toMember, amount, occurredAt];
}

/// A suggested payment that settles part of the group's debts.
class Transfer extends Equatable {
  const Transfer({required this.from, required this.to, required this.amountMinor});

  final String from;
  final String to;
  final int amountMinor;

  @override
  List<Object?> get props => [from, to, amountMinor];

  @override
  String toString() => '$from -> $to: $amountMinor';
}

class GroupSummary extends Equatable {
  const GroupSummary({required this.group, required this.memberCount, required this.totalSpent});

  final Group group;
  final int memberCount;
  final Money totalSpent;

  @override
  List<Object?> get props => [group, memberCount, totalSpent];
}

class GroupDetails extends Equatable {
  const GroupDetails({
    required this.group,
    required this.members,
    required this.expenses,
    required this.settlements,
    required this.balances,
    required this.transfers,
  });

  final Group group;
  final List<GroupMember> members;
  final List<GroupExpense> expenses;
  final List<Settlement> settlements;

  /// memberId -> net balance in minor units (positive means they are owed).
  final Map<String, int> balances;
  final List<Transfer> transfers;

  String nameOf(String memberId) => members.where((m) => m.id == memberId).map((m) => m.name).firstOrNull ?? '?';

  Money get totalSpent => Money(expenses.fold(0, (sum, e) => sum + e.amount.minor), currency: group.currency);

  @override
  List<Object?> get props => [group, members, expenses, settlements, balances, transfers];
}
