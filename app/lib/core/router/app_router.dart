import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/lock_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/goals/presentation/goals_page.dart';
import '../../features/groups/domain/repositories/group_repository.dart';
import '../../features/groups/presentation/group_detail_page.dart';
import '../../features/groups/presentation/groups_cubit.dart';
import '../../features/groups/presentation/groups_page.dart';
import '../../features/reminders/domain/reminder_repository.dart';
import '../../features/reminders/presentation/reminders_cubit.dart';
import '../../features/reminders/presentation/reminders_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/transactions/domain/categorisation/category_rules.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/presentation/bloc/analytics_cubit.dart';
import '../../features/transactions/presentation/bloc/transaction_form_cubit.dart';
import '../../features/transactions/presentation/pages/insights_page.dart';
import '../../features/transactions/presentation/pages/transaction_form_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../l10n/l10n.dart';
import '../config/app_config.dart';
import '../di/injection.dart';

const _publicRoutes = {'/login', '/register'};
const _gateRoutes = {'/splash', '/lock', ..._publicRoutes};

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _StreamListenable(authBloc.stream),
    redirect: (context, state) {
      final location = state.matchedLocation;
      return switch (authBloc.state) {
        AuthUnknown() => location == '/splash' ? null : '/splash',
        Unauthenticated() => _publicRoutes.contains(location) ? null : '/login',
        AuthLocked() => location == '/lock' ? null : '/lock',
        Authenticated() => _gateRoutes.contains(location) ? '/home' : null,
      };
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashPage()),
      GoRoute(
        path: '/login',
        builder: (_, _) => AuthPage(offlineOnly: !sl<AppConfig>().hasBackend && kIsWeb),
      ),
      GoRoute(
        path: '/register',
        builder: (_, _) => AuthPage(register: true, offlineOnly: !sl<AppConfig>().hasBackend && kIsWeb),
      ),
      GoRoute(path: '/lock', builder: (_, _) => const LockPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const DashboardPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/transactions', builder: (_, _) => const TransactionsPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/groups', builder: (_, _) => const GroupsPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/goals', builder: (_, _) => const GoalsPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => SettingsPage(transactions: sl()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/transactions/new',
        builder: (_, _) => BlocProvider(create: (_) => _formCubit(), child: const TransactionFormPage()),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => _formCubit()..load(id),
            child: TransactionFormPage(editingId: id),
          );
        },
      ),
      GoRoute(
        path: '/insights',
        builder: (_, _) => BlocProvider(
          create: (_) => AnalyticsCubit(sl<TransactionRepository>())..start(),
          child: const InsightsPage(),
        ),
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (_, state) => BlocProvider(
          create: (_) => GroupDetailCubit(sl<GroupRepository>(), state.pathParameters['id']!)..start(),
          child: const GroupDetailPage(),
        ),
      ),
      GoRoute(
        path: '/reminders',
        builder: (_, _) => BlocProvider(
          create: (_) => RemindersCubit(sl<ReminderRepository>())..start(),
          child: const RemindersPage(),
        ),
      ),
    ],
  );
}

TransactionFormCubit _formCubit() {
  return TransactionFormCubit(
    repository: sl(),
    engine: sl<CategoryRuleEngine>(),
    learn: learnMerchantCategory,
    newId: sl<IdGenerator>(),
  );
}

class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navTransactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: l10n.navGroups,
          ),
          NavigationDestination(
            icon: const Icon(Icons.flag_outlined),
            selectedIcon: const Icon(Icons.flag),
            label: l10n.navGoals,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

/// Lets go_router re-run its redirect whenever the auth state changes.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
