# Flutter Project Starter

A Mason brick for scaffolding production-ready Flutter projects with flavors, Firebase, Riverpod, and modern tooling.

## Overview

This repository contains a [Mason](https://github.com/felangel/mason) brick that generates a complete Flutter project structure with:

- **Multi-environment Flavors**: Development, Staging, and Production
- **State Management**: Riverpod 3.0.3 with code generation
- **Routing**: GoRouter 17.0.0 with type-safe routes
- **Local Database**: Sembast with encryption support
- **HTTP Client**: Dio with Alice debugging inspector (optional)
- **Firebase**: Core, Messaging, and FlutterFire CLI integration (optional)
- **Responsive Design**: Flutter ScreenUtil
- **Localization**: English and Indonesian (extensible, optional)
- **Form Handling**: Flutter Form Builder with validators
- **Custom Icons & Splash**: Automated generation via Flutter Launcher Icons and Native Splash (optional)

## Prerequisites

Before using this brick, ensure you have:

1. **Flutter SDK** (>= 3.38.0)
   ```bash
   flutter --version
   ```

2. **Mason CLI**
   ```bash
   dart pub global activate mason_cli
   ```

3. **FlutterFire CLI** (required only if `use_firebase` is enabled)
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. **Firebase CLI** (required only if `use_firebase` is enabled, must be logged in)
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

## Installation

Add directly from Git in your global mason configuration:

```bash
mason add starter --git-url https://github.com/Logique-ID/project-starter.git --git-path src --git-ref main
```

## Usage

### Generate a New Project

From the repository root (or anywhere if installed globally):

```bash
mason make starter
```

### Optional Features

The brick supports several optional features that can be enabled or disabled:

- **Firebase** (`use_firebase`): When enabled, includes Firebase Core, Messaging, and auto-configures FlutterFire CLI for all flavors. When disabled, Firebase dependencies and initialization code are excluded.
- **Localization** (`use_localization`): When enabled, includes ARB-based localization with English and Indonesian support. When disabled, provides a `StringHardcoded` extension for hardcoded strings.
- **Dio HTTP Client** (`use_dio`): When enabled, includes Dio with Alice debugging inspector for HTTP requests. When disabled, provides TODO comments suggesting alternative HTTP client implementations.
- **Splash Screen** (`use_splash`): When enabled, generates native splash screen configuration. When disabled, splash screen dependencies and initialization are excluded.

All optional features default to `true` for a complete setup, but can be disabled to create a minimal project structure.

### Interactive Prompts

The generator will ask for the following information:

| Prompt | Description | Default |
|--------|-------------|---------|
| `project_name` | Project name in snake_case (used in pubspec.yaml) | `my_app` |
| `app_name` | Display name shown on device | `My App` |
| `app_id` | Bundle/application ID (e.g., `com.company.myapp`) | `com.example.myapp` |
| `custom_icon` | Whether to use a custom app icon | `false` |
| `use_splash` | Implement native splash screen | `true` |
| `use_firebase` | Enable Firebase integration | `true` |
| `use_localization` | Enable localization support | `true` |
| `use_dio` | Enable Dio HTTP client with Alice debugging | `true` |
| `firebase_project_id` | Your Firebase project ID | (required if `use_firebase` is `true`) |

If you select custom options:
- **Custom Icon**: You'll be prompted for the path to your icon file (1024x1024 PNG recommended)
- **Splash Screen**: You'll be prompted for the path to your splash image (if `use_splash` is `true`)

### Non-Interactive Mode

You can also pass variables directly:

```bash
mason make starter \
  --project_name awesome_app \
  --app_name "Awesome App" \
  --app_id com.mycompany.awesomeapp \
  --custom_icon false \
  --use_splash true \
  --use_firebase true \
  --use_localization true \
  --use_dio true \
  --firebase_project_id your-firebase-project-id
```

## Generated Project Structure

```
your_project_name/
├── android/
│   └── app/src/
│       ├── dev/              # Dev flavor config
│       ├── stg/              # Staging flavor config
│       ├── prod/             # Production flavor config
│       └── main/
│           └── kotlin/<package>/ # Generated from app_id
│
├── ios/
│   ├── flavors/
│   │   ├── dev/              # GoogleService-Info.plist (dev, if use_firebase)
│   │   ├── stg/              # GoogleService-Info.plist (stg, if use_firebase)
│   │   └── prod/             # GoogleService-Info.plist (prod, if use_firebase)
│   └── Runner/
│
├── lib/
│   ├── firebase_options/     # Environment-specific Firebase options (if use_firebase)
│   │   ├── firebase_options_dev.dart
│   │   ├── firebase_options_stg.dart
│   │   └── firebase_options_prod.dart
│   ├── src/
│   │   ├── common_widget/    # Reusable UI components
│   │   ├── constant/         # App constants and error messages
│   │   ├── core/             # Core mixins and utilities
│   │   ├── feature/          # Feature modules (authentication, home, etc.)
│   │   ├── localization/     # L10n configuration and ARB files (if use_localization)
│   │   ├── routing/          # GoRouter configuration
│   │   ├── service/          # Firebase and notification services (if use_firebase)
│   │   ├── theme/            # App theming
│   │   └── utils/            # Utilities and data source config
│   │       ├── dio_config.dart      # Dio configuration (if use_dio)
│   │       └── cancel_token_ref.dart # Cancel token utility (if use_dio)
│   │
│   ├── flavor.dart           # Flavor enum and configuration
│   ├── initializer.dart      # App initialization logic
│   ├── main_dev.dart         # Development entry point
│   ├── main_stg.dart         # Staging entry point
│   └── main_prod.dart        # Production entry point
│
├── assets/
│   ├── android/              # Android-specific icons
│   ├── common/               # Shared assets (icons, splash)
│   └── icons/                # SVG icons
│
├── flutterfire-config.sh     # Firebase config script (if use_firebase)
├── pubspec.yaml
└── l10n.yaml                  # Localization config (if use_localization)
```

## Development

### Project Structure

```
project-starter/
├── src/
│   ├── __brick__/            # Template files (with Mustache variables)
│   │   └── {{project_name}}/
│   ├── hooks/
│   │   ├── pre_gen.dart      # Runs before generation (prompts)
│   │   ├── post_gen.dart     # Runs after generation (setup)
│   │   └── helper.dart       # Hook utilities
│   ├── brick.yaml            # Brick configuration
│   └── README.md             # Brick-specific readme
├── mason.yaml                # Local brick registry
└── README.md                 # This file
```

### Modifying the Brick

1. Edit template files in `src/__brick__/{{project_name}}/`
2. Update variables in `src/brick.yaml`
3. Modify hooks in `src/hooks/` for pre/post generation logic
4. Test changes:
   ```bash
   mason make starter --output-dir ./test_output
   ```

### Template Syntax

This brick uses [Mustache](https://mustache.github.io/) templating:

- `{{variable}}` - Variable substitution
- `{{#condition}}...{{/condition}}` - Conditional block (true)
- `{{^condition}}...{{/condition}}` - Inverted block (false)
- `{{#list}}...{{/list}}` - Iteration

## Troubleshooting

### Firebase Configuration Fails

If you enabled Firebase (`use_firebase: true`), ensure you're logged into Firebase CLI and the project ID is correct:

```bash
firebase projects:list
```

**Note**: If you don't need Firebase, set `use_firebase: false` to skip Firebase setup entirely.

### Android Build Fails with Package Not Found

The Kotlin directory structure should match your `app_id`. The brick creates this automatically, but verify:

```bash
ls android/app/src/main/kotlin/
# Should show: com/yourcompany/yourapp/MainActivity.kt
```

### iOS Build Fails

Ensure CocoaPods is up to date:

```bash
cd ios && pod install --repo-update
```

### Code Generation Issues

Clear build cache and regenerate:

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Resources

- [Mason Documentation](https://docs.brickhub.dev)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## License

This project is open source. See the LICENSE file for details.
