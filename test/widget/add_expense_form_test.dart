import 'package:expense_tracker_app/features/expenses/presentation/screens/add_edit_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows amount validation error on empty submit', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AddEditExpenseScreen())),
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Enter an amount greater than 0'), findsOneWidget);
  });
}
