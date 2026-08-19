import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../../core/widgets/brand_app_bar_title.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/expense_card.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/expense.dart';
import '../providers/expense_providers.dart';
import 'add_edit_expense_screen.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expensesControllerProvider);
    final currency =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ??
        '\$';

    return Scaffold(
      appBar: AppBar(title: const BrandAppBarTitle(sectionTitle: 'Expenses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: const InputDecoration(
                hintText: 'Search notes or categories',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (expenses) {
                final filtered = _applyFilter(expenses);
                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.receipt_long_rounded,
                    title: _query.isEmpty ? 'No expenses yet' : 'No results',
                    message: _query.isEmpty
                        ? 'Add your first expense to start tracking.'
                        : 'Try a different search term.',
                    action: _query.isEmpty
                        ? FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddEditExpenseScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Expense'),
                          )
                        : null,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemBuilder: (context, index) {
                    final expense = filtered[index];
                    return Dismissible(
                      key: ValueKey(expense.id),
                      background: const _SwipeActionBackground(
                        alignment: Alignment.centerLeft,
                        icon: Icons.edit_rounded,
                      ),
                      secondaryBackground: const _SwipeActionBackground(
                        alignment: Alignment.centerRight,
                        icon: Icons.delete_rounded,
                        destructive: true,
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditExpenseScreen(initialExpense: expense),
                            ),
                          );
                          return false;
                        }

                        final confirmed = await showConfirmDeleteDialog(
                          context,
                        );
                        if (confirmed) {
                          await ref
                              .read(expensesControllerProvider.notifier)
                              .remove(expense.id);
                        }
                        return false;
                      },
                      child: ExpenseCard(
                        expense: expense,
                        currencySymbol: currency,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditExpenseScreen(initialExpense: expense),
                            ),
                          );
                        },
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddEditExpenseScreen(
                                    initialExpense: expense,
                                  ),
                                ),
                              );
                            } else {
                              final confirmed = await showConfirmDeleteDialog(
                                context,
                              );
                              if (confirmed) {
                                await ref
                                    .read(expensesControllerProvider.notifier)
                                    .remove(expense.id);
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemCount: filtered.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Expense> _applyFilter(List<Expense> expenses) {
    if (_query.isEmpty) {
      return expenses;
    }
    final q = _query.toLowerCase();
    return expenses
        .where(
          (e) =>
              e.note.toLowerCase().contains(q) ||
              e.category.label.toLowerCase().contains(q),
        )
        .toList();
  }
}

class _SwipeActionBackground extends StatelessWidget {
  const _SwipeActionBackground({
    required this.alignment,
    required this.icon,
    this.destructive = false,
  });

  final Alignment alignment;
  final IconData icon;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: destructive ? Colors.red.shade600 : Colors.blueGrey.shade500,
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white),
    );
  }
}
