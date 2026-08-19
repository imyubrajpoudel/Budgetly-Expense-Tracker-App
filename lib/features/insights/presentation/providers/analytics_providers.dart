import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../expenses/domain/expense.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/analytics_models.dart';
import '../../domain/expense_analytics.dart';

final expenseListProvider = Provider<List<Expense>>((ref) {
  return ref
      .watch(expensesControllerProvider)
      .maybeWhen(data: (value) => value, orElse: () => const []);
});

final totalExpenseProvider = Provider<double>((ref) {
  return ExpenseAnalytics.total(ref.watch(expenseListProvider));
});

final todayExpenseProvider = Provider<double>((ref) {
  return ExpenseAnalytics.totalForDay(
    ref.watch(expenseListProvider),
    DateTime.now(),
  );
});

final thisMonthExpenseProvider = Provider<double>((ref) {
  return ExpenseAnalytics.totalForMonth(
    ref.watch(expenseListProvider),
    DateTime.now(),
  );
});

final dailySummaryProvider = Provider<List<DailySummary>>((ref) {
  return ExpenseAnalytics.dailySummary(ref.watch(expenseListProvider));
});

final monthlySummaryProvider = Provider<List<MonthlySummary>>((ref) {
  return ExpenseAnalytics.monthlySummary(ref.watch(expenseListProvider));
});

final categorySummaryProvider = Provider<List<CategorySummary>>((ref) {
  return ExpenseAnalytics.categorySummary(ref.watch(expenseListProvider));
});

final budgetStatusProvider = Provider<BudgetStatus>((ref) {
  final monthlySpent = ref.watch(thisMonthExpenseProvider);
  final budget = ref
      .watch(settingsControllerProvider)
      .valueOrNull
      ?.monthlyBudget;
  return ExpenseAnalytics.budgetStatus(
    monthlySpent: monthlySpent,
    budget: budget,
  );
});

final budgetUsageProvider = Provider<double>((ref) {
  final monthlySpent = ref.watch(thisMonthExpenseProvider);
  final budget = ref
      .watch(settingsControllerProvider)
      .valueOrNull
      ?.monthlyBudget;
  if (budget == null || budget <= 0) {
    return 0;
  }
  return (monthlySpent / budget).clamp(0, 1.25);
});
