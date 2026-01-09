import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

import '../utils/data_source_config/sembast/sembast_config.dart';

part 'app_localization_repository.g.dart';

/// setup initialization in MaterialApp locale: Locale(ref.watch(localeProvider))

/// use this to change lang to English
/// ref.read(appLocalizationRepositoryProvider).setLocalization('en', ref);
/// use this to change lang to Indonesia
/// ref.read(appLocalizationRepositoryProvider).setLocalization('id', ref);

/// use this to watch locale. result will 'en' or 'id'
/// final locale = consRef.watch(localeProvider);

/// use this to watch string translation
/// final loc = consRef.watch(appLocalizationsProvider);
/// loc.appTitle (this 'appTitle' will be generated after run flutter gen-l10n)

/// add translation in each .arb files and run flutter gen-l10n to generate

class AppLocalizationRepository {
  AppLocalizationRepository(this._store, this._db);
  final StoreRef<dynamic, dynamic> _store;
  final Database _db;

  static const localizationKey = 'localizationKey';

  Future<void> readLocalization(Ref ref) async {
    final locale = await _store.record(localizationKey).get(_db) as String?;

    ref.read(localeProvider.notifier).state =
        locale ?? 'id'; //default Indonesia
  }

  Future<void> setLocalization(String locale, WidgetRef ref) async {
    await _store.record(localizationKey).put(_db, locale);
    ref.read(localeProvider.notifier).state = locale;
  }
}

@Riverpod(keepAlive: true)
AppLocalizationRepository appLocalizationRepository(Ref ref) {
  final sembastDatabase = ref.read(sembastDatabaseProvider).requireValue;
  final store = sembastDatabase.store;
  final db = sembastDatabase.db;
  return AppLocalizationRepository(store, db);
}

final localeProvider = StateProvider<String>((ref) {
  return 'id'; //default Indonesia
});

final localeProviderToNumber = StateProvider<int>((ref) {
  return ref.watch(localeProvider) == 'en' ? 2 : 1;
});
