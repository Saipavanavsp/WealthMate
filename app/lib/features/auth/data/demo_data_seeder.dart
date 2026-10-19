import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../groups/domain/algorithms/split_calculator.dart';

/// Fills the local database with six months of realistic data for demo mode.
///
/// Rows are written straight to the tables without outbox entries because a
/// demo session never syncs. A fixed random seed keeps the data identical on
/// every run, which keeps screenshots and the demo video consistent.
class DemoDataSeeder {
  DemoDataSeeder(this._db, {required String Function() newId}) : _newId = newId;

  final AppDatabase _db;
  final String Function() _newId;

  static const _spending = <(String, List<String>, int, int, int)>[
    ('Food', ['Swiggy', 'Zomato', 'Starbucks', 'Dominos'], 150, 900, 9),
    ('Groceries', ['BigBasket', 'DMart', 'Zepto', 'Blinkit'], 300, 2500, 5),
    ('Transport', ['Uber', 'Ola', 'Rapido', 'IndianOil'], 80, 1200, 7),
    ('Shopping', ['Amazon', 'Flipkart', 'Myntra'], 400, 4500, 2),
    ('Entertainment', ['BookMyShow', 'Netflix'], 200, 1200, 1),
    ('Health', ['Apollo Pharmacy', 'PharmEasy'], 150, 1500, 1),
  ];

  Future<void> seed(DateTime now) async {
    final random = Random(42);
    int between(int min, int max) => min + random.nextInt(max - min + 1);
    final stamp = now.millisecondsSinceEpoch;
    const day = Duration(days: 1);

    await _db.transaction(() async {
      final txs = <TransactionsCompanion>[];
      void tx({
        required String type,
        required int amount,
        required String category,
        required String merchant,
        required DateTime at,
        String recurrence = 'none',
      }) {
        txs.add(
          TransactionsCompanion.insert(
            id: _newId(),
            type: type,
            amountMinor: amount,
            category: category,
            merchant: Value(merchant),
            occurredAt: at.millisecondsSinceEpoch,
            recurrence: Value(recurrence),
            updatedAt: stamp,
          ),
        );
      }

      for (var monthsAgo = 5; monthsAgo >= 0; monthsAgo--) {
        final monthStart = DateTime(now.year, now.month - monthsAgo, 1, 9);
        final daysAvailable = monthsAgo == 0 ? now.day : 28;
        // Only the latest occurrence of a recurring series carries the flag.
        final recurrence = monthsAgo == 0 ? 'monthly' : 'none';

        tx(
          type: 'income',
          amount: 8500000,
          category: 'Salary',
          merchant: 'Acme Technologies',
          at: monthStart,
          recurrence: recurrence,
        );
        if (daysAvailable > 2) {
          tx(
            type: 'expense',
            amount: 2200000,
            category: 'Rent',
            merchant: 'House rent',
            at: monthStart.add(day * 2),
            recurrence: recurrence,
          );
        }
        if (daysAvailable > 5) {
          tx(
            type: 'expense',
            amount: 149900,
            category: 'Bills',
            merchant: 'Airtel Broadband',
            at: monthStart.add(day * 5),
            recurrence: recurrence,
          );
        }

        for (final (category, merchants, min, max, perMonth) in _spending) {
          for (var i = 0; i < perMonth; i++) {
            final at = monthStart.add(day * between(0, daysAvailable - 1)).add(Duration(hours: between(0, 12)));
            if (at.isAfter(now)) continue;
            tx(
              type: 'expense',
              amount: between(min, max) * 100,
              category: category,
              merchant: merchants[between(0, merchants.length - 1)],
              at: at,
            );
          }
        }
      }
      await _db.batch((b) => b.insertAll(_db.transactions, txs));

      for (final (name, target, saved, days) in const [
        ('Emergency fund', 30000000, 16500000, 240),
        ('New laptop', 12000000, 4500000, 150),
        ('Goa trip', 4000000, 3200000, 45),
      ]) {
        await _db
            .into(_db.goals)
            .insert(
              GoalsCompanion.insert(
                id: _newId(),
                name: name,
                targetMinor: target,
                savedMinor: Value(saved),
                deadline: now.add(Duration(days: days)).millisecondsSinceEpoch,
                updatedAt: stamp,
              ),
            );
      }

      await _seedTrip(now, stamp);

      for (final (title, amount, dayOfMonth) in const [
        ('Credit card bill', 1850000, 15),
        ('Electricity', 240000, 20),
        ('Netflix', 64900, 7),
      ]) {
        await _db
            .into(_db.billReminders)
            .insert(BillRemindersCompanion.insert(title: title, amountMinor: amount, dayOfMonth: dayOfMonth));
      }
    });
  }

  Future<void> _seedTrip(DateTime now, int stamp) async {
    final groupId = _newId();
    await _db.into(_db.groups).insert(GroupsCompanion.insert(id: groupId, name: 'Goa Trip', updatedAt: stamp));

    final ids = <String, String>{};
    for (final name in ['You', 'Ravi', 'Priya', 'Arjun']) {
      ids[name] = _newId();
      await _db
          .into(_db.groupMembers)
          .insert(GroupMembersCompanion.insert(id: ids[name]!, groupId: groupId, name: name, updatedAt: stamp));
    }
    final everyone = ids.values.toList();

    Future<void> expense(String description, int amount, String paidBy, Map<String, int> shares, int daysAgo) {
      return _db
          .into(_db.groupExpenses)
          .insert(
            GroupExpensesCompanion.insert(
              id: _newId(),
              groupId: groupId,
              description: description,
              amountMinor: amount,
              paidBy: ids[paidBy]!,
              splitType: shares.length == everyone.length && shares.values.toSet().length == 1 ? 'equal' : 'custom',
              shares: jsonEncode(shares),
              occurredAt: now.subtract(Duration(days: daysAgo)).millisecondsSinceEpoch,
              updatedAt: stamp,
            ),
          );
    }

    await expense('Villa booking', 2400000, 'You', SplitCalculator.equal(const Money(2400000), everyone), 20);
    await expense('Scooter rental', 480000, 'Ravi', SplitCalculator.equal(const Money(480000), everyone), 19);
    await expense('Seafood dinner', 600000, 'Priya', {
      ids['You']!: 150000,
      ids['Ravi']!: 200000,
      ids['Priya']!: 100000,
      ids['Arjun']!: 150000,
    }, 18);

    await _db
        .into(_db.settlements)
        .insert(
          SettlementsCompanion.insert(
            id: _newId(),
            groupId: groupId,
            fromMember: ids['Arjun']!,
            toMember: ids['You']!,
            amountMinor: 300000,
            occurredAt: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
            updatedAt: stamp,
          ),
        );
  }
}
