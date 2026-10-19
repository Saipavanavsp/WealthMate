import 'transaction_entry.dart';

/// Built-in categories. Stored as plain strings so the server stays agnostic
/// and new categories don't need a migration.
abstract final class Categories {
  static const food = 'Food';
  static const groceries = 'Groceries';
  static const transport = 'Transport';
  static const shopping = 'Shopping';
  static const bills = 'Bills';
  static const rent = 'Rent';
  static const entertainment = 'Entertainment';
  static const health = 'Health';
  static const education = 'Education';
  static const travel = 'Travel';
  static const investments = 'Investments';
  static const salary = 'Salary';
  static const freelance = 'Freelance';
  static const other = 'Other';

  static const expense = [
    food,
    groceries,
    transport,
    shopping,
    bills,
    rent,
    entertainment,
    health,
    education,
    travel,
    investments,
    other,
  ];

  static const income = [salary, freelance, investments, other];

  static List<String> forType(TransactionType type) => type == TransactionType.expense ? expense : income;
}
