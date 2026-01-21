// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_analytics_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAnalyticsClient)
const firebaseAnalyticsClientProvider = FirebaseAnalyticsClientProvider._();

final class FirebaseAnalyticsClientProvider
    extends
        $FunctionalProvider<
          FirebaseAnalyticsClient,
          FirebaseAnalyticsClient,
          FirebaseAnalyticsClient
        >
    with $Provider<FirebaseAnalyticsClient> {
  const FirebaseAnalyticsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAnalyticsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAnalyticsClientHash();

  @$internal
  @override
  $ProviderElement<FirebaseAnalyticsClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAnalyticsClient create(Ref ref) {
    return firebaseAnalyticsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAnalyticsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAnalyticsClient>(value),
    );
  }
}

String _$firebaseAnalyticsClientHash() =>
    r'3250ca105921d5cccca3c7919ef92b437c2c2686';
