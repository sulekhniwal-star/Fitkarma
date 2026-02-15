// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosha_quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoshaQuizController)
final doshaQuizControllerProvider = DoshaQuizControllerProvider._();

final class DoshaQuizControllerProvider
    extends $AsyncNotifierProvider<DoshaQuizController, DoshaQuizState> {
  DoshaQuizControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doshaQuizControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doshaQuizControllerHash();

  @$internal
  @override
  DoshaQuizController create() => DoshaQuizController();
}

String _$doshaQuizControllerHash() =>
    r'f289cb64de2801b333ccf4f10f6b946e90298886';

abstract class _$DoshaQuizController extends $AsyncNotifier<DoshaQuizState> {
  FutureOr<DoshaQuizState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DoshaQuizState>, DoshaQuizState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DoshaQuizState>, DoshaQuizState>,
              AsyncValue<DoshaQuizState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
