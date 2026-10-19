import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wealthmate/core/error/failures.dart';
import 'package:wealthmate/core/error/result.dart';
import 'package:wealthmate/features/auth/domain/entities/session.dart';
import 'package:wealthmate/features/auth/presentation/bloc/auth_bloc.dart';

import '../helpers/mocks.dart';

void main() {
  late MockAuthRepository repo;
  late MockBiometrics biometrics;
  late StreamController<Session?> sessions;
  var lockEnabled = false;

  const session = Session(
    user: AppUser(id: 'u1', email: 'sai@example.com', name: 'Sai Pavan'),
    accessToken: 'a',
    refreshToken: 'r',
  );

  setUp(() {
    repo = MockAuthRepository();
    biometrics = MockBiometrics();
    sessions = StreamController<Session?>.broadcast();
    lockEnabled = false;
    when(() => repo.sessionChanges).thenAnswer((_) => sessions.stream);
    when(() => biometrics.isAvailable()).thenAnswer((_) async => true);
  });

  tearDown(() => sessions.close());

  AuthBloc build() => AuthBloc(repository: repo, biometrics: biometrics, biometricLockEnabled: () => lockEnabled);

  group('AuthStarted', () {
    blocTest<AuthBloc, AuthState>(
      'goes to Unauthenticated without a saved session',
      setUp: () => when(() => repo.restoreSession()).thenAnswer((_) async => null),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'restores the session',
      setUp: () => when(() => repo.restoreSession()).thenAnswer((_) async => session),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const Authenticated(session)],
    );

    blocTest<AuthBloc, AuthState>(
      'locks when biometric lock is on',
      setUp: () {
        lockEnabled = true;
        when(() => repo.restoreSession()).thenAnswer((_) async => session);
      },
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthLocked(session)],
    );
  });

  group('sign in', () {
    blocTest<AuthBloc, AuthState>(
      'login success',
      setUp: () => when(
        () => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Ok(session)),
      build: build,
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'sai@example.com', password: 'Password1')),
      expect: () => [const Unauthenticated(submitting: true), const Authenticated(session)],
    );

    blocTest<AuthBloc, AuthState>(
      'login failure carries the failure',
      setUp: () => when(
        () => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Err(UnauthorizedFailure('Incorrect email or password'))),
      build: build,
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'x@y.z', password: 'wrongpass')),
      expect: () => [
        const Unauthenticated(submitting: true),
        const Unauthenticated(failure: UnauthorizedFailure('Incorrect email or password')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'register success',
      setUp: () => when(
        () => repo.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Ok(session)),
      build: build,
      act: (bloc) =>
          bloc.add(const AuthRegisterRequested(name: 'Sai', email: 'sai@example.com', password: 'Password1')),
      expect: () => [const Unauthenticated(submitting: true), const Authenticated(session)],
    );

    blocTest<AuthBloc, AuthState>(
      'demo mode',
      setUp: () => when(() => repo.startDemo()).thenAnswer((_) async => const Session.demo()),
      build: build,
      act: (bloc) => bloc.add(const AuthDemoRequested()),
      expect: () => [const Unauthenticated(submitting: true), const Authenticated(Session.demo())],
    );

    blocTest<AuthBloc, AuthState>(
      'demo mode storage error',
      setUp: () => when(() => repo.startDemo()).thenThrow(Exception('disk full')),
      build: build,
      act: (bloc) => bloc.add(const AuthDemoRequested()),
      expect: () => [const Unauthenticated(submitting: true), const Unauthenticated(failure: StorageFailure())],
    );
  });

  group('lock and logout', () {
    blocTest<AuthBloc, AuthState>(
      'unlock succeeds',
      setUp: () => when(() => biometrics.authenticate(any())).thenAnswer((_) async => true),
      build: build,
      seed: () => const AuthLocked(session),
      act: (bloc) => bloc.add(const AuthUnlockRequested('Unlock')),
      expect: () => [const Authenticated(session)],
    );

    blocTest<AuthBloc, AuthState>(
      'unlock fails and stays locked',
      setUp: () => when(() => biometrics.authenticate(any())).thenAnswer((_) async => false),
      build: build,
      seed: () => const AuthLocked(session),
      act: (bloc) => bloc.add(const AuthUnlockRequested('Unlock')),
      expect: () => [const AuthLocked(session, failed: true)],
    );

    blocTest<AuthBloc, AuthState>(
      'logout clears local data',
      setUp: () => when(() => repo.logout()).thenAnswer((_) async {}),
      build: build,
      seed: () => const Authenticated(session),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [const Unauthenticated()],
      verify: (_) => verify(() => repo.logout()).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'a session that disappears (refresh rejected) signs the user out',
      build: build,
      seed: () => const Authenticated(session),
      act: (bloc) => sessions.add(null),
      expect: () => [const Unauthenticated(failure: UnauthorizedFailure())],
    );
  });
}
