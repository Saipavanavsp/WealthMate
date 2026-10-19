import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/auth_repository.dart';
import '../../domain/entities/session.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

final class AuthDemoRequested extends AuthEvent {
  const AuthDemoRequested();
}

final class AuthUnlockRequested extends AuthEvent {
  const AuthUnlockRequested(this.reason);

  /// Localised prompt shown by the OS biometric sheet.
  final String reason;

  @override
  List<Object?> get props => [reason];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class _AuthSessionChanged extends AuthEvent {
  const _AuthSessionChanged(this.session);

  final Session? session;

  @override
  List<Object?> get props => [session];
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated({this.submitting = false, this.failure});

  final bool submitting;
  final Failure? failure;

  @override
  List<Object?> get props => [submitting, failure];
}

final class AuthLocked extends AuthState {
  const AuthLocked(this.session, {this.failed = false});

  final Session session;
  final bool failed;

  @override
  List<Object?> get props => [session, failed];
}

final class Authenticated extends AuthState {
  const Authenticated(this.session);

  final Session session;

  @override
  List<Object?> get props => [session];
}

/// Owns the sign-in lifecycle: restore on launch, biometric lock, sign in,
/// demo mode, and sign out (including forced sign-out when a refresh fails).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository repository,
    required BiometricAuthenticator biometrics,
    required bool Function() biometricLockEnabled,
  }) : _repository = repository,
       _biometrics = biometrics,
       _biometricLockEnabled = biometricLockEnabled,
       super(const AuthUnknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthDemoRequested>(_onDemo);
    on<AuthUnlockRequested>(_onUnlock);
    on<AuthLogoutRequested>(_onLogout);
    on<_AuthSessionChanged>(_onSessionChanged);

    _sessionSub = _repository.sessionChanges.listen((s) => add(_AuthSessionChanged(s)));
  }

  final AuthRepository _repository;
  final BiometricAuthenticator _biometrics;
  final bool Function() _biometricLockEnabled;
  late final StreamSubscription<Session?> _sessionSub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final session = await _repository.restoreSession();
    if (session == null) return emit(const Unauthenticated());
    if (_biometricLockEnabled() && await _biometrics.isAvailable()) return emit(AuthLocked(session));
    emit(Authenticated(session));
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const Unauthenticated(submitting: true));
    final result = await _repository.login(email: event.email, password: event.password);
    emit(result.fold((f) => Unauthenticated(failure: f), Authenticated.new));
  }

  Future<void> _onRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(const Unauthenticated(submitting: true));
    final result = await _repository.register(name: event.name, email: event.email, password: event.password);
    emit(result.fold((f) => Unauthenticated(failure: f), Authenticated.new));
  }

  Future<void> _onDemo(AuthDemoRequested event, Emitter<AuthState> emit) async {
    emit(const Unauthenticated(submitting: true));
    try {
      emit(Authenticated(await _repository.startDemo()));
    } catch (_) {
      emit(const Unauthenticated(failure: StorageFailure()));
    }
  }

  Future<void> _onUnlock(AuthUnlockRequested event, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthLocked) return;
    final ok = await _biometrics.authenticate(event.reason);
    emit(ok ? Authenticated(current.session) : AuthLocked(current.session, failed: true));
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    // Emit first so the session-cleared notification isn't mistaken for an expiry.
    emit(const Unauthenticated());
    await _repository.logout();
  }

  void _onSessionChanged(_AuthSessionChanged event, Emitter<AuthState> emit) {
    // Only react to the session disappearing (e.g. refresh token rejected).
    if (event.session == null && state is Authenticated) {
      emit(const Unauthenticated(failure: UnauthorizedFailure()));
    }
  }

  @override
  Future<void> close() async {
    await _sessionSub.cancel();
    return super.close();
  }
}
