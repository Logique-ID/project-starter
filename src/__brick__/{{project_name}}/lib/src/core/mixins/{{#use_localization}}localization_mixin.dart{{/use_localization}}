import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../localization/app_localization_repository.dart';
import '../../localization/app_localizations.dart';
import '../../localization/app_localizations_provider.dart';

/// Mixin for localization operations.
///
/// Provides methods to:
/// - Get localized strings (AppLocalizations)
/// - Get current locale value
/// - Get locale as number
/// - Set/change localization
///
/// Usage:
/// ```dart
/// class MyScreen extends ConsumerWidget with LocalizationMixin {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final loc = getLocalizations(ref);
///     return Text(loc.appTitle);
///   }
/// }
/// ```
mixin class LocalizationMixin {
  /// Gets the [AppLocalizations] instance for the current locale.
  ///
  /// Returns the appropriate localization instance based on the current locale.
  /// This will automatically update when the locale changes.
  ///
  /// Example:
  /// ```dart
  /// final loc = getLocalizations(ref);
  /// Text(loc.appTitle);
  /// ```
  AppLocalizations getLocalizations(WidgetRef ref) =>
      ref.watch(appLocalizationsProvider);

  /// Gets the current locale code as a string.
  ///
  /// Returns 'en' for English or 'id' for Indonesian.
  ///
  /// Example:
  /// ```dart
  /// final locale = getLocale(ref);
  /// if (locale == 'en') { ... }
  /// ```
  String getLocale(WidgetRef ref) => ref.watch(localeProvider);

  /// Gets the current locale as a number.
  ///
  /// Returns:
  /// - 2 for English ('en')
  /// - 1 for Indonesian ('id')
  ///
  /// Example:
  /// ```dart
  /// final localeNumber = getLocaleToNumber(ref);
  /// ```
  int getLocaleToNumber(WidgetRef ref) => ref.watch(localeProviderToNumber);

  /// Sets the app localization to the specified locale.
  ///
  /// [locale] should be either 'en' for English or 'id' for Indonesian.
  /// This will update the locale provider and persist the change to local storage.
  ///
  /// Example:
  /// ```dart
  /// await setLocalization('en', ref); // Change to English
  /// await setLocalization('id', ref); // Change to Indonesian
  /// ```
  Future<void> setLocalization(String locale, WidgetRef ref) async {
    await ref
        .read(appLocalizationRepositoryProvider)
        .setLocalization(locale, ref);
  }
}
