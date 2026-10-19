import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthmate/core/database/app_database.dart';
import 'package:wealthmate/core/di/injection.dart';
import 'package:wealthmate/core/network/connectivity_service.dart';
import 'package:wealthmate/core/sync/sync_remote_data_source.dart';
import 'package:wealthmate/features/auth/data/auth_remote_data_source.dart';
import 'package:wealthmate/features/auth/domain/auth_repository.dart';
import 'package:wealthmate/features/auth/domain/entities/session.dart';
import 'package:wealthmate/features/reminders/data/local_notification_service.dart';

/// Wires the real app (real blocs, repositories, sync engine and an in-memory
/// SQLite database) with fakes only at the edges: the HTTP server, network
/// status, biometrics and notifications.
class AppHarness {
  final server = RecordingSyncServer();
  late final AppDatabase db;

  Future<void> setUp() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());

    await configureDependencies(
      database: db,
      syncRemote: server,
      authRemote: FakeAuthRemote(),
      connectivity: AlwaysOnline(),
      biometrics: NoBiometrics(),
      notifier: const NoopReminderNotifier(),
    );
  }
}

class RecordingSyncServer implements SyncRemoteDataSource {
  final pushed = <String, List<Map<String, dynamic>>>{};
  int _cursor = 0;

  @override
  Future<List<PushResult>> push(List<OutboxEntry> entries) async {
    return [
      for (final e in entries)
        () {
          final record = jsonDecode(e.payload) as Map<String, dynamic>;
          pushed.putIfAbsent(e.entity, () => []).add(record);
          _cursor++;
          return PushResult(changeId: e.id, status: PushStatus.applied, record: record);
        }(),
    ];
  }

  @override
  Future<PullResponse> pull(int since) async => PullResponse(changes: const {}, cursor: _cursor);
}

class FakeAuthRemote extends AuthRemoteDataSource {
  FakeAuthRemote() : super(Dio());

  @override
  Future<Session> login(String email, String password) async => Session(
    user: AppUser(id: 'u1', email: email, name: 'Sai Pavan'),
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  @override
  Future<Session> register(String name, String email, String password) => login(email, password);

  @override
  Future<void> logout(String refreshToken) async {}
}

class AlwaysOnline implements ConnectivityService {
  @override
  Future<bool> isOnline() async => true;

  @override
  Stream<bool> get onlineChanges => const Stream.empty();
}

class NoBiometrics implements BiometricAuthenticator {
  @override
  Future<bool> authenticate(String reason) async => false;

  @override
  Future<bool> isAvailable() async => false;
}
