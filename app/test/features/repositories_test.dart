import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/core/database/app_database.dart';
import 'package:wealthmate/core/error/failures.dart';
import 'package:wealthmate/core/error/result.dart';
import 'package:wealthmate/core/money/money.dart';
import 'package:wealthmate/core/sync/sync_handler.dart';
import 'package:wealthmate/core/sync/sync_queue.dart';
import 'package:wealthmate/core/sync/synced_writer.dart';
import 'package:wealthmate/features/auth/data/demo_data_seeder.dart';
import 'package:wealthmate/features/goals/data/goal_repository_impl.dart';
import 'package:wealthmate/features/groups/data/group_repository_impl.dart';
import 'package:wealthmate/features/groups/domain/entities/group_entities.dart';
import 'package:wealthmate/features/reminders/data/local_notification_service.dart';
import 'package:wealthmate/features/reminders/data/reminder_repository_impl.dart';
import 'package:wealthmate/features/reminders/domain/bill_reminder.dart';
import 'package:wealthmate/features/transactions/data/transaction_repository_impl.dart';
import 'package:wealthmate/features/transactions/domain/entities/transaction_entry.dart';
import 'package:wealthmate/features/transactions/domain/recurring/recurring_scheduler.dart';

import '../helpers/test_helpers.dart';

