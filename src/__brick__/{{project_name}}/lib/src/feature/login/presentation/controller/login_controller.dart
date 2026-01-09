import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/login_repository.dart';

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
    state = await AsyncValue.guard(
      () => ref.watch(
        loginProvider(
          username: username,
          password: password,
          recaptchaToken: recaptchaToken,
        ).future,
      ),
    );
  }
}
