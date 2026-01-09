import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

import '../../../utils/data_source_config/sembast/in_memory_store.dart';
import '../../../utils/data_source_config/sembast/sembast_config.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._store, this._db);
  final StoreRef<dynamic, dynamic> _store;
  final Database _db;

  static const authKey = 'authKey';
  static const fcmTokenKey = 'fcmTokenKey';

  final _authState = InMemoryStore<AppUser?>(null);

  AppUser? get currentUser => _authState.value;

  Future<void> saveSession(AppUser user) async {
    await _store.record(authKey).put(_db, user.toJson());
  }

  Future<void> clearSession() async {
    await _store.record(authKey).delete(_db);
  }

  Stream<AppUser?> authStateChangesStream() {
    final record = _store.record(authKey);
    return record.onSnapshot(_db).map((snapshot) {
      AppUser? appUser;
      if (snapshot != null) {
        appUser = AppUser.fromJson(snapshot.value);
      } else {
        appUser = null;
      }
      _authState.value = appUser;
      return appUser;
    });
  }

  void dispose() => _authState.close();

  //TODO call this when success login
  Future<void> saveFcmToken(String token) async {
    await _store.record(fcmTokenKey).put(_db, token);
  }

  Future<String?> getFcmToken() async {
    final fcmToken = await _store.record(fcmTokenKey).get(_db) as String?;
    return fcmToken;
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final sembastDatabase = ref.read(sembastDatabaseProvider).requireValue;
  final store = sembastDatabase.store;
  final db = sembastDatabase.db;
  final authRepository = AuthRepository(store, db);
  ref.onDispose(() => authRepository.dispose());
  return authRepository;
}
