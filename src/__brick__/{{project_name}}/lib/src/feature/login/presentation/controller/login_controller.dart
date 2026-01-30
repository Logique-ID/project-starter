{{^use_legacy}}import 'package:flutter_riverpod/flutter_riverpod.dart';{{/use_legacy}}
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/login_repository.dart';
{{^use_legacy}}import '../../data/remote/local_login_repo_impl.dart';{{/use_legacy}}

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
    {{#use_legacy}}
    state = await AsyncValue.guard(
      () => ref.watch(
        loginProvider(
          username: username,
          password: password,
          recaptchaToken: recaptchaToken,
        ).future,
      ),
    );
    {{/use_legacy}}
    {{^use_legacy}}
    final loginRepo = ref.watch(loginRepoProvider);
    state = await AsyncValue.guard(
      () => loginRepo.login(
        username: username,
        password: password,
        recaptchaToken: recaptchaToken,
      ),
    );
    {{/use_legacy}}
  }
}

{{^use_legacy}}/// Interface for LoginRepository
final loginRepoProvider = Provider<LoginRepository>((ref) {
  return RemoteLoginRepositoryImpl(ref);
});{{/use_legacy}}