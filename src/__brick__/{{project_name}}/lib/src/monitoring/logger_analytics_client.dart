import 'dart:async';
import 'dart:developer';

import 'analytics_client.dart';

class LoggerAnalyticsClient implements AnalyticsClient {
  const LoggerAnalyticsClient();

  static const _name = 'Event';

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    log('setAnalyticsCollectionEnabled($enabled)', name: _name);
  }

  @override
  Future<void> trackLogin() async {
    log('trackLogin', name: _name);
  }

  ///TODO: Add other event tracking methods here
}
