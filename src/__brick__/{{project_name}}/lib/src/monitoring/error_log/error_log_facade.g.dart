// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_log_facade.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(errorLogFacade)
const errorLogFacadeProvider = ErrorLogFacadeProvider._();

final class ErrorLogFacadeProvider
    extends $FunctionalProvider<ErrorLogFacade, ErrorLogFacade, ErrorLogFacade>
    with $Provider<ErrorLogFacade> {
  const ErrorLogFacadeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorLogFacadeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorLogFacadeHash();

  @$internal
  @override
  $ProviderElement<ErrorLogFacade> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorLogFacade create(Ref ref) {
    return errorLogFacade(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorLogFacade value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorLogFacade>(value),
    );
  }
}

String _$errorLogFacadeHash() => r'b77ea656b5025f955a0354fc495528132e2473c4';
