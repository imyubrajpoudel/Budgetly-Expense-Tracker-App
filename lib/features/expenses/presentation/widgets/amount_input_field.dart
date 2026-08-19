import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  const AmountInputField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Amount', hintText: '0.00'),
      validator: (value) {
        final amount = double.tryParse((value ?? '').trim());
        if (amount == null || amount <= 0) {
          return 'Enter an amount greater than 0';
        }
        return null;
      },
    );
  }
}
