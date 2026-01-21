{{#use_firebase}}import 'package:firebase_core/firebase_core.dart';
{{^use_sentry}}import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/use_sentry}}
import 'package:firebase_messaging/firebase_messaging.dart';
{{^use_sentry}}import 'package:flutter/foundation.dart';{{/use_sentry}}{{/use_firebase}}
{{#use_sentry}}import 'package:flutter/foundation.dart';{{/use_sentry}}
import 'package:flutter/material.dart';
{{#use_splash}}import 'package:flutter_native_splash/flutter_native_splash.dart';{{/use_splash}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#use_sentry}}import 'package:sentry_flutter/sentry_flutter.dart';import 'flavor.dart';{{/use_sentry}}
import 'src/routing/app_startup.dart';
{{#use_firebase}}{{^use_mixpanel}}import 'src/service/firebase/analytics/firebase_analytics_client.dart';{{/use_mixpanel}}
import 'src/service/firebase/firebase_service.dart';{{/use_firebase}}
{{#use_mixpanel}}import 'src/service/mixpanel/mixpanel_analytics_client.dart';{{/use_mixpanel}}

Future<void> initializeApp({{#use_firebase}}{required FirebaseOptions firebaseOptions}{{/use_firebase}}) async {
  final container = ProviderContainer();
  
  {{#use_splash}}
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  {{/use_splash}}
  
  {{^use_splash}}
  WidgetsFlutterBinding.ensureInitialized();
  {{/use_splash}}

  {{#use_firebase}}
  // Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);

  {{^use_sentry}}
  // Handle Flutter errors with Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Enable Crashlytics collection only in release builds
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    kReleaseMode,
  );
  {{/use_sentry}}

  {{^use_mixpanel}}
  // Initialize Firebase Analytics - explicitly enable
  final analytics = container.read(firebaseAnalyticsClientProvider);
  await analytics.setAnalyticsCollectionEnabled(true);
  {{/use_mixpanel}}

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  {{/use_firebase}}
  
  {{#use_sentry}}
  // Initialize Sentry
  await SentryFlutter.init((options) {
    options.dsn = F.sentryDsn;
    options.environment = F.appFlavor.name;
    options.beforeSend = (SentryEvent event, Hint hint) async {
      // Ignore events that are not from release builds
      if (kDebugMode) {
        return null;
      }
      // For all other events, return the event as is
      return event;
    };
  });

  // Handle Flutter errors with Sentry
  FlutterError.onError = (errorDetails) {
    Sentry.captureException(
      errorDetails.exception,
      stackTrace: errorDetails.stack,
    );
  };

  // Pass all uncaught asynchronous errors to Sentry
  PlatformDispatcher.instance.onError = (error, stack) {
    Sentry.captureException(error, stackTrace: stack);
    return true;
  };
  {{/use_sentry}}

  {{#use_mixpanel}}
  // * Preload MixpanelAnalyticsClient, so we can make unawaited analytics calls
  final mixpanelAnalytics = await container.read(
    mixpanelAnalyticsClientProvider.future,
  );
  await mixpanelAnalytics.setAnalyticsCollectionEnabled(true);
  {{/use_mixpanel}}

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppStartupScreen(),
    ),
  );
}
