import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../monitoring/error_log/error_log_client.dart';

part 'firebase_crashlytics_client.g.dart';

class FirebaseCrashlyticsClient implements ErrorLogClient {
  const FirebaseCrashlyticsClient(this._crashlytics);
  final FirebaseCrashlytics _crashlytics;

  Future<void> init() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
  }

  @override
  Future<void> fatalError(dynamic error, StackTrace stackTrace) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      fatal: true,
      printDetails: false,
    );
  }

  @override
  Future<void> flutterError(FlutterErrorDetails errorDetails) async {
    await _crashlytics.recordFlutterError(errorDetails);
  }

  @override
  Future<void> nonFatalError(dynamic error, StackTrace stackTrace) async {
    await _crashlytics.recordError(error, stackTrace, printDetails: false);
  }
}

@Riverpod(keepAlive: true)
FirebaseCrashlyticsClient firebaseCrashlyticsClient(Ref ref) {
  return FirebaseCrashlyticsClient(FirebaseCrashlytics.instance);
}
