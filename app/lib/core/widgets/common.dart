import 'package:flutter/material.dart';

import '../money/money.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.icon, required this.message, super.key});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Amount coloured green for income and red for expenses.
class MoneyText extends StatelessWidget {
  const MoneyText(this.amount, {this.showSign = false, this.style, super.key});

  final Money amount;
  final bool showSign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.finance;
    final color = amount.isNegative ? colors.expense : (showSign ? colors.income : null);
    final sign = showSign && amount.isPositive ? '+' : (amount.isNegative ? '-' : '');
    final text = '$sign${formatMoney(context, amount.abs())}';
    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Circular progress with the percentage in the middle.
class ProgressRing extends StatelessWidget {
  const ProgressRing({required this.value, this.size = 64, this.strokeWidth = 7, this.color, this.label, super.key});

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;

  /// Shown in the middle instead of the percentage.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (value * 100).round();
    return Semantics(
      label: '$percent percent',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: color ?? theme.colorScheme.primary,
            ),
            Center(
              child: ExcludeSemantics(
                child: Text(
                  label ?? '$percent%',
                  style: (size > 80 ? theme.textTheme.headlineMedium : theme.textTheme.labelLarge)?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats with Indian digit grouping (12,34,567) in every app language.
String formatMoney(BuildContext context, Money amount, {bool compact = false}) {
  final language = Localizations.localeOf(context).languageCode;
  return amount.format(locale: language == 'en' ? 'en_IN' : '${language}_IN', compact: compact);
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}
