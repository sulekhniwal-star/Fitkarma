// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodayFoodLogs)
final todayFoodLogsProvider = TodayFoodLogsProvider._();

final class TodayFoodLogsProvider
    extends $AsyncNotifierProvider<TodayFoodLogs, List<FoodLog>> {
  TodayFoodLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayFoodLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayFoodLogsHash();

  @$internal
  @override
  TodayFoodLogs create() => TodayFoodLogs();
}

String _$todayFoodLogsHash() => r'f7de993ff927ec80048b0305f74cb8e74924bb7f';

abstract class _$TodayFoodLogs extends $AsyncNotifier<List<FoodLog>> {
  FutureOr<List<FoodLog>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<FoodLog>>, List<FoodLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FoodLog>>, List<FoodLog>>,
              AsyncValue<List<FoodLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(dailyNutrition)
final dailyNutritionProvider = DailyNutritionProvider._();

final class DailyNutritionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  DailyNutritionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyNutritionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyNutritionHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    return dailyNutrition(ref);
  }
}

String _$dailyNutritionHash() => r'67cd21ad19ab0e73aebcacaa616baed1497c0f6a';

@ProviderFor(mealWiseLogs)
final mealWiseLogsProvider = MealWiseLogsProvider._();

final class MealWiseLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<FoodLog>>>,
          Map<String, List<FoodLog>>,
          FutureOr<Map<String, List<FoodLog>>>
        >
    with
        $FutureModifier<Map<String, List<FoodLog>>>,
        $FutureProvider<Map<String, List<FoodLog>>> {
  MealWiseLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealWiseLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealWiseLogsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<FoodLog>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<FoodLog>>> create(Ref ref) {
    return mealWiseLogs(ref);
  }
}

String _$mealWiseLogsHash() => r'9705c521c1bef4f86002ef1afc9bbcd2ab1d94ba';

@ProviderFor(foodSearch)
final foodSearchProvider = FoodSearchFamily._();

final class FoodSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FoodItem>>,
          List<FoodItem>,
          FutureOr<List<FoodItem>>
        >
    with $FutureModifier<List<FoodItem>>, $FutureProvider<List<FoodItem>> {
  FoodSearchProvider._({
    required FoodSearchFamily super.from,
    required ({String? query, String? category, String? cuisineType})
    super.argument,
  }) : super(
         retry: null,
         name: r'foodSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodSearchHash();

  @override
  String toString() {
    return r'foodSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<FoodItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FoodItem>> create(Ref ref) {
    final argument =
        this.argument
            as ({String? query, String? category, String? cuisineType});
    return foodSearch(
      ref,
      query: argument.query,
      category: argument.category,
      cuisineType: argument.cuisineType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodSearchHash() => r'5677a15c896a41e58f30c16ace6948d942466ae0';

final class FoodSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<FoodItem>>,
          ({String? query, String? category, String? cuisineType})
        > {
  FoodSearchFamily._()
    : super(
        retry: null,
        name: r'foodSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodSearchProvider call({
    String? query,
    String? category,
    String? cuisineType,
  }) => FoodSearchProvider._(
    argument: (query: query, category: category, cuisineType: cuisineType),
    from: this,
  );

  @override
  String toString() => r'foodSearchProvider';
}

@ProviderFor(foodItemDetails)
final foodItemDetailsProvider = FoodItemDetailsFamily._();

final class FoodItemDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FoodItem?>,
          FoodItem?,
          FutureOr<FoodItem?>
        >
    with $FutureModifier<FoodItem?>, $FutureProvider<FoodItem?> {
  FoodItemDetailsProvider._({
    required FoodItemDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'foodItemDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodItemDetailsHash();

  @override
  String toString() {
    return r'foodItemDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FoodItem?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FoodItem?> create(Ref ref) {
    final argument = this.argument as String;
    return foodItemDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodItemDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodItemDetailsHash() => r'e85a003db387757feb2aaf861638822664dff503';

final class FoodItemDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FoodItem?>, String> {
  FoodItemDetailsFamily._()
    : super(
        retry: null,
        name: r'foodItemDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodItemDetailsProvider call(String foodItemId) =>
      FoodItemDetailsProvider._(argument: foodItemId, from: this);

  @override
  String toString() => r'foodItemDetailsProvider';
}

@ProviderFor(barcodeLookup)
final barcodeLookupProvider = BarcodeLookupFamily._();

final class BarcodeLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<FoodItem?>,
          FoodItem?,
          FutureOr<FoodItem?>
        >
    with $FutureModifier<FoodItem?>, $FutureProvider<FoodItem?> {
  BarcodeLookupProvider._({
    required BarcodeLookupFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'barcodeLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$barcodeLookupHash();

  @override
  String toString() {
    return r'barcodeLookupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FoodItem?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FoodItem?> create(Ref ref) {
    final argument = this.argument as String;
    return barcodeLookup(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BarcodeLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$barcodeLookupHash() => r'78f2a25d30754295f9e33566eeb42c21810c6294';

final class BarcodeLookupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FoodItem?>, String> {
  BarcodeLookupFamily._()
    : super(
        retry: null,
        name: r'barcodeLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BarcodeLookupProvider call(String barcode) =>
      BarcodeLookupProvider._(argument: barcode, from: this);

  @override
  String toString() => r'barcodeLookupProvider';
}

@ProviderFor(FoodLogController)
final foodLogControllerProvider = FoodLogControllerProvider._();

final class FoodLogControllerProvider
    extends $AsyncNotifierProvider<FoodLogController, void> {
  FoodLogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodLogControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodLogControllerHash();

  @$internal
  @override
  FoodLogController create() => FoodLogController();
}

String _$foodLogControllerHash() => r'e91d615207c41fa8ca147040562d9faa97da1c99';

abstract class _$FoodLogController extends $AsyncNotifier<void> {
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
