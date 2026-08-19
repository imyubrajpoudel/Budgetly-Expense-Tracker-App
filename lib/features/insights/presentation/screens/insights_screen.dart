import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/brand_app_bar_title.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../expenses/domain/expense.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/analytics_providers.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daily = ref.watch(dailySummaryProvider);
    final monthly = ref.watch(monthlySummaryProvider);
    final category = ref.watch(categorySummaryProvider);
    final currency =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ??
        '\$';

    if (daily.isEmpty && monthly.isEmpty && category.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.insights_outlined,
          title: 'No insights yet',
          message:
              'Add expenses to see daily, monthly, and category summaries.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const BrandAppBarTitle(sectionTitle: 'Insights')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          Text('Daily Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (daily.isEmpty)
            const _InlineEmpty(label: 'No daily data')
          else
            ...daily
                .take(14)
                .map(
                  (entry) => Card(
                    child: ListTile(
                      title: Text(Formatters.dayShort(entry.date)),
                      trailing: Text(Formatters.money(entry.total, currency)),
                    ),
                  ),
                ),
          const SizedBox(height: 12),
          Text(
            'Monthly Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (monthly.isEmpty)
            const _InlineEmpty(label: 'No monthly data')
          else
            ...monthly.map(
              (entry) => Card(
                child: ListTile(
                  title: Text(Formatters.monthYear(entry.month)),
                  trailing: Text(Formatters.money(entry.total, currency)),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Category Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (category.isEmpty)
            const _InlineEmpty(label: 'No category data')
          else
            ...category.map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.category.label),
                  subtitle: Text(
                    '${(entry.percentage * 100).toStringAsFixed(1)}% of spend',
                  ),
                  trailing: Text(Formatters.money(entry.total, currency)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(label)),
    );
  }
}
