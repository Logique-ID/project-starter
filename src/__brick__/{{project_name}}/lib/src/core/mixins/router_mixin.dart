import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_router.dart';

mixin RouterMixin {
  GoRouter goRouter(WidgetRef ref) => ref.watch(goRouterProvider);
}
