import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

/// A helper class for Mason hooks to perform common project generation tasks.
class HookHelper {
  /// Runs a command in the generated project directory.
  static Future<void> runCommand(
    HookContext context, {
    required String command,
    required List<String> arguments,
  }) async {
    final projectName = context.vars['project_name'] as String;
    final directory = path.join(Directory.current.path, projectName);

    final progress = _showProgress(
      context,
      message: 'Running $command ${arguments.join(' ')}',
    );

    try {
      final result = await Process.run(
        command,
        arguments,
        workingDirectory: directory,
        runInShell: true, // Often needed for commands like 'flutter' on Windows
      );

      if (result.exitCode == 0) {
        progress
            .complete('Successfully executed $command ${arguments.join(' ')}');
      } else {
        progress.fail('Failed to execute $command ${arguments.join(' ')}');
        await rollback(context);
        throw MasonException(result.stderr.toString());
      }
    } catch (e) {
      progress.fail('Error executing $command: $e');
      await rollback(context);
      rethrow;
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

    final projectName = context.vars['project_name'] as String;
    final projectDir =
        Directory(path.join(Directory.current.path, projectName));

    final targetFile = await _findFile(projectDir, originalFileName);

    if (targetFile == null) {
      _showError(
        context,
        message:
            'Target file "$originalFileName" not found in generated project',
      );
      return;
    }

    try {
      await sourceFile.copy(targetFile.path);
      _showSuccess(
        context,
        message: 'Applied $originalFileName from: $sourcePath',
      );
    } catch (e) {
      _showError(context, message: 'Failed to copy $originalFileName: $e');
    }
  }

  /// Creates directory structure from app_id (e.g., com.dash.app → com/dash/app)
  /// and moves template files to the correct location.
  static Future<void> createPackageDirectory(
    HookContext context, {
    required String appId,
    required String templateFileName,
    required String baseDir,
  }) async {
    final projectName = context.vars['project_name'] as String;
    final projectDir = path.join(Directory.current.path, projectName);

    final packagePath = appId.replaceAll('.', path.separator);
    final targetDir = path.join(projectDir, baseDir, packagePath);

    await Directory(targetDir).create(recursive: true);

    final templatesDir =
        Directory(path.join(projectDir, baseDir, '_templates'));
    final templateFile = File(path.join(templatesDir.path, templateFileName));

    if (await templateFile.exists()) {
      final targetFile = File(path.join(targetDir, templateFileName));
      await templateFile.copy(targetFile.path);
      await templateFile.delete();

      // Clean up _templates directory if empty
      if (await templatesDir.exists() && (await templatesDir.list().isEmpty)) {
        await templatesDir.delete();
      }

      _showSuccess(
        context,
        message: 'Created $templateFileName at $packagePath',
      );
    }
  }

  /// Validates a variable with retry logic.
  static void validateRetriable(
    HookContext context, {
    required String key,
    required String promptMessage,
    required String errorMessage,
    required String infoMessage,
    bool validateSymbols = false,
  }) {
    String? value = context.vars[key] as String?;

    const maxAttempts = 3;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final isInvalid = value == null ||
          value.trim().isEmpty ||
          (validateSymbols && _hasInvalidSymbols(value));

      if (!isInvalid) {
        context.vars[key] = value.trim();
        return;
      }

      if (attempt < maxAttempts) {
        _showError(context, message: errorMessage);
        _showInfo(context, message: infoMessage);
        value = _promptValue(
          context,
          promptMessage: promptMessage,
          defaultValue: value ?? '',
        );
      }
    }

    throw MasonException('$errorMessage. Generation cancelled.');
  }

  /// Rolls back the project by deleting the generated directory.
  static Future<void> rollback(HookContext context) async {
    final projectName = context.vars['project_name'] as String?;
    if (projectName == null) return;

    final directory = Directory(path.join(Directory.current.path, projectName));

    final progress = _showProgress(context, message: 'Rolling back project');

    try {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        progress.complete('Successfully rolled back project');
      } else {
        progress.complete('Rollback skipped: Directory does not exist');
      }
    } catch (e) {
      progress.fail('Failed to roll back project: $e');
    }
  }

  /// Recursively searches for a file by name.
  static Future<File?> _findFile(Directory dir, String fileName) async {
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && path.basename(entity.path) == fileName) {
          return entity;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Shows a progress message.
  static Progress _showProgress(HookContext context,
          {required String message}) =>
      context.logger.progress(message);

  /// Shows an info message.
  static void _showInfo(HookContext context, {required String message}) =>
      context.logger.info(message);

  /// Shows a success message.
  static void _showSuccess(HookContext context, {required String message}) =>
      context.logger.success(message);

  /// Shows an error message.
  static void _showError(HookContext context, {required String message}) =>
      context.logger.err(message);

  /// Prompts the user for a value.
  static String _promptValue(
    HookContext context, {
    required String promptMessage,
    String defaultValue = '',
  }) {
    return context.logger.prompt(
      promptMessage,
      defaultValue: defaultValue,
    );
  }

  /// Checks if a string contains invalid symbols.
  static bool _hasInvalidSymbols(String value) {
    return RegExp(r'[^a-zA-Z0-9.]').hasMatch(value);
  }
}
