/// §P5-D Smart Indian Meal Intelligence
///
/// Pure-Dart regional cuisine dataset mapping, mixed-dish macro estimation,
/// oil/fat profile multipliers, and fasting compliance validation.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Enums & Models
// ─────────────────────────────────────────────────────────────────────────────

/// Primary geographical culinary regions of India.
enum IndianRegion {
  north,
  south,
  east,
  west,
  central,
}

/// Preparation method affecting oil and hidden fat density.
enum CookingStyle {
  homeCooked,
  lowOil,
  restaurantStyle,
  dhabaStyle,
}

/// Religious or cultural fasting modes.
enum FastingMode {
  none,
  navratri,
  ramadan,
  ekadashi,
}

/// Profile defining oil usage and fat multipliers by region and cooking style.
class RegionalOilProfile {
  const RegionalOilProfile({
    required this.region,
    required this.primaryOilName,
    required this.baseOilGramsPerMeal,
  });

  /// Default profile factory for a given region.
  factory RegionalOilProfile.forRegion(IndianRegion region) {
    final oilName = getOilNameForRegion(region);
    final baseGrams = switch (region) {
      IndianRegion.north => 12.0,
      IndianRegion.south => 10.0,
      IndianRegion.east => 11.0,
      IndianRegion.west => 10.5,
      IndianRegion.central => 11.5,
    };
    return RegionalOilProfile(
      region: region,
      primaryOilName: oilName,
      baseOilGramsPerMeal: baseGrams,
    );
  }

  final IndianRegion region;
  final String primaryOilName;
  final double baseOilGramsPerMeal;

  /// Returns the fat multiplier relative to standard home cooking for a given [style].
  static double getFatMultiplier(CookingStyle style) {
    return switch (style) {
      CookingStyle.lowOil => 0.70,
      CookingStyle.homeCooked => 1.00,
      CookingStyle.restaurantStyle => 1.30,
      CookingStyle.dhabaStyle => 1.55,
    };
  }

  /// Returns the primary oil name for a region.
  static String getOilNameForRegion(IndianRegion region) {
    return switch (region) {
      IndianRegion.north => 'Ghee / Mustard Oil',
      IndianRegion.south => 'Coconut / Sesame Oil',
      IndianRegion.east => 'Mustard Oil',
      IndianRegion.west => 'Groundnut Oil',
      IndianRegion.central => 'Soybean / Ghee',
    };
  }
}

/// A component item within a thali or mixed dish.
class ThaliComponent {
  const ThaliComponent({
    required this.id,
    required this.name,
    required this.servingDescription,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.glycemicIndex,
    this.isGrain = false,
    this.isLegume = false,
    this.isFastingFriendly = true,
  });

  final String id;
  final String name;
  final String servingDescription;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final int glycemicIndex;
  final bool isGrain;
  final bool isLegume;
  final bool isFastingFriendly;

  ThaliComponent scale(double factor) {
    return ThaliComponent(
      id: id,
      name: name,
      servingDescription: servingDescription,
      calories: calories * factor,
      proteinG: proteinG * factor,
      carbsG: carbsG * factor,
      fatG: fatG * factor,
      fiberG: fiberG * factor,
      glycemicIndex: glycemicIndex,
      isGrain: isGrain,
      isLegume: isLegume,
      isFastingFriendly: isFastingFriendly,
    );
  }
}

/// Preset template defining a composite Indian Thali or platter.
class ThaliTemplate {
  const ThaliTemplate({
    required this.id,
    required this.name,
    required this.region,
    required this.description,
    required this.components,
  });

  final String id;
  final String name;
  final IndianRegion region;
  final String description;
  final List<ThaliComponent> components;
}

// ─────────────────────────────────────────────────────────────────────────────
// Built-in Regional Thali Templates
// ─────────────────────────────────────────────────────────────────────────────

class RegionalThaliDataset {
  RegionalThaliDataset._();

