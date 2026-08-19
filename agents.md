## Project
**Personal Expense Note App**  
A clean, offline-first Flutter app for recording and managing personal expenses on **iOS and Android**.

---

## Mission for the coding agent

Build this application **end-to-end** in Flutter with production-quality structure, clear UI/UX, local persistence, and polished theming.  
The app must be:

- **Offline only**
- **Fast and lightweight**
- **Easy to use with one hand**
- **Visually modern and calm**
- **Compatible with iOS and Android**
- **Maintainable and scalable**
- **Ready to run after code generation with minimal manual fixes**

Do not produce a prototype or partial demo. Build a complete working application.

---

## Product summary

Users should be able to:

- Add a new expense
- Edit an expense
- Delete an expense
- Choose a category
- Enter amount, date, and short note
- View total expenses
- View daily summary
- View monthly summary
- View category-wise spending
- Receive a budget warning when spending crosses a limit
- Store all data locally on device
- Use the app with a simple and intuitive interface

No login, no cloud sync, no backend, no internet dependency.

---

## Core product principles

1. **Simplicity first**
   - The main flows must be obvious without explanation.
   - Users should be able to add an expense in a few taps.

2. **Excellent local-first experience**
   - All data must work fully offline.
   - App launch and CRUD operations should feel instant.

3. **Polished design**
   - Use a refined visual system with proper spacing, typography, elevation, and iconography.
   - Avoid overly playful, cluttered, or noisy UI.

4. **Theme control**
   - There must be a clearly defined place where the app’s theme can be controlled globally.
   - Colors, typography, corner radius, spacing tokens, and icon mapping should be centralized.

5. **Cross-platform quality**
   - Respect both Material patterns and mobile platform ergonomics.
   - Ensure safe areas, keyboard handling, date picker behavior, and touch target sizes work well on both iOS and Android.

---

## Technical requirements

### Framework
- Use **Flutter**
- Use current stable Flutter patterns
- Use **null safety**
- Keep codebase clean and idiomatic

### State management
Choose one modern, clean approach and use it consistently across the app.  
Preferred order:

1. **Riverpod**
2. Provider

Do not mix multiple state-management styles unless absolutely necessary.

### Local database
Use a local persistence solution suitable for structured offline data. Preferred order:

1. **Hive**
2. Isar
3. sqflite

Recommendation: **Hive** for simplicity and speed.

### Charts / summaries
For summary visuals, use a lightweight Flutter chart package only if it materially improves UX.  
If charts are added, keep them minimal and readable.  
If not, use elegant cards, progress bars, and grouped lists.

### Routing
Use a clean navigation setup. Small app navigation is acceptable with Navigator 2.0 abstraction or a simple named/typed routing approach.  
Do not over-engineer routing.

### Internationalization
Structure text so localization can be added later, even if only English is implemented initially.

---

## Target screens

Build these screens fully:

1. **Splash / startup flow**
   - Lightweight startup screen if needed
   - Initialize local storage and app settings

2. **Home / Dashboard**
   - Show:
     - total spending
     - today’s spending
     - current month spending
     - budget status
     - quick category breakdown
     - recent expenses
   - Include obvious CTA to add expense

3. **All Expenses screen**
   - Search/filter list of expenses
   - Group by date if helpful
   - Support edit and delete actions

4. **Add / Edit Expense screen**
   - Shared form for create and update
   - Fields:
     - amount
     - category
     - date
     - note
   - Strong validation and smooth UX

5. **Analytics / Summary screen**
   - Daily summary
   - Monthly summary
   - Category-wise spending
   - Date range support is a plus

6. **Settings screen**
   - Budget limit
   - Currency symbol / code
   - Theme mode
   - Theme preset / color seed
   - Optional reset data action
   - About section

---

## Information architecture

Recommended bottom navigation with 4 tabs:

- **Home**
- **Expenses**
- **Insights**
- **Settings**

