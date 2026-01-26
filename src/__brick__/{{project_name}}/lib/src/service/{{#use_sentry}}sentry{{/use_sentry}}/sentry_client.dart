import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../flavor.dart';
import '../../monitoring/error_log/error_log_client.dart';

part 'sentry_client.g.dart';

class SentryClient implements ErrorLogClient {
  const SentryClient();

  @override
  Future<void> fatalError(dynamic error, StackTrace stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> flutterError(FlutterErrorDetails errorDetails) async {
    await Sentry.captureException(
      errorDetails.exception,
      stackTrace: errorDetails.stack,
    );
  }

  @override
  Future<void> nonFatalError(dynamic error, StackTrace stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}

@Riverpod(keepAlive: true)
Future<SentryClient> sentryClient(Ref ref) async {
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

  return const SentryClient();
}
