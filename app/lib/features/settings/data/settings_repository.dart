import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../transactions/domain/categorisation/category_rules.dart';

/// Small, non-sensitive preferences. Tokens live in secure storage instead.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _biometricKey = 'biometric_lock';
  static const _learnedPrefix = 'merchant_rule:';

  ThemeMode get themeMode => ThemeMode.values.asNameMap()[_prefs.getString(_themeKey)] ?? ThemeMode.system;

  Future<void> setThemeMode(ThemeMode mode) => _prefs.setString(_themeKey, mode.name);

  /// Null means "follow the device language".
  Locale? get locale {
    final code = _prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) {
    return locale == null ? _prefs.remove(_localeKey) : _prefs.setString(_localeKey, locale.languageCode);
  }

  bool get biometricLock => _prefs.getBool(_biometricKey) ?? false;

  Future<void> setBiometricLock(bool enabled) => _prefs.setBool(_biometricKey, enabled);

  /// Merchant -> category corrections the user has made, used by the rules engine.
  LearnedMerchantRule loadLearnedRule() {
    final mappings = {
      for (final key in _prefs.getKeys().where((k) => k.startsWith(_learnedPrefix)))
        key.substring(_learnedPrefix.length): _prefs.getString(key) ?? '',
    }..removeWhere((_, v) => v.isEmpty);
    return LearnedMerchantRule(mappings);
  }

  Future<void> rememberMerchant(String merchant, String category) {
    return _prefs.setString('$_learnedPrefix${merchant.trim().toLowerCase()}', category);
  }
}