Use a centered or floating add button where appropriate.  
Primary action of the app is **Add Expense**, so that action must always feel easy to reach.

---

## UX requirements

### General UX
- Keep flows short
- Avoid deep nesting
- Prefer cards, segmented filters, chips, bottom sheets, and well-spaced lists
- Provide empty states with helpful guidance
- Use confirmation for destructive deletion
- Support pull-to-refresh only if it makes sense for local state refresh; otherwise skip it

### Form UX
- Amount field should open numeric keyboard
- Category selection should be quick and visual
- Date selection should use a native-feeling date picker
- Note field should be optional but easy to fill
- Submit button should stay visible and accessible
- For edit flow, prefill all fields
- Validate:
  - amount > 0
  - category required
  - valid date required

### List UX
- Expense items should be highly readable
- Each item should show:
  - category icon
  - category name
  - amount
  - date
  - note preview if present
- Swipe actions are acceptable, but always provide an accessible alternative for edit/delete

### Summary UX
- Daily and monthly summaries should be immediately understandable
- Category breakdown should use color consistently
- Budget warning should be noticeable but not alarming or ugly

---

## Visual design direction

Design a **modern, elegant, calm finance UI**.

### Style keywords
- clean
- soft
- premium
- readable
- trustworthy
- uncluttered
- mobile-first

### Avoid
- overly saturated colors everywhere
- tiny text
- crowded cards
- harsh borders
- random gradients
- inconsistent icon usage
- too many accent colors at once

---

## Design system requirements

Create a centralized theme system.  
There must be a dedicated place from which the entire theme can be controlled.

### Required files or similar structure
Create a structure similar to:

```text
lib/
  core/
    theme/
      app_theme.dart
      app_colors.dart
      app_text_theme.dart
      app_spacing.dart
      app_radius.dart
      app_icons.dart
      theme_controller.dart
````

This must be the **single source of truth** for:

* light theme
* dark theme
* color palette
* semantic colors
* typography
* spacing scale
* corner radii
* icon choices
* component styles

### Theme controls

Expose app theme settings in a way that the developer can easily change:

* primary seed / brand color
* light mode palette
* dark mode palette
* card styling
* button styling
* input styling
* chart/category colors
* typography scale
* icon set mapping

Also provide a Settings UI for:

* System theme
* Light theme
* Dark theme
* Preferred accent preset

---

## Recommended color palette

Use tasteful, finance-friendly colors.

### Primary palette

* **Primary / Brand:** `#4F46E5` (indigo)
* **Primary container:** `#E0E7FF`
* **Accent / Support:** `#14B8A6` (teal)
* **Background light:** `#F8FAFC`
* **Surface light:** `#FFFFFF`
* **Text primary light:** `#0F172A`
* **Text secondary light:** `#475569`
* **Border / outline light:** `#E2E8F0`

### Dark palette

* **Background dark:** `#0B1220`
* **Surface dark:** `#111827`
* **Surface variant dark:** `#1F2937`
* **Text primary dark:** `#F8FAFC`
* **Text secondary dark:** `#CBD5E1`
* **Border / outline dark:** `#334155`

### Semantic colors

* **Success:** `#22C55E`
* **Warning:** `#F59E0B`
* **Error:** `#EF4444`
* **Info:** `#3B82F6`

### Category colors

Use a curated reusable set, for example:

* Food: orange
* Transport: blue
* Shopping: purple
* Bills: red
* Health: green
* Entertainment: pink
* Education: cyan
* Travel: indigo
* Other: slate

Do not make category colors neon or visually aggressive.

---

## Iconography

Use Material Symbols or standard Flutter Material icons consistently.

Recommended category icons:

* Food: `restaurant_rounded`
* Transport: `directions_car_rounded`
* Shopping: `shopping_bag_rounded`
* Bills: `receipt_long_rounded`
* Health: `health_and_safety_rounded`
* Entertainment: `movie_rounded`
* Education: `school_rounded`
* Travel: `flight_takeoff_rounded`
* Other: `category_rounded`

