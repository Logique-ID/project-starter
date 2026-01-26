import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

{{#use_sentry}}import '../../service/sentry/sentry_client.dart';{{/use_sentry}}
{{^use_sentry}}{{#use_firebase}}import '../../service/firebase/crashlytics/firebase_crashlytics_client.dart';{{/use_firebase}}{{/use_sentry}}
import 'error_log_client.dart';
import 'logger_error_log_client.dart';

part 'error_log_facade.g.dart';

class ErrorLogFacade implements ErrorLogClient {
  const ErrorLogFacade(this.clients);
  final List<ErrorLogClient> clients;

  @override
  Future<void> fatalError(dynamic error, StackTrace stackTrace) =>
      _dispatch((c) => c.fatalError(error, stackTrace));

  @override
  Future<void> flutterError(FlutterErrorDetails errorDetails) =>
      _dispatch((c) => c.flutterError(errorDetails));

  @override
  Future<void> nonFatalError(dynamic error, StackTrace stackTrace) =>
      _dispatch((c) => c.nonFatalError(error, stackTrace));

  Future<void> _dispatch(
    Future<void> Function(ErrorLogClient client) work,
  ) async {
    await Future.wait(clients.map(work));
  }
}

@Riverpod(keepAlive: true)
ErrorLogFacade errorLogFacade(Ref ref) {
  {{#use_sentry}}final sentryClient = ref.watch(sentryClientProvider).requireValue;{{/use_sentry}}
  {{^use_sentry}}{{#use_firebase}}final firebaseCrashlyticsClient = ref.watch(firebaseCrashlyticsClientProvider);{{/use_firebase}}{{/use_sentry}}

  return ErrorLogFacade([
    {{#use_sentry}}sentryClient,{{/use_sentry}}
    {{^use_sentry}}{{#use_firebase}}firebaseCrashlyticsClient,{{/use_firebase}}{{/use_sentry}}
    if (kDebugMode) const LoggerErrorLogClient(),
  ]);
}
