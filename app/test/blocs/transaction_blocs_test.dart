import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wealthmate/core/error/failures.dart';
import 'package:wealthmate/core/error/result.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/features/transactions/domain/analytics/spending_analytics.dart';
import 'package:wealthmate/features/transactions/domain/categorisation/category_rules.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';
import 'package:wealthmate/features/transactions/presentation/bloc/analytics_cubit.dart';
import 'package:wealthmate/features/transactions/presentation/bloc/transaction_form_cubit.dart';
import 'package:wealthmate/features/transactions/presentation/bloc/transactions_bloc.dart';

import '../helpers/mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockTransactionRepository repo;
  final income = tx(id: 'i', type: TransactionType.income, category: 'Salary');
  final expense = tx(id: 'e');

  setUpAll(registerFallbacks);
  setUp(() => repo = MockTransactionRepository());

  group('TransactionsBloc', () {
    blocTest<TransactionsBloc, TransactionsState>(
      'loads from the repository stream',
      setUp: () => when(() => repo.watchAll()).thenAnswer((_) => Stream.value([expense, income])),
      build: () => TransactionsBloc(repo),
      act: (bloc) => bloc.add(const TransactionsSubscribed()),
      expect: () => [
        TransactionsState(status: TransactionsStatus.ready, all: [expense, income]),
      ],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'filters without reloading',
      build: () => TransactionsBloc(repo),
      seed: () => TransactionsState(status: TransactionsStatus.ready, all: [expense, income]),
      act: (bloc) => bloc
        ..add(const TransactionsFilterChanged(TransactionFilter.income))
        ..add(const TransactionsFilterChanged(TransactionFilter.expenses)),
      verify: (bloc) => expect(bloc.state.visible, [expense]),
      expect: () => [
        isA<TransactionsState>().having((s) => s.visible, 'visible', [income]),
        isA<TransactionsState>().having((s) => s.visible, 'visible', [expense]),
      ],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'surfaces a delete failure',
      setUp: () => when(() => repo.delete('e')).thenAnswer((_) async => const Err(StorageFailure())),
      build: () => TransactionsBloc(repo),
      act: (bloc) => bloc.add(const TransactionDeleted('e')),
      expect: () => [const TransactionsState(failure: StorageFailure())],
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'database errors are reported',
      setUp: () => when(() => repo.watchAll()).thenAnswer((_) => Stream.error(Exception('db'))),
      build: () => TransactionsBloc(repo),
      act: (bloc) => bloc.add(const TransactionsSubscribed()),
      expect: () => [const TransactionsState(status: TransactionsStatus.ready, failure: StorageFailure())],
    );
  });

  group('TransactionFormCubit', () {
    final now = DateTime(2026, 10, 19, 10);
    final learned = <String, String>{};

    TransactionFormCubit build() {
      learned.clear();
      return TransactionFormCubit(
        repository: repo,
        engine: CategoryRuleEngine.withDefaults(),
        learn: (m, c) async => learned[m] = c,
        newId: () => 'new',
        clock: () => now,
      );
    }

    blocTest<TransactionFormCubit, TransactionFormState>(
      'suggests a category from the merchant',
      build: build,
      act: (cubit) => cubit.merchantChanged('Swiggy'),
      expect: () => [
        TransactionFormState(occurredAt: now, merchant: 'Swiggy', category: 'Food', categorySuggested: true),
      ],
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'stops suggesting once the user picks a category',
      build: build,
      act: (cubit) => cubit
        ..categoryChanged('Travel')
        ..merchantChanged('Uber'),
      verify: (cubit) => expect(cubit.state.category, 'Travel'),
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'switching to income replaces an expense-only category',
      build: build,
      act: (cubit) => cubit
        ..categoryChanged('Food')
        ..typeChanged(TransactionType.income),
      verify: (cubit) => expect(cubit.state.category, 'Salary'),
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'saves and learns a corrected merchant category',
      setUp: () => when(() => repo.save(any())).thenAnswer((_) async => const Ok(null)),
      build: build,
      act: (cubit) async {
        cubit
          ..amountChanged('450')
          ..merchantChanged('Amazon')
          ..categoryChanged('Groceries')
          ..noteChanged('weekly order')
          ..dateChanged(now)
          ..recurrenceChanged(Recurrence.weekly);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, FormStatus.saved);
        final saved = verify(() => repo.save(captureAny())).captured.single as TransactionEntry;
        expect(saved.amount, const Money(45000));
        expect(saved.category, 'Groceries');
        expect(saved.recurrence, Recurrence.weekly);
        expect(learned, {'Amazon': 'Groceries'});
      },
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'rejects an invalid amount',
      build: build,
      act: (cubit) => cubit.save(),
      expect: () => [
        TransactionFormState(occurredAt: now, failure: const ValidationFailure('Enter an amount greater than zero')),
      ],
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'loads an existing entry for editing',
      setUp: () => when(() => repo.findById('e')).thenAnswer((_) async => expense),
      build: build,
      act: (cubit) => cubit.load('e'),
      verify: (cubit) {
        expect(cubit.state.isEditing, isTrue);
        expect(cubit.state.amountText, '100.00');
      },
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'returns to editing when the save fails',
      setUp: () => when(() => repo.save(any())).thenAnswer((_) async => const Err(StorageFailure())),
      build: build,
      act: (cubit) async {
        cubit.amountChanged('10');
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, FormStatus.editing);
        expect(cubit.state.failure, const StorageFailure());
      },
    );
  });

  group('AnalyticsCubit', () {
    final now = DateTime(2026, 10, 19);

    blocTest<AnalyticsCubit, AnalyticsState>(
      'aggregates whenever transactions change',
      setUp: () => when(() => repo.watchAll()).thenAnswer((_) => Stream.value([expense])),
      build: () => AnalyticsCubit(repo, runner: (r) async => SpendingAnalytics.summarise(r), clock: () => now),
      act: (cubit) => cubit.start(),
      wait: Duration.zero,
      verify: (cubit) {
        expect(cubit.state.loading, isFalse);
        expect(cubit.state.summary.monthly.last.expenseMinor, 10000);
      },
    );

    blocTest<AnalyticsCubit, AnalyticsState>(
      'switches the chart period',
      build: () => AnalyticsCubit(repo),
      act: (cubit) => cubit.periodChanged(ChartPeriod.weekly),
      expect: () => [const AnalyticsState(period: ChartPeriod.weekly)],
    );
  });
}
