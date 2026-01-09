import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final isConnectionAvailableProvider = StateProvider<bool>((ref) {
  return true;
});

mixin ConnectionMixin {
  bool isConnectionAvailable(WidgetRef ref) =>
      ref.watch(isConnectionAvailableProvider);

  void setConnectionAvailable(WidgetRef ref, bool value) {
    ref.read(isConnectionAvailableProvider.notifier).state = value;
  }
}
