import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/entities/session.dart';

/// Keeps the current session in memory and persists it in secure storage
/// (Keychain on iOS, EncryptedSharedPreferences/Keystore on Android).
class SessionStore {
  SessionStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final _changes = StreamController<Session?>.broadcast();

  static const _key = 'session';

  Session? _current;

  Session? get current => _current;

  /// Emits whenever the session changes, including when it expires.
  Stream<Session?> get changes => _changes.stream;

  Future<Session?> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return _current = null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _current = Session(
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        isDemo: json['isDemo'] as bool? ?? false,
      );
    } on FormatException {
      await _storage.delete(key: _key);
      _current = null;
    }
    return _current;
  }

  Future<void> save(Session session) async {
    _current = session;
    await _storage.write(
      key: _key,
      value: jsonEncode({
        'user': session.user.toJson(),
        'accessToken': session.accessToken,
        'refreshToken': session.refreshToken,
        'isDemo': session.isDemo,
      }),
    );
    _changes.add(session);
  }

  Future<void> clear() async {
    _current = null;
    await _storage.delete(key: _key);
    _changes.add(null);
  }
}
