import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/routing/app_startup.dart';
import 'src/service/firebase/firebase_service.dart';

Future<void> initializeApp({required FirebaseOptions firebaseOptions}) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: firebaseOptions);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const AppStartupScreen(),
    ),
  );
}
