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

### Included Feature Modules
- Authentication (auth repository with app user model)
- Login (complete with controller, state, and events)
- Main navigation with bottom nav bar (lazy load indexed stack)
- Home, Berita, Kegiatan, Laporan, FAQ subscreens

