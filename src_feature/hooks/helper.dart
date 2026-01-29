import 'dart:io';

import 'package:mason/mason.dart';

/// A helper class for Mason hooks to perform common project generation tasks.
class HookHelper {
  /// Runs a command in the generated project directory.
  static Future<void> runCommand(
    HookContext context, {
    required String command,
    required List<String> arguments,
  }) async {
    final progress = _showProgress(
      context,
      message: 'Running $command ${arguments.join(' ')}',
    );

    try {
      final result = await Process.run(
        command,
        arguments,
        workingDirectory: Directory.current.path,
        runInShell: true, // Often needed for commands like 'flutter' on Windows
      );

      if (result.exitCode == 0) {
        progress
            .complete('Successfully executed $command ${arguments.join(' ')}');
      } else {
        progress.fail('Failed to execute $command ${arguments.join(' ')}');
        throw MasonException(result.stderr.toString());
      }
    } catch (e) {
      progress.fail('Error executing $command: $e');
      rethrow;
    }
  }

  /// Shows a progress message.
  static Progress _showProgress(HookContext context,
          {required String message}) =>
      context.logger.progress(message);
}
