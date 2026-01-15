/// Configuration and patterns for template synchronization
class SyncConfig {
  /// Path to reference project
  static const String refPath = 'ref/project-starter-ref';

  /// Path to template directory
  static const String templatePath = 'src/__brick__/{{project_name}}';

  /// Reference project name (to be replaced with {{project_name}})
  static const String refProjectName = 'project-starter-ref';

  /// Reference app ID pattern (to be replaced with {{app_id}})
  static const String refAppId = 'id.logique.trial';

  /// Reference app name pattern (to be replaced with {{app_name}})
  static const String refAppName = 'Trial';

  /// Binary file extensions that should be copied directly
  static const List<String> binaryExtensions = [
    '.png',
    '.jpg',
    '.jpeg',
    '.gif',
    '.ico',
    '.svg',
    '.pdf',
    '.zip',
    '.jar',
    '.aar',
    '.so',
    '.dylib',
    '.dll',
    '.exe',
    '.ttf',
    '.otf',
    '.woff',
    '.woff2',
  ];

  /// Hardcoded whitelist: Specific files/folders by exact name that are always ignored
  /// These are checked first before pattern-based ignores
  /// Use exact names (case-sensitive), e.g., 'specific_file.dart' or 'folder_name/'
  static const List<String> whitelistIgnore = [
    /// general flutter
    '.git',
    '.specstory/',
    '.cursorindexingignore',
    '.cursorignore',
    '.cursor/rules/derived-cursor-rules.mdc',
    '.flutter-plugins-dependencies',

    /// android
    'android/app/src/main/kotlin/',
    'android/gradle/wrapper/gradle-wrapper.jar',
    'android/local.properties',
    'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',

    /// ios
    'ios/Flutter/',
    'ios/Runner/Assets.xcassets/devAppIcon.appiconset/',
    'ios/Runner/Assets.xcassets/LaunchImage.imageset/',
    'ios/Runner/Assets.xcassets/prodAppIcon.appiconset/',
    'ios/Runner/Assets.xcassets/stgAppIcon.appiconset/',
    'ios/Runner/Assets.xcassets/prodLaunchImage.imageset/',
    'ios/Runner/Assets.xcassets/stgLaunchImage.imageset/',
    'ios/Runner/Assets.xcassets/devLaunchImage.imageset/',
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/',
    'ios/Runner/Assets.xcassets/LaunchBackground.imageset/',
    'ios/Runner.xcworkspace/xcuserdata/',
    'ios/Runner.xcodeproj/project.xcworkspace/xcuserdata/',
    'ios/Podfile.lock',
    'ios/Runner/GeneratedPluginRegistrant.m',

    /// assets
    'app-icon.png',
    'app-icon-transparent.png',
    'app-splash.png',
    'app-icon-android.png',
    'app-icon-background.png',
    'app-icon-foreground.png',
    'icon_eye.svg',
    'icon_eye_slash.svg',
    'android/app/src/main/res/',

    /// dio
    'lib/src/utils/data_source_config/dio/',

    /// flavors
    'flavorizr.gradle.kts',

    /// firebase
    'flutterfire-config.sh',
    'firebase/',
    'google-services.json',
    'GoogleService-Info.plist',
    'firebase_options/',
    'firebase.json',

    /// localization
    'localization/',
    'localization_mixin.dart',
    'l10n.yaml',
    'untranslated_msg_list.txt',
  ];

  /// Files/directories to ignore during sync (pattern-based)
  static const List<String> ignorePatterns = [
    'build/',
    '.dart_tool/',
    '.idea/',
    '.vscode/',
    '.gradle/',
    'ios/Pods/',
    'ios/.symlinks/',
    'ios/Flutter/ephemeral/',
    'ios/Flutter/Flutter.framework/',
    'ios/Flutter/Flutter.podspec',
    '.DS_Store',
    '*.iml',
  ];

  /// Known Mason variable patterns for path mapping
  static const Map<String, String> variableMappings = {
    'project-starter-ref': '{{project_name}}',
    'id.logique.trial': '{{app_id}}',
    'Trial': '{{app_name}}',
  };

  /// Check if a file path should be ignored
  /// First checks whitelist (exact name match), then pattern-based ignores
  static bool shouldIgnore(String path) {
    // Check whitelist first (exact name match)
    for (final whitelistItem in whitelistIgnore) {
      if (_matchesWhitelist(path, whitelistItem)) {
        return true;
      }
    }

    // Then check pattern-based ignores
    return ignorePatterns.any((pattern) {
      if (pattern.endsWith('/')) {
        return path.contains(pattern);
      } else if (pattern.startsWith('*.')) {
        final ext = pattern.substring(1);
        return path.endsWith(ext);
      } else {
        return path.contains(pattern);
      }
    });
  }

  /// Check if a path matches a whitelist item (exact name match)
  /// Supports both files and folders
  static bool _matchesWhitelist(String path, String whitelistItem) {
    // Normalize path separators
    final normalizedPath = path.replaceAll('\\', '/');
    final normalizedItem = whitelistItem.replaceAll('\\', '/');

    // If whitelist item ends with '/', it's a folder - check if path contains this folder
    if (normalizedItem.endsWith('/')) {
      // Check if any path segment matches the folder name
      final folderName = normalizedItem.substring(0, normalizedItem.length - 1);
      final pathSegments = normalizedPath.split('/');
      return pathSegments.contains(folderName) ||
          normalizedPath.contains('/$folderName/') ||
          normalizedPath.startsWith('$folderName/') ||
          normalizedPath.endsWith('/$folderName');
    } else {
      // It's a file - check exact filename match
      final fileName = normalizedPath.split('/').last;
      return fileName == normalizedItem ||
          normalizedPath.endsWith('/$normalizedItem') ||
          normalizedPath == normalizedItem;
    }
  }

  /// Check if a file is binary based on extension
  static bool isBinaryFile(String path) {
    return binaryExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }
}
