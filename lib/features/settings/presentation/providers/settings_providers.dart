import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/settings_repository.dart';
import '../../domain/app_settings.dart';

final settingsBoxProvider = Provider<Box<Map>>(
  (ref) => throw UnimplementedError('settingsBoxProvider must be overridden'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => HiveSettingsRepository(ref.watch(settingsBoxProvider)),
);

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>(
      (ref) => SettingsController(ref.watch(settingsRepositoryProvider)),
    );

class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsRepository _repository;

  Future<void> _load() async {
    try {
      state = AsyncValue.data(await _repository.get());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> save(AppSettings settings) async {
    await _repository.save(settings);
    state = AsyncValue.data(settings);
  }

  Future<void> update({
    double? monthlyBudget,
    bool clearBudget = false,
    String? currencySymbol,
    ThemeModePreference? themeModePreference,
    String? themePreset,
  }) async {
    final current = state.valueOrNull ?? AppSettings.defaults;
    final updated = current.copyWith(
      monthlyBudget: monthlyBudget,
      clearBudget: clearBudget,
      currencySymbol: currencySymbol,
      themeModePreference: themeModePreference,
      themePreset: themePreset,
    );
    await save(updated);
  }
}
