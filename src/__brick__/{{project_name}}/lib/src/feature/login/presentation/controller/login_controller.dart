import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/login_repository.dart';
import '../../data/remote/local_login_repo_impl.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> login({
    required String username,
    required String password,
    required String recaptchaToken,
  }) async {
    state = const AsyncValue.loading();
    final loginRepo = ref.watch(loginRepoProvider);
    state = await AsyncValue.guard(
      () => loginRepo.login(
        username: username,
        password: password,
        recaptchaToken: recaptchaToken,
      ),
    );
  }
}

/// Interface for LoginRepository
final loginRepoProvider = Provider<LoginRepository>((ref) {
  return RemoteLoginRepositoryImpl(ref);
});