  static const ThaliComponent roti = ThaliComponent(
    id: 'roti',
    name: 'Whole Wheat Roti',
    servingDescription: '2 Rotis (80g)',
    calories: 170,
    proteinG: 6.0,
    carbsG: 36,
    fatG: 1.0,
    fiberG: 5.0,
    glycemicIndex: 62,
    isGrain: true,
  );

  static const ThaliComponent dalTadka = ThaliComponent(
    id: 'dal_tadka',
    name: 'Dal Tadka (Yellow)',
    servingDescription: '1 Bowl (150g)',
    calories: 150,
    proteinG: 8.5,
    carbsG: 22,
    fatG: 3.5,
    fiberG: 6.0,
    glycemicIndex: 45,
    isLegume: true,
  );

  static const ThaliComponent paneerSabzi = ThaliComponent(
    id: 'paneer_sabzi',
    name: 'Paneer Bhurji / Gravy',
    servingDescription: '1 Bowl (120g)',
    calories: 220,
    proteinG: 14.0,
    carbsG: 6,
    fatG: 16.0,
    fiberG: 1.5,
    glycemicIndex: 30,
  );

  static const ThaliComponent steamedRice = ThaliComponent(
    id: 'steamed_rice',
    name: 'Steamed Rice',
    servingDescription: '1 Cup (150g)',
    calories: 200,
    proteinG: 4.2,
    carbsG: 44,
    fatG: 0.4,
    fiberG: 1.0,
    glycemicIndex: 72,
    isGrain: true,
  );

  static const ThaliComponent curd = ThaliComponent(
    id: 'curd',
    name: 'Curd (Dahi)',
    servingDescription: '1 Cup (100g)',
    calories: 65,
    proteinG: 3.5,
    carbsG: 4,
    fatG: 4.0,
    fiberG: 0.0,
    glycemicIndex: 28,
  );

  static const ThaliComponent sambar = ThaliComponent(
    id: 'sambar',
    name: 'Veg Sambar',
    servingDescription: '1 Bowl (150g)',
    calories: 110,
    proteinG: 4.0,
    carbsG: 18,
    fatG: 2.0,
    fiberG: 4.5,
    glycemicIndex: 48,
    isLegume: true,
  );

  static const ThaliComponent rasam = ThaliComponent(
    id: 'rasam',
    name: 'Tomato Rasam',
    servingDescription: '1 Cup (120g)',
    calories: 45,
    proteinG: 1.0,
    carbsG: 7,
    fatG: 1.5,
    fiberG: 1.2,
    glycemicIndex: 40,
  );

  static const ThaliComponent poriyal = ThaliComponent(
    id: 'poriyal',
    name: 'Cabbage/Beans Poriyal',
    servingDescription: '1 Bowl (100g)',
    calories: 75,
    proteinG: 2.0,
    carbsG: 9,
    fatG: 3.5,
    fiberG: 3.0,
    glycemicIndex: 35,
  );

  static const ThaliComponent gujaratiDal = ThaliComponent(
    id: 'gujarati_dal',
    name: 'Sweet Gujarati Dal',
    servingDescription: '1 Bowl (150g)',
    calories: 160,
    proteinG: 6.5,
    carbsG: 26,
    fatG: 3.5,
    fiberG: 4.5,
    glycemicIndex: 52,
    isLegume: true,
  );

  static const ThaliComponent fishCurry = ThaliComponent(
    id: 'fish_curry',
    name: 'Bengali Fish Curry',
    servingDescription: '1 Bowl (150g)',
    calories: 210,
    proteinG: 22.0,
    carbsG: 4,
    fatG: 11.0,
    fiberG: 0.8,
    glycemicIndex: 20,
  );

  static const ThaliComponent sabudanaKhichdi = ThaliComponent(
    id: 'sabudana_khichdi',
    name: 'Sabudana Khichdi',
    servingDescription: '1 Bowl (150g)',
    calories: 280,
    proteinG: 3.0,
    carbsG: 48,
    fatG: 9.0,
    fiberG: 2.0,
    glycemicIndex: 75,
    isGrain: false,
    isLegume: false,
    isFastingFriendly: true,
  );

