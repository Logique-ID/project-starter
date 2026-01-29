import 'dart:io';
import 'package:mason/mason.dart';

import 'helper.dart';
import 'package:path/path.dart' as path;

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

    // Run flutterfire config if use_firebase is true
    final useFirebase = context.vars['use_firebase'] as bool? ?? false;
    if (useFirebase) {
      /// Run flutterfire config
      await HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'dev'],
      );
      await HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'stg'],
      );
      await HookHelper.runCommand(
        context,
        command: 'sh',
        arguments: ['flutterfire-config.sh', 'prod'],
      );

      // Reorder FlutterFire build phases to ensure correct order
      await reorderFlutterFireBuildPhases(context);
    }
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

  /// Format code
  await HookHelper.runCommand(
    context,
    command: 'dart',
    arguments: ['format', '.'],
  );

  /// Remove feature brick
  await HookHelper.runCommand(
    context,
    command: 'mason',
    arguments: ['remove', '-g', 'feature'],
    withRollback: false,
  );

  /// Add feature brick
  await HookHelper.runCommand(
    context,
    command: 'mason',
    arguments: [
      'add',
      '-g',
      'feature',
      '--git-url',
      'https://github.com/Logique-ID/project-starter.git',
      '--git-path',
      'src_feature',
    ],
  );
}

// Reorder FlutterFire build phases to ensure correct order
Future<void> reorderFlutterFireBuildPhases(HookContext context) async {
  final projectName = context.vars['project_name'] as String?;
  if (projectName == null || projectName.isEmpty) {
    context.logger.warn('project_name not found in context');
    return;
  }

  final pbxprojPath = path.join(
    Directory.current.path,
    projectName,
    'ios',
    'Runner.xcodeproj',
    'project.pbxproj',
  );

  final file = File(pbxprojPath);
  if (!await file.exists()) {
    return;
  }

  final lines = await file.readAsLines();
  bool modified = false;

  const bundleServiceLiteral =
      '/* FlutterFire: "flutterfire bundle-service-file" */,';
  const uploadCrashlyticsLiteral =
      '/* FlutterFire: "flutterfire upload-crashlytics-symbols" */,';

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('buildPhases = (')) {
      int bundleIdx = -1;
      int uploadIdx = -1;

      // Scan within the buildPhases block
      int j = i + 1;
      while (j < lines.length && !lines[j].contains(');')) {
        if (lines[j].contains(bundleServiceLiteral)) bundleIdx = j;
        if (lines[j].contains(uploadCrashlyticsLiteral)) uploadIdx = j;
        j++;
      }

      // If both phases are found in the same target and in the wrong order, swap them
      if (bundleIdx != -1 && uploadIdx != -1 && bundleIdx > uploadIdx) {
        final temp = lines[bundleIdx];
        lines[bundleIdx] = lines[uploadIdx];
        lines[uploadIdx] = temp;
        modified = true;
      }

      // Move outer loop index to the end of this block
      i = j;
    }
  }

  if (modified) {
    await file.writeAsString(lines.join('\n'));
    context.logger
        .success('Reordered FlutterFire build phases in project.pbxproj');
  }
}
