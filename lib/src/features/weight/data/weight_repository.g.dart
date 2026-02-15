// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weightRepository)
final weightRepositoryProvider = WeightRepositoryProvider._();

final class WeightRepositoryProvider
    extends
        $FunctionalProvider<
          WeightRepository,
          WeightRepository,
          WeightRepository
        >
    with $Provider<WeightRepository> {
  WeightRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeightRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeightRepository create(Ref ref) {
    return weightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeightRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeightRepository>(value),
    );
  }
}

String _$weightRepositoryHash() => r'f18a877b0914464ab79788951f49eca4b0c13f5d';
