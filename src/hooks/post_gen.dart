import 'package:mason/mason.dart';

import 'helper.dart';

Future<void> run(HookContext context) async {
  // Create Kotlin package directory structure from app_id
  final appId = context.vars['app_id'] as String;
  if (appId.isNotEmpty) {
    await HookHelper.createPackageDirectory(
      context,
      appId: appId,
      templateFileName: 'MainActivity.kt',
      baseDir: 'android/app/src/main/kotlin',
    );

    /// Run flutterfire config
    await Future.wait([
      HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'dev'],
      ),
      HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'stg'],
      ),
      HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'prod'],
      ),
    ]);
  }

  // Apply custom app icon if provided
  final appIconPath = context.vars['app_icon_path'] as String?;
  if (appIconPath != null && appIconPath.isNotEmpty) {
    await Future.wait([
      /// Copy app-icon.png to assets/common/app-icon.png
      HookHelper.overwriteFile(
        context,
        sourcePath: appIconPath,
        originalFileName: 'app-icon.png',
      ),

      /// Copy app-icon.png to assets/common/app-icon-transparent.png
      HookHelper.overwriteFile(
        context,
        sourcePath: appIconPath,
        originalFileName: 'app-icon-transparent.png',
      ),

      /// Copy app-icon.png to assets/android/app-icon-android.png
      HookHelper.overwriteFile(
        context,
        sourcePath: appIconPath,
        originalFileName: 'app-icon-android.png',
      ),

      /// Copy app-icon.png to assets/android/app-icon-foreground.png
      HookHelper.overwriteFile(
        context,
        sourcePath: appIconPath,
        originalFileName: 'app-icon-foreground.png',
      ),
    ]);

    /// Generate launcher icons
    await HookHelper.runCommand(
      context,
      command: 'flutter',
      arguments: [
        'pub',
        'run',
        'flutter_launcher_icons:main',
        '-f',
        'pubspec.yaml'
      ],
    );
  }

  // Use app splash if provided
  final useSplash = context.vars['use_splash'] as bool? ?? false;
  if (useSplash) {
    // Apply custom app splash if provided
    final appSplashPath = context.vars['app_splash_path'] as String?;
    if (appSplashPath != null && appSplashPath.isNotEmpty) {
      /// Copy app-splash.png to assets/common/app-splash.png
      await HookHelper.overwriteFile(
        context,
        sourcePath: appSplashPath,
        originalFileName: 'app-splash.png',
      );

      /// Generate native splash
      await HookHelper.runCommand(
        context,
        command: 'flutter',
        arguments: ['pub', 'run', 'flutter_native_splash:create'],
      );
    }
  }
}
