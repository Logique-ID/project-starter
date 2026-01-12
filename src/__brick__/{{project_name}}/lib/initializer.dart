{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
{{/use_firebase}}
import 'package:flutter/material.dart';
{{#use_splash}}
import 'package:flutter_native_splash/flutter_native_splash.dart';
{{/use_splash}}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/routing/app_startup.dart';
{{#use_firebase}}
import 'src/service/firebase/firebase_service.dart';
{{/use_firebase}}

Future<void> initializeApp({{#use_firebase}}{required FirebaseOptions firebaseOptions}{{/use_firebase}}) async {
  {{#use_splash}}
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  {{/use_splash}}
  {{^use_splash}}
  WidgetsFlutterBinding.ensureInitialized();
  {{/use_splash}}

  {{#use_firebase}}
  await Firebase.initializeApp(options: firebaseOptions);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  {{/use_firebase}}

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const AppStartupScreen(),
    ),
  );
}
