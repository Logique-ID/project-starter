enum Flavor { dev, stg, prod }

class F {
  static Flavor? _appFlavor;
  static set appFlavor(Flavor value) => _appFlavor = value;
  static Flavor get appFlavor => _appFlavor ?? Flavor.dev;

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'API_URL_DEV';
      case Flavor.stg:
        return 'API_URL_STG';
      default:
        return 'API_URL_PROD';
    }
  }

  static String get imageUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'IMAGE_URL_DEV';
      case Flavor.stg:
        return 'IMAGE_URL_STG';
      default:
        return 'IMAGE_URL_PROD';
    }
  }

  static String get apiKey {
    switch (appFlavor) {
      case Flavor.dev:
        return 'API_KEY_DEV';
      case Flavor.stg:
        return 'API_KEY_STG';
      default:
        return 'API_KEY_PROD';
    }
  }
  {{#use_sentry}}
  /// Sentry DSN for error tracking
  static String get sentryDsn => '{{{sentry_dsn}}}';
  {{/use_sentry}}
}
