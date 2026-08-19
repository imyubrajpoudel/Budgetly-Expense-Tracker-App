import 'package:expense_tracker_app/features/expenses/domain/expense.dart';
import 'package:expense_tracker_app/features/insights/domain/analytics_models.dart';
import 'package:expense_tracker_app/features/insights/domain/expense_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sample = [
    Expense(
      id: '1',
      amount: 100,
      category: ExpenseCategory.food,
      date: DateTime(2026, 3, 10),
      note: 'Lunch',
      createdAt: DateTime(2026, 3, 10),
      updatedAt: DateTime(2026, 3, 10),
    ),
    Expense(
      id: '2',
      amount: 40,
      category: ExpenseCategory.transport,
      date: DateTime(2026, 3, 10),
      note: 'Taxi',
      createdAt: DateTime(2026, 3, 10),
      updatedAt: DateTime(2026, 3, 10),
    ),
    Expense(
      id: '3',
      amount: 60,
      category: ExpenseCategory.food,
      date: DateTime(2026, 2, 28),
      note: 'Dinner',
      createdAt: DateTime(2026, 2, 28),
      updatedAt: DateTime(2026, 2, 28),
    ),
  ];

  test('calculates total expense', () {
    expect(ExpenseAnalytics.total(sample), 200);
  });

  test('aggregates daily summary descending', () {
    final daily = ExpenseAnalytics.dailySummary(sample);
    expect(daily.length, 2);
    expect(daily.first.total, 140);
    expect(daily.first.date, DateTime(2026, 3, 10));
  });

  test('aggregates monthly summary descending', () {
    final monthly = ExpenseAnalytics.monthlySummary(sample);
    expect(monthly.length, 2);
    expect(monthly.first.total, 140);
    expect(monthly.first.month, DateTime(2026, 3));
  });

  test('aggregates category summary with percentages', () {
    final categories = ExpenseAnalytics.categorySummary(sample);
    final food = categories.firstWhere(
      (entry) => entry.category == ExpenseCategory.food,
    );
    expect(food.total, 160);
    expect(food.percentage, closeTo(0.8, 0.0001));
  });

  test('budget status logic works', () {
    expect(
      ExpenseAnalytics.budgetStatus(monthlySpent: 50, budget: 100),
      BudgetStatus.underBudget,
    );
    expect(
      ExpenseAnalytics.budgetStatus(monthlySpent: 85, budget: 100),
      BudgetStatus.nearLimit,
    );
    expect(
      ExpenseAnalytics.budgetStatus(monthlySpent: 101, budget: 100),
      BudgetStatus.exceeded,
    );
  });
}
