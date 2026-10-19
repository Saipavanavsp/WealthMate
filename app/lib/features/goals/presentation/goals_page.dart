import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/money/money.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../domain/entities/savings_goal.dart';
import 'goals_cubit.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navGoals)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoalForm(context),
        icon: const Icon(Icons.flag_outlined),
        label: Text(l10n.newGoal),
      ),
      body: BlocConsumer<GoalsCubit, GoalsState>(
        listenWhen: (p, n) => n.failure != null && p.failure != n.failure,
        listener: (context, state) => showMessage(context, state.failure!.message),
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.goals.isEmpty) return EmptyState(icon: Icons.savings_outlined, message: l10n.noGoals);
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            itemCount: state.goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => GoalCard(goal: state.goals[index]),
          );
        },
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard({required this.goal, super.key});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final color = goal.isComplete
        ? context.finance.income
        : goal.isOverdue(now)
        ? context.finance.expense
        : theme.colorScheme.primary;

    final status = goal.isComplete
        ? l10n.goalComplete
        : goal.isOverdue(now)
        ? l10n.goalOverdue
        : l10n.suggestedMonthly(formatMoney(context, goal.suggestedMonthlyContribution(now)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ProgressRing(value: goal.progress, color: color, size: 72),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(l10n.savedOf(formatMoney(context, goal.saved), formatMoney(context, goal.target))),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.deadline}: ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(goal.deadline)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: goal.name,
              onSelected: (value) {
                if (value == 'add') _showContribution(context, goal);
                if (value == 'delete') context.read<GoalsCubit>().delete(goal.id);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'add', child: Text(l10n.addMoney)),
                PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final _amountFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

Future<void> _showContribution(BuildContext context, SavingsGoal goal) async {
  final l10n = context.l10n;
  final controller = TextEditingController();
  final cubit = context.read<GoalsCubit>();
  final amount = await showDialog<Money>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('${l10n.addMoney} · ${goal.name}'),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [_amountFormatter],
        decoration: InputDecoration(labelText: l10n.amount, prefixText: '₹ '),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, Money.tryParse(controller.text)),
          child: Text(l10n.save),
        ),
      ],
    ),
  );
  controller.dispose();
  if (amount != null) await cubit.contribute(goal.id, amount);
}

Future<void> _showGoalForm(BuildContext context) {
  final cubit = context.read<GoalsCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider.value(value: cubit, child: const _GoalForm()),
  );
}

class _GoalForm extends StatefulWidget {
  const _GoalForm();

  @override
  State<_GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<_GoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _saved = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 180));

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _saved.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<GoalsCubit>().create(
      name: _name.text,
      target: Money.tryParse(_target.text)!,
      saved: Money.tryParse(_saved.text) ?? const Money.zero(),
      deadline: _deadline,
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.newGoal, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.goalName),
              validator: (v) => (v ?? '').trim().isEmpty ? l10n.requiredField : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _target,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [_amountFormatter],
              decoration: InputDecoration(labelText: l10n.targetAmount, prefixText: '₹ '),
              validator: (v) => (Money.tryParse(v ?? '')?.isPositive ?? false) ? null : l10n.amountInvalid,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _saved,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [_amountFormatter],
              decoration: InputDecoration(labelText: l10n.savedSoFar, prefixText: '₹ '),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.event_outlined),
              label: Text(
                '${l10n.deadline}: ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_deadline)}',
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _deadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
                );
                if (picked != null) setState(() => _deadline = picked);
              },
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}
