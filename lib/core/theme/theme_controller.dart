import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_providers.dart';
import 'app_colors.dart';

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsControllerProvider).valueOrNull?.themeMode ??
      ThemeMode.system;
});

final appThemeSeedProvider = Provider<Color>((ref) {
  final preset =
      ref.watch(settingsControllerProvider).valueOrNull?.themePreset ??
      'amber';
  return AppColors.presets[preset] ?? AppColors.brandIndigo;
});
