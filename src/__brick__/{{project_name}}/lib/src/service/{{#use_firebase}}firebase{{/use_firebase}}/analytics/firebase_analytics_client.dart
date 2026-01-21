import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../monitoring/analytics_client.dart';

part 'firebase_analytics_client.g.dart';

class FirebaseAnalyticsClient implements AnalyticsClient {
  const FirebaseAnalyticsClient(this._analytics);
  final FirebaseAnalytics _analytics;

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> trackLogin() async {
    await _analytics.logEvent(name: 'user_login');
  }

  ///TODO: Add other event tracking methods here
}

@Riverpod(keepAlive: true)
FirebaseAnalyticsClient firebaseAnalyticsClient(Ref ref) {
  return FirebaseAnalyticsClient(FirebaseAnalytics.instance);
}
