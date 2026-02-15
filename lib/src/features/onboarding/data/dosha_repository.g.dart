// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosha_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doshaRepository)
final doshaRepositoryProvider = DoshaRepositoryProvider._();

final class DoshaRepositoryProvider
    extends
        $FunctionalProvider<DoshaRepository, DoshaRepository, DoshaRepository>
    with $Provider<DoshaRepository> {
  DoshaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doshaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doshaRepositoryHash();

  @$internal
  @override
  $ProviderElement<DoshaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DoshaRepository create(Ref ref) {
    return doshaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoshaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DoshaRepository>(value),
    );
  }
}

String _$doshaRepositoryHash() => r'e4a2d27177b3650e8e3d64ff6b2467eb58ccc6b9';
