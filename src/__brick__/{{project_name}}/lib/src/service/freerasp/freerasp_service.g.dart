// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freerasp_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(freeraspService)
const freeraspServiceProvider = FreeraspServiceProvider._();

final class FreeraspServiceProvider
    extends
        $FunctionalProvider<FreeraspService, FreeraspService, FreeraspService>
    with $Provider<FreeraspService> {
  const FreeraspServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'freeraspServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$freeraspServiceHash();

  @$internal
  @override
  $ProviderElement<FreeraspService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FreeraspService create(Ref ref) {
    return freeraspService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FreeraspService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FreeraspService>(value),
    );
  }
}

String _$freeraspServiceHash() => r'1a0c34f57cc978c1e2e1b779e5c6a59acbf2e7af';
