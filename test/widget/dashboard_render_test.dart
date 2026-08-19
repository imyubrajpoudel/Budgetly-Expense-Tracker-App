import 'package:expense_tracker_app/features/dashboard/presentation/screens/home_screen.dart';
import 'package:expense_tracker_app/features/expenses/domain/expense.dart';
import 'package:expense_tracker_app/features/insights/domain/analytics_models.dart';
import 'package:expense_tracker_app/features/insights/presentation/providers/analytics_providers.dart';
import 'package:expense_tracker_app/features/settings/data/settings_repository.dart';
import 'package:expense_tracker_app/features/settings/domain/app_settings.dart';
import 'package:expense_tracker_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders dashboard summary cards', (tester) async {
    final expenses = [
      Expense(
        id: '1',
        amount: 100,
        category: ExpenseCategory.food,
        date: DateTime.now(),
        note: 'Meal',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final fakeSettings = _FakeSettingsController(
      const AsyncValue.data(
        AppSettings(
          monthlyBudget: 500,
          currencySymbol: '\$',
          themeModePreference: ThemeModePreference.system,
          themePreset: 'indigo',
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith((ref) => fakeSettings),
          expenseListProvider.overrideWithValue(expenses),
          totalExpenseProvider.overrideWithValue(100),
          todayExpenseProvider.overrideWithValue(100),
          thisMonthExpenseProvider.overrideWithValue(100),
          categorySummaryProvider.overrideWithValue([
            CategorySummary(
              category: ExpenseCategory.food,
              total: 100,
              percentage: 1,
            ),
          ]),
          budgetStatusProvider.overrideWithValue(BudgetStatus.underBudget),
          budgetUsageProvider.overrideWithValue(0.2),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Total Spent'), findsOneWidget);
    expect(find.text('This Month'), findsAtLeastNWidgets(1));
  });
}

class _FakeSettingsController extends SettingsController {
  _FakeSettingsController(AsyncValue<AppSettings> initial)
    : super(_FakeSettingsRepository()) {
    state = initial;
  }
}

class _FakeSettingsRepository extends SettingsRepository {
  @override
  Future<AppSettings> get() async => AppSettings.defaults;

  @override
  Future<void> save(AppSettings settings) async {}
}
