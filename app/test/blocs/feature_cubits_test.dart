import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wealthmate/core/error/failures.dart';
import 'package:wealthmate/core/error/result.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/core/sync/sync_cubit.dart';
import 'package:wealthmate/core/sync/sync_engine.dart';
import 'package:wealthmate/features/dashboard/presentation/dashboard_cubit.dart';
import 'package:wealthmate/features/goals/presentation/goals_cubit.dart';
import 'package:wealthmate/features/groups/domain/entities/group_entities.dart';
import 'package:wealthmate/features/groups/presentation/groups_cubit.dart';
import 'package:wealthmate/features/reminders/domain/bill_reminder.dart';
import 'package:wealthmate/features/reminders/presentation/reminders_cubit.dart';
import 'package:wealthmate/features/settings/presentation/settings_cubit.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';

import '../helpers/mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(registerFallbacks);

  group('DashboardCubit', () {
    final now = DateTime(2026, 10, 19);
    late MockTransactionRepository txRepo;
    late MockGoalRepository goalRepo;

    setUp(() {
      txRepo = MockTransactionRepository();
      goalRepo = MockGoalRepository();
    });

    blocTest<DashboardCubit, DashboardState>(
      'waits for both streams, then summarises the current month',
      setUp: () {
        when(() => txRepo.watchAll()).thenAnswer(
          (_) => Stream.value([
            tx(id: 'a', amount: 3000, at: DateTime(2026, 10, 5)),
            tx(id: 'b', type: TransactionType.income, category: 'Salary', at: DateTime(2026, 10)),
            tx(id: 'c', amount: 999, at: DateTime(2026, 9, 5)),
          ]),
        );
        when(() => goalRepo.watchAll()).thenAnswer((_) => Stream.value([goal(saved: 50000)]));
      },
      build: () => DashboardCubit(transactions: txRepo, goals: goalRepo, clock: () => now),
      act: (cubit) => cubit.start(),
      verify: (cubit) {
        final state = cubit.state;
        expect(state.loading, isFalse);
        expect(state.monthIncome, const Money(10000));
        expect(state.monthExpense, const Money(3000));
        expect(state.monthNet, const Money(7000));
        expect(state.recent, hasLength(3));
        expect(state.score, isNotNull);
      },
    );
  });

  group('GoalsCubit', () {
    late MockGoalRepository repo;
    setUp(() => repo = MockGoalRepository());

    blocTest<GoalsCubit, GoalsState>(
      'lists goals',
      setUp: () => when(() => repo.watchAll()).thenAnswer((_) => Stream.value([goal(saved: 100)])),
      build: () => GoalsCubit(repo, newId: () => 'g'),
      act: (cubit) => cubit.start(),
      expect: () => [
        GoalsState(loading: false, goals: [goal(saved: 100)]),
      ],
      verify: (cubit) => expect(cubit.state.totalSaved, const Money(100)),
    );

    blocTest<GoalsCubit, GoalsState>(
      'creates a goal',
      setUp: () => when(() => repo.save(any())).thenAnswer((_) async => const Ok(null)),
      build: () => GoalsCubit(repo, newId: () => 'g', clock: () => DateTime(2026)),
      act: (cubit) =>
          cubit.create(name: 'Bike', target: const Money(100), saved: const Money(0), deadline: DateTime(2027)),
      expect: () => <GoalsState>[],
      verify: (_) => verify(() => repo.save(any())).called(1),
    );

    blocTest<GoalsCubit, GoalsState>(
      'reports failures from contribute and delete',
      setUp: () {
        when(() => repo.addContribution(any(), any())).thenAnswer((_) async => const Err(ValidationFailure('no')));
        when(() => repo.delete(any())).thenAnswer((_) async => const Ok(null));
      },
      build: () => GoalsCubit(repo, newId: () => 'g'),
      act: (cubit) async {
        await cubit.contribute('g', const Money(5));
        await cubit.delete('g');
      },
      expect: () => [const GoalsState(loading: false, failure: ValidationFailure('no'))],
    );
  });

  group('GroupsCubit', () {
    late MockGroupRepository repo;
    final summary = GroupSummary(
      group: Group(id: 'g', name: 'Trip', currency: 'INR', updatedAt: DateTime(2026)),
      memberCount: 3,
      totalSpent: const Money(100),
    );
    setUp(() => repo = MockGroupRepository());

    blocTest<GroupsCubit, GroupsState>(
      'lists groups',
      setUp: () => when(() => repo.watchGroups()).thenAnswer((_) => Stream.value([summary])),
      build: () => GroupsCubit(repo),
      act: (cubit) => cubit.start(),
      expect: () => [
        GroupsState(loading: false, groups: [summary]),
      ],
    );

    blocTest<GroupsCubit, GroupsState>(
      'create returns null and reports invalid input',
      setUp: () =>
          when(() => repo.createGroup(any(), any()))
              .thenAnswer((_) async => const Err(ValidationFailure('A group needs at least two members'))),
      build: () => GroupsCubit(repo),
      act: (cubit) async => expect(await cubit.create('Solo', ['me']), isNull),
      expect: () => [
        const GroupsState(loading: false, failure: ValidationFailure('A group needs at least two members')),
      ],
    );

    blocTest<GroupsCubit, GroupsState>(
      'create returns the new id',
      setUp: () => when(() => repo.createGroup(any(), any())).thenAnswer((_) async => const Ok('new')),
      build: () => GroupsCubit(repo),
      act: (cubit) async => expect(await cubit.create('Trip', ['a', 'b']), 'new'),
      expect: () => <GroupsState>[],
    );
  });

  group('GroupDetailCubit', () {
    late MockGroupRepository repo;
    setUp(() => repo = MockGroupRepository());

    blocTest<GroupDetailCubit, GroupDetailState>(
      'records a settlement with a confirmation',
      setUp: () => when(
        () => repo.recordSettlement(
          groupId: any(named: 'groupId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          amount: any(named: 'amount'),
        ),
      ).thenAnswer((_) async => const Ok(null)),
      build: () => GroupDetailCubit(repo, 'g'),
      act: (cubit) => cubit.settle(
        const Transfer(from: 'a', to: 'b', amountMinor: 500),
        confirmation: 'Paid',
      ),
      expect: () => [const GroupDetailState(loading: false, message: 'Paid')],
      verify: (_) =>
          verify(() => repo.recordSettlement(groupId: 'g', from: 'a', to: 'b', amount: const Money(500))).called(1),
    );

    blocTest<GroupDetailCubit, GroupDetailState>(
      'reports a bad expense',
      setUp: () => when(
        () => repo.addExpense(
          groupId: any(named: 'groupId'),
          description: any(named: 'description'),
          amount: any(named: 'amount'),
          paidBy: any(named: 'paidBy'),
          splitType: any(named: 'splitType'),
          shares: any(named: 'shares'),
        ),
      ).thenAnswer((_) async => const Err(ValidationFailure('Shares must add up to the full amount'))),
      build: () => GroupDetailCubit(repo, 'g'),
      act: (cubit) => cubit.addExpense(
        description: 'x',
        amount: const Money(10),
        paidBy: 'a',
        splitType: SplitType.custom,
        shares: {'a': 1},
      ),
      expect: () => [
        const GroupDetailState(loading: false, failure: ValidationFailure('Shares must add up to the full amount')),
      ],
    );

    blocTest<GroupDetailCubit, GroupDetailState>(
      'watches details and supports member and expense changes',
      setUp: () {
        when(() => repo.watchDetails('g')).thenAnswer((_) => Stream.value(null));
        when(() => repo.addMember(any(), any())).thenAnswer((_) async => const Ok(null));
        when(() => repo.deleteExpense(any())).thenAnswer((_) async => const Ok(null));
      },
      build: () => GroupDetailCubit(repo, 'g'),
      act: (cubit) async {
        cubit.start();
        await cubit.addMember('Neha');
        await cubit.deleteExpense(
          GroupExpense(
            id: 'e',
            groupId: 'g',
            description: 'd',
            amount: const Money(1),
            paidBy: 'a',
            splitType: SplitType.equal,
            shares: const {'a': 1},
            occurredAt: DateTime(2026),
          ),
        );
      },
      expect: () => [const GroupDetailState(loading: false)],
    );
  });

  group('RemindersCubit', () {
    late MockReminderRepository repo;
    const reminder = BillReminder(id: 1, title: 'Rent', amount: Money(100), dayOfMonth: 5);
    setUp(() => repo = MockReminderRepository());

    blocTest<RemindersCubit, RemindersState>(
      'lists, toggles and deletes',
      setUp: () {
        when(() => repo.watchAll()).thenAnswer((_) => Stream.value([reminder]));
        when(() => repo.save(any())).thenAnswer((i) async => i.positionalArguments.first as BillReminder);
        when(() => repo.delete(any())).thenAnswer((_) async {});
      },
      build: () => RemindersCubit(repo),
      act: (cubit) async {
        cubit.start();
        await cubit.toggle(reminder);
        await cubit.save(reminder);
        await cubit.delete(reminder);
      },
      expect: () => [
        const RemindersState(loading: false, reminders: [reminder]),
      ],
      verify: (_) {
        verify(() => repo.save(reminder.copyWith(enabled: false))).called(1);
        verify(() => repo.delete(reminder)).called(1);
      },
    );
  });

  group('SettingsCubit', () {
    late MockSettingsRepository repo;
    late MockBiometrics biometrics;

    setUp(() {
      repo = MockSettingsRepository();
      biometrics = MockBiometrics();
      when(() => repo.themeMode).thenReturn(ThemeMode.system);
      when(() => repo.locale).thenReturn(null);
      when(() => repo.biometricLock).thenReturn(false);
      when(() => repo.setThemeMode(any())).thenAnswer((_) async {});
      when(() => repo.setLocale(any())).thenAnswer((_) async {});
      when(() => repo.setBiometricLock(any())).thenAnswer((_) async {});
    });

    setUpAll(() {
      registerFallbackValue(ThemeMode.system);
      registerFallbackValue(const Locale('en'));
    });

    blocTest<SettingsCubit, SettingsState>(
      'changes theme and language',
      build: () => SettingsCubit(repo, biometrics),
      act: (cubit) async {
        await cubit.setThemeMode(ThemeMode.dark);
        await cubit.setLocale(const Locale('te'));
        await cubit.setLocale(null);
      },
      expect: () => const [
        SettingsState(themeMode: ThemeMode.dark),
        SettingsState(themeMode: ThemeMode.dark, locale: Locale('te')),
        SettingsState(themeMode: ThemeMode.dark),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'enabling biometric lock requires a successful check',
      setUp: () {
        when(() => biometrics.isAvailable()).thenAnswer((_) async => true);
        when(() => biometrics.authenticate(any())).thenAnswer((_) async => true);
      },
      build: () => SettingsCubit(repo, biometrics),
      act: (cubit) async {
        await cubit.checkBiometrics();
        await cubit.setBiometricLock(true, reason: 'confirm');
      },
      expect: () => const [
        SettingsState(biometricAvailable: true),
        SettingsState(biometricAvailable: true, biometricLock: true),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'a failed check leaves the lock off',
      setUp: () => when(() => biometrics.authenticate(any())).thenAnswer((_) async => false),
      build: () => SettingsCubit(repo, biometrics),
      act: (cubit) => cubit.setBiometricLock(true, reason: 'confirm'),
      expect: () => <SettingsState>[],
    );
  });

  group('SyncCubit', () {
    late MockSyncEngine engine;
    late MockSyncQueue queue;
    late MockConnectivity connectivity;
    late StreamController<int> pending;
    late StreamController<bool> online;
    var canSync = true;

    setUp(() {
      engine = MockSyncEngine();
      queue = MockSyncQueue();
      connectivity = MockConnectivity();
      pending = StreamController<int>.broadcast();
      online = StreamController<bool>.broadcast();
      canSync = true;
      when(() => queue.watchPendingCount()).thenAnswer((_) => pending.stream);
      when(() => connectivity.onlineChanges).thenAnswer((_) => online.stream);
      when(() => connectivity.isOnline()).thenAnswer((_) async => true);
      when(() => engine.sync()).thenAnswer((_) async => const SyncReport(pushed: 1));
    });

    tearDown(() async {
      await pending.close();
      await online.close();
    });

    SyncCubit build() => SyncCubit(
      engine: engine,
      queue: queue,
      connectivity: connectivity,
      canSync: () => canSync,
      debounce: Duration.zero,
    );

    blocTest<SyncCubit, SyncState>(
      'syncs and records the time',
      build: build,
      act: (cubit) => cubit.syncNow(),
      expect: () => [
        const SyncState(status: SyncStatus.syncing),
        isA<SyncState>().having((s) => s.lastSyncedAt, 'lastSyncedAt', isNotNull),
      ],
    );

    blocTest<SyncCubit, SyncState>(
      'is disabled for demo sessions',
      setUp: () => canSync = false,
      build: build,
      act: (cubit) => cubit.syncNow(),
      expect: () => [const SyncState(status: SyncStatus.disabled)],
      verify: (_) => verifyNever(() => engine.sync()),
    );

    blocTest<SyncCubit, SyncState>(
      'reports offline without calling the server',
      setUp: () => when(() => connectivity.isOnline()).thenAnswer((_) async => false),
      build: build,
      act: (cubit) => cubit.syncNow(),
      expect: () => [const SyncState(status: SyncStatus.offline)],
    );

    blocTest<SyncCubit, SyncState>(
      'maps errors to a message',
      setUp: () => when(() => engine.sync()).thenThrow(Exception('boom')),
      build: build,
      act: (cubit) => cubit.syncNow(),
      expect: () => [
        const SyncState(status: SyncStatus.syncing),
        const SyncState(status: SyncStatus.failed, error: 'Something unexpected happened'),
      ],
    );

    blocTest<SyncCubit, SyncState>(
      'new local changes and reconnecting both trigger a sync',
      build: build,
      act: (cubit) async {
        cubit.start();
        await pumpEventQueue();
        pending.add(2);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        online.add(true);
        await pumpEventQueue();
      },
      verify: (cubit) {
        expect(cubit.state.pending, 2);
        verify(() => engine.sync()).called(greaterThanOrEqualTo(3));
      },
    );
  });
}
