import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

class HookHelper {
  static Future<void> runCommand(
    HookContext context, {
    required String command,
    required List<String> arguments,
  }) async {
    final projectName = context.vars['project_name'] as String;
    final directory = "${Directory.current.path}/$projectName";

    /// Run a command in the generated directory
    final process = context.logger.progress('Running $command $arguments');
    final result = await Process.run(
      command,
      arguments,
      workingDirectory: directory,
    );

    if (result.exitCode == 0) {
      process.complete('Successfully executed $command ${arguments.join(' ')}');
    } else {
      process.fail('Failed to execute $command ${arguments.join(' ')}');
      context.logger.err('Error: ${result.stderr}');
    }
  }

  /// Overwrites a file in the generated project directory.
  /// Automatically searches for [originalFileName] in the directory tree.
  static Future<void> overwriteFile(
    HookContext context, {
    required String sourcePath,
    required String originalFileName,
  }) async {
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      context.logger.err('Source file not found at: $sourcePath');
      return;
    }

    // Find target file in the generated output directory
    final projectName = context.vars['project_name'] as String;
    final projectDir =
        Directory(path.join(Directory.current.path, projectName));

    final targetFile = await _findFile(projectDir, originalFileName);

    if (targetFile == null) {
      context.logger.err(
        'Target file "$originalFileName" not found in generated project',
      );
      return;
    }

    try {
      await sourceFile.copy(targetFile.path);
      context.logger.success('Applied $originalFileName from: $sourcePath');
    } catch (e) {
      context.logger.err('Failed to copy $originalFileName: $e');
    }
  }

  /// Recursively searches for a file by name in the given directory.
  static Future<File?> _findFile(Directory dir, String fileName) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && path.basename(entity.path) == fileName) {
        return entity;
      }
    }
    return null;
  }

  /// Creates directory structure from app_id (e.g., com.dash.app → com/dash/app)
  /// and moves template files to the correct location
  static Future<void> createPackageDirectory(
    HookContext context, {
    required String appId,
    required String templateFileName,
    required String baseDir,
  }) async {
    final projectName = context.vars['project_name'] as String;
    final projectDir = path.join(Directory.current.path, projectName);

    // Convert app_id to directory path (com.dash.app → com/dash/app)
    final packagePath = appId.replaceAll('.', Platform.pathSeparator);
    final targetDir = path.join(projectDir, baseDir, packagePath);

    // Create the directory structure
    await Directory(targetDir).create(recursive: true);

    // Find and move the template file
    final templatesDir =
        Directory(path.join(projectDir, baseDir, '_templates'));
    final templateFile = File(path.join(templatesDir.path, templateFileName));

    if (await templateFile.exists()) {
      final targetFile = File(path.join(targetDir, templateFileName));
      await templateFile.copy(targetFile.path);
      await templateFile.delete();

      // Clean up _templates directory if empty
      if (await templatesDir.list().isEmpty) {
        await templatesDir.delete();
      }

      context.logger.success('Created $templateFileName at $packagePath');
    }
  }
}
