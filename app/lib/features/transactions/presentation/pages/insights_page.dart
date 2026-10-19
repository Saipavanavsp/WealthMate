import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/money/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/analytics/spending_analytics.dart';
import '../bloc/analytics_cubit.dart';
import '../widgets/transaction_tile.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.analytics)),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              SegmentedButton<ChartPeriod>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: ChartPeriod.monthly, label: Text(l10n.monthly)),
                  ButtonSegment(value: ChartPeriod.weekly, label: Text(l10n.weekly)),
                ],
                selected: {state.period},
                onSelectionChanged: (s) => context.read<AnalyticsCubit>().periodChanged(s.first),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240,
                        child: _IncomeExpenseChart(bars: state.bars, period: state.period),
                      ),
                      const SizedBox(height: 8),
                      _Legend(),
                    ],
                  ),
                ),
              ),
              SectionHeader(l10n.spendingByCategory),
              if (state.summary.byCategory.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(l10n.noDataYet)),
                )
              else
                _CategoryBreakdown(totals: state.summary.byCategory),
            ],
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget dot(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dot(context.finance.income, l10n.income),
        const SizedBox(width: 20),
        dot(context.finance.expense, l10n.expenses),
      ],
    );
  }
}

class _IncomeExpenseChart extends StatelessWidget {
  const _IncomeExpenseChart({required this.bars, required this.period});

  final List<PeriodTotal> bars;
  final ChartPeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = context.finance;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final label = period == ChartPeriod.monthly ? DateFormat.MMM(locale) : DateFormat.Md(locale);
    final maxY = bars.fold<int>(0, (m, b) => max(m, max(b.incomeMinor, b.expenseMinor))) / 100;
    final top = maxY == 0 ? 100.0 : maxY * 1.15;

    final summary = bars
        .map(
          (b) => '${label.format(b.start)}: ${Money(b.incomeMinor).format()} in, ${Money(b.expenseMinor).format()} out',
        )
        .join('; ');

    return Semantics(
      label: summary,
      child: BarChart(
        BarChartData(
          maxY: top,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: top / 4,
            getDrawingHorizontalLine: (_) => FlLine(color: theme.colorScheme.outlineVariant, strokeWidth: 0.6),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: top / 4,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(Money((value * 100).round()).format(compact: true), style: theme.textTheme.labelSmall),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(label.format(bars[value.toInt()].start), style: theme.textTheme.labelSmall),
                ),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                Money((rod.toY * 100).round()).format(),
                TextStyle(color: theme.colorScheme.onInverseSurface, fontWeight: FontWeight.w600),
              ),
              getTooltipColor: (_) => theme.colorScheme.inverseSurface,
            ),
          ),
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].incomeMinor / 100,
                    color: colors.income,
                    width: period == ChartPeriod.monthly ? 12 : 8,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                  BarChartRodData(
                    toY: bars[i].expenseMinor / 100,
                    color: colors.expense,
                    width: period == ChartPeriod.monthly ? 12 : 8,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.totals});

  final List<CategoryTotal> totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ExcludeSemantics(
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 56,
                    sectionsSpace: 2,
                    sections: [
                      for (final t in totals)
                        PieChartSectionData(
                          value: t.amountMinor.toDouble(),
                          color: CategoryStyle.color(t.category),
                          radius: 36,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final t in totals)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: CategoryAvatar(t.category),
                title: Text(t.category),
                subtitle: LinearProgressIndicator(
                  value: t.share,
                  color: CategoryStyle.color(t.category),
                  borderRadius: BorderRadius.circular(4),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatMoney(context, Money(t.amountMinor)),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${(t.share * 100).toStringAsFixed(0)}%', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
