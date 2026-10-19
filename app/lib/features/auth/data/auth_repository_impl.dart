import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/error/result.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/session_store.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/session.dart';
import 'auth_remote_data_source.dart';
import 'demo_data_seeder.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required SessionStore sessions,
    required AppDatabase db,
    required DemoDataSeeder seeder,
  }) : _remote = remote,
       _sessions = sessions,
       _db = db,
       _seeder = seeder;

  final AuthRemoteDataSource _remote;
  final SessionStore _sessions;
  final AppDatabase _db;
  final DemoDataSeeder _seeder;

  @override
  Stream<Session?> get sessionChanges => _sessions.changes;

  @override
  Future<Session?> restoreSession() => _sessions.load();

  @override
  Future<Result<Session>> login({required String email, required String password}) {
    return _signIn(() => _remote.login(email.trim(), password));
  }

  @override
  Future<Result<Session>> register({required String name, required String email, required String password}) {
    return _signIn(() => _remote.register(name.trim(), email.trim(), password));
  }

  Future<Result<Session>> _signIn(Future<Session> Function() call) async {
    try {
      final session = await call();
      // Data from a previous account (or the demo) must not leak into this one.
      await _db.clearAll();
      await _sessions.save(session);
      return Ok(session);
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<Session> startDemo() async {
    await _db.clearAll();
    await _seeder.seed(DateTime.now());
    const session = Session.demo();
    await _sessions.save(session);
    return session;
  }

  @override
  Future<void> logout() async {
    final refreshToken = _sessions.current?.refreshToken;
    if (refreshToken != null) {
      try {
        await _remote.logout(refreshToken);
      } on DioException catch (e) {
        // Signing out locally still works when offline; the token expires on its own.
        debugPrint('Remote logout failed: ${e.message}');
      }
    }
    await _db.clearAll();
    await _sessions.clear();
  }
}
