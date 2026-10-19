import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/data/auth_remote_data_source.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/data/biometric_service.dart';
import '../../features/auth/data/demo_data_seeder.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/goals/data/goal_repository_impl.dart';
import '../../features/goals/domain/repositories/goal_repository.dart';
import '../../features/groups/data/group_repository_impl.dart';
import '../../features/groups/domain/repositories/group_repository.dart';
import '../../features/reminders/data/local_notification_service.dart';
import '../../features/reminders/data/reminder_repository_impl.dart';
import '../../features/reminders/domain/reminder_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/transactions/data/transaction_repository_impl.dart';
import '../../features/transactions/domain/categorisation/category_rules.dart';
import '../../features/transactions/domain/recurring/recurring_scheduler.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../network/session_store.dart';
import '../sync/sync_engine.dart';
import '../sync/sync_handler.dart';
import '../sync/sync_queue.dart';
import '../sync/sync_remote_data_source.dart';
import '../sync/synced_writer.dart';

final sl = GetIt.instance;

typedef IdGenerator = String Function();

/// Wires the object graph. Everything is registered against its interface
/// (Dependency Inversion), so tests can swap any piece through the optional
/// parameters without touching the rest.
Future<void> configureDependencies({
  AppConfig? config,
  AppDatabase? database,
  SyncRemoteDataSource? syncRemote,
  AuthRemoteDataSource? authRemote,
  ConnectivityService? connectivity,
  BiometricAuthenticator? biometrics,
  ReminderNotifier? notifier,
  FlutterSecureStorage? secureStorage,
}) async {
  await sl.reset();

  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment())
    ..registerSingleton<IdGenerator>(const Uuid().v4)
    ..registerSingleton<SettingsRepository>(SettingsRepository(prefs))
    ..registerSingleton<SessionStore>(SessionStore(secureStorage))
    ..registerLazySingleton<Dio>(() => createApiClient(sl(), sl()))
    ..registerSingleton<AppDatabase>(database ?? AppDatabase(), dispose: (db) => db.close())
    ..registerLazySingleton(() => SyncQueueStore(sl()))
    ..registerLazySingleton(() => SyncHandlers(sl()))
    ..registerLazySingleton(() => SyncedWriter(sl(), sl()))
    ..registerLazySingleton<SyncRemoteDataSource>(() => syncRemote ?? SyncApi(sl()))
    ..registerLazySingleton(
      () => SyncEngine(db: sl(), queue: sl(), remote: sl(), handlers: sl<SyncHandlers>().byEntity),
    )
    ..registerLazySingleton<ConnectivityService>(() => connectivity ?? ConnectivityPlusService())
    ..registerLazySingleton<BiometricAuthenticator>(() => biometrics ?? BiometricService())
    ..registerLazySingleton<ReminderNotifier>(
      () => notifier ?? (kIsWeb ? const NoopReminderNotifier() : LocalNotificationService()),
    )
    ..registerLazySingleton(() => sl<SettingsRepository>().loadLearnedRule())
    ..registerLazySingleton(() => CategoryRuleEngine.withDefaults(learned: sl<LearnedMerchantRule>()))
    ..registerLazySingleton(() => DemoDataSeeder(sl(), newId: sl<IdGenerator>()))
    ..registerLazySingleton(() => authRemote ?? AuthRemoteDataSource(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), sessions: sl(), db: sl(), seeder: sl()),
    )
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(
        db: sl(),
        writer: sl(),
        handlers: sl(),
        scheduler: RecurringScheduler(newId: sl<IdGenerator>()),
      ),
    )
    ..registerLazySingleton<GoalRepository>(() => GoalRepositoryImpl(db: sl(), writer: sl(), handlers: sl()))
    ..registerLazySingleton<GroupRepository>(
      () => GroupRepositoryImpl(db: sl(), writer: sl(), handlers: sl(), newId: sl<IdGenerator>()),
    )
    ..registerLazySingleton<ReminderRepository>(() => ReminderRepositoryImpl(sl(), sl()));
}

/// Saves a merchant -> category correction so future suggestions use it.
Future<void> learnMerchantCategory(String merchant, String category) async {
  sl<LearnedMerchantRule>().learn(merchant, category);
  await sl<SettingsRepository>().rememberMerchant(merchant, category);
}
