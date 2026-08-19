import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_app_bar_title.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../domain/app_settings.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _budgetController = TextEditingController();
  final _currencyController = TextEditingController();
  String? _budgetDraft;
  String? _currencyDraft;

  @override
  void dispose() {
    _budgetController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final budgetText = settings.monthlyBudget?.toString() ?? '';
    if (_budgetController.text != budgetText) {
      _budgetController.text = budgetText;
    }
    if (_currencyController.text != settings.currencySymbol) {
      _currencyController.text = settings.currencySymbol;
    }

    return Scaffold(
      appBar: AppBar(title: const BrandAppBarTitle(sectionTitle: 'Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          TextFormField(
            controller: _budgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monthly budget',
              hintText: 'Leave empty to disable budget warning',
            ),
            onChanged: (value) => _budgetDraft = value,
            onFieldSubmitted: (_) => _saveBudget(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _currencyController,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    labelText: 'Currency symbol',
                    hintText: '\$',
                    counterText: '',
                  ),
                  onChanged: (value) => _currencyDraft = value,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(onPressed: _saveSettings, child: const Text('Save')),
            ],
          ),
          const SizedBox(height: 12),
          Text('Theme mode', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ThemeModePreference>(
            segments: const [
              ButtonSegment(
                value: ThemeModePreference.system,
                label: Text('System'),
              ),
              ButtonSegment(
                value: ThemeModePreference.light,
                label: Text('Light'),
              ),
              ButtonSegment(
                value: ThemeModePreference.dark,
                label: Text('Dark'),
              ),
            ],
            selected: {settings.themeModePreference},
            onSelectionChanged: (selection) {
              ref
                  .read(settingsControllerProvider.notifier)
                  .update(themeModePreference: selection.first);
            },
          ),
          const SizedBox(height: 12),
          Text('Accent preset', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppColors.presets.entries.map((entry) {
              final selected = entry.key == settings.themePreset;
              return ChoiceChip(
                label: Text(entry.key),
                selected: selected,
                onSelected: (_) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .update(themePreset: entry.key);
                },
                avatar: CircleAvatar(backgroundColor: entry.value, radius: 8),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _resetData,
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('Reset all local data'),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('About'),
              subtitle: Text(
                'Budgetly — Offline-first personal expense tracker for iOS and Android.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(isLoggedInProvider.notifier).state = false;
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBudget() async {
    await _saveSettings(clearBudgetWhenEmpty: true);
  }

  Future<void> _saveSettings({bool clearBudgetWhenEmpty = false}) async {
    final budgetValue = (_budgetDraft ?? _budgetController.text).trim();
    final parsedBudget = budgetValue.isEmpty ? null : double.tryParse(budgetValue);
    if (budgetValue.isNotEmpty && parsedBudget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid monthly budget.')),
      );
      return;
    }

    final currencyValue = (_currencyDraft ?? _currencyController.text).trim();
    final currentSettings =
        ref.read(settingsControllerProvider).valueOrNull ?? AppSettings.defaults;

    await ref.read(settingsControllerProvider.notifier).update(
          monthlyBudget: parsedBudget,
          clearBudget: clearBudgetWhenEmpty && budgetValue.isEmpty,
          currencySymbol:
              currencyValue.isEmpty ? currentSettings.currencySymbol : currencyValue,
        );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
          'This clears all expenses and restores default settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(expensesControllerProvider.notifier).clearAll();
    await ref
        .read(settingsControllerProvider.notifier)
        .save(AppSettings.defaults);
  }
}
