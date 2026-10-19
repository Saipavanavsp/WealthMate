import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/money/money.dart';
import '../domain/entities/savings_goal.dart';
import '../domain/repositories/goal_repository.dart';

class GoalsState extends Equatable {
  const GoalsState({this.loading = true, this.goals = const [], this.failure});

  final bool loading;
  final List<SavingsGoal> goals;
  final Failure? failure;

  Money get totalSaved => goals.fold(const Money.zero(), (sum, g) => sum + g.saved);

  @override
  List<Object?> get props => [loading, goals, failure];
}

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this._repository, {required String Function() newId, DateTime Function()? clock})
    : _newId = newId,
      _clock = clock ?? DateTime.now,
      super(const GoalsState());

  final GoalRepository _repository;
  final String Function() _newId;
  final DateTime Function() _clock;

  StreamSubscription<List<SavingsGoal>>? _sub;

  void start() {
    _sub ??= _repository.watchAll().listen((goals) => emit(GoalsState(loading: false, goals: goals)));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }

  Future<bool> create({required String name, required Money target, required Money saved, required DateTime deadline}) {
    final goal = SavingsGoal(
      id: _newId(),
      name: name,
      target: target,
      saved: saved,
      deadline: deadline,
      updatedAt: _clock(),
    );
    return _handle(_repository.save(goal));
  }

  Future<bool> contribute(String goalId, Money amount) => _handle(_repository.addContribution(goalId, amount));

  Future<bool> delete(String goalId) => _handle(_repository.delete(goalId));

  Future<bool> _handle(Future<Result<void>> pending) async {
    final result = await pending;
    return result.fold((failure) {
      emit(GoalsState(loading: false, goals: state.goals, failure: failure));
      return false;
    }, (_) => true);
  }
}