  static const ThaliTemplate northIndianThali = ThaliTemplate(
    id: 'north_thali',
    name: 'North Indian Thali',
    region: IndianRegion.north,
    description: 'Rotis, Dal Tadka, Paneer Sabzi, Steamed Rice, Curd & Salad',
    components: [roti, dalTadka, paneerSabzi, steamedRice, curd],
  );

  static const ThaliTemplate southIndianThali = ThaliTemplate(
    id: 'south_thali',
    name: 'South Indian Meals (Thali)',
    region: IndianRegion.south,
    description: 'Steamed Rice, Veg Sambar, Tomato Rasam, Poriyal & Curd',
    components: [steamedRice, sambar, rasam, poriyal, curd],
  );

  static const ThaliTemplate gujaratiThali = ThaliTemplate(
    id: 'gujarati_thali',
    name: 'Gujarati Thali',
    region: IndianRegion.west,
    description: 'Phulkas, Sweet Gujarati Dal, Steamed Rice, Poriyal & Curd',
    components: [roti, gujaratiDal, steamedRice, poriyal, curd],
  );

  static const ThaliTemplate bengaliThali = ThaliTemplate(
    id: 'bengali_thali',
    name: 'Bengali Fish Thali',
    region: IndianRegion.east,
    description: 'Steamed Rice, Fish Curry, Veg Poriyal & Curd',
    components: [steamedRice, fishCurry, poriyal, curd],
  );

  static const ThaliTemplate navratriFastingThali = ThaliTemplate(
    id: 'navratri_thali',
    name: 'Navratri Fasting Thali',
    region: IndianRegion.north,
    description: 'Sabudana Khichdi, Curd & Fruit Salad',
    components: [sabudanaKhichdi, curd],
  );