App-wide action icons:

* Add expense: `add_circle_rounded`
* Edit: `edit_rounded`
* Delete: `delete_rounded`
* Calendar/date: `calendar_month_rounded`
* Budget: `account_balance_wallet_rounded`
* Summary: `insights_rounded`
* Settings: `settings_rounded`

Centralize icon mapping in theme/design files instead of scattering icons throughout widgets.

---

## Data model

Create a proper expense entity.

Suggested fields:

```dart
class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

Category model:

```dart
enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  health,
  entertainment,
  education,
  travel,
  other,
}
```

Settings model should include at least:

```dart
class AppSettings {
  final double monthlyBudget;
  final String currencySymbol;
  final ThemeModePreference themeModePreference; // system, light, dark
  final String themePreset; // e.g. indigo, emerald, rose, amber
}
```

---

## Storage requirements

Persist all of the following locally:

* expense records
* app settings
* budget limit
* theme preference
* selected currency symbol/code

App must restore state correctly after restart.

Handle local storage initialization gracefully.
Do not lose data on hot restart or app relaunch.

---

## Business logic requirements

Implement the following calculations:

### Totals

* Total of all expenses
* Today’s total
* This month’s total

### Daily summary

* Aggregate expenses by day
* Sort descending by date by default

### Monthly summary

* Aggregate expenses by month
* Show current month prominently

### Category summary

* Sum all expenses per category
* Provide percentage contribution for each category if useful

### Budget warning

* Compare current month spending against budget
* Display:

  * safe state when below threshold
  * warning when near limit, for example >= 80%
  * exceeded state when above limit

Suggested statuses:

* Under budget
* Near budget limit
* Budget exceeded

---

## Architecture expectations

Use a clean, practical architecture. Do not overcomplicate.

Recommended layers:

```text
lib/
  core/
  features/
    expenses/
      data/
      domain/
      presentation/
    dashboard/
      presentation/
    insights/
      presentation/
    settings/
      data/
      presentation/
