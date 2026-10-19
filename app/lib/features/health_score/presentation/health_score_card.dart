import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../domain/health_score_calculator.dart';

class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({required this.score, super.key});

  final HealthScore score;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final (bandLabel, color) = switch (score.band) {
      HealthBand.excellent => (l10n.healthExcellent, context.finance.income),
      HealthBand.good => (l10n.healthGood, theme.colorScheme.primary),
      HealthBand.fair => (l10n.healthFair, context.finance.warning),
      HealthBand.needsAttention => (l10n.healthNeedsAttention, context.finance.expense),
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // Hide the ExpansionTile dividers so it blends into the card.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const Key('health.card'),
          tilePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          leading: ProgressRing(value: score.score / 100, color: color, label: '${score.score}', size: 56),
          title: Text(l10n.healthScore, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          subtitle: Text(
            bandLabel,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.howCalculated, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            _ComponentRow(
              title: l10n.scoreSavingsTitle,
              component: score.savings,
              detail: score.savings.value == null
                  ? l10n.scoreSavingsNoData
                  : l10n.scoreSavingsDetail(_percent(score.savings.value!)),
            ),
            _ComponentRow(
              title: l10n.scoreTrendTitle,
              component: score.trend,
              detail: switch (score.trend.value) {
                null => l10n.scoreTrendNoData,
                final change when change > 0 => l10n.scoreTrendHigher(_percent(change)),
                final change => l10n.scoreTrendLower(_percent(change.abs())),
              },
            ),
            _ComponentRow(
              title: l10n.scoreGoalsTitle,
              component: score.goals,
              detail: score.goals.value == null
                  ? l10n.scoreGoalsNoData
                  : l10n.scoreGoalsDetail(_percent(score.goals.value!)),
            ),
          ],
        ),
      ),
    );
  }

  static String _percent(double v) => '${(v * 100).round()}%';
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({required this.title, required this.component, required this.detail});

  final String title;
  final ScoreComponent component;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text(context.l10n.points(component.points.toStringAsFixed(0), component.maxPoints)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: component.points / component.maxPoints,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 6),
          Text(detail, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
