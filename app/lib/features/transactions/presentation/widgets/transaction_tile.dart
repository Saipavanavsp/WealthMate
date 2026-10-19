import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/common.dart';
import '../../domain/entities/transaction_entry.dart';

/// Icon and colour for each category. Unknown categories get a neutral style.
abstract final class CategoryStyle {
  static const _styles = <String, (IconData, Color)>{
    'Food': (Icons.restaurant, Color(0xFFEA580C)),
    'Groceries': (Icons.local_grocery_store, Color(0xFF65A30D)),
    'Transport': (Icons.directions_car, Color(0xFF2563EB)),
    'Shopping': (Icons.shopping_bag, Color(0xFFDB2777)),
    'Bills': (Icons.receipt_long, Color(0xFF7C3AED)),
    'Rent': (Icons.home, Color(0xFF0891B2)),
    'Entertainment': (Icons.movie, Color(0xFFE11D48)),
    'Health': (Icons.favorite, Color(0xFFDC2626)),
    'Education': (Icons.school, Color(0xFF4F46E5)),
    'Travel': (Icons.flight, Color(0xFF0D9488)),
    'Investments': (Icons.trending_up, Color(0xFF059669)),
    'Salary': (Icons.payments, Color(0xFF16A34A)),
    'Freelance': (Icons.work, Color(0xFF0284C7)),
  };

  static IconData icon(String category) => _styles[category]?.$1 ?? Icons.category;

  static Color color(String category) => _styles[category]?.$2 ?? const Color(0xFF64748B);
}

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar(this.category, {super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    final color = CategoryStyle.color(category);
    return CircleAvatar(
      radius: 22,
      backgroundColor: color.withValues(alpha: 0.14),
      child: Icon(CategoryStyle.icon(category), color: color, size: 22, semanticLabel: category),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.entry, this.onTap, super.key});

  final TransactionEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final subtitle = [entry.category, DateFormat.MMMd(locale).format(entry.occurredAt)].join(' · ');

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CategoryAvatar(entry.category),
      title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        children: [
          Flexible(child: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (entry.isRecurring) ...[
            const SizedBox(width: 6),
            Icon(Icons.repeat, size: 14, semanticLabel: entry.recurrence.name),
          ],
        ],
      ),
      trailing: MoneyText(entry.signedAmount, showSign: true),
    );
  }
}
