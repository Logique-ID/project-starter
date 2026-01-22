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
    final process = _showProgress(
      context,
      message: 'Running $command $arguments',
    );
    final failureMessage = 'Failed to execute $command ${arguments.join(' ')}';

    final result = await Process.run(
      command,
      arguments,
      workingDirectory: directory,
    );

    /// Throw an exception if the command failed
    if (result.exitCode == 0) {
      process.complete('Successfully executed $command ${arguments.join(' ')}');
    } else {
      process.fail(failureMessage);
      await _rollback(context);
      throw MasonException(result.stderr.toString());
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
      _showError(context, message: 'Source file not found at: $sourcePath');
      return;
    }

    // Find target file in the generated output directory
    final projectName = context.vars['project_name'] as String;
    final projectDir =
        Directory(path.join(Directory.current.path, projectName));

    final targetFile = await _findFile(projectDir, originalFileName);

    if (targetFile == null) {
      _showError(context,
          message:
              'Target file "$originalFileName" not found in generated project');
      return;
    }

    try {
      await sourceFile.copy(targetFile.path);
      _showSuccess(context,
          message: 'Applied $originalFileName from: $sourcePath');
    } catch (e) {
      _showError(context, message: 'Failed to copy $originalFileName: $e');
    }
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

      _showSuccess(
        context,
        message: 'Created $templateFileName at $packagePath',
      );
    }
  }

  static void validateRetriable(
    HookContext context, {
    required String key,
    required String promptMessage,
    required String errorMessage,
    required String infoMessage,
  }) {
    String? value = context.vars[key] as String?;
    // Prompt with retry logic
    const maxAttempts = 2;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      value = _promptValue(
        context,
        key: key,
        promptMessage: promptMessage,
        defaultValue: '',
      );

      // If value is not empty, return
      if (value.trim().isNotEmpty) {
        context.vars[key] = value;
        return;
      }

      // Show error on first failed attempt
      if (attempt < maxAttempts) {
        _showError(context, message: errorMessage);
        _showInfo(context, message: infoMessage);
      }
    }

    // Final validation - throw if still empty after all attempts
    throw MasonException(
      '$errorMessage. Generation cancelled.',
    );
  }
}

Future<void> _rollback(HookContext context) async {
  final projectName = context.vars['project_name'] as String;
  final directory = "${Directory.current.path}/$projectName";

  /// Run a command in the generated directory
  final process = _showProgress(
    context,
    message: 'Rolling back project',
  );

  final result = await Process.run(
    'rm',
    ['-rf', directory],
    workingDirectory: directory,
  );

  if (result.exitCode == 0) {
    process.complete('Successfully rolled back project');
  } else {
    final failureMessage = 'Failed to roll back project';
    process.fail(failureMessage);
    throw MasonException('$failureMessage: ${result.stderr}');
  }
}

/// Recursively searches for a file by name in the given directory.
Future<File?> _findFile(Directory dir, String fileName) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && path.basename(entity.path) == fileName) {
      return entity;
    }
  }
  return null;
}

Progress _showProgress(
  HookContext context, {
  required String message,
}) =>
    context.logger.progress(message);

void _showInfo(
  HookContext context, {
  required String message,
}) =>
    context.logger.info(message);

void _showSuccess(
  HookContext context, {
  required String message,
}) =>
    context.logger.success(message);

void _showError(
  HookContext context, {
  required String message,
}) =>
    context.logger.err(message);

String _promptValue(
  HookContext context, {
  required String key,
  required String promptMessage,
  String defaultValue = '',
}) {
  String? value = context.vars[key] as String?;
  if (value == null || value.isEmpty) {
    value = context.logger.prompt(
      promptMessage,
      defaultValue: defaultValue,
    );
    context.vars[key] = value;
  }
  return value;
}
