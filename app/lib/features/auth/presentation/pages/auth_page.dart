import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/common.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';

/// Sign-in and registration share one screen; [register] switches the form.
class AuthPage extends StatefulWidget {
  const AuthPage({this.register = false, this.offlineOnly = false, super.key});

  final bool register;

  /// True for builds without an API server (the hosted web demo). Sign-in is
  /// still shown, with a note that demo mode is the way to try the app.
  final bool offlineOnly;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<AuthBloc>();
    if (widget.register) {
      bloc.add(AuthRegisterRequested(name: _name.text, email: _email.text, password: _password.text));
    } else {
      bloc.add(AuthLoginRequested(email: _email.text, password: _password.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, state) => state is Unauthenticated && state.failure != null,
      listener: (context, state) => showMessage(context, (state as Unauthenticated).failure!.message),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Logo(),
                        const SizedBox(height: 32),
                        Text(
                          widget.register ? l10n.registerTitle : l10n.loginTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.loginSubtitle, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 32),
                        if (widget.register) ...[
                          TextFormField(
                            controller: _name,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            decoration: InputDecoration(
                              labelText: l10n.name,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (v) => (v ?? '').trim().isEmpty ? l10n.requiredField : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          key: const Key('auth.email'),
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),
                          validator: (v) =>
                              RegExp(r'^\S+@\S+\.\S+$').hasMatch((v ?? '').trim()) ? null : l10n.invalidEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('auth.password'),
                          controller: _password,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          autofillHints: [widget.register ? AutofillHints.newPassword : AutofillHints.password],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: l10n.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _obscure ? 'Show password' : 'Hide password',
                              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v ?? '').length < 8 ? l10n.passwordTooShort : null,
                        ),
                        const SizedBox(height: 24),
                        BlocSelector<AuthBloc, AuthState, bool>(
                          selector: (state) => state is Unauthenticated && state.submitting,
                          builder: (context, submitting) => FilledButton(
                            key: const Key('auth.submit'),
                            onPressed: submitting ? null : _submit,
                            child: submitting
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  )
                                : Text(widget.register ? l10n.createAccount : l10n.signIn),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.go(widget.register ? '/login' : '/register'),
                          child: Text(widget.register ? l10n.haveAccount : l10n.noAccount),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          key: const Key('auth.demo'),
                          icon: const Icon(Icons.play_circle_outline),
                          label: Text(l10n.tryDemo),
                          onPressed: () => context.read<AuthBloc>().add(const AuthDemoRequested()),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.demoHint, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                        if (widget.offlineOnly) ...[
                          const SizedBox(height: 16),
                          Card(
                            color: theme.colorScheme.secondaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: theme.colorScheme.onSecondaryContainer),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      l10n.offlineDemoNote,
                                      style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(14)),
          child: Icon(Icons.savings_outlined, color: scheme.onPrimary),
        ),
        const SizedBox(width: 12),
        Text(
          context.l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
