import 'package:flutter/material.dart';

import '../../features/insights/domain/analytics_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.spentText,
    required this.budgetText,
    required this.remainingText,
    required this.status,
    required this.progress,
  });

  final String spentText;
  final String budgetText;
  final String remainingText;
  final BudgetStatus status;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final statusMeta = switch (status) {
      BudgetStatus.underBudget => ('Under budget', AppColors.success),
      BudgetStatus.nearLimit => ('Near budget limit', AppColors.warning),
      BudgetStatus.exceeded => ('Budget exceeded', AppColors.error),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Budget', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  statusMeta.$1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusMeta.$2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Spent: $spentText'),
            Text('Limit: $budgetText'),
            Text('Remaining: $remainingText'),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              minHeight: 8,
              value: progress.clamp(0, 1).toDouble(),
              color: statusMeta.$2,
              backgroundColor: statusMeta.$2.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ),
      ),
    );
  }
}
