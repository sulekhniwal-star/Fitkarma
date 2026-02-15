// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayWater)
final todayWaterProvider = TodayWaterProvider._();

final class TodayWaterProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterLog?>,
          WaterLog?,
          FutureOr<WaterLog?>
        >
    with $FutureModifier<WaterLog?>, $FutureProvider<WaterLog?> {
  TodayWaterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayWaterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayWaterHash();

  @$internal
  @override
  $FutureProviderElement<WaterLog?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WaterLog?> create(Ref ref) {
    return todayWater(ref);
  }
}

String _$todayWaterHash() => r'5a38312b2cf25805b93b0b4e295a88561afb004c';

@ProviderFor(waterSettings)
final waterSettingsProvider = WaterSettingsProvider._();

final class WaterSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterSettings?>,
          WaterSettings?,
          FutureOr<WaterSettings?>
        >
    with $FutureModifier<WaterSettings?>, $FutureProvider<WaterSettings?> {
  WaterSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterSettingsHash();

  @$internal
  @override
  $FutureProviderElement<WaterSettings?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WaterSettings?> create(Ref ref) {
    return waterSettings(ref);
  }
}

String _$waterSettingsHash() => r'458e437b55d3d1c8ef4d4ee046276fe3a598a52c';

@ProviderFor(weeklyWaterStats)
final weeklyWaterStatsProvider = WeeklyWaterStatsProvider._();

final class WeeklyWaterStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  WeeklyWaterStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyWaterStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyWaterStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return weeklyWaterStats(ref);
  }
}

String _$weeklyWaterStatsHash() => r'927c5429095c6110071ec38325ed08d9fefd8146';

@ProviderFor(hydrationStreak)
final hydrationStreakProvider = HydrationStreakProvider._();

final class HydrationStreakProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  HydrationStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hydrationStreakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hydrationStreakHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return hydrationStreak(ref);
  }
}

String _$hydrationStreakHash() => r'bb3544afcbedb68aa9f936ab1250f623858f3afe';

@ProviderFor(WaterLogController)
final waterLogControllerProvider = WaterLogControllerProvider._();

final class WaterLogControllerProvider
    extends $AsyncNotifierProvider<WaterLogController, void> {
  WaterLogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterLogControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterLogControllerHash();

  @$internal
  @override
  WaterLogController create() => WaterLogController();
}

String _$waterLogControllerHash() =>
    r'1cda55b5639ea4836b22666444ae03cb18f93613';

abstract class _$WaterLogController extends $AsyncNotifier<void> {
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
