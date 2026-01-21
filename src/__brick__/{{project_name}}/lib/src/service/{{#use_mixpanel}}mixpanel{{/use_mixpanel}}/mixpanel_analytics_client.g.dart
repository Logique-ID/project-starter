// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixpanel_analytics_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mixpanelAnalyticsClient)
const mixpanelAnalyticsClientProvider = MixpanelAnalyticsClientProvider._();

final class MixpanelAnalyticsClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<MixpanelAnalyticsClient>,
          MixpanelAnalyticsClient,
          FutureOr<MixpanelAnalyticsClient>
        >
    with
        $FutureModifier<MixpanelAnalyticsClient>,
        $FutureProvider<MixpanelAnalyticsClient> {
  const MixpanelAnalyticsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixpanelAnalyticsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixpanelAnalyticsClientHash();

  @$internal
  @override
  $FutureProviderElement<MixpanelAnalyticsClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MixpanelAnalyticsClient> create(Ref ref) {
    return mixpanelAnalyticsClient(ref);
  }
}

String _$mixpanelAnalyticsClientHash() =>
    r'935c7d424cd62c0619fe15ecf451c678579024b7';
