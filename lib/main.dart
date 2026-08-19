import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/expense_app.dart';
import 'features/expenses/data/expense_repository.dart';
import 'features/expenses/presentation/providers/expense_providers.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    final expensesBox = await Hive.openBox<Map>(expensesBoxName);
    final settingsBox = await Hive.openBox<Map>(settingsBoxName);
    final authBox = await Hive.openBox<Map>(authBoxName);

    runApp(
      ProviderScope(
        overrides: [
          expenseBoxProvider.overrideWithValue(expensesBox),
          settingsBoxProvider.overrideWithValue(settingsBox),
          authBoxProvider.overrideWithValue(authBox),
        ],
        child: const ExpenseApp(),
      ),
    );
  } catch (error) {
    runApp(BootstrapErrorApp(error: error.toString()));
  }
}

class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 42),
                const SizedBox(height: 12),
                const Text('Failed to initialize local storage'),
                const SizedBox(height: 8),
                Text(error, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
