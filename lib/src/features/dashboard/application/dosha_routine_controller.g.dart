// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosha_routine_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoshaRoutineController)
final doshaRoutineControllerProvider = DoshaRoutineControllerProvider._();

final class DoshaRoutineControllerProvider
    extends
        $AsyncNotifierProvider<
          DoshaRoutineController,
          List<Map<String, dynamic>>
        > {
  DoshaRoutineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doshaRoutineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doshaRoutineControllerHash();

  @$internal
  @override
  DoshaRoutineController create() => DoshaRoutineController();
}

String _$doshaRoutineControllerHash() =>
    r'0374ef201e5fed9b0c50fd7e4e54a9916158f855';

abstract class _$DoshaRoutineController
    extends $AsyncNotifier<List<Map<String, dynamic>>> {
  FutureOr<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              List<Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                List<Map<String, dynamic>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
