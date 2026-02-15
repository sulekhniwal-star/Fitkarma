// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stepsRepository)
final stepsRepositoryProvider = StepsRepositoryProvider._();

final class StepsRepositoryProvider
    extends
        $FunctionalProvider<StepsRepository, StepsRepository, StepsRepository>
    with $Provider<StepsRepository> {
  StepsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StepsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StepsRepository create(Ref ref) {
    return stepsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StepsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StepsRepository>(value),
    );
  }
}

String _$stepsRepositoryHash() => r'bd32800befefeb46c9fba28aba109c7cd334dc4d';
