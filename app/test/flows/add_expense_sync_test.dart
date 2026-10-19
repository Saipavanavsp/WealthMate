import 'package:flutter_test/flutter_test.dart';

import '../../integration_test/support/add_expense_flow.dart';
import '../../integration_test/support/harness.dart';

/// The same end-to-end flow as integration_test/app_test.dart, run headless
/// so CI covers it on every push without needing an emulator.
void main() {
  testWidgets('add an expense offline-first, then sync it', (tester) async {
    final harness = AppHarness();
    await harness.setUp();
    await runAddExpenseThenSyncFlow(tester, harness);
  });
}
