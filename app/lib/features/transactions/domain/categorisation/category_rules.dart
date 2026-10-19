import '../entities/categories.dart';

/// One way of guessing a category from a merchant name. Returns null when the
/// rule has no opinion, so the next rule in the chain gets a turn.
abstract interface class CategoryRule {
  String? categorise(String merchant);
}

/// Exact matches the user taught the app by correcting a suggestion.
/// Checked first so personal choices always beat the generic keywords.
class LearnedMerchantRule implements CategoryRule {
  LearnedMerchantRule([Map<String, String>? mappings]) : _mappings = {...?mappings};

  final Map<String, String> _mappings;

  Map<String, String> get mappings => Map.unmodifiable(_mappings);

  void learn(String merchant, String category) => _mappings[_normalise(merchant)] = category;

  @override
  String? categorise(String merchant) => _mappings[_normalise(merchant)];
}

/// Matches if the merchant contains any of the keywords as a whole word or
/// word prefix ("uber" matches "Uber Trip" and "UberEats" but not "Kuber").
class KeywordRule implements CategoryRule {
  KeywordRule(this.category, List<String> keywords)
    : _pattern = RegExp('\\b(${keywords.map(RegExp.escape).join('|')})', caseSensitive: false);

  final String category;
  final RegExp _pattern;

  @override
  String? categorise(String merchant) => _pattern.hasMatch(merchant) ? category : null;
}

/// Chain of responsibility over [CategoryRule]s: the first rule that returns
/// a category wins. New strategies (regex, ML model, server-side rules) can be
/// added without touching existing ones, which is the Open/Closed principle.
///
/// Cost is O(r) rule checks per lookup, where r is the number of rules.
class CategoryRuleEngine {
  CategoryRuleEngine(this.rules, {this.fallback = Categories.other});

  factory CategoryRuleEngine.withDefaults({LearnedMerchantRule? learned}) {
    return CategoryRuleEngine([learned ?? LearnedMerchantRule(), ...defaultKeywordRules]);
  }

  final List<CategoryRule> rules;
  final String fallback;

  String categorise(String merchant) {
    final trimmed = merchant.trim();
    if (trimmed.isEmpty) return fallback;
    for (final rule in rules) {
      final category = rule.categorise(trimmed);
      if (category != null) return category;
    }
    return fallback;
  }

  static final defaultKeywordRules = <CategoryRule>[
    KeywordRule(Categories.food, [
      'swiggy',
      'zomato',
      'dominos',
      'pizza',
      'starbucks',
      'cafe',
      'coffee',
      'restaurant',
      'kfc',
      'mcdonald',
      'burger',
      'biryani',
      'chai',
      'bakery',
    ]),
    KeywordRule(Categories.groceries, [
      'bigbasket',
      'dmart',
      'zepto',
      'blinkit',
      'instamart',
      'grocery',
      'reliance fresh',
      'more supermarket',
      'supermarket',
      'kirana',
    ]),
    KeywordRule(Categories.transport, [
      'uber',
      'ola',
      'rapido',
      'metro',
      'irctc',
      'petrol',
      'fuel',
      'indianoil',
      'hpcl',
      'bpcl',
      'shell',
      'fastag',
      'parking',
    ]),
    KeywordRule(Categories.travel, [
      'makemytrip',
      'goibibo',
      'indigo',
      'air india',
      'vistara',
      'oyo',
      'hotel',
      'airbnb',
    ]),
    KeywordRule(Categories.shopping, ['amazon', 'flipkart', 'myntra', 'ajio', 'nykaa', 'meesho', 'decathlon', 'ikea']),
    KeywordRule(Categories.bills, [
      'airtel',
      'jio',
      'vodafone',
      'bsnl',
      'electricity',
      'bescom',
      'tneb',
      'broadband',
      'act fibernet',
      'gas',
      'water bill',
      'recharge',
    ]),
    KeywordRule(Categories.entertainment, [
      'netflix',
      'hotstar',
      'prime video',
      'spotify',
      'bookmyshow',
      'pvr',
      'inox',
    ]),
    KeywordRule(Categories.health, [
      'apollo',
      'pharmeasy',
      '1mg',
      'netmeds',
      'hospital',
      'clinic',
      'pharmacy',
      'medplus',
    ]),
    KeywordRule(Categories.education, ['udemy', 'coursera', 'byju', 'unacademy', 'school', 'college', 'tuition']),
    KeywordRule(Categories.investments, ['zerodha', 'groww', 'upstox', 'sip', 'mutual fund', 'ppf', 'nps']),
    KeywordRule(Categories.rent, ['rent', 'nobroker', 'landlord']),
  ];
}

String _normalise(String merchant) => merchant.trim().toLowerCase();
