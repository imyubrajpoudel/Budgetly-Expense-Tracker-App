import 'package:flutter/material.dart';

import '../../features/expenses/domain/expense.dart';

class AppIcons {
  static const IconData addExpense = Icons.add_circle_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData calendar = Icons.calendar_month_rounded;
  static const IconData budget = Icons.account_balance_wallet_rounded;
  static const IconData insights = Icons.insights_rounded;
  static const IconData settings = Icons.settings_rounded;

  static IconData category(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.bills:
        return Icons.receipt_long_rounded;
      case ExpenseCategory.health:
        return Icons.health_and_safety_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.travel:
        return Icons.flight_takeoff_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }
}
