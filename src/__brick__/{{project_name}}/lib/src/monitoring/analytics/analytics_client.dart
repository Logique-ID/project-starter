abstract class AnalyticsClient {
  Future<void> setAnalyticsCollectionEnabled(bool enabled);
  Future<void> trackLogin();
  Future<void> trackScreenView(String routeName, String action);
  //TODO: Add other event tracking methods here
}
