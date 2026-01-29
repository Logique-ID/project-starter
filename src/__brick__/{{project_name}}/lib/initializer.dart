{{#use_firebase}}import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';{{/use_firebase}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
{{#use_splash}}import 'package:flutter_native_splash/flutter_native_splash.dart';{{/use_splash}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/routing/app_startup.dart';
import 'src/monitoring/error_log/error_log_facade.dart';
{{#use_firebase}}{{^use_mixpanel}}import 'src/service/firebase/analytics/firebase_analytics_client.dart';{{/use_mixpanel}}
{{^use_sentry}}import 'src/service/firebase/crashlytics/firebase_crashlytics_client.dart';{{/use_sentry}}
import 'src/service/firebase/firebase_service.dart';{{/use_firebase}}
{{#use_mixpanel}}import 'src/service/mixpanel/mixpanel_analytics_client.dart';{{/use_mixpanel}}
{{#use_sentry}}import 'src/service/sentry/sentry_client.dart';{{/use_sentry}}
import 'src/service/freerasp/freerasp_service.dart';

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
  // Initialize Firebase Crashlytics
  final crashlytics = container.read(firebaseCrashlyticsClientProvider);
  await crashlytics.init();
  {{/use_sentry}}

  {{^use_mixpanel}}
  // Initialize Firebase Analytics
  final analytics = container.read(firebaseAnalyticsClientProvider);
  await analytics.setAnalyticsCollectionEnabled(kReleaseMode);
  {{/use_mixpanel}}

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  {{/use_firebase}}
  
  {{#use_sentry}}
  // Initialize Sentry
  await container.read(sentryClientProvider.future);
  {{/use_sentry}}

  {{#use_mixpanel}}
  // Initialize Mixpanel Analytics
  final mixpanelAnalytics = await container.read(
    mixpanelAnalyticsClientProvider.future,
  );
  await mixpanelAnalytics.setAnalyticsCollectionEnabled(kReleaseMode);
  {{/use_mixpanel}}

  // Initialize Error Log
  final errorLog = container.read(errorLogFacadeProvider);
  // Handle Flutter errors
  FlutterError.onError = errorLog.flutterError;
  // Pass all uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    errorLog.nonFatalError(error, stack);
    return true;
  };

  // Initialize freeRASP
  final freerasp = container.read(freeraspServiceProvider);
  await freerasp.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppStartupScreen(),
    ),
  );
}
