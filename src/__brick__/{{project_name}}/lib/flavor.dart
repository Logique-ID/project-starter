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

  static String get packageName {
    switch (appFlavor) {
      case Flavor.dev:
        return '{{{app_id}}}.dev';
      case Flavor.stg:
        return '{{{app_id}}}.stg';
      default:
        return '{{{app_id}}}';
    }
  }

  /// Talsec RASP
  // Replace with your release (!) signing certificate hash(es)
  static String get androidSigningCertHash =>
      'mVr/qQLO8DKTwqlL+B1qigl9NoBnbiUs8b4c2Ewcz0k=';
  // iOS Team ID
  static String get iosTeamId => 'IOS_TEAM_ID';
  // Replace with your email
  static String get watcherMail => 'example@logique.co.id';
  {{#use_sentry}}
  /// Sentry DSN for error tracking
  static String get sentryDsn => '{{{sentry_dsn}}}';
  {{/use_sentry}}
  {{#use_mixpanel}}
  /// Mixpanel token is used to track user events and behaviors in Mixpanel.
  static String get mixpanelToken {
    switch (appFlavor) {
      case Flavor.dev:
        return '{{{mixpanel_token}}}';
      case Flavor.stg:
        return '{{{mixpanel_token}}}';
      default:
        return '{{{mixpanel_token}}}';
    }
  }
  {{/use_mixpanel}}
}
