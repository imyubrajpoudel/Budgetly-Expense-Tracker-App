import 'package:collection/collection.dart';

import '../../expenses/domain/expense.dart';
import 'analytics_models.dart';

class ExpenseAnalytics {
  static double total(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  static double totalForDay(List<Expense> expenses, DateTime day) {
    return expenses
        .where(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        )
        .fold(0, (sum, e) => sum + e.amount);
  }

  static double totalForMonth(List<Expense> expenses, DateTime month) {
    return expenses
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  static List<DailySummary> dailySummary(List<Expense> expenses) {
    final grouped = groupBy<Expense, DateTime>(
      expenses,
      (e) => DateTime(e.date.year, e.date.month, e.date.day),
    );
    final result =
        grouped.entries
            .map(
              (entry) => DailySummary(
                date: entry.key,
                total: entry.value.fold(0, (sum, e) => sum + e.amount),
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  static List<MonthlySummary> monthlySummary(List<Expense> expenses) {
    final grouped = groupBy<Expense, DateTime>(
      expenses,
      (e) => DateTime(e.date.year, e.date.month),
    );
    final result =
        grouped.entries
            .map(
              (entry) => MonthlySummary(
                month: entry.key,
                total: entry.value.fold(0, (sum, e) => sum + e.amount),
              ),
            )
            .toList()
          ..sort((a, b) => b.month.compareTo(a.month));
    return result;
  }

  static List<CategorySummary> categorySummary(List<Expense> expenses) {
    final grandTotal = total(expenses);
    final grouped = groupBy<Expense, ExpenseCategory>(
      expenses,
      (e) => e.category,
    );
    final result = grouped.entries.map((entry) {
      final categoryTotal = entry.value.fold(0.0, (sum, e) => sum + e.amount);
      final pct = grandTotal == 0 ? 0.0 : categoryTotal / grandTotal;
      return CategorySummary(
        category: entry.key,
        total: categoryTotal,
        percentage: pct,
      );
    }).toList()..sort((a, b) => b.total.compareTo(a.total));

    return result;
  }

  static BudgetStatus budgetStatus({
    required double monthlySpent,
    required double? budget,
  }) {
    if (budget == null || budget <= 0) {
      return BudgetStatus.underBudget;
    }
    final ratio = monthlySpent / budget;
    if (ratio > 1) {
      return BudgetStatus.exceeded;
    }
    if (ratio >= 0.90) {
      return BudgetStatus.nearLimit;
    }
    return BudgetStatus.underBudget;
  }
}
