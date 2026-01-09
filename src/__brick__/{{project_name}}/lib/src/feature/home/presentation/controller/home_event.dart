import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';

mixin class HomeEvent {
  void goToLogin(WidgetRef ref) {
    ref
        .read(goRouterProvider)
        .goNamed(AppRoute.login.name, pathParameters: {'currentIndex': '0'});
  }
}
