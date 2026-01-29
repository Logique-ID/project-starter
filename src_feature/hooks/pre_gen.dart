import 'package:mason/mason.dart';

void run(HookContext context) {
  // Update variables to be used in file templates
  context.vars['output_dir'] = 'lib/src/feature';
}
