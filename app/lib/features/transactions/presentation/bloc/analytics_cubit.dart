import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/analytics/spending_analytics.dart';
import '../../domain/entities/transaction_entry.dart';
import '../../domain/repositories/transaction_repository.dart';

enum ChartPeriod { monthly, weekly }

class AnalyticsState extends Equatable {
  const AnalyticsState({this.loading = true, this.summary = SpendingSummary.empty, this.period = ChartPeriod.monthly});

  final bool loading;
  final SpendingSummary summary;
  final ChartPeriod period;

  List<PeriodTotal> get bars => period == ChartPeriod.monthly ? summary.monthly : summary.weekly;

  AnalyticsState copyWith({bool? loading, SpendingSummary? summary, ChartPeriod? period}) {
    return AnalyticsState(
      loading: loading ?? this.loading,
      summary: summary ?? this.summary,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [loading, summary, period];
}

/// Signature of the function that runs the aggregation. Defaults to Flutter's
/// [compute], which moves the work to a background isolate so large histories
/// don't drop frames. Tests pass a synchronous version.
typedef AnalyticsRunner = Future<SpendingSummary> Function(AnalyticsRequest request);

Future<SpendingSummary> runInIsolate(AnalyticsRequest request) => compute(SpendingAnalytics.summarise, request);

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._repository, {AnalyticsRunner runner = runInIsolate, DateTime Function()? clock})
    : _runner = runner,
      _clock = clock ?? DateTime.now,
      super(const AnalyticsState());

  final TransactionRepository _repository;
  final AnalyticsRunner _runner;
  final DateTime Function() _clock;
  StreamSubscription<List<TransactionEntry>>? _sub;

  void start() {
    _sub ??= _repository.watchAll().listen((items) async {
      final summary = await _runner(AnalyticsRequest(items, _clock()));
      if (!isClosed) emit(state.copyWith(loading: false, summary: summary));
    });
  }

  void periodChanged(ChartPeriod period) => emit(state.copyWith(period: period));

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
