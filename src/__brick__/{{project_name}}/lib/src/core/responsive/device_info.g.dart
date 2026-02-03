// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceInfoNotifier)
const deviceInfoProvider = DeviceInfoNotifierProvider._();

final class DeviceInfoNotifierProvider
    extends $NotifierProvider<DeviceInfoNotifier, DeviceInfo> {
  const DeviceInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoNotifierHash();

  @$internal
  @override
  DeviceInfoNotifier create() => DeviceInfoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceInfo>(value),
    );
  }
}

String _$deviceInfoNotifierHash() =>
    r'50d1d618aefd828d711f416e677d74a065b38e48';

abstract class _$DeviceInfoNotifier extends $Notifier<DeviceInfo> {
  DeviceInfo build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DeviceInfo, DeviceInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceInfo, DeviceInfo>,
              DeviceInfo,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
