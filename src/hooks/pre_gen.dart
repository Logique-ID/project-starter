import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Prepare project');

  final useFirebase = context.vars['use_firebase'] as bool? ?? false;
  if (useFirebase) {
    // Prompt for Firebase project ID
    final firebaseProjectId = context.logger.prompt(
      'Enter your Firebase project ID:',
      defaultValue: '',
    );
    context.vars['firebase_project_id'] = firebaseProjectId;
  }

  final useSentry = context.vars['use_sentry'] as bool? ?? false;
  if (useSentry) {
    // Prompt for Sentry DSN
    final sentryDsn = context.logger.prompt(
      'Enter your Sentry DSN:',
      defaultValue: '',
    );
    context.vars['sentry_dsn'] = sentryDsn;
  }

  // Check if custom_icon is true
  final customIcon = context.vars['custom_icon'] as bool? ?? false;
  if (customIcon) {
    // Prompt for custom app icon path
    final iconPath = context.logger.prompt(
      'Enter path to your custom app icon (or press Enter to skip)',
      defaultValue: '',
    );
    context.vars['app_icon_path'] = iconPath;
  }

  // Check if use_splash is true
  final useSplash = context.vars['use_splash'] as bool? ?? false;

  if (useSplash) {
    // Only prompt for app_splash_path if use_splash is true
    final splashPath = context.logger.prompt(
      'Enter path to your app splash (or press Enter to skip)',
      defaultValue: '',
    );
    context.vars['app_splash_path'] = splashPath;
  }

  progress.complete();
}
