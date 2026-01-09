// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localNotification)
const localNotificationProvider = LocalNotificationProvider._();

final class LocalNotificationProvider
    extends
        $FunctionalProvider<
          LocalNotification,
          LocalNotification,
          LocalNotification
        >
    with $Provider<LocalNotification> {
  const LocalNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationHash();

  @$internal
  @override
  $ProviderElement<LocalNotification> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalNotification create(Ref ref) {
    return localNotification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalNotification value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalNotification>(value),
    );
  }
}

String _$localNotificationHash() => r'066de0862291de49015b26f01f5786a5c40451df';
