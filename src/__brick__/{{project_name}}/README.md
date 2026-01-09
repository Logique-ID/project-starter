# {{project_name}}

{{app_name}} - A Flutter application.

## Getting Started

This project was generated using the [Starter Mason Brick](https://github.com/felangel/mason).

### Prerequisites

- Flutter SDK ^3.38.0
- Dart SDK ^3.8.1

### Setup

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Generate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Configure Firebase (required):
   - Update `YOUR_FIREBASE_PROJECT_ID` in `flutterfire-config.sh` with your Firebase project ID
   - Run the configuration script for each flavor:
     ```bash
     ./flutterfire-config.sh dev
     ./flutterfire-config.sh stg
     ./flutterfire-config.sh prod
     ```

4. **Important**: Rename the Android Kotlin directory to match your app ID:
   - Move `android/app/src/main/kotlin/id/logique/trial/` to match your `app_id` structure
   - For example, if your app_id is `com.example.myapp`, rename to `android/app/src/main/kotlin/com/example/myapp/`

### Running the App

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor stg -t lib/main_stg.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

## Project Structure

- `lib/src/` - Main source code
  - `feature/` - Feature modules
  - `common_widget/` - Reusable widgets
  - `routing/` - GoRouter configuration
  - `theme/` - App theming
  - `localization/` - Localization files

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
