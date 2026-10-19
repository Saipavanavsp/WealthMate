import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/app.dart';

import 'harness.dart';

/// Sign in, add an expense through the UI, and check that it reaches the
/// server through the outbox. Shared by the CI flow test and the on-device
/// integration test.
Future<void> runAddExpenseThenSyncFlow(WidgetTester tester, AppHarness harness) async {
  await tester.pumpWidget(const WealthMateApp());
  await tester.pumpAndSettle();

  // Login screen
  expect(find.text('Welcome back'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('auth.email')), 'sai@example.com');
  await tester.enterText(find.byKey(const Key('auth.password')), 'Password1');
  await tester.tap(find.byKey(const Key('auth.submit')));
  await tester.pumpAndSettle();

  // Dashboard
  expect(find.text('Hi, Sai'), findsOneWidget);
  await tester.tap(find.byKey(const Key('dashboard.add')));
  await tester.pumpAndSettle();

  // Add-expense form: the merchant name picks the category automatically.
  await tester.enterText(find.byKey(const Key('form.amount')), '250');
  await tester.enterText(find.byKey(const Key('form.merchant')), 'Swiggy');
  await tester.pump();
  expect(find.text('Category suggested from the merchant name'), findsOneWidget);
  await tester.scrollUntilVisible(
    find.byKey(const Key('form.save')),
    200,
    scrollable: find.descendant(of: find.byKey(const Key('form.list')), matching: find.byType(Scrollable)).first,
  );
  await tester.tap(find.byKey(const Key('form.save')));
  await tester.pumpAndSettle();

  // Back on the dashboard, the expense is visible straight from the local DB.
  expect(find.text('Swiggy'), findsOneWidget);

  // The sync cubit debounces new changes by two seconds before pushing.
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();

  final pushed = harness.server.pushed['transactions'];
  expect(pushed, isNotNull);
  expect(pushed!.single['amountMinor'], 25000);
  expect(pushed.single['category'], 'Food');
  expect(pushed.single['merchant'], 'Swiggy');

  // Tear the tree down so blocs cancel their timers and subscriptions.
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}