```

### Minimum architectural standards

* Separate models/entities from UI
* Keep widgets small and reusable
* Avoid putting calculation logic directly inside UI widgets
* Create providers/controllers/notifiers for app state
* Keep theme and constants centralized
* Add repositories/services for local persistence access

---

## Required reusable components

Create reusable widgets/components such as:

* expense card
* category chip / badge
* summary stat card
* budget progress card
* empty state widget
* confirm delete dialog
* amount input field
* category selector grid or bottom sheet
* date picker field
* app scaffold wrapper if useful

These should be polished and consistent.

---

## Accessibility and usability

The app must be comfortable for everyday use.

### Accessibility requirements

* Maintain readable contrast
* Support text scaling reasonably
* Minimum comfortable tap targets
* Avoid relying on color alone for status
* Provide labels/tooltips where helpful
* Ensure icons paired with text when needed

### Usability requirements

* Keyboard should not cover form actions
* Respect safe areas
* Support long notes gracefully
* Handle empty, loading, and error states cleanly
* Smooth scrolling and responsive layout

---

## Platform requirements

The app must run properly on:

* **Android**
* **iOS**

### Cross-platform expectations

* No platform-specific breakage
* Date pickers and dialogs should feel appropriate
* Test responsive layouts on small and large phones
* Ensure typography and padding are visually balanced on both platforms

If a plugin requires native setup, complete it properly.

---

## Implementation expectations

The coding agent should complete all of the following:

1. Initialize Flutter project structure
2. Add dependencies
3. Configure local database
4. Build centralized theming system
5. Implement settings persistence
6. Implement expense CRUD
7. Build dashboard
8. Build summaries and category breakdown
9. Add budget warning logic
10. Create polished reusable widgets
11. Ensure app works offline
12. Ensure Android and iOS compatibility
13. Add basic tests
14. Provide clear README with setup/run instructions

---

## Dependencies guidance

You may choose exact packages, but keep the dependency list lean.

Suggested package categories:

* state management: riverpod / flutter_riverpod
* local storage: hive, hive_flutter
* formatting: intl
* charts: optional lightweight chart package
* icons: standard material icons preferred
* uuid generation: uuid if needed

Do not add heavy or unnecessary packages.

---

## Code quality bar

Generate code that is:

* readable
* well-structured
* consistently named
* documented where necessary
* easy to extend

Also:

* avoid dead code
* avoid placeholder TODOs unless truly minor
* avoid giant widget files
* avoid duplicated styling values scattered across files
* avoid magic numbers without central tokens where appropriate

---

## Testing requirements

At minimum, include:

### Unit tests

* expense total calculation
* daily summary aggregation
* monthly summary aggregation
* category summary logic
* budget status logic

### Widget tests

* add expense form validation
* dashboard rendering with mock/local state
* expense list item rendering

Tests do not need to be excessive, but cover the core logic and core UI flows.

---

## Error handling

Handle common edge cases:

* empty expense list
* invalid amount
* zero or missing budget
* very long note
* deleting the last expense
* editing an old expense
* dark mode readability issues
* corrupted or unavailable local box initialization fallback where reasonable

Surface errors cleanly with snackbars, banners, or inline validation.

---

## Performance expectations

Even though the app is small, code should still be efficient.

* Avoid unnecessary rebuilds
* Use derived selectors/providers for computed summaries
* Keep lists efficient
* Avoid blocking UI during local initialization
* Do not recompute heavy summaries repeatedly if simple memoized/provider-based solutions can be used

---

## Empty states

Create thoughtful empty states for:

* no expenses yet
* no category data
* no daily/monthly summary data
* no search results

Each empty state should guide the user toward the next useful action.

---

## Budget UX guidance

Budget visibility should be present on Home and optionally Insights.

Recommended display:

* monthly budget amount
* spent amount
* remaining amount
* progress indicator
* status label:

  * Under budget
  * Near limit
  * Exceeded

Use semantic colors carefully:

* green for healthy
* amber for near limit
* red for exceeded

---

## Suggested default content behavior

On first launch:

* Set a sensible default monthly budget, or leave empty but clearly prompt user to set one
* Default theme should be **system**
* Default theme preset should be **indigo**
* Provide a polished empty dashboard instead of a blank app

---

## README requirements

Generate a `README.md` that includes:

* project overview
* features
* stack used
* folder structure
* setup instructions
* how local storage works
* how to run tests
* how to change the theme from the centralized theme files
* screenshots section placeholders if actual screenshots are not generated

---

## Delivery expectations

The coding agent should finish with:

* complete Flutter source code
* dependencies configured
* local storage wired up
* Android and iOS compatible implementation
* clean theming system
* working CRUD flows
* summaries and budget logic
* tests
* README

Do not stop after scaffolding.
Do not leave major screens unfinished.
Do not leave theme control half-implemented.

---

## Acceptance checklist

Before considering the task complete, verify:

* [ ] App builds successfully
* [ ] Works on Android
* [ ] Works on iOS
* [ ] Expense can be added
* [ ] Expense can be edited
* [ ] Expense can be deleted
* [ ] Expense data persists locally after app restart
* [ ] Home screen shows total, daily, and monthly spending
* [ ] Insights show daily, monthly, and category summaries
* [ ] Budget warning works correctly
* [ ] Theme can be controlled centrally in code
* [ ] Theme can be changed from settings
* [ ] UI is polished and consistent
* [ ] Empty states are handled
* [ ] Tests are included and pass
* [ ] README is included and useful

---

## Final instruction to the coding agent

Make thoughtful implementation decisions where needed, but always optimize for:

* clean architecture
* excellent mobile UX
* polished modern visuals
* maintainability
* offline reliability
* cross-platform compatibility
* centralized theme control

Build this like a small real product, not a classroom demo.