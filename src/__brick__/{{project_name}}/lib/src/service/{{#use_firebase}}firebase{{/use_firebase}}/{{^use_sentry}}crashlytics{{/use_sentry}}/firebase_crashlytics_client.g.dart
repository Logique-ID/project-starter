// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_crashlytics_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseCrashlyticsClient)
const firebaseCrashlyticsClientProvider = FirebaseCrashlyticsClientProvider._();

final class FirebaseCrashlyticsClientProvider
    extends
        $FunctionalProvider<
          FirebaseCrashlyticsClient,
          FirebaseCrashlyticsClient,
          FirebaseCrashlyticsClient
        >
    with $Provider<FirebaseCrashlyticsClient> {
  const FirebaseCrashlyticsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseCrashlyticsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseCrashlyticsClientHash();

  @$internal
  @override
  $ProviderElement<FirebaseCrashlyticsClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseCrashlyticsClient create(Ref ref) {
    return firebaseCrashlyticsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseCrashlyticsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseCrashlyticsClient>(value),
    );
  }
}

String _$firebaseCrashlyticsClientHash() =>
    r'2f0a44674ed6b56ce3947f2c27fa208786306651';
