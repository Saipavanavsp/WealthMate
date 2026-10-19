import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/add_expense_flow.dart';
import 'support/harness.dart';

/// Runs on a device or emulator:
/// `flutter test integration_test -d <device-id>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add an expense offline-first, then sync it', (tester) async {
    final harness = AppHarness();
    await harness.setUp();
    await runAddExpenseThenSyncFlow(tester, harness);
  });
}
