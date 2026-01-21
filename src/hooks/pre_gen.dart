import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Prepare project');

  final useFirebase = context.vars['use_firebase'] as bool? ?? false;
  if (useFirebase) {
    String? firebaseProjectId = context.vars['firebase_project_id'] as String?;
    // Prompt for Firebase project ID
    if (firebaseProjectId == null || firebaseProjectId.isEmpty) {
      // Only prompt if not already provided
      firebaseProjectId = context.logger.prompt(
        'Enter your Firebase project ID:',
        defaultValue: '',
      );
    }
    context.vars['firebase_project_id'] = firebaseProjectId;
  }

  final useSentry = context.vars['use_sentry'] as bool? ?? false;
  if (useSentry) {
    String? sentryDsn = context.vars['sentry_dsn'] as String?;
    // Prompt for Sentry DSN
    if (sentryDsn == null || sentryDsn.isEmpty) {
      // Only prompt if not already provided
      sentryDsn = context.logger.prompt(
        'Enter your Sentry DSN:',
        defaultValue: '',
      );
    }
    context.vars['sentry_dsn'] = sentryDsn;
  }

  final useMixpanel = context.vars['use_mixpanel'] as bool? ?? false;
  if (useMixpanel) {
    String? mixpanelToken = context.vars['mixpanel_token'] as String?;
    // Prompt for Mixpanel token
    if (mixpanelToken == null || mixpanelToken.isEmpty) {
      // Only prompt if not already provided
      mixpanelToken = context.logger.prompt(
        'Enter your Mixpanel token:',
        defaultValue: '',
      );
    }
    context.vars['mixpanel_token'] = mixpanelToken;
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
