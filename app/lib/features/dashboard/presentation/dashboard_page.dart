import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sync/sync_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../health_score/presentation/health_score_card.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import 'dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = context.select<AuthBloc, String>(
      (bloc) => switch (bloc.state) {
        Authenticated(:final session) => session.user.name.split(' ').first,
        _ => '',
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.greeting(name)), actions: const [_SyncIndicator(), SizedBox(width: 8)]),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('dashboard.add'),
        onPressed: () => context.push('/transactions/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTransaction),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          return RefreshIndicator(
            onRefresh: () => context.read<SyncCubit>().syncNow(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              children: [
                _MonthSummary(state: state),
                const SizedBox(height: 16),
                if (state.score != null) HealthScoreCard(score: state.score!),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.insights_outlined,
                        label: l10n.analytics,
                        onTap: () => context.push('/insights'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.notifications_active_outlined,
                        label: l10n.reminders,
                        onTap: () => context.push('/reminders'),
                      ),
                    ),
                  ],
                ),
                SectionHeader(
                  l10n.recentTransactions,
                  trailing: TextButton(onPressed: () => context.go('/transactions'), child: Text(l10n.seeAll)),
                ),
                if (state.recent.isEmpty)
                  EmptyState(icon: Icons.receipt_long_outlined, message: l10n.noTransactions)
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          for (final entry in state.recent)
                            TransactionTile(entry: entry, onTap: () => context.push('/transactions/${entry.id}')),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final onPrimary = scheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.primary, Color.lerp(scheme.primary, Colors.black, 0.25)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.thisMonth, style: TextStyle(color: onPrimary.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Text(
            formatMoney(context, state.monthNet),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: onPrimary, fontWeight: FontWeight.w700),
          ),
          Text(l10n.net, style: TextStyle(color: onPrimary.withValues(alpha: 0.8))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.south_west,
                  label: l10n.income,
                  value: formatMoney(context, state.monthIncome),
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.north_east,
                  label: l10n.expenses,
                  value: formatMoney(context, state.monthExpense),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return MergeSemantics(
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: onPrimary.withValues(alpha: 0.18),
            child: Icon(icon, size: 16, color: onPrimary),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: onPrimary.withValues(alpha: 0.8), fontSize: 12)),
                Text(
                  value,
                  style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncIndicator extends StatelessWidget {
  const _SyncIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SyncCubit, SyncState>(
      buildWhen: (p, n) => p.status != n.status || p.pending != n.pending,
      builder: (context, state) {
        final (icon, color, tooltip) = switch (state.status) {
          SyncStatus.syncing => (Icons.sync, null, l10n.syncing),
          SyncStatus.offline => (Icons.cloud_off_outlined, context.finance.warning, l10n.syncOffline),
          SyncStatus.failed => (Icons.sync_problem, context.finance.expense, l10n.syncFailed(state.error ?? '')),
          SyncStatus.disabled => (Icons.phone_android, null, l10n.demoMode),
          SyncStatus.idle when state.pending > 0 => (
            Icons.cloud_upload_outlined,
            null,
            l10n.pendingChanges(state.pending),
          ),
          SyncStatus.idle => (Icons.cloud_done_outlined, context.finance.income, l10n.syncUpToDate),
        };
        return IconButton(
          tooltip: tooltip,
          icon: Icon(icon, color: color),
          onPressed: () {
            showMessage(context, tooltip);
            context.read<SyncCubit>().syncNow();
          },
        );
      },
    );
  }
}
