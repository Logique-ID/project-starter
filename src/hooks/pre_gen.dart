import 'package:mason/mason.dart';

import 'helper.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Prepare project');

  final useFirebase = context.vars['use_firebase'] as bool? ?? false;
  if (useFirebase) {
    HookHelper.validateRetriable(
      context,
      key: 'firebase_project_id',
      promptMessage: 'Enter your Firebase project ID:',
      errorMessage:
          'Firebase Project ID cannot be empty when Firebase is enabled.',
      infoMessage: 'Please enter a valid Firebase Project ID to continue.',
    );
  }

  final useSentry = context.vars['use_sentry'] as bool? ?? false;
  if (useSentry) {
    HookHelper.validateRetriable(
      context,
      key: 'sentry_dsn',
      promptMessage: 'Enter your Sentry DSN:',
      errorMessage: 'Sentry DSN cannot be empty when Sentry is enabled.',
      infoMessage: 'Please enter a valid Sentry DSN to continue.',
    );
  }

  final useMixpanel = context.vars['use_mixpanel'] as bool? ?? false;
  if (useMixpanel) {
    HookHelper.validateRetriable(
      context,
      key: 'mixpanel_token',
      promptMessage: 'Enter your Mixpanel token:',
      errorMessage: 'Mixpanel token cannot be empty when Mixpanel is enabled.',
      infoMessage: 'Please enter a valid Mixpanel token to continue.',
    );
  }

  // Check if custom_icon is true
  final customIcon = context.vars['custom_icon'] as bool? ?? false;
  if (customIcon) {
    String? iconPath = context.vars['app_icon_path'] as String?;
    // Prompt for custom app icon path
    if (iconPath == null || iconPath.isEmpty) {
      // Only prompt if not already provided
      iconPath = context.logger.prompt(
        'Enter path to your custom app icon (or press Enter to skip)',
        defaultValue: '',
      );
    }
    context.vars['app_icon_path'] = iconPath;
  }

  // Check if use_splash is true
  final useSplash = context.vars['use_splash'] as bool? ?? false;
  if (useSplash) {
    String? splashPath = context.vars['app_splash_path'] as String?;
    // Prompt for app splash path
    if (splashPath == null || splashPath.isEmpty) {
      // Only prompt if not already provided
      splashPath = context.logger.prompt(
        'Enter path to your app splash (or press Enter to skip)',
        defaultValue: '',
      );
    }
    context.vars['app_splash_path'] = splashPath;
  }

  progress.complete();
}
