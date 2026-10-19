import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/network/session_store.dart';
import 'core/router/app_router.dart';
import 'core/sync/sync_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/dashboard_cubit.dart';
import 'features/goals/presentation/goals_cubit.dart';
import 'features/groups/presentation/groups_cubit.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'features/transactions/domain/repositories/transaction_repository.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';
import 'l10n/l10n.dart';

class WealthMateApp extends StatefulWidget {
  const WealthMateApp({super.key});

  @override
  State<WealthMateApp> createState() => _WealthMateAppState();
}

class _WealthMateAppState extends State<WealthMateApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(
      repository: sl(),
      biometrics: sl(),
      biometricLockEnabled: () => sl<SettingsRepository>().biometricLock,
    )..add(const AuthStarted());
    _router = createRouter(_authBloc);
  }

  @override
  void dispose() {
    _router.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => SettingsCubit(sl(), sl())..checkBiometrics()),
        BlocProvider(
          create: (_) => SyncCubit(
            engine: sl(),
            queue: sl(),
            connectivity: sl(),
            canSync: () => sl<SessionStore>().current?.canSync ?? false,
          ),
        ),
        BlocProvider(create: (_) => TransactionsBloc(sl())..add(const TransactionsSubscribed())),
        BlocProvider(
          create: (_) => DashboardCubit(transactions: sl(), goals: sl())..start(),
        ),
        BlocProvider(create: (_) => GoalsCubit(sl(), newId: sl<IdGenerator>())..start()),
        BlocProvider(create: (_) => GroupsCubit(sl())..start()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, next) => next is Authenticated && prev is! Authenticated,
        listener: (context, state) {
          unawaited(sl<TransactionRepository>().generateDueRecurring(DateTime.now()));
          context.read<SyncCubit>().start();
          unawaited(context.read<SyncCubit>().syncNow());
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (p, n) => p.themeMode != n.themeMode || p.locale != n.locale,
          builder: (context, settings) => MaterialApp.router(
            title: 'WealthMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
