import '../../../../core/error/result.dart';
import '../../../../core/money/money.dart';
import '../entities/group_entities.dart';

abstract interface class GroupRepository {
  Stream<List<GroupSummary>> watchGroups();

  /// Emits null if the group doesn't exist or was deleted.
  Stream<GroupDetails?> watchDetails(String groupId);

  Future<Result<String>> createGroup(String name, List<String> memberNames);

  Future<Result<void>> addMember(String groupId, String name);

  Future<Result<void>> addExpense({
    required String groupId,
    required String description,
    required Money amount,
    required String paidBy,
    required SplitType splitType,
    required Map<String, int> shares,
  });

  Future<Result<void>> deleteExpense(GroupExpense expense);

  Future<Result<void>> recordSettlement({
    required String groupId,
    required String from,
    required String to,
    required Money amount,
  });

  Future<Result<void>> deleteGroup(String groupId);
}
