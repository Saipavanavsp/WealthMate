// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WealthMate';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Activity';

  @override
  String get navGroups => 'Groups';

  @override
  String get navGoals => 'Goals';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Track spending, split bills and grow your savings.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get noAccount => 'New here? Create an account';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get tryDemo => 'Explore with demo data';

  @override
  String get demoHint => 'No sign-up needed. Everything stays on this device.';

  @override
  String get offlineDemoNote =>
      'This web build isn\'t connected to a server, so sign-in won\'t work here. Use demo data to try every feature.';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'Use at least 8 characters';

  @override
  String get requiredField => 'Required';

  @override
  String get unlockTitle => 'WealthMate is locked';

  @override
  String get unlockButton => 'Unlock';

  @override
  String get unlockReason => 'Unlock WealthMate to see your finances';

  @override
  String get signOut => 'Sign out';

  @override
  String greeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get thisMonth => 'This month';

  @override
  String get income => 'Income';

  @override
  String get expenses => 'Expenses';

  @override
  String get net => 'Net';

  @override
  String get recentTransactions => 'Recent activity';

  @override
  String get seeAll => 'See all';

  @override
  String get noTransactions => 'No transactions yet. Tap + to add your first one.';

  @override
  String get healthScore => 'Financial health';

  @override
  String get healthExcellent => 'Excellent';

  @override
  String get healthGood => 'Good';

  @override
  String get healthFair => 'Fair';

  @override
  String get healthNeedsAttention => 'Needs attention';

  @override
  String get howCalculated => 'How is this calculated?';

  @override
  String get scoreSavingsTitle => 'Savings rate';

  @override
  String scoreSavingsDetail(String rate) {
    return 'You kept $rate of your income over the last 3 months. 30% or more earns full points.';
  }

  @override
  String get scoreSavingsNoData => 'Add some income to score this part.';

  @override
  String get scoreTrendTitle => 'Spending trend';

  @override
  String scoreTrendLower(String change) {
    return 'Last month you spent $change less than your 3-month average. Spending 10% less earns full points.';
  }

  @override
  String scoreTrendHigher(String change) {
    return 'Last month you spent $change more than your 3-month average. Holding steady or spending less scores better.';
  }

  @override
  String get scoreTrendNoData => 'Not enough history yet, so this is scored as steady.';

  @override
  String get scoreGoalsTitle => 'Goal progress';

  @override
  String scoreGoalsDetail(String progress) {
    return 'Your goals are $progress complete on average.';
  }

  @override
  String get scoreGoalsNoData => 'Add a savings goal to earn these points.';

  @override
  String points(String points, int max) {
    return '$points / $max';
  }

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get expense => 'Expense';

  @override
  String get incomeType => 'Income';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get merchant => 'Merchant or payee';

  @override
  String get note => 'Note';

  @override
  String get date => 'Date';

  @override
  String get repeat => 'Repeat';

  @override
  String get repeatNone => 'Does not repeat';

  @override
  String get repeatWeekly => 'Every week';

  @override
  String get repeatMonthly => 'Every month';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get suggestedCategory => 'Category suggested from the merchant name';

  @override
  String get amountInvalid => 'Enter an amount greater than zero';

  @override
  String get transactionSaved => 'Transaction saved';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get deleteConfirm => 'Delete this transaction?';

  @override
  String get filterAll => 'All';

  @override
  String get filterExpenses => 'Expenses';

  @override
  String get filterIncome => 'Income';

  @override
  String get analytics => 'Insights';

  @override
  String get monthly => 'Monthly';

  @override
  String get weekly => 'Weekly';

  @override
  String get spendingByCategory => 'Spending by category this month';

  @override
  String get noDataYet => 'Not enough data yet';

  @override
  String get newGoal => 'New goal';

  @override
  String get goalName => 'Goal name';

  @override
  String get targetAmount => 'Target amount';

  @override
  String get savedSoFar => 'Saved so far';

  @override
  String get deadline => 'Target date';

  @override
  String get addMoney => 'Add money';

  @override
  String suggestedMonthly(String amount) {
    return 'Save $amount a month to finish on time';
  }

  @override
  String get goalComplete => 'Goal reached';

  @override
  String get goalOverdue => 'Past the target date';

  @override
  String get noGoals => 'No goals yet. Set one and track your progress here.';

  @override
  String savedOf(String saved, String target) {
    return '$saved of $target';
  }

  @override
  String get newGroup => 'New group';

  @override
  String get groupName => 'Group name';

  @override
  String get members => 'Members';

  @override
  String get addMember => 'Add member';

  @override
  String get memberNameHint => 'Member name';

  @override
  String get noGroups => 'No groups yet. Create one to split trips, rent or dinners.';

  @override
  String get addExpense => 'Add expense';

  @override
  String get description => 'Description';

  @override
  String get paidBy => 'Paid by';

  @override
  String get splitEqually => 'Equally';

  @override
  String get splitByShares => 'By shares';

  @override
  String get settleUp => 'Settle up';

  @override
  String get whoPaysWhom => 'Who pays whom';

  @override
  String get allSettled => 'Everyone is settled up';

  @override
  String get markPaid => 'Mark paid';

  @override
  String get balances => 'Balances';

  @override
  String paysTo(String from, String to) {
    return '$from pays $to';
  }

  @override
  String getsBack(String amount) {
    return 'gets back $amount';
  }

  @override
  String owesAmount(String amount) {
    return 'owes $amount';
  }

  @override
  String get settled => 'settled';

  @override
  String get groupExpenses => 'Expenses';

  @override
  String get settlementRecorded => 'Payment recorded';

  @override
  String get totalSpent => 'Total spent';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count members', one: '1 member');
    return '$_temp0';
  }

  @override
  String get simplifiedHint => 'Debts are simplified so the group needs the fewest payments.';

  @override
  String get reminders => 'Bill reminders';

  @override
  String get newReminder => 'New reminder';

  @override
  String get reminderTitle => 'Bill name';

  @override
  String get dayOfMonth => 'Day of month';

  @override
  String dueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
      zero: 'Due today',
    );
    return '$_temp0';
  }

  @override
  String get noReminders => 'No reminders yet.';

  @override
  String get remindersWebNote => 'Notifications need the mobile app. Reminders still show here.';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get security => 'Security';

  @override
  String get biometricLock => 'Biometric lock';

  @override
  String get biometricLockHint => 'Ask for fingerprint or face when the app opens';

  @override
  String get biometricUnavailable => 'Biometrics aren\'t available on this device';

  @override
  String get data => 'Data';

  @override
  String get exportCsv => 'Export transactions (CSV)';

  @override
  String get sync => 'Sync';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncing => 'Syncing…';

  @override
  String get syncUpToDate => 'Up to date';

  @override
  String get syncOffline => 'Offline. Changes are saved and will sync later.';

  @override
  String syncFailed(String message) {
    return 'Sync failed: $message';
  }

  @override
  String pendingChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes waiting to sync',
      one: '1 change waiting to sync',
      zero: 'No changes waiting',
    );
    return '$_temp0';
  }

  @override
  String lastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get demoMode => 'Demo mode: data stays on this device and is not synced.';

  @override
  String get account => 'Account';

  @override
  String get genericError => 'Something went wrong. Please try again.';
}
