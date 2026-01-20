{{#use_firebase}}import 'package:firebase_core/firebase_core.dart';{{^use_sentry}}import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/use_sentry}}import 'package:firebase_messaging/firebase_messaging.dart';import 'package:flutter/foundation.dart';{{/use_firebase}}
import 'package:flutter/material.dart';
{{#use_splash}}import 'package:flutter_native_splash/flutter_native_splash.dart';{{/use_splash}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#use_sentry}}import 'package:sentry_flutter/sentry_flutter.dart';import 'flavor.dart';{{/use_sentry}}
import 'src/routing/app_startup.dart';
{{#use_firebase}}import 'src/service/firebase/firebase_service.dart';{{/use_firebase}}

Future<void> initializeApp({{#use_firebase}}{required FirebaseOptions firebaseOptions}{{/use_firebase}}) async {
  {{#use_splash}}
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  {{/use_splash}}
  
  {{^use_splash}}
  WidgetsFlutterBinding.ensureInitialized();
  {{/use_splash}}
  
  {{#use_sentry}}
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
  {{/use_sentry}}
  
  {{#use_firebase}}
  await Firebase.initializeApp(options: firebaseOptions);
  {{/use_firebase}}

  // Initialize Crashlytics
  FlutterError.onError = (errorDetails) {
    {{^use_sentry}}{{#use_firebase}}
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    {{/use_firebase}}{{/use_sentry}}
    
    {{#use_sentry}}
    Sentry.captureException(
      errorDetails.exception,
      stackTrace: errorDetails.stack,
    );
    {{/use_sentry}}
  };

  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    {{^use_sentry}}{{#use_firebase}}
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    {{/use_firebase}}{{/use_sentry}}
    
    {{#use_sentry}}
    Sentry.captureException(error, stackTrace: stack);
    {{/use_sentry}}
    return true;
  };

  {{#use_firebase}}{{^use_sentry}}
  // Enable Crashlytics collection only in non-debug builds
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    kReleaseMode,
  );{{/use_sentry}}
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  {{/use_firebase}}

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const AppStartupScreen(),
    ),
  );
}
