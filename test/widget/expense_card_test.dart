import 'package:expense_tracker_app/core/widgets/expense_card.dart';
import 'package:expense_tracker_app/features/expenses/domain/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders expense card values', (tester) async {
    final expense = Expense(
      id: '1',
      amount: 42.5,
      category: ExpenseCategory.shopping,
      date: DateTime(2026, 3, 11),
      note: 'Shirt',
      createdAt: DateTime(2026, 3, 11),
      updatedAt: DateTime(2026, 3, 11),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpenseCard(expense: expense, currencySymbol: '\$'),
        ),
      ),
    );

    expect(find.text('Shopping'), findsAtLeastNWidgets(1));
    expect(find.textContaining('42.50'), findsOneWidget);
    expect(find.text('Shirt'), findsOneWidget);
  });
}
