// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'WealthMate';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navTransactions => 'లావాదేవీలు';

  @override
  String get navGroups => 'గ్రూపులు';

  @override
  String get navGoals => 'లక్ష్యాలు';

  @override
  String get navSettings => 'సెట్టింగ్‌లు';

  @override
  String get loginTitle => 'మళ్ళీ స్వాగతం';

  @override
  String get loginSubtitle => 'ఖర్చులు ట్రాక్ చేయండి, బిల్లులు పంచుకోండి, పొదుపు పెంచుకోండి.';

  @override
  String get registerTitle => 'మీ ఖాతాను సృష్టించండి';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get name => 'పేరు';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get createAccount => 'ఖాతా సృష్టించండి';

  @override
  String get noAccount => 'కొత్తవారా? ఖాతా సృష్టించండి';

  @override
  String get haveAccount => 'ఇప్పటికే ఖాతా ఉందా? సైన్ ఇన్ చేయండి';

  @override
  String get tryDemo => 'డెమో డేటాతో చూడండి';

  @override
  String get demoHint => 'సైన్ అప్ అవసరం లేదు. డేటా ఈ పరికరంలోనే ఉంటుంది.';

  @override
  String get offlineDemoNote =>
      'ఈ వెబ్ వెర్షన్‌కు సర్వర్ కనెక్ట్ కాలేదు, కాబట్టి ఇక్కడ సైన్ ఇన్ పని చేయదు. అన్ని ఫీచర్లు చూడటానికి డెమో డేటా వాడండి.';

  @override
  String get invalidEmail => 'సరైన ఇమెయిల్ ఇవ్వండి';

  @override
  String get passwordTooShort => 'కనీసం 8 అక్షరాలు వాడండి';

  @override
  String get requiredField => 'తప్పనిసరి';

  @override
  String get unlockTitle => 'WealthMate లాక్ అయింది';

  @override
  String get unlockButton => 'అన్‌లాక్';

  @override
  String get unlockReason => 'మీ ఆర్థిక వివరాలు చూడటానికి WealthMate అన్‌లాక్ చేయండి';

  @override
  String get signOut => 'సైన్ అవుట్';

  @override
  String greeting(String name) {
    return 'హాయ్, $name';
  }

  @override
  String get thisMonth => 'ఈ నెల';

  @override
  String get income => 'ఆదాయం';

  @override
  String get expenses => 'ఖర్చులు';

  @override
  String get net => 'నికరం';

  @override
  String get recentTransactions => 'ఇటీవలి లావాదేవీలు';

  @override
  String get seeAll => 'అన్నీ చూడండి';

  @override
  String get noTransactions => 'ఇంకా లావాదేవీలు లేవు. మొదటిది జోడించడానికి + నొక్కండి.';

  @override
  String get healthScore => 'ఆర్థిక ఆరోగ్యం';

  @override
  String get healthExcellent => 'అద్భుతం';

  @override
  String get healthGood => 'బాగుంది';

  @override
  String get healthFair => 'పరవాలేదు';

  @override
  String get healthNeedsAttention => 'శ్రద్ధ అవసరం';

  @override
  String get howCalculated => 'ఇది ఎలా లెక్కిస్తారు?';

  @override
  String get scoreSavingsTitle => 'పొదుపు రేటు';

  @override
  String scoreSavingsDetail(String rate) {
    return 'గత 3 నెలల్లో మీ ఆదాయంలో $rate పొదుపు చేశారు. 30% లేదా అంతకంటే ఎక్కువకు పూర్తి పాయింట్లు.';
  }

  @override
  String get scoreSavingsNoData => 'దీనికి స్కోర్ రావాలంటే ఆదాయం జోడించండి.';

  @override
  String get scoreTrendTitle => 'ఖర్చుల ధోరణి';

  @override
  String scoreTrendLower(String change) {
    return 'గత నెల మీ 3 నెలల సగటు కంటే $change తక్కువ ఖర్చు చేశారు. 10% తక్కువ ఖర్చుకు పూర్తి పాయింట్లు.';
  }

  @override
  String scoreTrendHigher(String change) {
    return 'గత నెల మీ 3 నెలల సగటు కంటే $change ఎక్కువ ఖర్చు చేశారు. ఖర్చు స్థిరంగా లేదా తక్కువగా ఉంటే మెరుగైన స్కోర్.';
  }

  @override
  String get scoreTrendNoData => 'చరిత్ర సరిపడా లేదు, కాబట్టి స్థిరంగా లెక్కించాం.';

  @override
  String get scoreGoalsTitle => 'లక్ష్యాల పురోగతి';

  @override
  String scoreGoalsDetail(String progress) {
    return 'మీ లక్ష్యాలు సగటున $progress పూర్తయ్యాయి.';
  }

  @override
  String get scoreGoalsNoData => 'ఈ పాయింట్ల కోసం పొదుపు లక్ష్యం జోడించండి.';

  @override
  String points(String points, int max) {
    return '$points / $max';
  }

  @override
  String get addTransaction => 'లావాదేవీ జోడించండి';

  @override
  String get editTransaction => 'లావాదేవీ మార్చండి';

  @override
  String get expense => 'ఖర్చు';

  @override
  String get incomeType => 'ఆదాయం';

  @override
  String get amount => 'మొత్తం';

  @override
  String get category => 'వర్గం';

  @override
  String get merchant => 'వ్యాపారి లేదా గ్రహీత';

  @override
  String get note => 'గమనిక';

  @override
  String get date => 'తేదీ';

  @override
  String get repeat => 'పునరావృతం';

  @override
  String get repeatNone => 'పునరావృతం కాదు';

  @override
  String get repeatWeekly => 'ప్రతి వారం';

  @override
  String get repeatMonthly => 'ప్రతి నెల';

  @override
  String get save => 'సేవ్';

  @override
  String get delete => 'తొలగించు';

  @override
  String get cancel => 'రద్దు';

  @override
  String get suggestedCategory => 'వ్యాపారి పేరు ఆధారంగా సూచించిన వర్గం';

  @override
  String get amountInvalid => 'సున్నా కంటే ఎక్కువ మొత్తం ఇవ్వండి';

  @override
  String get transactionSaved => 'లావాదేవీ సేవ్ అయింది';

  @override
  String get transactionDeleted => 'లావాదేవీ తొలగించబడింది';

  @override
  String get deleteConfirm => 'ఈ లావాదేవీని తొలగించాలా?';

  @override
  String get filterAll => 'అన్నీ';

  @override
  String get filterExpenses => 'ఖర్చులు';

  @override
  String get filterIncome => 'ఆదాయం';

  @override
  String get analytics => 'విశ్లేషణ';

  @override
  String get monthly => 'నెలవారీ';

  @override
  String get weekly => 'వారానికి';

  @override
  String get spendingByCategory => 'ఈ నెల వర్గాల వారీగా ఖర్చు';

  @override
  String get noDataYet => 'ఇంకా సరిపడా డేటా లేదు';

  @override
  String get newGoal => 'కొత్త లక్ష్యం';

  @override
  String get goalName => 'లక్ష్యం పేరు';

  @override
  String get targetAmount => 'లక్ష్య మొత్తం';

  @override
  String get savedSoFar => 'ఇప్పటివరకు పొదుపు';

  @override
  String get deadline => 'లక్ష్య తేదీ';

  @override
  String get addMoney => 'డబ్బు జోడించండి';

  @override
  String suggestedMonthly(String amount) {
    return 'సమయానికి పూర్తి చేయడానికి నెలకు $amount పొదుపు చేయండి';
  }

  @override
  String get goalComplete => 'లక్ష్యం చేరుకున్నారు';

  @override
  String get goalOverdue => 'లక్ష్య తేదీ దాటింది';

  @override
  String get noGoals => 'ఇంకా లక్ష్యాలు లేవు. ఒకటి పెట్టి పురోగతి ఇక్కడ చూడండి.';

  @override
  String savedOf(String saved, String target) {
    return '$target లో $saved';
  }

  @override
  String get newGroup => 'కొత్త గ్రూప్';

  @override
  String get groupName => 'గ్రూప్ పేరు';

  @override
  String get members => 'సభ్యులు';

  @override
  String get addMember => 'సభ్యుడిని జోడించండి';

  @override
  String get memberNameHint => 'సభ్యుని పేరు';

  @override
  String get noGroups => 'ఇంకా గ్రూపులు లేవు. ట్రిప్‌లు, అద్దె, భోజనాలు పంచుకోవడానికి ఒకటి సృష్టించండి.';

  @override
  String get addExpense => 'ఖర్చు జోడించండి';

  @override
  String get description => 'వివరణ';

  @override
  String get paidBy => 'చెల్లించినవారు';

  @override
  String get splitEqually => 'సమానంగా';

  @override
  String get splitByShares => 'వాటాల ప్రకారం';

  @override
  String get settleUp => 'లెక్క తేల్చండి';

  @override
  String get whoPaysWhom => 'ఎవరు ఎవరికి చెల్లించాలి';

  @override
  String get allSettled => 'అందరి లెక్కలు తేలిపోయాయి';

  @override
  String get markPaid => 'చెల్లించినట్లు గుర్తించు';

  @override
  String get balances => 'బ్యాలెన్స్‌లు';

  @override
  String paysTo(String from, String to) {
    return '$from → $to కు చెల్లించాలి';
  }

  @override
  String getsBack(String amount) {
    return '$amount తిరిగి రావాలి';
  }

  @override
  String owesAmount(String amount) {
    return '$amount బాకీ';
  }

  @override
  String get settled => 'తేలింది';

  @override
  String get groupExpenses => 'ఖర్చులు';

  @override
  String get settlementRecorded => 'చెల్లింపు నమోదైంది';

  @override
  String get totalSpent => 'మొత్తం ఖర్చు';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count సభ్యులు', one: '1 సభ్యుడు');
    return '$_temp0';
  }

  @override
  String get simplifiedHint => 'తక్కువ చెల్లింపులతో లెక్క తేలేలా బాకీలు సరళీకరించబడ్డాయి.';

  @override
  String get reminders => 'బిల్ రిమైండర్‌లు';

  @override
  String get newReminder => 'కొత్త రిమైండర్';

  @override
  String get reminderTitle => 'బిల్ పేరు';

  @override
  String get dayOfMonth => 'నెలలో తేదీ';

  @override
  String dueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days రోజుల్లో చెల్లించాలి',
      one: 'రేపు చెల్లించాలి',
      zero: 'ఈరోజు చెల్లించాలి',
    );
    return '$_temp0';
  }

  @override
  String get noReminders => 'ఇంకా రిమైండర్‌లు లేవు.';

  @override
  String get remindersWebNote => 'నోటిఫికేషన్‌లకు మొబైల్ యాప్ కావాలి. రిమైండర్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get appearance => 'రూపం';

  @override
  String get theme => 'థీమ్';

  @override
  String get themeSystem => 'సిస్టమ్';

  @override
  String get themeLight => 'లైట్';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get language => 'భాష';

  @override
  String get languageSystem => 'పరికర భాష';

  @override
  String get security => 'భద్రత';

  @override
  String get biometricLock => 'బయోమెట్రిక్ లాక్';

  @override
  String get biometricLockHint => 'యాప్ తెరిచినప్పుడు వేలిముద్ర లేదా ముఖం అడగండి';

  @override
  String get biometricUnavailable => 'ఈ పరికరంలో బయోమెట్రిక్స్ అందుబాటులో లేవు';

  @override
  String get data => 'డేటా';

  @override
  String get exportCsv => 'లావాదేవీలు ఎగుమతి (CSV)';

  @override
  String get sync => 'సింక్';

  @override
  String get syncNow => 'ఇప్పుడు సింక్ చేయండి';

  @override
  String get syncing => 'సింక్ అవుతోంది…';

  @override
  String get syncUpToDate => 'తాజాగా ఉంది';

  @override
  String get syncOffline => 'ఆఫ్‌లైన్. మార్పులు సేవ్ అయ్యాయి, తర్వాత సింక్ అవుతాయి.';

  @override
  String syncFailed(String message) {
    return 'సింక్ విఫలమైంది: $message';
  }

  @override
  String pendingChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మార్పులు సింక్ కోసం వేచి ఉన్నాయి',
      one: '1 మార్పు సింక్ కోసం వేచి ఉంది',
      zero: 'పెండింగ్ మార్పులు లేవు',
    );
    return '$_temp0';
  }

  @override
  String lastSynced(String time) {
    return 'చివరి సింక్ $time';
  }

  @override
  String get demoMode => 'డెమో మోడ్: డేటా ఈ పరికరంలోనే ఉంటుంది, సింక్ కాదు.';

  @override
  String get account => 'ఖాతా';

  @override
  String get genericError => 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించండి.';
}
