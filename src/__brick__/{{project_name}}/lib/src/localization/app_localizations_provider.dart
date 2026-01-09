import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_localization_repository.dart';
import 'app_localizations.dart';

/// Provider that supplies [AppLocalizations] based on the current locale.
///
/// This provider:
/// - Watches the [localeProvider] to reactively update when locale changes
/// - Listens to system locale changes via [WidgetsBindingObserver]
/// - Automatically cleans up observers when the provider is disposed
/// - Returns the appropriate [AppLocalizations] instance for the current locale
///
/// Usage:
/// ```dart
/// final localizations = ref.watch(appLocalizationsProvider);
/// final title = localizations.appTitle;
/// ```
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  // Watch the locale provider to reactively update when locale changes
  // This ensures the AppLocalizations instance is updated whenever the locale changes
  final localeCode = ref.watch(localeProvider);

  // Create a Locale object from the language code
  final locale = Locale(localeCode);

  // Lookup and return the appropriate AppLocalizations instance
  // This is cached per locale, so multiple calls with the same locale
  // will return the same instance
  final appLocalizations = lookupAppLocalizations(locale);

  // Create an observer to listen for system locale changes
  // This allows the app to automatically update when the user changes
  // their device language settings
  final observer = _LocaleObserver((locales) {
    // Update the locale provider when system locale changes
    // Use the first locale from the system, or default to 'en' if none available
    final newLocaleCode = (locales != null && locales.isNotEmpty)
        ? locales.first.languageCode
        : 'en';

    // Only update if the locale actually changed to avoid unnecessary rebuilds
    // This optimization prevents redundant state updates and widget rebuilds
    final currentLocaleCode = ref.read(localeProvider);
    if (currentLocaleCode != newLocaleCode) {
      ref.read(localeProvider.notifier).state = newLocaleCode;
    }
  });

  // Get the WidgetsBinding instance to register our observer
  final binding = WidgetsBinding.instance;

  // Register the observer to receive system locale change notifications
  binding.addObserver(observer);

  // Clean up: Remove the observer when this provider is disposed
  // This prevents memory leaks and ensures proper resource management
  // The observer will be removed when no widgets are watching this provider
  ref.onDispose(() {
    binding.removeObserver(observer);
  });

  return appLocalizations;
});

/// Observer that listens to system locale changes from Flutter's [WidgetsBinding].
///
/// This class extends [WidgetsBindingObserver] to receive notifications when
/// the system locale changes (e.g., when user changes device language settings).
/// When a locale change is detected, it calls the provided callback to update
/// the app's locale state.
class _LocaleObserver extends WidgetsBindingObserver {
  /// Creates a [_LocaleObserver] with the given callback.
  ///
  /// The [didChangeLocales] callback will be invoked whenever the system
  /// locale changes, receiving the new list of locales as a parameter.
  _LocaleObserver(this._didChangeLocales);

  /// Callback function that is invoked when system locales change.
  final void Function(List<Locale>? locales) _didChangeLocales;

  /// Called by Flutter when the system locale changes.
  ///
  /// This method is part of the [WidgetsBindingObserver] interface and is
  /// automatically called by Flutter's binding system when the device's
  /// locale settings change. It forwards the new locales to the callback
  /// function, which updates the app's locale state accordingly.
  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
  }
}
