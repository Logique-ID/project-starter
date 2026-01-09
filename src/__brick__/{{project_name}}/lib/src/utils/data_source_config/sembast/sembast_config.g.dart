// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sembast_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sembastDatabase)
const sembastDatabaseProvider = SembastDatabaseProvider._();

final class SembastDatabaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SembastDatabase>,
          SembastDatabase,
          FutureOr<SembastDatabase>
        >
    with $FutureModifier<SembastDatabase>, $FutureProvider<SembastDatabase> {
  const SembastDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sembastDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sembastDatabaseHash();

  @$internal
  @override
  $FutureProviderElement<SembastDatabase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SembastDatabase> create(Ref ref) {
    return sembastDatabase(ref);
  }
}

String _$sembastDatabaseHash() => r'ef0e9835cd2b174279a27a0646a595026aee0e2b';
