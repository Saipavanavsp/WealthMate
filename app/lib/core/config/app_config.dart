/// Build-time configuration, passed with `--dart-define`.
///
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1
class AppConfig {
  const AppConfig({required this.apiBaseUrl, this.hasBackend = true});

  factory AppConfig.fromEnvironment() {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    return AppConfig(apiBaseUrl: fromEnv.isEmpty ? _localEmulatorUrl : fromEnv, hasBackend: fromEnv.isNotEmpty);
  }

  /// The host machine as seen from the Android emulator.
  static const _localEmulatorUrl = 'http://10.0.2.2:8080/api/v1';

  /// Base URL of the WealthMate API, including the `/api/v1` prefix.
  final String apiBaseUrl;

  /// False when no API_BASE_URL was given at build time. The hosted web demo
  /// is built this way and points people to demo mode instead of sign-in.
  final bool hasBackend;
}
