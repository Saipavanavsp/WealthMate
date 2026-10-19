import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/money/money.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../domain/bill_reminder.dart';
import 'reminders_cubit.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reminders)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.newReminder,
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add_alert_outlined),
      ),
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          final now = DateTime.now();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            children: [
              if (kIsWeb)
                Card(
                  child: ListTile(leading: const Icon(Icons.info_outline), title: Text(l10n.remindersWebNote)),
                ),
              if (state.reminders.isEmpty)
                EmptyState(icon: Icons.notifications_none, message: l10n.noReminders)
              else
                for (final r in state.reminders) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      onLongPress: () => context.read<RemindersCubit>().delete(r),
                      leading: CircleAvatar(child: Text('${r.dayOfMonth}')),
                      title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${formatMoney(context, r.amount)} · ${l10n.dueIn(r.daysUntilDue(now))}',
                        style: r.daysUntilDue(now) <= 2 && r.enabled ? TextStyle(color: context.finance.warning) : null,
                      ),
                      trailing: Switch(value: r.enabled, onChanged: (_) => context.read<RemindersCubit>().toggle(r)),
                    ),
                  ),
                ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _showForm(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<RemindersCubit>();
    final title = TextEditingController();
    final amount = TextEditingController();
    var day = DateTime.now().day.clamp(1, 28);

    final reminder = await showDialog<BillReminder>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(l10n.newReminder),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.reminderTitle),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                decoration: InputDecoration(labelText: l10n.amount, prefixText: '₹ '),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: day,
                decoration: InputDecoration(labelText: l10n.dayOfMonth),
                items: [for (var d = 1; d <= 28; d++) DropdownMenuItem(value: d, child: Text('$d'))],
                onChanged: (v) => setState(() => day = v ?? day),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () {
                final money = Money.tryParse(amount.text);
                if (title.text.trim().isEmpty || money == null) return;
                Navigator.pop(dialogContext, BillReminder(title: title.text, amount: money, dayOfMonth: day));
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    title.dispose();
    amount.dispose();
    if (reminder != null) await cubit.save(reminder);
  }
}
