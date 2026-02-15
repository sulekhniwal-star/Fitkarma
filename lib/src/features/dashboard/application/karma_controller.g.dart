// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KarmaController)
final karmaControllerProvider = KarmaControllerProvider._();

final class KarmaControllerProvider
    extends $AsyncNotifierProvider<KarmaController, void> {
  KarmaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'karmaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$karmaControllerHash();

  @$internal
  @override
  KarmaController create() => KarmaController();
}

String _$karmaControllerHash() => r'ed4a08332de5cb4cf56b3646c520177e3dfc7595';

abstract class _$KarmaController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
