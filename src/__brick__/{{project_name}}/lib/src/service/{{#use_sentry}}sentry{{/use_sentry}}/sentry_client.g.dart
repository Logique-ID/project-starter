// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentry_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sentryClient)
const sentryClientProvider = SentryClientProvider._();

final class SentryClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<SentryClient>,
          SentryClient,
          FutureOr<SentryClient>
        >
    with $FutureModifier<SentryClient>, $FutureProvider<SentryClient> {
  const SentryClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentryClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentryClientHash();

  @$internal
  @override
  $FutureProviderElement<SentryClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SentryClient> create(Ref ref) {
    return sentryClient(ref);
  }
}

String _$sentryClientHash() => r'e4a1deedfc4d9ddaa1931a00880a5677f561a780';
