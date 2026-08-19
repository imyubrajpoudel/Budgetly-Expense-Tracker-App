import 'package:flutter/material.dart';

import '../../features/expenses/domain/expense.dart';

class AppColors {
  static const Color brandIndigo = Color(0xFF4F46E5);
  static const Color accentTeal = Color(0xFF14B8A6);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightOutline = Color(0xFFE2E8F0);

  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkOutline = Color(0xFF334155);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Map<String, Color> presets = {
    'indigo': Color(0xFF4F46E5),
    'emerald': Color(0xFF059669),
    'rose': Color(0xFFE11D48),
    'amber': Color(0xFFD97706),
    'ocean': Color(0xFF0284C7),
    'violet': Color(0xFF7C3AED),
    'coral': Color(0xFFF43F5E),
    'slate': Color(0xFF475569),
  };

  static Color category(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return const Color(0xFFF97316);
      case ExpenseCategory.transport:
        return const Color(0xFF2563EB);
      case ExpenseCategory.shopping:
        return const Color(0xFF7C3AED);
      case ExpenseCategory.bills:
        return const Color(0xFFDC2626);
      case ExpenseCategory.health:
        return const Color(0xFF16A34A);
      case ExpenseCategory.entertainment:
        return const Color(0xFFDB2777);
      case ExpenseCategory.education:
        return const Color(0xFF0891B2);
      case ExpenseCategory.travel:
        return const Color(0xFF4338CA);
      case ExpenseCategory.other:
        return const Color(0xFF475569);
    }
  }
}
