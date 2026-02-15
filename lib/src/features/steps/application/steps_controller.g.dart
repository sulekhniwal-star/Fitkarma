// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodaySteps)
final todayStepsProvider = TodayStepsProvider._();

final class TodayStepsProvider
    extends $AsyncNotifierProvider<TodaySteps, StepLog?> {
  TodayStepsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayStepsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayStepsHash();

  @$internal
  @override
  TodaySteps create() => TodaySteps();
}

String _$todayStepsHash() => r'e9e7c4763445af7fe953974cb1bf3e1eb2c983ed';

abstract class _$TodaySteps extends $AsyncNotifier<StepLog?> {
  FutureOr<StepLog?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StepLog?>, StepLog?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StepLog?>, StepLog?>,
              AsyncValue<StepLog?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(stepSettings)
final stepSettingsProvider = StepSettingsProvider._();

final class StepSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StepSettings?>,
          StepSettings?,
          FutureOr<StepSettings?>
        >
    with $FutureModifier<StepSettings?>, $FutureProvider<StepSettings?> {
  StepSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepSettingsHash();

  @$internal
  @override
  $FutureProviderElement<StepSettings?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StepSettings?> create(Ref ref) {
    return stepSettings(ref);
  }
}

String _$stepSettingsHash() => r'f9fe5e0761008d35bb49eb67b302672eca9559c9';

@ProviderFor(weeklySteps)
final weeklyStepsProvider = WeeklyStepsProvider._();

final class WeeklyStepsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StepLog>>,
          List<StepLog>,
          FutureOr<List<StepLog>>
        >
    with $FutureModifier<List<StepLog>>, $FutureProvider<List<StepLog>> {
  WeeklyStepsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyStepsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyStepsHash();

  @$internal
  @override
  $FutureProviderElement<List<StepLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StepLog>> create(Ref ref) {
    return weeklySteps(ref);
  }
}

String _$weeklyStepsHash() => r'28793f940acbcf5a8e4bbf8d02d25ed79d02f956';

@ProviderFor(weeklyStepsStats)
final weeklyStepsStatsProvider = WeeklyStepsStatsProvider._();

final class WeeklyStepsStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  WeeklyStepsStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyStepsStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyStepsStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return weeklyStepsStats(ref);
  }
}

String _$weeklyStepsStatsHash() => r'309df1da02dab3a745a4f07972ae28ea3867bdfa';