  static const List<ThaliTemplate> allTemplates = [
    northIndianThali,
    southIndianThali,
    gujaratiThali,
    bengaliThali,
    navratriFastingThali,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Fasting Validator Logic
// ─────────────────────────────────────────────────────────────────────────────

class FastingValidationResult {
  const FastingValidationResult({
    required this.isCompliant,
    required this.violations,
    required this.recommendations,
  });

  final bool isCompliant;
  final List<String> violations;
  final List<String> recommendations;
}

class FastingValidator {
  const FastingValidator();

  /// Validates a list of components against the specified [mode].
  FastingValidationResult validate({
    required List<ThaliComponent> components,
    required FastingMode mode,
  }) {
    if (mode == FastingMode.none) {
      return const FastingValidationResult(
        isCompliant: true,
        violations: [],
        recommendations: [],
      );
    }

    final violations = <String>[];
    final recommendations = <String>[];

    for (final item in components) {
      switch (mode) {
        case FastingMode.navratri:
          if (item.isGrain) {
            violations.add('${item.name} contains cereal grains (not allowed in Navratri fast)');
          } else if (item.isLegume) {
            violations.add('${item.name} contains pulses/legumes (avoid during Navratri fast)');
          } else if (!item.isFastingFriendly) {
            violations.add('${item.name} is not fasting-friendly');
          }
          break;

        case FastingMode.ekadashi:
          if (item.isGrain) {
            violations.add('${item.name} contains grains (Ekadashi prohibits grains)');
          } else if (item.isLegume) {
            violations.add('${item.name} contains beans/pulses (Ekadashi prohibits legumes)');
          }
          break;

        case FastingMode.ramadan:
          // Ramadan: Check macro suitability for Sehri (pre-fast) vs Iftar (break fast)
          final totalFiber = components.fold<double>(0, (sum, c) => sum + c.fiberG);
          if (totalFiber < 4.0) {
            recommendations.add('Add high-fiber foods for sustained energy during Sehri');
          }
          break;

        case FastingMode.none:
          break;
      }
    }

    if (mode == FastingMode.navratri && violations.isNotEmpty) {
      recommendations.add('Replace grains/pulses with Sabudana, Kuttu, Singhara, or fruits');
    } else if (mode == FastingMode.ekadashi && violations.isNotEmpty) {
      recommendations.add('Opt for milk, curd, fruits, and root vegetables on Ekadashi');
    }

    return FastingValidationResult(
      isCompliant: violations.isEmpty,
      violations: violations,
      recommendations: recommendations,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mixed Dish Macro Estimator
// ─────────────────────────────────────────────────────────────────────────────

class MixedDishEstimateResult {
  const MixedDishEstimateResult({
    required this.dishName,
    required this.region,
    required this.cookingStyle,
    required this.fastingMode,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.totalFiberG,
    required this.weightedGI,
    required this.primaryOilName,
    required this.fastingValidation,
    required this.itemBreakdown,
  });

  final String dishName;
  final IndianRegion region;
  final CookingStyle cookingStyle;
  final FastingMode fastingMode;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final double totalFiberG;
  final int weightedGI;
  final String primaryOilName;
  final FastingValidationResult fastingValidation;
  final List<ThaliComponent> itemBreakdown;
}

class MixedDishMacroEstimator {
  const MixedDishMacroEstimator({
    FastingValidator? fastingValidator,
  }) : _fastingValidator = fastingValidator ?? const FastingValidator();

  final FastingValidator _fastingValidator;

  /// Estimates composite macros for a pre-mapped [template] with optional
  /// regional override, cooking style, and fasting mode validation.
  MixedDishEstimateResult estimateTemplate({
    required ThaliTemplate template,
    IndianRegion? regionOverride,
    CookingStyle cookingStyle = CookingStyle.homeCooked,
    FastingMode fastingMode = FastingMode.none,
    double portionMultiplier = 1.0,
  }) {
    final region = regionOverride ?? template.region;
    final scaledComponents = template.components
        .map((c) => c.scale(portionMultiplier))
        .toList();

    return estimateCustom(
      dishName: template.name,
      components: scaledComponents,
      region: region,
      cookingStyle: cookingStyle,
      fastingMode: fastingMode,
    );
  }

  /// Estimates composite macros for a custom list of [components].
  MixedDishEstimateResult estimateCustom({
    required String dishName,
    required List<ThaliComponent> components,
    required IndianRegion region,
    CookingStyle cookingStyle = CookingStyle.homeCooked,
    FastingMode fastingMode = FastingMode.none,
  }) {
    final oilProfile = RegionalOilProfile.forRegion(region);
    final fatMultiplier = RegionalOilProfile.getFatMultiplier(cookingStyle);

    double baseCalories = 0;
    double baseProtein = 0;
    double baseCarbs = 0;
    double baseFat = 0;
    double baseFiber = 0;
    double carbWeightedGISum = 0;

    for (final item in components) {
      baseCalories += item.calories;
      baseProtein += item.proteinG;
      baseCarbs += item.carbsG;
      baseFat += item.fatG;
      baseFiber += item.fiberG;
      carbWeightedGISum += (item.carbsG * item.glycemicIndex);
    }

    // Apply fat multiplier based on cooking style (adds/subtracts oil fat calories)
    final adjustedFat = baseFat * fatMultiplier;
    final fatDeltaGrams = adjustedFat - baseFat;
    final adjustedCalories = baseCalories + (fatDeltaGrams * 9.0);

    final weightedGI = baseCarbs > 0 ? (carbWeightedGISum / baseCarbs).round() : 0;

    final fastingVal = _fastingValidator.validate(
      components: components,
      mode: fastingMode,
    );

    return MixedDishEstimateResult(
      dishName: dishName,
      region: region,
      cookingStyle: cookingStyle,
      fastingMode: fastingMode,
      totalCalories: double.parse(adjustedCalories.toStringAsFixed(1)),
      totalProteinG: double.parse(baseProtein.toStringAsFixed(1)),
      totalCarbsG: double.parse(baseCarbs.toStringAsFixed(1)),
      totalFatG: double.parse(adjustedFat.toStringAsFixed(1)),
      totalFiberG: double.parse(baseFiber.toStringAsFixed(1)),
      weightedGI: weightedGI,
      primaryOilName: oilProfile.primaryOilName,
      fastingValidation: fastingVal,
      itemBreakdown: components,
    );
  }
}
