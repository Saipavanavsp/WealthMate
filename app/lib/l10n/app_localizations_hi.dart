// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'WealthMate';

  @override
  String get navHome => 'होम';

  @override
  String get navTransactions => 'लेन-देन';

  @override
  String get navGroups => 'ग्रुप';

  @override
  String get navGoals => 'लक्ष्य';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get loginTitle => 'फिर से स्वागत है';

  @override
  String get loginSubtitle => 'खर्च ट्रैक करें, बिल बाँटें और बचत बढ़ाएँ।';

  @override
  String get registerTitle => 'अपना खाता बनाएँ';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get name => 'नाम';

  @override
  String get signIn => 'साइन इन';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get noAccount => 'नए हैं? खाता बनाएँ';

  @override
  String get haveAccount => 'पहले से खाता है? साइन इन करें';

  @override
  String get tryDemo => 'डेमो डेटा के साथ देखें';

  @override
  String get demoHint => 'साइन अप की ज़रूरत नहीं। सारा डेटा इसी डिवाइस पर रहता है।';

  @override
  String get offlineDemoNote =>
      'यह वेब वर्ज़न किसी सर्वर से नहीं जुड़ा है, इसलिए यहाँ साइन इन काम नहीं करेगा। सभी फ़ीचर आज़माने के लिए डेमो डेटा इस्तेमाल करें।';

  @override
  String get invalidEmail => 'सही ईमेल डालें';

  @override
  String get passwordTooShort => 'कम से कम 8 अक्षर रखें';

  @override
  String get requiredField => 'ज़रूरी';

  @override
  String get unlockTitle => 'WealthMate लॉक है';

  @override
  String get unlockButton => 'अनलॉक';

  @override
  String get unlockReason => 'अपनी वित्तीय जानकारी देखने के लिए WealthMate अनलॉक करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String greeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get income => 'आय';

  @override
  String get expenses => 'खर्च';

  @override
  String get net => 'शुद्ध';

  @override
  String get recentTransactions => 'हाल के लेन-देन';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get noTransactions => 'अभी कोई लेन-देन नहीं। पहला जोड़ने के लिए + दबाएँ।';

  @override
  String get healthScore => 'वित्तीय सेहत';

  @override
  String get healthExcellent => 'बेहतरीन';

  @override
  String get healthGood => 'अच्छा';

  @override
  String get healthFair => 'ठीक-ठाक';

  @override
  String get healthNeedsAttention => 'ध्यान दें';

  @override
  String get howCalculated => 'यह कैसे गिना जाता है?';

  @override
  String get scoreSavingsTitle => 'बचत दर';

  @override
  String scoreSavingsDetail(String rate) {
    return 'पिछले 3 महीनों में आपने आय का $rate बचाया। 30% या ज़्यादा पर पूरे अंक।';
  }

  @override
  String get scoreSavingsNoData => 'इस हिस्से के अंक के लिए आय जोड़ें।';

  @override
  String get scoreTrendTitle => 'खर्च का रुझान';

  @override
  String scoreTrendLower(String change) {
    return 'पिछले महीने आपने 3 महीने के औसत से $change कम खर्च किया। 10% कम खर्च पर पूरे अंक।';
  }

  @override
  String scoreTrendHigher(String change) {
    return 'पिछले महीने आपने 3 महीने के औसत से $change ज़्यादा खर्च किया। खर्च स्थिर या कम रखने पर बेहतर अंक।';
  }

  @override
  String get scoreTrendNoData => 'पर्याप्त इतिहास नहीं है, इसलिए इसे स्थिर माना गया।';

  @override
  String get scoreGoalsTitle => 'लक्ष्यों की प्रगति';

  @override
  String scoreGoalsDetail(String progress) {
    return 'आपके लक्ष्य औसतन $progress पूरे हुए हैं।';
  }

  @override
  String get scoreGoalsNoData => 'ये अंक पाने के लिए बचत लक्ष्य जोड़ें।';

  @override
  String points(String points, int max) {
    return '$points / $max';
  }

  @override
  String get addTransaction => 'लेन-देन जोड़ें';

  @override
  String get editTransaction => 'लेन-देन बदलें';

  @override
  String get expense => 'खर्च';

  @override
  String get incomeType => 'आय';

  @override
  String get amount => 'राशि';

  @override
  String get category => 'श्रेणी';

  @override
  String get merchant => 'दुकानदार या प्राप्तकर्ता';

  @override
  String get note => 'नोट';

  @override
  String get date => 'तारीख';

  @override
  String get repeat => 'दोहराएँ';

  @override
  String get repeatNone => 'नहीं दोहराता';

  @override
  String get repeatWeekly => 'हर हफ़्ते';

  @override
  String get repeatMonthly => 'हर महीने';

  @override
  String get save => 'सेव करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get suggestedCategory => 'दुकानदार के नाम से सुझाई गई श्रेणी';

  @override
  String get amountInvalid => 'शून्य से ज़्यादा राशि डालें';

  @override
  String get transactionSaved => 'लेन-देन सेव हुआ';

  @override
  String get transactionDeleted => 'लेन-देन हटाया गया';

  @override
  String get deleteConfirm => 'यह लेन-देन हटाएँ?';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterExpenses => 'खर्च';

  @override
  String get filterIncome => 'आय';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get monthly => 'मासिक';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get spendingByCategory => 'इस महीने श्रेणी के अनुसार खर्च';

  @override
  String get noDataYet => 'अभी पर्याप्त डेटा नहीं है';

  @override
  String get newGoal => 'नया लक्ष्य';

  @override
  String get goalName => 'लक्ष्य का नाम';

  @override
  String get targetAmount => 'लक्ष्य राशि';

  @override
  String get savedSoFar => 'अब तक की बचत';

  @override
  String get deadline => 'लक्ष्य तारीख';

  @override
  String get addMoney => 'पैसे जोड़ें';

  @override
  String suggestedMonthly(String amount) {
    return 'समय पर पूरा करने के लिए हर महीने $amount बचाएँ';
  }

  @override
  String get goalComplete => 'लक्ष्य पूरा हुआ';

  @override
  String get goalOverdue => 'लक्ष्य तारीख निकल गई';

  @override
  String get noGoals => 'अभी कोई लक्ष्य नहीं। एक बनाएँ और प्रगति यहाँ देखें।';

  @override
  String savedOf(String saved, String target) {
    return '$target में से $saved';
  }

  @override
  String get newGroup => 'नया ग्रुप';

  @override
  String get groupName => 'ग्रुप का नाम';

  @override
  String get members => 'सदस्य';

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get memberNameHint => 'सदस्य का नाम';

  @override
  String get noGroups => 'अभी कोई ग्रुप नहीं। ट्रिप, किराया या खाने का खर्च बाँटने के लिए ग्रुप बनाएँ।';

  @override
  String get addExpense => 'खर्च जोड़ें';

  @override
  String get description => 'विवरण';

  @override
  String get paidBy => 'किसने चुकाया';

  @override
  String get splitEqually => 'बराबर';

  @override
  String get splitByShares => 'हिस्सों के अनुसार';

  @override
  String get settleUp => 'हिसाब चुकता करें';

  @override
  String get whoPaysWhom => 'कौन किसे देगा';

  @override
  String get allSettled => 'सबका हिसाब बराबर है';

  @override
  String get markPaid => 'भुगतान हुआ';

  @override
  String get balances => 'बैलेंस';

  @override
  String paysTo(String from, String to) {
    return '$from → $to को देगा';
  }

  @override
  String getsBack(String amount) {
    return '$amount वापस मिलेंगे';
  }

  @override
  String owesAmount(String amount) {
    return '$amount देने हैं';
  }

  @override
  String get settled => 'बराबर';

  @override
  String get groupExpenses => 'खर्च';

  @override
  String get settlementRecorded => 'भुगतान दर्ज हुआ';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count सदस्य', one: '1 सदस्य');
    return '$_temp0';
  }

  @override
  String get simplifiedHint => 'कर्ज़ को सरल किया गया है ताकि सबसे कम भुगतान में हिसाब हो जाए।';

  @override
  String get reminders => 'बिल रिमाइंडर';

  @override
  String get newReminder => 'नया रिमाइंडर';

  @override
  String get reminderTitle => 'बिल का नाम';

  @override
  String get dayOfMonth => 'महीने की तारीख';

  @override
  String dueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में देय',
      one: 'कल देय',
      zero: 'आज देय',
    );
    return '$_temp0';
  }

  @override
  String get noReminders => 'अभी कोई रिमाइंडर नहीं।';

  @override
  String get remindersWebNote => 'नोटिफ़िकेशन के लिए मोबाइल ऐप चाहिए। रिमाइंडर यहाँ दिखते रहेंगे।';

  @override
  String get appearance => 'दिखावट';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'डिवाइस की भाषा';

  @override
  String get security => 'सुरक्षा';

  @override
  String get biometricLock => 'बायोमेट्रिक लॉक';

  @override
  String get biometricLockHint => 'ऐप खोलते समय फ़िंगरप्रिंट या चेहरा माँगें';

  @override
  String get biometricUnavailable => 'इस डिवाइस पर बायोमेट्रिक उपलब्ध नहीं है';

  @override
  String get data => 'डेटा';

  @override
  String get exportCsv => 'लेन-देन निर्यात करें (CSV)';

  @override
  String get sync => 'सिंक';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncing => 'सिंक हो रहा है…';

  @override
  String get syncUpToDate => 'अपडेटेड है';

  @override
  String get syncOffline => 'ऑफ़लाइन। बदलाव सेव हैं और बाद में सिंक होंगे।';

  @override
  String syncFailed(String message) {
    return 'सिंक नहीं हो सका: $message';
  }

  @override
  String pendingChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बदलाव सिंक के लिए बाकी',
      one: '1 बदलाव सिंक के लिए बाकी',
      zero: 'कोई बदलाव बाकी नहीं',
    );
    return '$_temp0';
  }

  @override
  String lastSynced(String time) {
    return 'आख़िरी सिंक $time';
  }

  @override
  String get demoMode => 'डेमो मोड: डेटा इसी डिवाइस पर रहता है और सिंक नहीं होता।';

  @override
  String get account => 'खाता';

  @override
  String get genericError => 'कुछ गड़बड़ हुई। कृपया फिर से कोशिश करें।';
}
