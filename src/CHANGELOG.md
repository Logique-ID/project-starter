# 0.1.6

## Changes

### Bug Fixes
- **Enhanced Pre-Generation Prompts**: Improved user prompts for Firebase, Sentry, Mixpanel, and custom app icon paths to only request input when the corresponding feature is enabled
- **Improved Error Handling**: Enhanced error handling and user prompts in Firebase configuration script and hook helper methods
  - Better error messages for missing or invalid configuration
  - Improved fallback behavior when commands fail
  - Enhanced validation for user inputs

### Improvements
- **Pre-Generation Hook Refactoring**: Streamlined pre-generation logic to conditionally prompt only for enabled features
- **Helper Methods Enhancement**: Added comprehensive error handling and retry logic in hook helper methods

# 0.1.5

## Changes

### Improvements
- **Sentry Integration**: Added `use_sentry` template variable (default: `false`) to replace Firebase Crashlytics
  - Added `sentry_flutter` dependency conditionally in `pubspec.yaml`
  - Added Sentry initialization in `initializer.dart` when enabled
  - Updated Android `build.gradle.kts` to conditionally include Sentry configuration
  - Provides centralized error tracking with performance monitoring

- **Mixpanel Integration**: Added `use_mixpanel` template variable (default: `false`) to replace Firebase Analytics
  - Added `mixpanel` and `uuid` dependencies conditionally in `pubspec.yaml`
  - Added monitoring directory with conditional analytics clients:
    - `analytics_facade.dart` - Central analytics interface
    - `analytics_client.dart` - Base client interface
    - `firebase_analytics_client.dart` (conditional on `use_firebase` and `!use_mixpanel`)
    - `mixpanel_analytics_client.dart` (conditional on `use_mixpanel`)
    - `logger_analytics_client.dart` - Fallback/development logger
    - `logger_navigator_observer.dart` - Navigation logging
  - Updated `flutterfire-config.sh` for Firebase Analytics plist configuration

- **Project Infrastructure Updates**:
  - Added `.cursor/rules/derived-cursor-rules.mdc` for SpecStory/Cursor integration
  - Added `scripts/` directory with sync-template tools for reference-to-template synchronization
  - Added `ref/project-starter-ref` as Git submodule for reference Flutter project
  - Removed `pubspec.lock` from template to avoid dependency conflicts

# 0.1.4

## Changes

### Improvements
- **Conditional Dio Implementation**: Made Dio HTTP client optional based on `use_dio` template variable
  - Added `use_dio` template variable (default: `true`) to `brick.yaml`
  - Dio dependencies (`dio`, `alice_dio`, `alice`) are now conditionally included in `pubspec.yaml`
  - Dio configuration files moved to conditional directory structure using `{{#use_dio}}` template syntax
  - `dio_config.dart` - Dio instance configuration with interceptors, authentication, error handling
  - `dio_config.g.dart` - Generated Riverpod provider
  - `cancel_token_ref.dart` - Cancel token reference utility
  - `login_repository.dart` conditionally uses Dio for HTTP requests or throws `UnimplementedError` when disabled
  - `app_router.dart` conditionally uses Alice navigator key (for debugging inspector) or creates standard `GlobalKey<NavigatorState>` when disabled
  - When disabled, provides TODO comment suggesting alternative HTTP client implementations (e.g., http package, chopper)

# 0.1.3

## Changes

### Improvements
- **Conditional Localization Implementation**: Made localization optional based on `use_localization` template variable
  - Added `use_localization` template variable (default: `true`) to `brick.yaml`
  - Localization files moved to conditional directory structure using `{{#use_localization}}` template syntax
  - All localization files (ARB files, repository, providers, mixins) are conditionally generated
  - When disabled, provides `string_hardcoded.dart` extension as fallback for hardcoded strings
  - `flutter_localizations` dependency is conditionally included in `pubspec.yaml`
  - `l10n.yaml` configuration file is conditionally generated
  - `untranslated_msg_list.txt` is conditionally generated
  - Localization mixin (`localization_mixin.dart`) is conditionally included
  - `app.dart` conditionally includes localization delegates, locale configuration, and supported locales
  - Feature screens (login, home) conditionally use `LocalizationMixin` when enabled or `StringHardcoded` extension when disabled
  - `app_startup.dart` conditionally initializes localization repository

# 0.1.2

## Changes

