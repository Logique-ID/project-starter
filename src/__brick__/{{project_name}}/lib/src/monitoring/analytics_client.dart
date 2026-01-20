abstract class AnalyticsClient {
  Future<void> setAnalyticsCollectionEnabled(bool enabled);
  Future<void> trackLogin();
  //TODO: Add other event tracking methods here
}