void main() {
  late AppDatabase db;
  late SyncQueueStore queue;
  late SyncedWriter writer;
  late SyncHandlers handlers;
  var ids = 0;
  String newId() => 'id-${ids++}';

  setUp(() {
    ids = 0;
    db = inMemoryDatabase();
    queue = SyncQueueStore(db);
    writer = SyncedWriter(db, queue);
    handlers = SyncHandlers(db);
  });

  tearDown(() => db.close());

  group('TransactionRepository', () {
    late TransactionRepositoryImpl repo;
    setUp(() {
      repo = TransactionRepositoryImpl(
        db: db,
        writer: writer,
        handlers: handlers,
        scheduler: RecurringScheduler(newId: newId),
      );
    });

    test('save writes the row and an outbox entry atomically', () async {
      expect(await repo.save(tx(id: 'a')), isA<Ok<void>>());
      expect(await repo.findById('a'), isNotNull);
      expect((await queue.nextBatch()).single.recordId, 'a');
    });

    test('rejects non-positive amounts', () async {
      final result = await repo.save(tx(amount: 0));
      expect(result, isA<Err<void>>());
      expect((result as Err<void>).failure, isA<ValidationFailure>());
    });

    test('watchAll is newest first and hides deleted rows', () async {
      await repo.save(tx(id: 'old', at: DateTime(2026)));
      await repo.save(tx(id: 'new', at: DateTime(2026, 5)));
      await repo.delete('old');
      final items = await repo.watchAll().first;
      expect(items.map((t) => t.id), ['new']);
      expect(await repo.delete('missing'), isA<Err<void>>());
    });

    test('getBetween filters by date', () async {
      await repo.save(tx(id: 'a', at: DateTime(2026, 3)));
      await repo.save(tx(id: 'b', at: DateTime(2026, 6)));
      final range = await repo.getBetween(DateTime(2026, 2), DateTime(2026, 4));
      expect(range.map((t) => t.id), ['a']);
    });

    test('generateDueRecurring creates missed occurrences once', () async {
      await repo.save(tx(id: 'rent', at: DateTime(2026, 8), recurrence: Recurrence.monthly));
      expect(await repo.generateDueRecurring(DateTime(2026, 10, 5)), 2);
      expect(await repo.generateDueRecurring(DateTime(2026, 10, 5)), 0);
      final all = await repo.watchAll().first;
      expect(all, hasLength(3));
      expect(all.where((t) => t.isRecurring), hasLength(1));
    });
  });

  group('GoalRepository', () {
    late GoalRepositoryImpl repo;
    setUp(() => repo = GoalRepositoryImpl(db: db, writer: writer, handlers: handlers));

    test('save, contribute and delete', () async {
      await repo.save(goal(id: 'g', target: 1000));
      await repo.addContribution('g', const Money(250));
      expect((await repo.getAll()).single.saved, const Money(250));

      await repo.delete('g');
      expect(await repo.getAll(), isEmpty);
    });

    test('validates input', () async {
      expect(await repo.save(goal(target: 0)), isA<Err<void>>());
      expect(await repo.addContribution('missing', const Money(5)), isA<Err<void>>());
      expect(await repo.addContribution('g', const Money(0)), isA<Err<void>>());
      expect(await repo.delete('missing'), isA<Err<void>>());
    });
  });

  group('GroupRepository', () {
    late GroupRepositoryImpl repo;
    setUp(() => repo = GroupRepositoryImpl(db: db, writer: writer, handlers: handlers, newId: newId));

    test('creates a group, adds expenses and simplifies debts', () async {
      final groupId = (await repo.createGroup('Trip', ['You', 'Ravi', 'Priya']) as Ok<String>).value;
      final details = (await repo.watchDetails(groupId).first)!;
      final [you, ravi, priya] = details.members.map((m) => m.id).toList();

      await repo.addExpense(
        groupId: groupId,
        description: 'Hotel',
        amount: const Money(900),
        paidBy: you,
        splitType: SplitType.equal,
        shares: {you: 300, ravi: 300, priya: 300},
      );

      final updated = (await repo.watchDetails(groupId).first)!;
      expect(updated.balances, {you: 600, ravi: -300, priya: -300});
      expect(updated.transfers, hasLength(2));

      await repo.recordSettlement(groupId: groupId, from: ravi, to: you, amount: const Money(300));
      final afterSettle = (await repo.watchDetails(groupId).first)!;
      expect(afterSettle.balances[ravi], 0);
      expect(afterSettle.transfers.single.from, priya);

      final summaries = await repo.watchGroups().first;
      expect(summaries.single.memberCount, 3);
      expect(summaries.single.totalSpent, const Money(900));
    });

    test('validates groups, members, expenses and settlements', () async {
      expect(await repo.createGroup('', ['a', 'b']), isA<Err<String>>());
      expect(await repo.createGroup('Solo', ['a']), isA<Err<String>>());
      expect(await repo.addMember('g', ' '), isA<Err<void>>());
      expect(
        await repo.addExpense(
          groupId: 'g',
          description: 'x',
          amount: const Money(100),
          paidBy: 'a',
          splitType: SplitType.custom,
          shares: {'a': 50},
        ),
        isA<Err<void>>(),
      );
      expect(await repo.recordSettlement(groupId: 'g', from: 'a', to: 'a', amount: const Money(1)), isA<Err<void>>());
    });

    test('deleting a group or expense hides it', () async {
      final groupId = (await repo.createGroup('Flat', ['A', 'B']) as Ok<String>).value;
      final members = (await repo.watchDetails(groupId).first)!.members;
      await repo.addExpense(
        groupId: groupId,
        description: 'Wifi',
        amount: const Money(100),
        paidBy: members.first.id,
        splitType: SplitType.equal,
        shares: {members.first.id: 50, members.last.id: 50},
      );
      final expense = (await repo.watchDetails(groupId).first)!.expenses.single;
      await repo.deleteExpense(expense);
      expect((await repo.watchDetails(groupId).first)!.expenses, isEmpty);

      await repo.deleteGroup(groupId);
      expect(await repo.watchDetails(groupId).first, isNull);
    });
  });

  group('ReminderRepository', () {
    test('stores reminders and keeps their ids', () async {
      final repo = ReminderRepositoryImpl(db, const NoopReminderNotifier());
      final saved = await repo.save(const BillReminder(title: 'Rent', amount: Money(100), dayOfMonth: 3));
      expect(saved.id, isNotNull);
      await repo.save(saved.copyWith(enabled: false));
      expect((await repo.watchAll().first).single.enabled, isFalse);
      await repo.delete(saved);
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  group('DemoDataSeeder', () {
    test('fills every table without touching the outbox', () async {
      await DemoDataSeeder(db, newId: newId).seed(DateTime(2026, 10, 19));
      expect(await db.select(db.transactions).get(), isNotEmpty);
      expect(await db.select(db.goals).get(), hasLength(3));
      expect(await db.select(db.groups).get(), hasLength(1));
      expect(await db.select(db.billReminders).get(), hasLength(3));
      expect(await queue.nextBatch(), isEmpty);
    });
  });
}
