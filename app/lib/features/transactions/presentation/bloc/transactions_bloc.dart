import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entry.dart';
import '../../domain/repositories/transaction_repository.dart';

enum TransactionFilter { all, expenses, income }

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionsSubscribed extends TransactionsEvent {
  const TransactionsSubscribed();
}

final class TransactionsFilterChanged extends TransactionsEvent {
  const TransactionsFilterChanged(this.filter);

  final TransactionFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class TransactionDeleted extends TransactionsEvent {
  const TransactionDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

enum TransactionsStatus { loading, ready }

class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TransactionsStatus.loading,
    this.all = const [],
    this.filter = TransactionFilter.all,
    this.failure,
  });

  final TransactionsStatus status;
  final List<TransactionEntry> all;
  final TransactionFilter filter;
  final Failure? failure;

  List<TransactionEntry> get visible => switch (filter) {
    TransactionFilter.all => all,
    TransactionFilter.expenses => all.where((t) => t.isExpense).toList(),
    TransactionFilter.income => all.where((t) => !t.isExpense).toList(),
  };

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionEntry>? all,
    TransactionFilter? filter,
    Failure? failure,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      all: all ?? this.all,
      filter: filter ?? this.filter,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, all, filter, failure];
}

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc(this._repository) : super(const TransactionsState()) {
    on<TransactionsSubscribed>(_onSubscribed);
    on<TransactionsFilterChanged>((event, emit) => emit(state.copyWith(filter: event.filter)));
    on<TransactionDeleted>(_onDeleted);
  }

  final TransactionRepository _repository;

  /// emit.forEach ties the database subscription to the bloc's lifetime,
  /// so it's cancelled automatically when the bloc closes.
  Future<void> _onSubscribed(TransactionsSubscribed event, Emitter<TransactionsState> emit) {
    return emit.forEach<List<TransactionEntry>>(
      _repository.watchAll(),
      onData: (items) => state.copyWith(status: TransactionsStatus.ready, all: items),
      onError: (_, _) => state.copyWith(status: TransactionsStatus.ready, failure: const StorageFailure()),
    );
  }

  Future<void> _onDeleted(TransactionDeleted event, Emitter<TransactionsState> emit) async {
    final result = await _repository.delete(event.id);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
  }
}
