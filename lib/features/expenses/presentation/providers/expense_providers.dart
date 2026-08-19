import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../data/expense_repository.dart';
import '../../domain/expense.dart';

final expenseBoxProvider = Provider<Box<Map>>(
  (ref) => throw UnimplementedError('expenseBoxProvider must be overridden'),
);

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => HiveExpenseRepository(ref.watch(expenseBoxProvider)),
);

final expensesControllerProvider =
    StateNotifierProvider<ExpensesController, AsyncValue<List<Expense>>>(
      (ref) => ExpensesController(ref.watch(expenseRepositoryProvider)),
    );

class ExpensesController extends StateNotifier<AsyncValue<List<Expense>>> {
  ExpensesController(this._repository) : super(const AsyncValue.loading()) {
    _load();
    _subscription = _repository.watchAll().listen((expenses) {
      state = AsyncValue.data(expenses);
    });
  }

  final ExpenseRepository _repository;
  final _uuid = const Uuid();
  StreamSubscription<List<Expense>>? _subscription;

  Future<void> _load() async {
    try {
      final items = await _repository.getAll();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> add({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required String note,
  }) async {
    final now = DateTime.now();
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      date: date,
      note: note.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _repository.upsert(expense);
  }

  Future<void> update({
    required Expense original,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required String note,
  }) async {
    final updated = original.copyWith(
      amount: amount,
      category: category,
      date: date,
      note: note.trim(),
      updatedAt: DateTime.now(),
    );
    await _repository.upsert(updated);
  }

  Future<void> remove(String id) => _repository.delete(id);

  Future<void> clearAll() => _repository.clear();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
