import 'package:mason/mason.dart';

import 'helper.dart';

void run(HookContext context) async {
  // generate code
  await HookHelper.runCommand(
    context,
    command: 'flutter',
    arguments: [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
  );

  // format code
  await HookHelper.runCommand(
    context,
    command: 'dart',
    arguments: ['format', '.'],
  );
}
