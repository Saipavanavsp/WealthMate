import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/common.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_tile.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTransactions),
        actions: [
          IconButton(
            tooltip: l10n.analytics,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => context.push('/insights'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('transactions.add'),
        tooltip: l10n.addTransaction,
        onPressed: () => context.push('/transactions/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: BlocSelector<TransactionsBloc, TransactionsState, TransactionFilter>(
              selector: (state) => state.filter,
              builder: (context, filter) => SizedBox(
                width: double.infinity,
                child: SegmentedButton<TransactionFilter>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: TransactionFilter.all, label: Text(l10n.filterAll)),
                    ButtonSegment(value: TransactionFilter.expenses, label: Text(l10n.filterExpenses)),
                    ButtonSegment(value: TransactionFilter.income, label: Text(l10n.filterIncome)),
                  ],
                  selected: {filter},
                  onSelectionChanged: (s) => context.read<TransactionsBloc>().add(TransactionsFilterChanged(s.first)),
                ),
              ),
            ),
          ),
          const Expanded(child: _TransactionList()),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<TransactionsBloc, TransactionsState>(
      listenWhen: (prev, next) => next.failure != null && prev.failure != next.failure,
      listener: (context, state) => showMessage(context, state.failure!.message),
      // Rebuild only for data or filter changes, not for failure-only updates.
      buildWhen: (prev, next) => prev.status != next.status || prev.all != next.all || prev.filter != next.filter,
      builder: (context, state) {
        if (state.status == TransactionsStatus.loading) return const Center(child: CircularProgressIndicator());
        final items = state.visible;
        if (items.isEmpty) return EmptyState(icon: Icons.receipt_long_outlined, message: l10n.noTransactions);

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final entry = items[index];
            return Dismissible(
              key: ValueKey(entry.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                color: Theme.of(context).colorScheme.errorContainer,
                child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              confirmDismiss: (_) => _confirmDelete(context),
              onDismissed: (_) {
                context.read<TransactionsBloc>().add(TransactionDeleted(entry.id));
                showMessage(context, l10n.transactionDeleted);
              },
              child: TransactionTile(entry: entry, onTap: () => context.push('/transactions/${entry.id}')),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
