import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  @override
  void initState() {
    super.initState();
    // Prompt straight away; the button is there if the user dismisses it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  void _unlock() => context.read<AuthBloc>().add(AuthUnlockRequested(context.l10n.unlockReason));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fingerprint, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(l10n.unlockTitle, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _unlock,
                  icon: const Icon(Icons.lock_open),
                  label: Text(l10n.unlockButton),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}
