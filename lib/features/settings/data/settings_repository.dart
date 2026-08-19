import 'package:hive/hive.dart';

import '../domain/app_settings.dart';

const String settingsBoxName = 'settings_box';
const String settingsKey = 'app_settings';

abstract class SettingsRepository {
  Future<AppSettings> get();
  Future<void> save(AppSettings settings);
}

class HiveSettingsRepository implements SettingsRepository {
  HiveSettingsRepository(this.box);

  final Box<Map> box;

  @override
  Future<AppSettings> get() async {
    final raw = box.get(settingsKey);
    if (raw == null) {
      return AppSettings.defaults;
    }
    return AppSettings.fromJson(raw);
  }

  @override
  Future<void> save(AppSettings settings) async {
    await box.put(settingsKey, settings.toJson());
  }
}
