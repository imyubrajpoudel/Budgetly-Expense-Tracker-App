import 'package:expense_tracker_app/features/settings/data/settings_repository.dart';
import 'package:expense_tracker_app/features/settings/domain/app_settings.dart';
import 'package:expense_tracker_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:expense_tracker_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('saving settings persists budget and currency', (tester) async {
    final fakeRepository = _FakeSettingsRepository(
      initial: const AppSettings(
        monthlyBudget: 250,
        currencySymbol: 'USD',
        themeModePreference: ThemeModePreference.system,
        themePreset: 'indigo',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      '480',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'CAD',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = fakeRepository.lastSaved;
    expect(saved, isNotNull);
    expect(saved!.monthlyBudget, 480);
    expect(saved.currencySymbol, 'CAD');
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({required this.initial});

  AppSettings initial;
  AppSettings? lastSaved;

  @override
  Future<AppSettings> get() async => initial;

  @override
  Future<void> save(AppSettings settings) async {
    lastSaved = settings;
    initial = settings;
  }
}