import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/money/money.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../domain/algorithms/split_calculator.dart';
import '../domain/entities/group_entities.dart';
import 'groups_cubit.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<GroupDetailCubit, GroupDetailState>(
      listenWhen: (p, n) =>
          (n.failure != null && p.failure != n.failure) || (n.message != null && p.message != n.message),
      listener: (context, state) => showMessage(context, state.failure?.message ?? state.message!),
      builder: (context, state) {
        if (state.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final details = state.details;
        if (details == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.genericError)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(details.group.name),
            actions: [
              IconButton(
                tooltip: l10n.addMember,
                icon: const Icon(Icons.person_add_alt),
                onPressed: () => _addMember(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddExpense(context, details),
            icon: const Icon(Icons.add),
            label: Text(l10n.addExpense),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            children: [
              _TotalCard(details: details),
              SectionHeader(l10n.whoPaysWhom),
              _Transfers(details: details),
              SectionHeader(l10n.balances),
              _Balances(details: details),
              SectionHeader(l10n.groupExpenses),
              _Expenses(details: details),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addMember(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<GroupDetailCubit>();
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addMember),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.memberNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: Text(l10n.save)),
        ],
      ),
    );
    controller.dispose();
    if (name != null) await cubit.addMember(name);
  }

  Future<void> _showAddExpense(BuildContext context, GroupDetails details) {
    final cubit = context.read<GroupDetailCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddGroupExpenseSheet(members: details.members),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.details});

  final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.totalSpent),
                  Text(
                    formatMoney(context, details.totalSpent),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Chip(
              avatar: const Icon(Icons.people_outline, size: 18),
              label: Text(l10n.membersCount(details.members.length)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Transfers extends StatelessWidget {
  const _Transfers({required this.details});

  final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (details.transfers.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.check_circle, color: context.finance.income),
          title: Text(l10n.allSettled),
        ),
      );
    }
    return Card(
      child: Column(
        children: [
          for (final transfer in details.transfers)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.arrow_forward)),
              title: Text(l10n.paysTo(details.nameOf(transfer.from), details.nameOf(transfer.to))),
              subtitle: Text(
                formatMoney(context, Money(transfer.amountMinor)),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: TextButton(
                onPressed: () =>
                    context.read<GroupDetailCubit>().settle(transfer, confirmation: l10n.settlementRecorded),
                child: Text(l10n.markPaid),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(l10n.simplifiedHint, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _Balances extends StatelessWidget {
  const _Balances({required this.details});

  final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Column(
        children: [
          for (final member in details.members)
            Builder(
              builder: (context) {
                final balance = details.balances[member.id] ?? 0;
                final amount = formatMoney(context, Money(balance.abs()));
                final (text, color) = balance > 0
                    ? (l10n.getsBack(amount), context.finance.income)
                    : balance < 0
                    ? (l10n.owesAmount(amount), context.finance.expense)
                    : (l10n.settled, Theme.of(context).colorScheme.onSurfaceVariant);
                return ListTile(
                  leading: CircleAvatar(child: Text(member.name.characters.first.toUpperCase())),
                  title: Text(member.name),
                  trailing: Text(
                    text,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _Expenses extends StatelessWidget {
  const _Expenses({required this.details});

  final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    if (details.expenses.isEmpty) {
      return Padding(padding: const EdgeInsets.all(16), child: Text(context.l10n.noDataYet));
    }
    return Card(
      child: Column(
        children: [
          for (final expense in details.expenses)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.receipt_outlined)),
              title: Text(expense.description),
              subtitle: Text(
                '${context.l10n.paidBy} ${details.nameOf(expense.paidBy)} · ${DateFormat.MMMd(locale).format(expense.occurredAt)}',
              ),
              trailing: Text(formatMoney(context, expense.amount), style: const TextStyle(fontWeight: FontWeight.w600)),
              onLongPress: () => context.read<GroupDetailCubit>().deleteExpense(expense),
            ),
        ],
      ),
    );
  }
}

/// Bottom sheet for adding a shared expense, split equally or by shares.
class AddGroupExpenseSheet extends StatefulWidget {
  const AddGroupExpenseSheet({required this.members, super.key});

  final List<GroupMember> members;

  @override
  State<AddGroupExpenseSheet> createState() => _AddGroupExpenseSheetState();
}

class _AddGroupExpenseSheetState extends State<AddGroupExpenseSheet> {
  final _description = TextEditingController();
  final _amount = TextEditingController();
  late String _paidBy = widget.members.first.id;
  SplitType _splitType = SplitType.equal;

  /// memberId -> share weight. 0 excludes the member from the split.
  late final Map<String, int> _weights = {for (final m in widget.members) m.id: 1};

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Map<String, int>? _shares() {
    final amount = Money.tryParse(_amount.text);
    if (amount == null || !amount.isPositive) return null;
    final included = _weights.entries.where((e) => e.value > 0).toList();
    if (included.isEmpty) return null;
    return _splitType == SplitType.equal
        ? SplitCalculator.equal(amount, [for (final e in included) e.key])
        : SplitCalculator.byShares(amount, _weights);
  }

  Future<void> _save() async {
    final shares = _shares();
    final amount = Money.tryParse(_amount.text);
    if (shares == null || amount == null) {
      showMessage(context, context.l10n.amountInvalid);
      return;
    }
    final ok = await context.read<GroupDetailCubit>().addExpense(
      description: _description.text,
      amount: amount,
      paidBy: _paidBy,
      splitType: _splitType,
      shares: shares,
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preview = _shares();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addExpense, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.description),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: l10n.amount, prefixText: '₹ '),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _paidBy,
              decoration: InputDecoration(labelText: l10n.paidBy),
              items: [for (final m in widget.members) DropdownMenuItem(value: m.id, child: Text(m.name))],
              onChanged: (v) => setState(() => _paidBy = v ?? _paidBy),
            ),
            const SizedBox(height: 16),
            SegmentedButton<SplitType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: SplitType.equal, label: Text(l10n.splitEqually)),
                ButtonSegment(value: SplitType.custom, label: Text(l10n.splitByShares)),
              ],
              selected: {_splitType},
              onSelectionChanged: (s) => setState(() {
                _splitType = s.first;
                for (final id in _weights.keys) {
                  _weights[id] = _weights[id]! > 0 ? 1 : 0;
                }
              }),
            ),
            const SizedBox(height: 8),
            for (final m in widget.members)
              _MemberShareRow(
                name: m.name,
                weight: _weights[m.id]!,
                custom: _splitType == SplitType.custom,
                share: preview?[m.id],
                onChanged: (w) => setState(() => _weights[m.id] = w),
              ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}

class _MemberShareRow extends StatelessWidget {
  const _MemberShareRow({
    required this.name,
    required this.weight,
    required this.custom,
    required this.share,
    required this.onChanged,
  });

  final String name;
  final int weight;
  final bool custom;
  final int? share;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final shareText = share == null ? '' : formatMoney(context, Money(share!));
    if (!custom) {
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: weight > 0,
        title: Text(name),
        secondary: Text(shareText),
        onChanged: (v) => onChanged((v ?? false) ? 1 : 0),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name),
      subtitle: Text(shareText),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: '$name -1',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: weight > 0 ? () => onChanged(weight - 1) : null,
          ),
          SizedBox(width: 24, child: Text('$weight', textAlign: TextAlign.center)),
          IconButton(
            tooltip: '$name +1',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: weight < 20 ? () => onChanged(weight + 1) : null,
          ),
        ],
      ),
    );
  }
}
