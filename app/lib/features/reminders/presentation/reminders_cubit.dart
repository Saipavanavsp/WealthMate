import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/bill_reminder.dart';
import '../domain/reminder_repository.dart';

class RemindersState extends Equatable {
  const RemindersState({this.loading = true, this.reminders = const []});

  final bool loading;
  final List<BillReminder> reminders;

  @override
  List<Object?> get props => [loading, reminders];
}

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(this._repository) : super(const RemindersState());

  final ReminderRepository _repository;
  StreamSubscription<List<BillReminder>>? _sub;

  void start() {
    _sub ??= _repository.watchAll().listen((items) => emit(RemindersState(loading: false, reminders: items)));
  }

  Future<void> save(BillReminder reminder) => _repository.save(reminder);

  Future<void> toggle(BillReminder reminder) => _repository.save(reminder.copyWith(enabled: !reminder.enabled));

  Future<void> delete(BillReminder reminder) => _repository.delete(reminder);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
