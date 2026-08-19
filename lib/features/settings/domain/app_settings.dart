import 'package:flutter/material.dart';

enum ThemeModePreference { system, light, dark }

@immutable
class AppSettings {
  const AppSettings({
    required this.monthlyBudget,
    required this.currencySymbol,
    required this.themeModePreference,
    required this.themePreset,
  });

  final double? monthlyBudget;
  final String currencySymbol;
  final ThemeModePreference themeModePreference;
  final String themePreset;

  static const AppSettings defaults = AppSettings(
    monthlyBudget: null,
    currencySymbol: r'$',
    themeModePreference: ThemeModePreference.system,
    themePreset: 'amber',
  );

  ThemeMode get themeMode {
    switch (themeModePreference) {
      case ThemeModePreference.system:
        return ThemeMode.system;
      case ThemeModePreference.light:
        return ThemeMode.light;
      case ThemeModePreference.dark:
        return ThemeMode.dark;
    }
  }

  AppSettings copyWith({
    double? monthlyBudget,
    bool clearBudget = false,
    String? currencySymbol,
    ThemeModePreference? themeModePreference,
    String? themePreset,
  }) {
    return AppSettings(
      monthlyBudget: clearBudget ? null : (monthlyBudget ?? this.monthlyBudget),
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeModePreference: themeModePreference ?? this.themeModePreference,
      themePreset: themePreset ?? this.themePreset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyBudget': monthlyBudget,
      'currencySymbol': currencySymbol,
      'themeModePreference': themeModePreference.name,
      'themePreset': themePreset,
    };
  }

  factory AppSettings.fromJson(Map<dynamic, dynamic> json) {
    return AppSettings(
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble(),
      currencySymbol: (json['currencySymbol'] as String?) ?? r'$',
      themeModePreference: ThemeModePreference.values.byName(
        (json['themeModePreference'] as String?) ?? 'system',
      ),
      themePreset: (json['themePreset'] as String?) ?? 'indigo',
    );
  }
}
