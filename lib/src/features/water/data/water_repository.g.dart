// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterRepository)
final waterRepositoryProvider = WaterRepositoryProvider._();

final class WaterRepositoryProvider
    extends
        $FunctionalProvider<WaterRepository, WaterRepository, WaterRepository>
    with $Provider<WaterRepository> {
  WaterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterRepositoryHash();

  @$internal
  @override
  $ProviderElement<WaterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WaterRepository create(Ref ref) {
    return waterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterRepository>(value),
    );
  }
}

String _$waterRepositoryHash() => r'7010b42414fc846889f0c16c262cc02cc7ca738c';
