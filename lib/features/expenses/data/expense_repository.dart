import 'dart:async';

import 'package:hive/hive.dart';

import '../domain/expense.dart';

const String expensesBoxName = 'expenses_box';

abstract class ExpenseRepository {
  Future<List<Expense>> getAll();
  Stream<List<Expense>> watchAll();
  Future<void> upsert(Expense expense);
  Future<void> delete(String id);
  Future<void> clear();
}

class HiveExpenseRepository implements ExpenseRepository {
  HiveExpenseRepository(this.box);

  final Box<Map> box;

  @override
  Future<List<Expense>> getAll() async => _decode(box.values);

  @override
  Stream<List<Expense>> watchAll() {
    return box.watch().map((_) => _decode(box.values));
  }

  @override
  Future<void> upsert(Expense expense) async {
    await box.put(expense.id, expense.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  List<Expense> _decode(Iterable<Map> values) {
    final decoded = values.map(Expense.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return decoded;
  }
}
