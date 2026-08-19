import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/expense.dart';
import '../providers/expense_providers.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/category_selector.dart';
import '../widgets/date_picker_field.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  const AddEditExpenseScreen({super.key, this.initialExpense});

  final Expense? initialExpense;

  @override
  ConsumerState<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  ExpenseCategory? _selectedCategory;
  late DateTime _selectedDate;
  bool _saving = false;

  bool get _isEditing => widget.initialExpense != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialExpense;
    _selectedDate = initial?.date ?? DateTime.now();
    _selectedCategory = initial?.category;
    if (initial != null) {
      _amountController.text = initial.amount.toStringAsFixed(2);
      _noteController.text = initial.note;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a category.')),
      );
      return;
    }

    final amount = double.parse(_amountController.text.trim());

    setState(() => _saving = true);
    try {
      final controller = ref.read(expensesControllerProvider.notifier);
      if (_isEditing) {
        await controller.update(
          original: widget.initialExpense!,
          amount: amount,
          category: _selectedCategory!,
          date: _selectedDate,
          note: _noteController.text,
        );
      } else {
        await controller.add(
          amount: amount,
          category: _selectedCategory!,
          date: _selectedDate,
          note: _noteController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Expense' : 'Add Expense')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmountInputField(controller: _amountController),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      CategorySelector(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      DatePickerField(value: _selectedDate, onPick: _pickDate),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _noteController,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 180,
                        decoration: const InputDecoration(
                          labelText: 'Note (optional)',
                          hintText: 'Quick detail for this expense',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: Text(_isEditing ? 'Save Changes' : 'Add Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
