import '../../../../core/error/result.dart';
import '../../../../core/money/money.dart';
import '../entities/savings_goal.dart';

abstract interface class GoalRepository {
  Stream<List<SavingsGoal>> watchAll();

  Future<List<SavingsGoal>> getAll();

  Future<Result<void>> save(SavingsGoal goal);

  Future<Result<void>> addContribution(String goalId, Money amount);

  Future<Result<void>> delete(String goalId);
}
