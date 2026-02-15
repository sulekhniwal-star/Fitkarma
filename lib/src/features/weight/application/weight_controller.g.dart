// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weightLogs)
final weightLogsProvider = WeightLogsProvider._();

final class WeightLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightLog>>,
          List<WeightLog>,
          FutureOr<List<WeightLog>>
        >
    with $FutureModifier<List<WeightLog>>, $FutureProvider<List<WeightLog>> {
  WeightLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightLogsHash();

  @$internal
  @override
  $FutureProviderElement<List<WeightLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightLog>> create(Ref ref) {
    return weightLogs(ref);
  }
}

String _$weightLogsHash() => r'ba3a3fdd76ca30d0e6210e06de833a2294c86345';

@ProviderFor(todayWeight)
final todayWeightProvider = TodayWeightProvider._();

final class TodayWeightProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeightLog?>,
          WeightLog?,
          FutureOr<WeightLog?>
        >
    with $FutureModifier<WeightLog?>, $FutureProvider<WeightLog?> {
  TodayWeightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayWeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayWeightHash();

  @$internal
  @override
  $FutureProviderElement<WeightLog?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WeightLog?> create(Ref ref) {
    return todayWeight(ref);
  }
}

String _$todayWeightHash() => r'bb75687a0df76568ad7408ba4a1facc55a9f32dd';

@ProviderFor(weightStats)
final weightStatsProvider = WeightStatsProvider._();

final class WeightStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  WeightStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return weightStats(ref);
  }
}

String _$weightStatsHash() => r'905d9f962caaaf3fc6afe8a8c308de60d00387ab';

@ProviderFor(weightTrends)
final weightTrendsProvider = WeightTrendsFamily._();

final class WeightTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightTrend>>,
          List<WeightTrend>,
          FutureOr<List<WeightTrend>>
        >
    with
        $FutureModifier<List<WeightTrend>>,
        $FutureProvider<List<WeightTrend>> {
  WeightTrendsProvider._({
    required WeightTrendsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'weightTrendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weightTrendsHash();

  @override
  String toString() {
    return r'weightTrendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeightTrend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightTrend>> create(Ref ref) {
    final argument = this.argument as int;
    return weightTrends(ref, days: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeightTrendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weightTrendsHash() => r'018b6a22ca22ad7b3bd752d9c0135746b4ca17aa';

final class WeightTrendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WeightTrend>>, int> {
  WeightTrendsFamily._()
    : super(
        retry: null,
        name: r'weightTrendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeightTrendsProvider call({int days = 30}) =>
      WeightTrendsProvider._(argument: days, from: this);

  @override
  String toString() => r'weightTrendsProvider';
}

@ProviderFor(WeightLogController)
final weightLogControllerProvider = WeightLogControllerProvider._();

final class WeightLogControllerProvider
    extends $AsyncNotifierProvider<WeightLogController, void> {
  WeightLogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightLogControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightLogControllerHash();

  @$internal
  @override
  WeightLogController create() => WeightLogController();
}

String _$weightLogControllerHash() =>
    r'b60838182b69df7a62c0e911345150ce182ac74c';

abstract class _$WeightLogController extends $AsyncNotifier<void> {
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
