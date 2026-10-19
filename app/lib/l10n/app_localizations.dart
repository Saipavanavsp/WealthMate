import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi'), Locale('te')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WealthMate'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navTransactions;

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track spending, split bills and grow your savings.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// No description provided for @tryDemo.
  ///
  /// In en, this message translates to:
  /// **'Explore with demo data'**
  String get tryDemo;

  /// No description provided for @demoHint.
  ///
  /// In en, this message translates to:
  /// **'No sign-up needed. Everything stays on this device.'**
  String get demoHint;

  /// No description provided for @offlineDemoNote.
  ///
  /// In en, this message translates to:
  /// **'This web build isn\'t connected to a server, so sign-in won\'t work here. Use demo data to try every feature.'**
  String get offlineDemoNote;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'WealthMate is locked'**
  String get unlockTitle;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButton;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock WealthMate to see your finances'**
  String get unlockReason;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String greeting(String name);

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentTransactions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet. Tap + to add your first one.'**
  String get noTransactions;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Financial health'**
  String get healthScore;

  /// No description provided for @healthExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get healthExcellent;

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// No description provided for @healthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get healthFair;

  /// No description provided for @healthNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get healthNeedsAttention;

  /// No description provided for @howCalculated.
  ///
  /// In en, this message translates to:
  /// **'How is this calculated?'**
  String get howCalculated;

  /// No description provided for @scoreSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get scoreSavingsTitle;

  /// No description provided for @scoreSavingsDetail.
  ///
  /// In en, this message translates to:
  /// **'You kept {rate} of your income over the last 3 months. 30% or more earns full points.'**
  String scoreSavingsDetail(String rate);

  /// No description provided for @scoreSavingsNoData.
  ///
  /// In en, this message translates to:
  /// **'Add some income to score this part.'**
  String get scoreSavingsNoData;

  /// No description provided for @scoreTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get scoreTrendTitle;

  /// No description provided for @scoreTrendLower.
  ///
  /// In en, this message translates to:
  /// **'Last month you spent {change} less than your 3-month average. Spending 10% less earns full points.'**
  String scoreTrendLower(String change);

  /// No description provided for @scoreTrendHigher.
  ///
  /// In en, this message translates to:
  /// **'Last month you spent {change} more than your 3-month average. Holding steady or spending less scores better.'**
  String scoreTrendHigher(String change);

  /// No description provided for @scoreTrendNoData.
  ///
  /// In en, this message translates to:
  /// **'Not enough history yet, so this is scored as steady.'**
  String get scoreTrendNoData;

  /// No description provided for @scoreGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal progress'**
  String get scoreGoalsTitle;

  /// No description provided for @scoreGoalsDetail.
  ///
  /// In en, this message translates to:
  /// **'Your goals are {progress} complete on average.'**
  String scoreGoalsDetail(String progress);

  /// No description provided for @scoreGoalsNoData.
  ///
  /// In en, this message translates to:
  /// **'Add a savings goal to earn these points.'**
  String get scoreGoalsNoData;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{points} / {max}'**
  String points(String points, int max);

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant or payee'**
  String get merchant;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get repeatNone;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @suggestedCategory.
  ///
  /// In en, this message translates to:
  /// **'Category suggested from the merchant name'**
  String get suggestedCategory;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get amountInvalid;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionSaved;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteConfirm;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get filterExpenses;

  /// No description provided for @filterIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get filterIncome;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get analytics;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category this month'**
  String get spendingByCategory;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get noDataYet;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get newGoal;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalName;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmount;

  /// No description provided for @savedSoFar.
  ///
  /// In en, this message translates to:
  /// **'Saved so far'**
  String get savedSoFar;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get deadline;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get addMoney;

  /// No description provided for @suggestedMonthly.
  ///
  /// In en, this message translates to:
  /// **'Save {amount} a month to finish on time'**
  String suggestedMonthly(String amount);

  /// No description provided for @goalComplete.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get goalComplete;

  /// No description provided for @goalOverdue.
  ///
  /// In en, this message translates to:
  /// **'Past the target date'**
  String get goalOverdue;

  /// No description provided for @noGoals.
  ///
  /// In en, this message translates to:
  /// **'No goals yet. Set one and track your progress here.'**
  String get noGoals;

  /// No description provided for @savedOf.
  ///
  /// In en, this message translates to:
  /// **'{saved} of {target}'**
  String savedOf(String saved, String target);

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroup;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @memberNameHint.
  ///
  /// In en, this message translates to:
  /// **'Member name'**
  String get memberNameHint;

  /// No description provided for @noGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet. Create one to split trips, rent or dinners.'**
  String get noGroups;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// No description provided for @splitEqually.
  ///
  /// In en, this message translates to:
  /// **'Equally'**
  String get splitEqually;

  /// No description provided for @splitByShares.
  ///
  /// In en, this message translates to:
  /// **'By shares'**
  String get splitByShares;

  /// No description provided for @settleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get settleUp;

  /// No description provided for @whoPaysWhom.
  ///
  /// In en, this message translates to:
  /// **'Who pays whom'**
  String get whoPaysWhom;

  /// No description provided for @allSettled.
  ///
  /// In en, this message translates to:
  /// **'Everyone is settled up'**
  String get allSettled;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get markPaid;

  /// No description provided for @balances.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get balances;

  /// No description provided for @paysTo.
  ///
  /// In en, this message translates to:
  /// **'{from} pays {to}'**
  String paysTo(String from, String to);

  /// No description provided for @getsBack.
  ///
  /// In en, this message translates to:
  /// **'gets back {amount}'**
  String getsBack(String amount);

  /// No description provided for @owesAmount.
  ///
  /// In en, this message translates to:
  /// **'owes {amount}'**
  String owesAmount(String amount);

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'settled'**
  String get settled;

  /// No description provided for @groupExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get groupExpenses;

  /// No description provided for @settlementRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get settlementRecorded;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String membersCount(int count);

  /// No description provided for @simplifiedHint.
  ///
  /// In en, this message translates to:
  /// **'Debts are simplified so the group needs the fewest payments.'**
  String get simplifiedHint;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Bill reminders'**
  String get reminders;

  /// No description provided for @newReminder.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get newReminder;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill name'**
  String get reminderTitle;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get dayOfMonth;

  /// No description provided for @dueIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Due today} =1{Due tomorrow} other{Due in {days} days}}'**
  String dueIn(int days);

  /// No description provided for @noReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get noReminders;

  /// No description provided for @remindersWebNote.
  ///
  /// In en, this message translates to:
  /// **'Notifications need the mobile app. Reminders still show here.'**
  String get remindersWebNote;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageSystem;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get biometricLock;

  /// No description provided for @biometricLockHint.
  ///
  /// In en, this message translates to:
  /// **'Ask for fingerprint or face when the app opens'**
  String get biometricLockHint;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics aren\'t available on this device'**
  String get biometricUnavailable;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export transactions (CSV)'**
  String get exportCsv;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncing;

  /// No description provided for @syncUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get syncUpToDate;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline. Changes are saved and will sync later.'**
  String get syncOffline;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {message}'**
  String syncFailed(String message);

  /// No description provided for @pendingChanges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No changes waiting} =1{1 change waiting to sync} other{{count} changes waiting to sync}}'**
  String pendingChanges(int count);

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String lastSynced(String time);

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: data stays on this device and is not synced.'**
  String get demoMode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
