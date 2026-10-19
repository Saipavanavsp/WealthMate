import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/money/money.dart';
import '../../../core/sync/sync_handler.dart';
import '../../../core/sync/synced_writer.dart';
import '../domain/entities/savings_goal.dart';
import '../domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl({
    required AppDatabase db,
    required SyncedWriter writer,
    required SyncHandlers handlers,
    DateTime Function()? clock,
  }) : _db = db,
       _writer = writer,
       _handler = handlers.goals,
       _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SyncedWriter _writer;
  final SyncHandler<$GoalsTable, GoalRow> _handler;
  final DateTime Function() _clock;

  SimpleSelectStatement<$GoalsTable, GoalRow> _live() {
    return _db.select(_db.goals)
      ..where((g) => g.deleted.equals(false))
      ..orderBy([(g) => OrderingTerm.asc(g.deadline)]);
  }

  @override
  Stream<List<SavingsGoal>> watchAll() => _live().watch().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<SavingsGoal>> getAll() async => (await _live().get()).map(_toEntity).toList();

  @override
  Future<Result<void>> save(SavingsGoal goal) async {
    if (goal.name.trim().isEmpty) return const Err(ValidationFailure('Give the goal a name'));
    if (!goal.target.isPositive) return const Err(ValidationFailure('Target must be greater than zero'));
    return _write(goal);
  }

  @override
  Future<Result<void>> addContribution(String goalId, Money amount) async {
    if (!amount.isPositive) return const Err(ValidationFailure('Amount must be greater than zero'));
    final row = await (_db.select(_db.goals)..where((g) => g.id.equals(goalId))).getSingleOrNull();
    if (row == null) return const Err(ValidationFailure('Goal not found'));
    final goal = _toEntity(row);
    return _write(goal.copyWith(saved: goal.saved + amount));
  }

  @override
  Future<Result<void>> delete(String goalId) async {
    final row = await (_db.select(_db.goals)..where((g) => g.id.equals(goalId))).getSingleOrNull();
    if (row == null) return const Err(ValidationFailure('Goal not found'));
    return _write(_toEntity(row), deleted: true);
  }

  Future<Result<void>> _write(SavingsGoal goal, {bool deleted = false}) async {
    try {
      await _writer.save(_handler, _toRow(goal.copyWith(updatedAt: _clock()), deleted: deleted));
      return const Ok(null);
    } catch (_) {
      return const Err(StorageFailure());
    }
  }

  SavingsGoal _toEntity(GoalRow row) {
    return SavingsGoal(
      id: row.id,
      name: row.name,
      target: Money(row.targetMinor, currency: row.currency),
      saved: Money(row.savedMinor, currency: row.currency),
      deadline: DateTime.fromMillisecondsSinceEpoch(row.deadline),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }

  GoalRow _toRow(SavingsGoal goal, {bool deleted = false}) {
    return GoalRow(
      id: goal.id,
      name: goal.name.trim(),
      targetMinor: goal.target.minor,
      savedMinor: goal.saved.minor,
      currency: goal.target.currency,
      deadline: goal.deadline.millisecondsSinceEpoch,
      updatedAt: goal.updatedAt.millisecondsSinceEpoch,
      deleted: deleted,
    );
  }
}
