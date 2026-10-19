import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wealthmate/features/auth/presentation/pages/auth_page.dart';
import 'package:wealthmate/features/groups/domain/entities/group_entities.dart';
import 'package:wealthmate/features/groups/presentation/group_detail_page.dart';
import 'package:wealthmate/features/groups/presentation/groups_cubit.dart';
import 'package:wealthmate/features/health_score/domain/health_score_calculator.dart';
import 'package:wealthmate/features/health_score/presentation/health_score_card.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';
import 'package:wealthmate/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:wealthmate/features/transactions/presentation/pages/transactions_page.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_helpers.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockTransactionsBloc extends MockBloc<TransactionsEvent, TransactionsState> implements TransactionsBloc {}

class MockGroupDetailCubit extends MockCubit<GroupDetailState> implements GroupDetailCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const AuthStarted());
    registerFallbackValue(const TransactionsSubscribed());
  });

  group('AuthPage', () {
    late MockAuthBloc bloc;
    setUp(() {
      bloc = MockAuthBloc();
      when(() => bloc.state).thenReturn(const Unauthenticated());
    });

    Future<void> pump(WidgetTester tester) =>
        tester.pumpApp(BlocProvider<AuthBloc>.value(value: bloc, child: const AuthPage()));

    testWidgets('validates the form before submitting', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('auth.submit')));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Use at least 8 characters'), findsOneWidget);
      verifyNever(() => bloc.add(any()));
    });

    testWidgets('submits credentials', (tester) async {
      await pump(tester);
      await tester.enterText(find.byKey(const Key('auth.email')), 'sai@example.com');
      await tester.enterText(find.byKey(const Key('auth.password')), 'Password1');
      await tester.tap(find.byKey(const Key('auth.submit')));

      verify(() => bloc.add(const AuthLoginRequested(email: 'sai@example.com', password: 'Password1'))).called(1);
    });

    testWidgets('starts demo mode', (tester) async {
      await pump(tester);
      await tester.ensureVisible(find.byKey(const Key('auth.demo')));
      await tester.tap(find.byKey(const Key('auth.demo')));
      verify(() => bloc.add(const AuthDemoRequested())).called(1);
    });

    testWidgets('shows a spinner while submitting', (tester) async {
      when(() => bloc.state).thenReturn(const Unauthenticated(submitting: true));
      await pump(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('TransactionsPage', () {
    late MockTransactionsBloc bloc;
    setUp(() => bloc = MockTransactionsBloc());

    Future<void> pump(WidgetTester tester) =>
        tester.pumpApp(BlocProvider<TransactionsBloc>.value(value: bloc, child: const TransactionsPage()));

    testWidgets('shows an empty state', (tester) async {
      when(() => bloc.state).thenReturn(const TransactionsState(status: TransactionsStatus.ready));
      await pump(tester);
      expect(find.textContaining('No transactions yet'), findsOneWidget);
    });

    testWidgets('lists transactions with signed amounts', (tester) async {
      when(() => bloc.state).thenReturn(
        TransactionsState(
          status: TransactionsStatus.ready,
          all: [
            tx(id: 'a', amount: 45000, merchant: 'Swiggy'),
            tx(id: 'b', amount: 8500000, type: TransactionType.income, category: 'Salary', merchant: 'Acme'),
          ],
        ),
      );
      await pump(tester);
      expect(find.text('Swiggy'), findsOneWidget);
      expect(find.text('-₹450.00'), findsOneWidget);
      expect(find.text('+₹85,000.00'), findsOneWidget);
    });

    testWidgets('changing the filter dispatches an event', (tester) async {
      when(() => bloc.state).thenReturn(const TransactionsState(status: TransactionsStatus.ready));
      await pump(tester);
      await tester.tap(find.text('Income'));
      verify(() => bloc.add(const TransactionsFilterChanged(TransactionFilter.income))).called(1);
    });
  });

  group('HealthScoreCard', () {
    testWidgets('shows the score and explains each part when expanded', (tester) async {
      const score = HealthScore(
        savings: ScoreComponent(points: 40, maxPoints: 40, value: 0.32),
        trend: ScoreComponent(points: 22.5, maxPoints: 30, value: 0),
        goals: ScoreComponent(points: 15, maxPoints: 30, value: null),
      );
      await tester.pumpApp(const Scaffold(body: HealthScoreCard(score: score)));

      expect(find.text('78'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);

      await tester.tap(find.text('Financial health'));
      await tester.pumpAndSettle();
      expect(find.textContaining('You kept 32% of your income'), findsOneWidget);
      expect(find.text('Add a savings goal to earn these points.'), findsOneWidget);
    });
  });

  group('GroupDetailPage', () {
    testWidgets('shows who pays whom and balances', (tester) async {
      final cubit = MockGroupDetailCubit();
      final details = GroupDetails(
        group: Group(id: 'g', name: 'Goa Trip', currency: 'INR', updatedAt: DateTime(2026)),
        members: const [
          GroupMember(id: 'a', groupId: 'g', name: 'You'),
          GroupMember(id: 'b', groupId: 'g', name: 'Ravi'),
        ],
        expenses: [
          GroupExpense(
            id: 'e',
            groupId: 'g',
            description: 'Villa',
            amount: const Money(100000),
            paidBy: 'a',
            splitType: SplitType.equal,
            shares: const {'a': 50000, 'b': 50000},
            occurredAt: DateTime(2026, 10),
          ),
        ],
        settlements: const [],
        balances: const {'a': 50000, 'b': -50000},
        transfers: const [Transfer(from: 'b', to: 'a', amountMinor: 50000)],
      );
      when(() => cubit.state).thenReturn(GroupDetailState(loading: false, details: details));

      await tester.pumpApp(BlocProvider<GroupDetailCubit>.value(value: cubit, child: const GroupDetailPage()));

      expect(find.text('Ravi pays You'), findsOneWidget);
      expect(find.text('gets back ₹500.00'), findsOneWidget);
      expect(find.text('owes ₹500.00'), findsOneWidget);
    });
  });

  group('Localisation', () {
    testWidgets('renders Telugu and Hindi strings', (tester) async {
      final bloc = MockAuthBloc();
      when(() => bloc.state).thenReturn(const Unauthenticated());
      await tester.pumpApp(
        BlocProvider<AuthBloc>.value(value: bloc, child: const AuthPage()),
        locale: const Locale('te'),
      );
      expect(find.text('సైన్ ఇన్'), findsOneWidget);

      await tester.pumpApp(
        BlocProvider<AuthBloc>.value(value: bloc, child: const AuthPage()),
        locale: const Locale('hi'),
      );
      await tester.pumpAndSettle();
      expect(find.text('साइन इन'), findsOneWidget);
    });
  });
}
