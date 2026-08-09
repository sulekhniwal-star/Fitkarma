import 'indian_food_item.dart';

/// Regional Cooking Oil Profiles
enum IndianRegionOilProfile { northGheeMustard, southCoconut, westGroundnut, eastMustard }

extension IndianRegionOilProfileEst on IndianRegionOilProfile {
  double get estimatedAddedFatGrams {
    switch (this) {
      case IndianRegionOilProfile.northGheeMustard:
        return 12.0; // ~1.5 tbsp ghee/oil per curry
      case IndianRegionOilProfile.southCoconut:
        return 8.0;  // Coconut oil tempering
      case IndianRegionOilProfile.westGroundnut:
        return 10.0;
      case IndianRegionOilProfile.eastMustard:
        return 9.0;
    }
  }
}

/// Fasting Protocol Modes
enum FastingProtocolMode { none, navratriGrainFree, ramadanSehriIftar, ekadashiNoGrains }

/// Pure Dart Local Meal Quality Score Calculator & Core Nutrition Adaptations Engine per §P5-D
class LocalMealQualityCalculator {
  const LocalMealQualityCalculator();

  /// Computes composite Meal Quality Score out of 10.0 per §P5-D formula:
  /// 1. Protein Density Score (Up to 3.0 pts)
  /// 2. Fiber Density Score (Up to 2.5 pts)
  /// 3. Glycemic Load Impact Score (Up to 2.5 pts)
  /// 4. Satiety Index Score (Up to 2.0 pts)
  double calculateMealQualityScore({
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required double fiberG,
    required int glycemicIndex,
  }) {
    if (calories <= 0) return 0.0;

    // 1. Protein Density Score (Up to 3.0 pts)
    final double proteinCal = proteinG * 4.0;
    final double proteinPct = proteinCal / calories;
    final double proteinScore = (proteinPct * 10.0).clamp(0.0, 3.0);

    // 2. Fiber Density Score (Up to 2.5 pts)
    final double targetFiber = (calories / 1000.0) * 14.0;
    final double fiberScore = targetFiber > 0
        ? ((fiberG / targetFiber) * 2.5).clamp(0.0, 2.5)
        : 0.0;

    // 3. Glycemic Load Impact Score (Up to 2.5 pts)
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    double glScore = 2.5;
    if (glycemicLoad > 20) {
      glScore = 0.5; // High GL
    } else if (glycemicLoad > 10) {
      glScore = 1.5; // Medium GL
    }

    // 4. Satiety Index Score (Up to 2.0 pts)
    final double satietyIndex = calculateSatietyIndex(proteinG, fiberG, fatG, carbsG);
    final double satietyScore = (satietyIndex / 100.0) * 2.0;

    final total = proteinScore + fiberScore + glScore + satietyScore;
    return double.parse(total.clamp(0.0, 10.0).toStringAsFixed(1));
  }

  /// Computes Satiety Index (10.0 - 100.0) based on macronutrient/fiber satiating effects
  double calculateSatietyIndex(double protein, double fiber, double fat, double carbs) {
    final double base = (protein * 2.5) + (fiber * 3.0) + (fat * 1.0) + (carbs * 0.5);
    return double.parse(base.clamp(10.0, 100.0).toStringAsFixed(1));
  }

  /// Evaluates readiness and muscle repair impact per §P5-D
  int calculateReadinessImpact(double proteinG, int glycemicIndex, double carbsG) {
    int impact = 0;

    // High protein post-workout aids muscle recovery
    if (proteinG >= 20.0) {
      impact += 2; // +2% readiness restoration
    }

    // High Glycemic Load causing an energy crash
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    if (glycemicLoad > 25.0) {
      impact -= 3; // -3% capacity score due to crash
    }

    return impact;
  }

  // ── Core Nutrition Adaptations ──────────────────────────────────────────────

  /// 1. Thali Composite Intelligence: Estimates full thali composite macros
  IndianFoodItem estimateCompositeThali({
    required List<IndianFoodItem> components,
    IndianRegionOilProfile region = IndianRegionOilProfile.northGheeMustard,
  }) {
    int cals = 0;
    double protein = 0.0, carbs = 0.0, fat = 0.0, avgGi = 0.0;

    for (final item in components) {
      cals += item.calories;
      protein += item.proteinGrams;
      carbs += item.carbsGrams;
      fat += item.fatGrams;
      avgGi += item.glycemicIndex;
    }

    // Add estimated oil per cooking style & region
    fat += region.estimatedAddedFatGrams;
    cals += (region.estimatedAddedFatGrams * 9.0).round();

    return IndianFoodItem(
      id: 'composite_thali_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Composite Indian Thali (${components.length} items)',
      category: 'Thali Composite',
      calories: cals,
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
      glycemicIndex: components.isNotEmpty ? avgGi / components.length : 50.0,
      satietyIndex: 85.0,
    );
  }

  /// 2. Fasting Protocol Filter: Evaluates item compliance against active fasting mode
  bool isFoodCompliantWithFasting(IndianFoodItem item, FastingProtocolMode mode) {
    switch (mode) {
      case FastingProtocolMode.none:
        return true;
      case FastingProtocolMode.navratriGrainFree:
      case FastingProtocolMode.ekadashiNoGrains:
        final cat = item.category.toLowerCase();
        final name = item.name.toLowerCase();
        return !cat.contains('grains') &&
            !cat.contains('breads') &&
            !name.contains('roti') &&
            !name.contains('rice') &&
            !name.contains('poha') &&
            !name.contains('dosa');
      case FastingProtocolMode.ramadanSehriIftar:
        return item.satietyIndex >= 50.0; // High satiety filter for fasting endurance
    }
  }

  /// 3. Festival Adaptation Buffer: Returns daily calorie buffer modifier (+200 kcal for Diwali week)
  double getFestivalCalorieBufferModifier({required bool isFestivalWeek}) {
    return isFestivalWeek ? 200.0 : 0.0;
  }
}
