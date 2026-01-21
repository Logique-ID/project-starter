import 'package:flutter/foundation.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../flavor.dart';
import '../../monitoring/analytics_client.dart';

part 'mixpanel_analytics_client.g.dart';

class MixpanelAnalyticsClient implements AnalyticsClient {
  const MixpanelAnalyticsClient(this._mixpanel);
  final Mixpanel _mixpanel;

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    if (enabled) {
      _mixpanel.optInTracking();
    } else {
      _mixpanel.optOutTracking();
    }
  }

  @override
  Future<void> trackLogin() async {
    await _mixpanel.track('user_login');
  }

  ///TODO: Add other event tracking methods here
}

@Riverpod(keepAlive: true)
Future<MixpanelAnalyticsClient> mixpanelAnalyticsClient(Ref ref) async {
  final mixpanel = await Mixpanel.init(
    F.mixpanelToken,
    trackAutomaticEvents: true,
  );

  // Enable logging in debug mode for easier debugging
  if (kDebugMode) {
    mixpanel.setLoggingEnabled(true);
  }

  return MixpanelAnalyticsClient(mixpanel);
}
