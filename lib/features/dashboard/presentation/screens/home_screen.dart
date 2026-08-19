import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/budget_progress_card.dart';
import '../../../../core/widgets/brand_app_bar_title.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/expense_card.dart';
import '../../../../core/widgets/summary_stat_card.dart';
import '../../../expenses/domain/expense.dart';
import '../../../expenses/presentation/screens/add_edit_expense_screen.dart';
import '../../../insights/domain/expense_analytics.dart';
import '../../../insights/presentation/providers/analytics_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

enum DashboardRangePreset { thisWeek, thisMonth, last30Days, allTime, custom }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DashboardRangePreset _selectedPreset = DashboardRangePreset.thisMonth;
  DateTimeRange? _customRange;

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final initial =
        _customRange ??
        DateTimeRange(
          start: DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 6)),
          end: DateTime(now.year, now.month, now.day),
        );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initial,
      helpText: 'Select date range',
    );

    if (picked != null) {
      setState(() {
        _customRange = picked;
        _selectedPreset = DashboardRangePreset.custom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseListProvider);
    final budgetStatus = ref.watch(budgetStatusProvider);
    final budgetProgress = ref.watch(budgetUsageProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final currency = settings?.currencySymbol ?? '\$';
    final now = DateTime.now();

    final activeRange = _resolveRange(now);
    final filteredExpenses = _filterExpenses(expenses, activeRange);
    final total = ExpenseAnalytics.total(filteredExpenses);
    final today = ExpenseAnalytics.totalForDay(filteredExpenses, now);
    final month = ExpenseAnalytics.totalForMonth(filteredExpenses, now);
    final categorySummary = ExpenseAnalytics.categorySummary(filteredExpenses);

    final budget = settings?.monthlyBudget;
    final remaining = (budget ?? 0) - month;

    return Scaffold(
      appBar: AppBar(title: const BrandAppBarTitle(sectionTitle: 'Dashboard')),
      body: expenses.isEmpty
          ? EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              title: 'No expenses yet',
              message:
                  'Your dashboard will show totals, category trends, and budget status once you add an expense.',
              action: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddEditExpenseScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add your first expense'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                _DateRangeFilterCard(
                  selectedPreset: _selectedPreset,
                  label: _rangeLabel(activeRange),
                  onPresetSelected: (preset) {
                    setState(() => _selectedPreset = preset);
                  },
                  onCustomTap: _pickCustomRange,
                ),
                const SizedBox(height: 12),
                if (filteredExpenses.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('No data in selected range'),
                          const SizedBox(height: 8),
                          Text(
                            'Try switching range or add expenses in this period.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.45,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    SummaryStatCard(
                      title: 'Total Spent',
                      value: Formatters.money(total, currency),
                      icon: Icons.payments_rounded,
                    ),
                    SummaryStatCard(
                      title: 'Today',
                      value: Formatters.money(today, currency),
                      icon: Icons.today_rounded,
                    ),
                    SummaryStatCard(
                      title: 'This Month',
                      value: Formatters.money(month, currency),
                      icon: Icons.calendar_month_rounded,
                    ),
                    SummaryStatCard(
                      title: 'Categories',
                      value: categorySummary.length.toString(),
                      icon: Icons.category_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BudgetProgressCard(
                  spentText: Formatters.money(month, currency),
                  budgetText: budget == null
                      ? AppStrings.noBudgetLabel
                      : Formatters.money(budget, currency),
                  remainingText: budget == null
                      ? '--'
                      : Formatters.money(remaining, currency),
                  status: budgetStatus,
                  progress: budgetProgress,
                ),
                const SizedBox(height: 12),
                Text(
                  'Category Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (categorySummary.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No category data available yet.'),
                    ),
                  )
                else
                  ...categorySummary
                      .take(4)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.pie_chart_rounded),
                              title: Text(item.category.label),
                              subtitle: Text(
                                '${(item.percentage * 100).toStringAsFixed(1)}%',
                              ),
                              trailing: Text(
                                Formatters.money(item.total, currency),
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                Text(
                  'Recent Expenses',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...filteredExpenses
                    .take(5)
                    .map(
                      (expense) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ExpenseCard(
                          expense: expense,
                          currencySymbol: currency,
                        ),
                      ),
                    ),
              ],
            ),
    );
  }

  DateTimeRange? _resolveRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    switch (_selectedPreset) {
      case DashboardRangePreset.thisWeek:
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: today);
      case DashboardRangePreset.thisMonth:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: today,
        );
      case DashboardRangePreset.last30Days:
        return DateTimeRange(
          start: today.subtract(const Duration(days: 29)),
          end: today,
        );
      case DashboardRangePreset.allTime:
        return null;
      case DashboardRangePreset.custom:
        return _customRange;
    }
  }

  List<Expense> _filterExpenses(List<Expense> expenses, DateTimeRange? range) {
    if (range == null) return expenses;
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
      999,
    );

    return expenses
        .where(
          (expense) =>
              !expense.date.isBefore(start) && !expense.date.isAfter(end),
        )
        .toList();
  }

  String _rangeLabel(DateTimeRange? range) {
    if (range == null) return 'All time';
    return '${Formatters.date(range.start)} - ${Formatters.date(range.end)}';
  }
}

class _DateRangeFilterCard extends StatelessWidget {
  const _DateRangeFilterCard({
    required this.selectedPreset,
    required this.label,
    required this.onPresetSelected,
    required this.onCustomTap,
  });

  final DashboardRangePreset selectedPreset;
  final String label;
  final ValueChanged<DashboardRangePreset> onPresetSelected;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Range', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _RangeChip(
                  label: 'This Week',
                  selected: selectedPreset == DashboardRangePreset.thisWeek,
                  onTap: () => onPresetSelected(DashboardRangePreset.thisWeek),
                ),
                _RangeChip(
                  label: 'This Month',
                  selected: selectedPreset == DashboardRangePreset.thisMonth,
                  onTap: () => onPresetSelected(DashboardRangePreset.thisMonth),
                ),
                _RangeChip(
                  label: 'Last 30 Days',
                  selected: selectedPreset == DashboardRangePreset.last30Days,
                  onTap: () =>
                      onPresetSelected(DashboardRangePreset.last30Days),
                ),
                _RangeChip(
                  label: 'All Time',
                  selected: selectedPreset == DashboardRangePreset.allTime,
                  onTap: () => onPresetSelected(DashboardRangePreset.allTime),
                ),
                _RangeChip(
                  label: 'Custom',
                  selected: selectedPreset == DashboardRangePreset.custom,
                  onTap: onCustomTap,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
