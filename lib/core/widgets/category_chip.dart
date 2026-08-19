import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../../features/expenses/domain/expense.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category, this.compact = false});

  final ExpenseCategory category;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.category(category);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.category(category), size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            category.label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
