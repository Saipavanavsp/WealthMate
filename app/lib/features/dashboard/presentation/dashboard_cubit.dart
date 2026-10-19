import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/money/money.dart';
import '../../goals/domain/entities/savings_goal.dart';
import '../../goals/domain/repositories/goal_repository.dart';
import '../../health_score/domain/health_score_calculator.dart';
import '../../transactions/domain/entities/transaction_entry.dart';
import '../../transactions/domain/repositories/transaction_repository.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.loading = true,
    this.monthIncome = const Money.zero(),
    this.monthExpense = const Money.zero(),
    this.recent = const [],
    this.score,
  });

  final bool loading;
  final Money monthIncome;
  final Money monthExpense;
  final List<TransactionEntry> recent;
  final HealthScore? score;

  Money get monthNet => monthIncome - monthExpense;

  @override
  List<Object?> get props => [loading, monthIncome, monthExpense, recent, score];
}

/// Combines the transaction and goal streams into the home screen summary.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required TransactionRepository transactions,
    required GoalRepository goals,
    HealthScoreCalculator calculator = const HealthScoreCalculator(),
    DateTime Function()? clock,
  }) : _transactions = transactions,
       _goals = goals,
       _calculator = calculator,
       _clock = clock ?? DateTime.now,
       super(const DashboardState());

  final TransactionRepository _transactions;
  final GoalRepository _goals;
  final HealthScoreCalculator _calculator;
  final DateTime Function() _clock;

  StreamSubscription<List<TransactionEntry>>? _txSub;
  StreamSubscription<List<SavingsGoal>>? _goalSub;
  List<TransactionEntry>? _latestTx;
  List<SavingsGoal>? _latestGoals;

  void start() {
    _txSub ??= _transactions.watchAll().listen((items) {
      _latestTx = items;
      _recompute();
    });
    _goalSub ??= _goals.watchAll().listen((items) {
      _latestGoals = items;
      _recompute();
    });
  }

  void _recompute() {
    final txs = _latestTx;
    final goals = _latestGoals;
    if (txs == null || goals == null || isClosed) return;

    final now = _clock();
    final monthStart = DateTime(now.year, now.month).millisecondsSinceEpoch;
    final nextMonth = DateTime(now.year, now.month + 1).millisecondsSinceEpoch;
    var income = 0;
    var expense = 0;
    for (final t in txs) {
      final at = t.occurredAt.millisecondsSinceEpoch;
      if (at < monthStart || at >= nextMonth) continue;
      if (t.isExpense) {
        expense += t.amount.minor;
      } else {
        income += t.amount.minor;
      }
    }

    emit(
      DashboardState(
        loading: false,
        monthIncome: Money(income),
        monthExpense: Money(expense),
        recent: txs.take(5).toList(),
        score: _calculator.calculate(transactions: txs, goals: goals, now: now),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _txSub?.cancel();
    await _goalSub?.cancel();
    return super.close();
  }
}
