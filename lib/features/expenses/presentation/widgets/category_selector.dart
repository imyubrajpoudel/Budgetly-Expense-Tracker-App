import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/expense.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ExpenseCategory? value;
  final ValueChanged<ExpenseCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: ExpenseCategory.values.map((category) {
        final selected = value == category;
        final color = AppColors.category(category);
        return ChoiceChip(
          label: Text(category.label),
          selected: selected,
          avatar: Icon(AppIcons.category(category), size: 18),
          onSelected: (_) => onChanged(category),
          selectedColor: color.withValues(alpha: 0.2),
        );
      }).toList(),
    );
  }
}
