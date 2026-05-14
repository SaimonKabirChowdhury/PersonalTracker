# PersonalTracker
# JARVIS Flutter Conversion

This workspace now contains a Flutter implementation of the original HTML app using a simple Provider architecture and separated layers.

## Architecture

- `lib/core/theme`: Design tokens and app theme.
- `lib/data/models`: Typed models for home/module content.
- `lib/data/repositories`: Repository with mapped static data from the HTML file.
- `lib/providers`: `ChangeNotifier` state for module navigation and mood selection.
- `lib/presentation/screens`: Home and module detail screens.
- `lib/presentation/widgets`: Reusable UI widgets.

## Main Behavior Ported

- Home dashboard with greeting, stats, vitals, and module grid.
- Module navigation (open and back flow similar to `goTo`/`goBack` in HTML).
- All 8 modules converted into structured data-driven screens.
- Mood selection state using Provider.

## Run

1. Make sure Flutter SDK is installed and available on your PATH.
2. Generate platform folders if needed:
   - `flutter create .`
3. Get dependencies:
   - `flutter pub get`
4. Run the app:
   - `flutter run`
