import 'package:mocktail/mocktail.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/core/network/connectivity_service.dart';
import 'package:wealthmate/core/sync/sync_engine.dart';
import 'package:wealthmate/core/sync/sync_queue.dart';
import 'package:wealthmate/features/auth/domain/auth_repository.dart';
import 'package:wealthmate/features/goals/domain/entities/savings_goal.dart';
import 'package:wealthmate/features/goals/domain/repositories/goal_repository.dart';
import 'package:wealthmate/features/groups/domain/entities/group_entities.dart';
import 'package:wealthmate/features/groups/domain/repositories/group_repository.dart';
import 'package:wealthmate/features/reminders/domain/bill_reminder.dart';
import 'package:wealthmate/features/reminders/domain/reminder_repository.dart';
import 'package:wealthmate/features/settings/data/settings_repository.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';
import 'package:wealthmate/features/transactions/domain/repositories/transaction_repository.dart';

import 'test_helpers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometrics extends Mock implements BiometricAuthenticator {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockGoalRepository extends Mock implements GoalRepository {}

class MockGroupRepository extends Mock implements GroupRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSyncEngine extends Mock implements SyncEngine {}

class MockSyncQueue extends Mock implements SyncQueueStore {}

class MockConnectivity extends Mock implements ConnectivityService {}

/// Registers fallback values for the argument matchers used across tests.
void registerFallbacks() {
  registerFallbackValue(tx());
  registerFallbackValue(goal());
  registerFallbackValue(const Money(0));
  registerFallbackValue(SplitType.equal);
  registerFallbackValue(const BillReminder(title: 't', amount: Money(1), dayOfMonth: 1));
  registerFallbackValue(
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
  registerFallbackValue(DateTime(2026));
  registerFallbackValue(<TransactionEntry>[]);
  registerFallbackValue(<SavingsGoal>[]);
}
