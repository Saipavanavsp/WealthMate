import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/domain/auth_repository.dart';
import '../data/settings_repository.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.biometricLock = false,
    this.biometricAvailable = false,
  });

  final ThemeMode themeMode;
  final Locale? locale;
  final bool biometricLock;
  final bool biometricAvailable;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? Function()? locale,
    bool? biometricLock,
    bool? biometricAvailable,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale != null ? locale() : this.locale,
      biometricLock: biometricLock ?? this.biometricLock,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, biometricLock, biometricAvailable];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository, this._biometrics)
    : super(
        SettingsState(
          themeMode: _repository.themeMode,
          locale: _repository.locale,
          biometricLock: _repository.biometricLock,
        ),
      );

  final SettingsRepository _repository;
  final BiometricAuthenticator _biometrics;

  static const supportedLocales = [Locale('en'), Locale('te'), Locale('hi')];

  Future<void> checkBiometrics() async {
    final available = await _biometrics.isAvailable();
    if (!isClosed) emit(state.copyWith(biometricAvailable: available));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _repository.setThemeMode(mode);
  }

  Future<void> setLocale(Locale? locale) async {
    emit(state.copyWith(locale: () => locale));
    await _repository.setLocale(locale);
  }

  /// Turning the lock on asks for a biometric check first, so users can't
  /// lock themselves out with a sensor that doesn't work.
  Future<void> setBiometricLock(bool enabled, {required String reason}) async {
    if (enabled && !await _biometrics.authenticate(reason)) return;
    emit(state.copyWith(biometricLock: enabled));
    await _repository.setBiometricLock(enabled);
  }
}
