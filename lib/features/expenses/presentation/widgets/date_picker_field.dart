import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({super.key, required this.value, required this.onPick});

  final DateTime value;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: const Icon(Icons.calendar_month_rounded),
      label: Text(Formatters.date(value)),
    );
  }
}
