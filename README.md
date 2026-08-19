# Expense Note (Flutter)

Offline-first personal expense tracker for iOS and Android with local persistence, budget alerts, and centralized theme control.

## Features

- Add, edit, and delete expenses
- Category-based expense tracking
- Amount, date, and optional note capture
- Dashboard totals: overall, today, and this month
- Insights: daily, monthly, and category summaries
- Budget status: under budget, near limit, exceeded
- Settings persistence:
	- Monthly budget
	- Currency symbol
	- Theme mode (system/light/dark)
	- Theme preset (indigo/emerald/rose/amber)
- Fully offline local storage with Hive

## Tech Stack

- Flutter (Material 3)
- Riverpod (`flutter_riverpod`) for state management
- Hive + hive_flutter for local storage
- intl for date/currency formatting
- uuid for id generation
- flutter_test for unit and widget tests

## Folder Structure

```text
lib/
	app/
		expense_app.dart
		navigation/
			main_shell.dart
	core/
		constants/
		theme/
			app_theme.dart
			app_colors.dart
			app_text_theme.dart
			app_spacing.dart
			app_radius.dart
			app_icons.dart
			theme_controller.dart
		utils/
		widgets/
	features/
		dashboard/
			presentation/screens/
		expenses/
			data/
			domain/
			presentation/providers/
			presentation/screens/
			presentation/widgets/
		insights/
			domain/
			presentation/providers/
			presentation/screens/
		settings/
			data/
			domain/
			presentation/providers/
			presentation/screens/
```

## Getting Started

### Prerequisites

- Flutter stable (tested with Flutter 3.41.x, Dart 3.11.x)
- Xcode (for iOS build)
- Android Studio / Android SDK (for Android build)

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

Run a specific target:

```bash
flutter run -d ios
flutter run -d android
```

## Local Storage Design

This app uses two Hive boxes:

- `expenses_box`: stores each expense record by id
- `settings_box`: stores app settings under a single key

Storage is initialized in app bootstrap (`lib/main.dart`) before the UI is rendered. Data persists across app restarts.

## Theme Customization

Centralized files under `lib/core/theme/` are the single source of truth.

- `app_colors.dart`: light/dark palette, semantic colors, category colors, presets
- `app_theme.dart`: ThemeData generation for light/dark
- `app_text_theme.dart`: typography scale
- `app_spacing.dart`: spacing tokens
- `app_radius.dart`: corner radius tokens
- `app_icons.dart`: app and category icon mapping
- `theme_controller.dart`: maps persisted settings to active theme mode and seed

To change app branding globally:

1. Update preset values in `app_colors.dart`
2. Adjust component styles in `app_theme.dart`
3. Update typography in `app_text_theme.dart`

## Running Tests

```bash
flutter test
```

### Included Test Coverage

- Unit tests:
	- Total aggregation
	- Daily summary aggregation
	- Monthly summary aggregation
	- Category summary percentages
	- Budget status logic
- Widget tests:
	- Add expense form validation
	- Dashboard render with mocked provider values
	- Expense card rendering

## Screenshots

Add screenshots here once captured:

- Home Dashboard: `docs/screenshots/home.png`
- Expenses List: `docs/screenshots/expenses.png`
- Add/Edit Expense: `docs/screenshots/add_edit.png`
- Insights: `docs/screenshots/insights.png`
- Settings: `docs/screenshots/settings.png`

## Notes

- The app is intentionally offline-only and does not require sign-in or network access.
- Budget can be left empty if the user does not want warning thresholds.
