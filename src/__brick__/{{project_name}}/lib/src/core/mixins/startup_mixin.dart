import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routing/app_startup.dart';

mixin StartupMixin {
  AsyncValue<void> startupState(WidgetRef ref) => ref.watch(appStartupProvider);

  void startupRetry(WidgetRef ref) {
    ref.invalidate(appStartupProvider);
  }
}
