import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

{{#use_firebase}}import '../service/firebase/analytics/firebase_analytics_client.dart';{{/use_firebase}}
{{#use_mixpanel}}import '../service/mixpanel/mixpanel_analytics_client.dart';{{/use_mixpanel}}
import 'analytics_client.dart';
import 'logger_analytics_client.dart';

part 'analytics_facade.g.dart';

class AnalyticsFacade implements AnalyticsClient {
  const AnalyticsFacade(this.clients);
  final List<AnalyticsClient> clients;

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) =>
      _dispatch((c) => c.setAnalyticsCollectionEnabled(enabled));

  @override
  Future<void> trackLogin() => _dispatch((c) => c.trackLogin());

  ///TODO: Add other event tracking methods here

  Future<void> _dispatch(
    Future<void> Function(AnalyticsClient client) work,
  ) async {
    await Future.wait(clients.map(work));
  }
}

@Riverpod(keepAlive: true)
AnalyticsFacade analyticsFacade(Ref ref) {
  {{#use_firebase}}final firebaseAnalyticsClient = ref.watch(firebaseAnalyticsClientProvider);{{/use_firebase}}
  {{#use_mixpanel}}final mixpanelAnalyticsClient = ref
      .watch(mixpanelAnalyticsClientProvider)
      .requireValue;{{/use_mixpanel}}
  return AnalyticsFacade([
    {{#use_mixpanel}}mixpanelAnalyticsClient,{{/use_mixpanel}}
    {{#use_firebase}}firebaseAnalyticsClient,{{/use_firebase}}
    if (kDebugMode) const LoggerAnalyticsClient(),
  ]);
}
