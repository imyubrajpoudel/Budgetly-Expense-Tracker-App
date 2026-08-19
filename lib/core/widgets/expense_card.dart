import 'package:flutter/material.dart';

import '../../features/expenses/domain/expense.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';
import 'category_chip.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.currencySymbol,
    this.onTap,
    this.trailing,
  });

  final Expense expense;
  final String currencySymbol;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final note = expense.note.trim();
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(AppIcons.category(expense.category), size: 18),
        ),
        title: Row(
          children: [
            Expanded(child: Text(expense.category.label)),
            Text(
              Formatters.money(expense.amount, currencySymbol),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(Formatters.dayShort(expense.date)),
            const SizedBox(height: AppSpacing.xs),
            CategoryChip(category: expense.category, compact: true),
            if (note.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(note, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
        trailing: trailing,
      ),
    );
  }
}
