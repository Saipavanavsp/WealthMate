import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/common.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/categories.dart';
import '../../domain/entities/transaction_entry.dart';
import '../bloc/transaction_form_cubit.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_tile.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({this.editingId, super.key});

  final String? editingId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<TransactionFormCubit, TransactionFormState>(
      listenWhen: (prev, next) => prev.status != next.status || (next.failure != null && prev.failure != next.failure),
      listener: (context, state) {
        if (state.status == FormStatus.saved) {
          showMessage(context, l10n.transactionSaved);
          context.pop();
        } else if (state.failure != null) {
          showMessage(context, state.failure!.message);
        }
      },
      buildWhen: (prev, next) => prev.id != next.id,
      builder: (context, state) {
        final waitingForLoad = editingId != null && state.id == null;
        return Scaffold(
          appBar: AppBar(
            title: Text(editingId == null ? l10n.addTransaction : l10n.editTransaction),
            actions: [
              if (state.isEditing)
                IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    context.read<TransactionsBloc>().add(TransactionDeleted(state.id!));
                    showMessage(context, l10n.transactionDeleted);
                    context.pop();
                  },
                ),
            ],
          ),
          body: waitingForLoad
              ? const Center(child: CircularProgressIndicator())
              : _Form(key: ValueKey(state.id), initial: state),
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.initial, super.key});

  final TransactionFormState initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<TransactionFormCubit>();

    return ListView(
      key: const Key('form.list'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        BlocSelector<TransactionFormCubit, TransactionFormState, TransactionType>(
          selector: (s) => s.type,
          builder: (context, type) => SegmentedButton<TransactionType>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text(l10n.expense),
                icon: const Icon(Icons.north_east),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text(l10n.incomeType),
                icon: const Icon(Icons.south_west),
              ),
            ],
            selected: {type},
            onSelectionChanged: (s) => cubit.typeChanged(s.first),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: const Key('form.amount'),
          initialValue: initial.amountText,
          autofocus: !initial.isEditing,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(labelText: l10n.amount, prefixText: '₹ '),
          onChanged: cubit.amountChanged,
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('form.merchant'),
          initialValue: initial.merchant,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.merchant, prefixIcon: const Icon(Icons.storefront_outlined)),
          onChanged: cubit.merchantChanged,
        ),
        const SizedBox(height: 20),
        const _CategoryPicker(),
        const SizedBox(height: 12),
        const _DateAndRepeat(),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: initial.note,
          maxLines: 2,
          decoration: InputDecoration(labelText: l10n.note, prefixIcon: const Icon(Icons.notes)),
          onChanged: cubit.noteChanged,
        ),
        const SizedBox(height: 28),
        BlocSelector<TransactionFormCubit, TransactionFormState, bool>(
          selector: (s) => s.canSave,
          builder: (context, canSave) =>
              FilledButton(key: const Key('form.save'), onPressed: canSave ? cubit.save : null, child: Text(l10n.save)),
        ),
      ],
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      buildWhen: (p, n) => p.category != n.category || p.type != n.type || p.categorySuggested != n.categorySuggested,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.category, style: Theme.of(context).textTheme.titleSmall),
            if (state.categorySuggested)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    Flexible(child: Text(l10n.suggestedCategory, style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in Categories.forType(state.type))
                  ChoiceChip(
                    avatar: Icon(CategoryStyle.icon(category), size: 18),
                    label: Text(category),
                    selected: category == state.category,
                    onSelected: (_) => context.read<TransactionFormCubit>().categoryChanged(category),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DateAndRepeat extends StatelessWidget {
  const _DateAndRepeat();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<TransactionFormCubit>();
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      buildWhen: (p, n) => p.occurredAt != n.occurredAt || p.recurrence != n.recurrence,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(state.occurredAt)),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: state.occurredAt,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    cubit.dateChanged(DateTime(picked.year, picked.month, picked.day, state.occurredAt.hour));
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<Recurrence>(
                initialValue: state.recurrence,
                decoration: InputDecoration(labelText: l10n.repeat),
                items: [
                  DropdownMenuItem(value: Recurrence.none, child: Text(l10n.repeatNone)),
                  DropdownMenuItem(value: Recurrence.weekly, child: Text(l10n.repeatWeekly)),
                  DropdownMenuItem(value: Recurrence.monthly, child: Text(l10n.repeatMonthly)),
                ],
                onChanged: (v) => cubit.recurrenceChanged(v ?? Recurrence.none),
              ),
            ),
          ],
        );
      },
    );
  }
}