### Improvements
- **Conditional Firebase Implementation**: Made Firebase integration optional based on `use_firebase` template variable
  - Added `use_firebase` template variable (default: `true`) to `brick.yaml`
  - Firebase dependencies (`firebase_core`, `firebase_messaging`) are now conditionally included in `pubspec.yaml`
  - Firebase initialization code is conditionally generated in `initializer.dart` and main entry files (`main_dev.dart`, `main_stg.dart`, `main_prod.dart`)
  - Firebase service files moved to conditional directory structure using `{{#use_firebase}}` template syntax
  - `flutterfire-config.sh` script is now conditionally generated
  - Pre-generation hook conditionally prompts for Firebase project ID only when `use_firebase` is enabled
  - Post-generation hook conditionally runs FlutterFire CLI configuration for all flavors
  - Removed hardcoded `firebase_options` files (now generated dynamically by FlutterFire CLI)
  - Android build configuration (`build.gradle.kts`, `settings.gradle.kts`) conditionally includes Firebase plugins
  - iOS Xcode project file (`project.pbxproj`) conditionally includes Firebase configuration
  - Notification service conditionally uses Firebase messaging

- **Android Studio Compatibility**: Added IDE configuration support for Android Studio

# 0.1.1

## Changes

### Improvements
- **Conditional Splash Screen**: Made splash screen implementation optional based on `use_splash` template variable
  - `flutter_native_splash` dependency and configuration are now conditionally included in `pubspec.yaml`
  - Splash screen initialization and removal code are conditionally generated in `initializer.dart` and `app_startup.dart`
  - Updated `use_splash` variable description and prompt in `brick.yaml` for clarity

# 0.1.0+1

Initial release of the Flutter Starter Brick.

## Features

### Core Architecture
- **Flavors**: Development (dev), Staging (stg), and Production (prod) environments with flutter_flavorizr
- **State Management**: Riverpod 3.0.3 with code generation (riverpod_generator)
- **Routing**: GoRouter 17.0.0 with shell route navigation
- **Local Database**: Sembast 3.8.5+2 with AES encryption support
- **HTTP Client**: Dio 5.9.0 with Alice debugging integration

### Firebase Integration
- Firebase Core 4.2.1
- Firebase Messaging 16.0.4
- Local notifications via flutter_local_notifications 19.5.0
- FlutterFire CLI auto-configuration for all flavors via shell script

### UI & Design
- Responsive design with Flutter ScreenUtil 5.9.3
- Custom launcher icons via flutter_launcher_icons 0.14.4 (iOS light/dark support)
- Optional native splash screen via flutter_native_splash 2.4.7 (Android 12+ support, conditionally included)
- Google Fonts 6.3.2
- SVG support via flutter_svg 2.2.2
- Material Design theming with custom color and text themes

### Forms & Validation
- flutter_form_builder 10.2.0
- form_builder_validators 11.2.0
- Pre-built custom text form field widget

### Localization
- English and Indonesian language support
- ARB-based localization with Flutter's built-in l10n
- Localization context extension for easy access

### Project Structure
- Feature-based architecture with data/domain/presentation layers
- Pre-configured common widgets (buttons, snackbar, async value widget)
- Core mixins for router, startup, localization, and connection listener
- Service layer for Firebase and notifications

### Development Tools
- Pre-configured VSCode settings and launch configurations for all flavors
- Cursor IDE rules for project structure, Dart conventions, Flutter UI patterns, Riverpod patterns, and routing
- Analysis options with flutter_lints 5.0.0
- Build runner 2.10.2 for code generation

### Mason Hooks
- **Pre-generation**: Prompts for Firebase project ID (if `use_firebase` is enabled), custom app icon path, and splash image path (if `use_splash` is enabled)
- **Post-generation**: 
  - Auto-creates Kotlin package directory structure from app_id
  - Runs FlutterFire CLI configuration for all flavors (if `use_firebase` is enabled)
  - Generates launcher icons from custom image
  - Creates native splash screen from custom image (if `use_splash` is enabled)

### Template Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Project name (snake_case) | `my_app` |
| `app_name` | Display name on device | `My App` |
| `app_id` | Bundle/application ID | `com.example.myapp` |
| `custom_icon` | Use custom app icon | `false` |
| `use_splash` | Use custom splash screen | `true` |
| `use_firebase` | Implement Firebase | `true` |
| `use_localization` | Implement localization | `true` |
| `use_dio` | Implement Dio with Alice debugging inspector | `true` |
| `use_sentry` | Implement Sentry (replaces Firebase Crashlytics) | `false` |
| `use_mixpanel` | Implement Mixpanel (replaces Firebase Analytics) | `false` |

### Included Feature Modules
- Authentication (auth repository with app user model)
- Login (complete with controller, state, and events)
- Main navigation with bottom nav bar (lazy load indexed stack)
- Home, Berita, Kegiatan, Laporan, FAQ subscreens

