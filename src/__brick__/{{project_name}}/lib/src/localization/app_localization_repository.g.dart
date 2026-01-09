// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_localization_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLocalizationRepository)
const appLocalizationRepositoryProvider = AppLocalizationRepositoryProvider._();

final class AppLocalizationRepositoryProvider
    extends
        $FunctionalProvider<
          AppLocalizationRepository,
          AppLocalizationRepository,
          AppLocalizationRepository
        >
    with $Provider<AppLocalizationRepository> {
  const AppLocalizationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocalizationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocalizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppLocalizationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppLocalizationRepository create(Ref ref) {
    return appLocalizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLocalizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLocalizationRepository>(value),
    );
  }
}

String _$appLocalizationRepositoryHash() =>
    r'f304fd095b9fd9a71cd6c407260f8a6a3a587688';
