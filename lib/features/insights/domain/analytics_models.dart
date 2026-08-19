import '../../expenses/domain/expense.dart';

enum BudgetStatus { underBudget, nearLimit, exceeded }

class DailySummary {
  DailySummary({required this.date, required this.total});

  final DateTime date;
  final double total;
}

class MonthlySummary {
  MonthlySummary({required this.month, required this.total});

  final DateTime month;
  final double total;
}

class CategorySummary {
  CategorySummary({
    required this.category,
    required this.total,
    required this.percentage,
  });

  final ExpenseCategory category;
  final double total;
  final double percentage;
}
