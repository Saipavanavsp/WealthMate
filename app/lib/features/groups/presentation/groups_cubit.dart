import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/money/money.dart';
import '../domain/entities/group_entities.dart';
import '../domain/repositories/group_repository.dart';

class GroupsState extends Equatable {
  const GroupsState({this.loading = true, this.groups = const [], this.failure});

  final bool loading;
  final List<GroupSummary> groups;
  final Failure? failure;

  @override
  List<Object?> get props => [loading, groups, failure];
}

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit(this._repository) : super(const GroupsState());

  final GroupRepository _repository;
  StreamSubscription<List<GroupSummary>>? _sub;

  void start() {
    _sub ??= _repository.watchGroups().listen((groups) => emit(GroupsState(loading: false, groups: groups)));
  }

  /// Returns the new group's id, or null if validation failed.
  Future<String?> create(String name, List<String> members) async {
    final result = await _repository.createGroup(name, members);
    return result.fold((f) {
      emit(GroupsState(loading: false, groups: state.groups, failure: f));
      return null;
    }, (id) => id);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

class GroupDetailState extends Equatable {
  const GroupDetailState({this.loading = true, this.details, this.failure, this.message});

  final bool loading;

  /// Null once loaded means the group was deleted.
  final GroupDetails? details;
  final Failure? failure;

  /// One-off confirmation such as "Payment recorded".
  final String? message;

  @override
  List<Object?> get props => [loading, details, failure, message];
}

class GroupDetailCubit extends Cubit<GroupDetailState> {
  GroupDetailCubit(this._repository, this.groupId) : super(const GroupDetailState());

  final GroupRepository _repository;
  final String groupId;
  StreamSubscription<GroupDetails?>? _sub;

  void start() {
    _sub ??= _repository.watchDetails(groupId).listen((d) => emit(GroupDetailState(loading: false, details: d)));
  }

  Future<bool> addExpense({
    required String description,
    required Money amount,
    required String paidBy,
    required SplitType splitType,
    required Map<String, int> shares,
  }) {
    return _run(
      _repository.addExpense(
        groupId: groupId,
        description: description,
        amount: amount,
        paidBy: paidBy,
        splitType: splitType,
        shares: shares,
      ),
    );
  }

  Future<bool> settle(Transfer transfer, {String? confirmation}) {
    return _run(
      _repository.recordSettlement(
        groupId: groupId,
        from: transfer.from,
        to: transfer.to,
        amount: Money(transfer.amountMinor),
      ),
      message: confirmation,
    );
  }

  Future<bool> addMember(String name) => _run(_repository.addMember(groupId, name));

  Future<bool> deleteExpense(GroupExpense expense) => _run(_repository.deleteExpense(expense));

  Future<bool> _run(Future<Result<void>> action, {String? message}) async {
    final result = await action;
    return result.fold(
      (f) {
        emit(GroupDetailState(loading: false, details: state.details, failure: f));
        return false;
      },
      (_) {
        if (message != null) emit(GroupDetailState(loading: false, details: state.details, message: message));
        return true;
      },
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
