import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/sync/sync_cubit.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../transactions/domain/repositories/transaction_repository.dart';
import '../data/csv_exporter.dart';
import 'settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.transactions, this.exporter = const CsvExporter(), super.key});

  final TransactionRepository transactions;
  final CsvExporter exporter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final auth = context.watch<AuthBloc>().state;
    final session = auth is Authenticated ? auth.session : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (session != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(session.user.name.characters.first.toUpperCase())),
                title: Text(session.user.name),
                subtitle: Text(session.isDemo ? l10n.demoMode : session.user.email),
              ),
            ),
          SectionHeader(l10n.appearance),
          const _AppearanceCard(),
          SectionHeader(l10n.security),
          const _SecurityCard(),
          SectionHeader(l10n.sync),
          const _SyncCard(),
          SectionHeader(l10n.data),
          Card(
            child: ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: Text(l10n.exportCsv),
              onTap: () async {
                final items = await transactions.watchAll().first;
                await exporter.share(items, DateTime.now());
              },
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(l10n.signOut),
            onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
          const SizedBox(height: 16),
          Center(child: Text('WealthMate 1.0.0 · Sai Pavan', style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (p, n) => p.themeMode != n.themeMode || p.locale != n.locale,
      builder: (context, state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.theme, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.themeSystem),
                      icon: const Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.themeLight),
                      icon: const Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.themeDark),
                      icon: const Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (s) => cubit.setThemeMode(s.first),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: state.locale?.languageCode ?? '',
                decoration: InputDecoration(labelText: l10n.language, prefixIcon: const Icon(Icons.translate)),
                items: [
                  DropdownMenuItem(value: '', child: Text(l10n.languageSystem)),
                  const DropdownMenuItem(value: 'en', child: Text('English')),
                  const DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
                  const DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                ],
                onChanged: (code) => cubit.setLocale(code == null || code.isEmpty ? null : Locale(code)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (p, n) => p.biometricLock != n.biometricLock || p.biometricAvailable != n.biometricAvailable,
      builder: (context, state) => Card(
        child: SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: Text(l10n.biometricLock),
          subtitle: Text(state.biometricAvailable ? l10n.biometricLockHint : l10n.biometricUnavailable),
          value: state.biometricLock,
          onChanged: state.biometricAvailable
              ? (v) => context.read<SettingsCubit>().setBiometricLock(v, reason: l10n.unlockReason)
              : null,
        ),
      ),
    );
  }
}

class _SyncCard extends StatelessWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {
        final subtitle = switch (state.status) {
          SyncStatus.disabled => l10n.demoMode,
          SyncStatus.syncing => l10n.syncing,
          SyncStatus.offline => l10n.syncOffline,
          SyncStatus.failed => l10n.syncFailed(state.error ?? ''),
          SyncStatus.idle when state.lastSyncedAt != null => l10n.lastSynced(
            DateFormat.jm(Localizations.localeOf(context).toString()).format(state.lastSyncedAt!),
          ),
          SyncStatus.idle => l10n.syncUpToDate,
        };
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_sync_outlined),
                title: Text(l10n.pendingChanges(state.pending)),
                subtitle: Text(subtitle),
              ),
              if (state.status != SyncStatus.disabled)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: FilledButton.tonalIcon(
                    onPressed: state.status == SyncStatus.syncing ? null : () => context.read<SyncCubit>().syncNow(),
                    icon: const Icon(Icons.sync),
                    label: Text(l10n.syncNow),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
