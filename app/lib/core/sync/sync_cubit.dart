import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import 'sync_engine.dart';
import 'sync_queue.dart';

enum SyncStatus { disabled, idle, syncing, offline, failed }

class SyncState extends Equatable {
  const SyncState({this.status = SyncStatus.idle, this.pending = 0, this.lastSyncedAt, this.error});

  final SyncStatus status;
  final int pending;
  final DateTime? lastSyncedAt;
  final String? error;

  SyncState copyWith({SyncStatus? status, int? pending, DateTime? lastSyncedAt, String? error}) {
    return SyncState(
      status: status ?? this.status,
      pending: pending ?? this.pending,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, pending, lastSyncedAt, error];
}

/// Decides when to sync and exposes progress to the UI.
///
/// Triggers: coming back online, new local changes (debounced so a burst of
/// edits becomes one request), a periodic timer, and the "Sync now" button.
class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required SyncEngine engine,
    required SyncQueueStore queue,
    required ConnectivityService connectivity,
    required bool Function() canSync,
    Duration debounce = const Duration(seconds: 2),
    Duration interval = const Duration(minutes: 5),
  }) : _engine = engine,
       _queue = queue,
       _connectivity = connectivity,
       _canSync = canSync,
       _debounce = debounce,
       _interval = interval,
       super(const SyncState());

  final SyncEngine _engine;
  final SyncQueueStore _queue;
  final ConnectivityService _connectivity;
  final bool Function() _canSync;
  final Duration _debounce;
  final Duration _interval;

  StreamSubscription<int>? _pendingSub;
  StreamSubscription<bool>? _onlineSub;
  Timer? _debounceTimer;
  Timer? _periodic;

  void start() {
    if (_pendingSub != null) return;
    _pendingSub = _queue.watchPendingCount().listen((count) {
      final increased = count > state.pending;
      emit(state.copyWith(pending: count, error: state.error));
      if (increased) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(_debounce, syncNow);
      }
    });
    _onlineSub = _connectivity.onlineChanges.listen((online) {
      if (online) {
        unawaited(syncNow());
      } else if (_canSync()) {
        emit(state.copyWith(status: SyncStatus.offline));
      }
    });
    _periodic = Timer.periodic(_interval, (_) => syncNow());
    unawaited(syncNow());
  }

  Future<void> syncNow() async {
    if (isClosed) return;
    if (!_canSync()) {
      emit(state.copyWith(status: SyncStatus.disabled));
      return;
    }
    if (!await _connectivity.isOnline()) {
      emit(state.copyWith(status: SyncStatus.offline));
      return;
    }

    emit(state.copyWith(status: SyncStatus.syncing));
    try {
      await _engine.sync();
      if (!isClosed) emit(state.copyWith(status: SyncStatus.idle, lastSyncedAt: DateTime.now()));
    } catch (e) {
      if (!isClosed) emit(state.copyWith(status: SyncStatus.failed, error: mapDioError(e).message));
    }
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    _periodic?.cancel();
    await _pendingSub?.cancel();
    await _onlineSub?.cancel();
    return super.close();
  }
}
