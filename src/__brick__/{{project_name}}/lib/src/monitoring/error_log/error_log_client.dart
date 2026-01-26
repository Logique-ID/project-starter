import 'package:flutter/foundation.dart';

abstract class ErrorLogClient {
  Future<void> fatalError(dynamic error, StackTrace stackTrace);

  Future<void> flutterError(FlutterErrorDetails errorDetails);

  Future<void> nonFatalError(dynamic error, StackTrace stackTrace);
}
