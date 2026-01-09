import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_controller.dart';

mixin class LoginState {
  bool isStateLoginLoading(WidgetRef ref) {
    return ref.watch(loginControllerProvider).isLoading;
  }
}
