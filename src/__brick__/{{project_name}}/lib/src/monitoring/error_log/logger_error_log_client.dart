import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'error_log_client.dart';

class LoggerErrorLogClient implements ErrorLogClient {
  const LoggerErrorLogClient();

  static const _fatalError = 'Fatal Error';
  static const _flutterError = 'Flutter Error';
  static const _nonFatalError = 'Non-Fatal Error';

  @override
  Future<void> fatalError(dynamic error, StackTrace stackTrace) async {
    log(error.toString(), name: _fatalError);
    log(stackTrace.toString(), name: _fatalError);
  }

  @override
  Future<void> flutterError(FlutterErrorDetails errorDetails) async {
    log(errorDetails.exception.toString(), name: _flutterError);
    log(errorDetails.stack.toString(), name: _flutterError);
  }

  @override
  Future<void> nonFatalError(dynamic error, StackTrace stackTrace) async {
    log(error.toString(), name: _nonFatalError);
    log(stackTrace.toString(), name: _nonFatalError);
  }
}
