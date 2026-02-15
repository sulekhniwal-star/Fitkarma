// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(karmaRepository)
final karmaRepositoryProvider = KarmaRepositoryProvider._();

final class KarmaRepositoryProvider
    extends
        $FunctionalProvider<KarmaRepository, KarmaRepository, KarmaRepository>
    with $Provider<KarmaRepository> {
  KarmaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'karmaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$karmaRepositoryHash();

  @$internal
  @override
  $ProviderElement<KarmaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KarmaRepository create(Ref ref) {
    return karmaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KarmaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KarmaRepository>(value),
    );
  }
}

String _$karmaRepositoryHash() => r'661d22567a13102dfbea2f1e7f6df748b3e48070';
