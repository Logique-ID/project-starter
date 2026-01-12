# Flutter Project Starter

A Mason brick for scaffolding production-ready Flutter projects with flavors, Firebase, Riverpod, and modern tooling.

## Overview

This repository contains a [Mason](https://github.com/felangel/mason) brick that generates a complete Flutter project structure with:

- **Multi-environment Flavors**: Development, Staging, and Production
- **State Management**: Riverpod 3.0.3 with code generation
- **Routing**: GoRouter 17.0.0 with type-safe routes
- **Local Database**: Sembast with encryption support
- **HTTP Client**: Dio with Alice debugging inspector
- **Firebase**: Core, Messaging, and FlutterFire CLI integration
- **Responsive Design**: Flutter ScreenUtil
- **Localization**: English and Indonesian (extensible)
- **Form Handling**: Flutter Form Builder with validators
- **Custom Icons & Splash**: Automated generation via Flutter Launcher Icons and Native Splash

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

3. **FlutterFire CLI** (for Firebase configuration)
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. **Firebase CLI** (logged in with your account)
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

## Installation

Add directly from Git in your global mason configuration:

```bash
mason add starter --git-url <repository-url> --git-path src --git-ref <ref>
```

## Usage

### Generate a New Project

From the repository root (or anywhere if installed globally):

```bash
mason make starter
```

### Interactive Prompts

The generator will ask for the following information:

| Prompt | Description | Default |
|--------|-------------|---------|
| `project_name` | Project name in snake_case (used in pubspec.yaml) | `my_app` |
| `app_name` | Display name shown on device | `My App` |
| `app_id` | Bundle/application ID (e.g., `com.company.myapp`) | `com.example.myapp` |
| `custom_icon` | Whether to use a custom app icon | `false` |
| `use_splash` | Implement native splash screen | `true` |
| `firebase_project_id` | Your Firebase project ID | (required) |

If you select custom options:
- **Custom Icon**: You'll be prompted for the path to your icon file (1024x1024 PNG recommended)
- **Splash Screen**: You'll be prompted for the path to your splash image

### Non-Interactive Mode

You can also pass variables directly:

```bash
mason make starter \
  --project_name awesome_app \
  --app_name "Awesome App" \
  --app_id com.mycompany.awesomeapp \
  --custom_icon false \
  --use_splash true
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
│   │   ├── dev/              # GoogleService-Info.plist (dev)
│   │   ├── stg/              # GoogleService-Info.plist (stg)
│   │   └── prod/             # GoogleService-Info.plist (prod)
│   └── Runner/
│
├── lib/
│   ├── firebase_options/     # Environment-specific Firebase options
│   │   ├── firebase_options_dev.dart
│   │   ├── firebase_options_stg.dart
│   │   └── firebase_options_prod.dart
│   ├── src/
│   │   ├── common_widget/    # Reusable UI components
│   │   ├── constant/         # App constants and error messages
│   │   ├── core/             # Core mixins and utilities
│   │   ├── feature/          # Feature modules (authentication, home, etc.)
│   │   ├── localization/     # L10n configuration and ARB files
│   │   ├── routing/          # GoRouter configuration
│   │   ├── service/          # Firebase and notification services
│   │   ├── theme/            # App theming
│   │   └── utils/            # Utilities and data source config
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
├── flutterfire-config.sh     # Firebase config script (pre-configured)
├── pubspec.yaml
└── l10n.yaml
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

Ensure you're logged into Firebase CLI and the project ID is correct:

```bash
firebase projects:list
```

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
