import 'nutrition_models.dart';

enum MealQualityGrade {
  elite(grade: 'A+', label: 'Elite Muscle & Metabolic Fuel', colorCode: 0xff22C55E),
  good(grade: 'A', label: 'Balanced Indian Nutrition', colorCode: 0xff3B82F6),
  moderate(grade: 'B', label: 'Moderate / Carb Heavy', colorCode: 0xffF97316),
  suboptimal(grade: 'C', label: 'Protein Deficient / High Glycemic', colorCode: 0xffEF4444);

  final String grade;
  final String label;
  final int colorCode;

  const MealQualityGrade({
    required this.grade,
    required this.label,
    required this.colorCode,
  });
}

class MealAnalysisReport {
  final int compositeScore; // 0 to 100
  final MealQualityGrade grade;
  final int proteinDensityScore;
  final int glycemicFiberScore;
  final int satietyScore;
  final int totalCalories;
  final double totalProteinGrams;
  final double totalCarbsGrams;
  final double totalFatsGrams;
  final double totalFiberGrams;
  final List<String> calibrationSuggestions;
  final String metabolicImpactSummary;

  const MealAnalysisReport({
    required this.compositeScore,
    required this.grade,
    required this.proteinDensityScore,
    required this.glycemicFiberScore,
    required this.satietyScore,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.totalCarbsGrams,
    required this.totalFatsGrams,
    required this.totalFiberGrams,
    required this.calibrationSuggestions,
    required this.metabolicImpactSummary,
  });
}

class MealAnalysisEngine {
  /// Pure Dart deterministic evaluation of meal macronutrient quality, protein density, and glycemic load
  static MealAnalysisReport analyzeMeal(List<LoggedMealEntry> entries) {
    if (entries.isEmpty) {
      return const MealAnalysisReport(
        compositeScore: 50,
        grade: MealQualityGrade.moderate,
        proteinDensityScore: 50,
        glycemicFiberScore: 50,
        satietyScore: 50,
        totalCalories: 0,
        totalProteinGrams: 0.0,
        totalCarbsGrams: 0.0,
        totalFatsGrams: 0.0,
        totalFiberGrams: 0.0,
        calibrationSuggestions: ['Log food items to view multi-factor meal analysis.'],
        metabolicImpactSummary: 'No food items evaluated.',
      );
    }

    final totalCals = entries.fold<int>(0, (sum, e) => sum + e.totalCalories);
    final totalProtein = entries.fold<double>(0.0, (sum, e) => sum + e.totalProtein);
    final totalCarbs = entries.fold<double>(0.0, (sum, e) => sum + e.totalCarbs);
    final totalFats = entries.fold<double>(0.0, (sum, e) => sum + e.totalFats);
    final totalFiber = entries.fold<double>(0.0, (sum, e) => sum + e.totalFiber);

    // 1. Protein Density Score (Protein calories / Total calories)
    final proteinCals = totalProtein * 4.0;
    final proteinRatio = totalCals > 0 ? (proteinCals / totalCals) : 0.15;
    final int proteinScore;
    if (proteinRatio >= 0.30) {
      proteinScore = 100;
    } else if (proteinRatio >= 0.22) {
      proteinScore = 85;
    } else if (proteinRatio >= 0.15) {
      proteinScore = 65;
    } else {
      proteinScore = 35;
    }

    // 2. Glycemic & Fiber Score (Fiber to Carb ratio)
    final fiberRatio = totalCarbs > 0 ? (totalFiber / totalCarbs) : 0.10;
    final int fiberScore;
    if (fiberRatio >= 0.18) {
      fiberScore = 100;
    } else if (fiberRatio >= 0.12) {
      fiberScore = 80;
    } else if (fiberRatio >= 0.06) {
      fiberScore = 60;
    } else {
      fiberScore = 35;
    }

    // 3. Satiety Index Score
    final int satietyScore = ((proteinScore * 0.5) + (fiberScore * 0.5)).round();

    // 4. Composite Meal Score
    final compScore = ((proteinScore * 0.45) + (fiberScore * 0.35) + (satietyScore * 0.20)).round().clamp(0, 100);

    // Grade assignment
    final MealQualityGrade grade;
    if (compScore >= 85) {
      grade = MealQualityGrade.elite;
    } else if (compScore >= 70) {
      grade = MealQualityGrade.good;
    } else if (compScore >= 50) {
      grade = MealQualityGrade.moderate;
    } else {
      grade = MealQualityGrade.suboptimal;
    }

    // 5. Actionable Indian Food Calibrations
    final List<String> suggestions = [];
    if (totalProtein < 25.0) {
      suggestions.add('Protein Booster: Add 100g low-fat Paneer (+18g P) or 1 scoop Whey Protein (+24g P) to trigger muscle protein synthesis (MPS).');
    }
    if (fiberRatio < 0.10 && totalCarbs > 40.0) {
      suggestions.add('Glycemic Buffer: Pair refined rotis/rice with a raw cucumber-tomato salad or a katori of sprouted moong to blunt the insulin spike.');
    }
    if (totalFats > 30.0) {
      suggestions.add('Oil & Ghee Calibration: Reduce cooking oil/tadka by 1 teaspoon to save ~120 surplus calories.');
    }
    if (suggestions.isEmpty) {
      suggestions.add('Excellent meal architecture! Ideal macro distribution for muscle preservation and sustained metabolic energy.');
    }

    final String summary;
    if (grade == MealQualityGrade.elite) {
      summary = 'Exceptional high-protein, low-glycemic meal structure. Optimizes muscle protein synthesis and keeps insulin steady.';
    } else if (grade == MealQualityGrade.good) {
      summary = 'Well-balanced Indian meal. Solid macronutrient distribution for daily energy demands.';
    } else {
      summary = 'High carbohydrate load with suboptimal protein density. Consider applying the smart protein booster suggestions.';
    }

    return MealAnalysisReport(
      compositeScore: compScore,
      grade: grade,
      proteinDensityScore: proteinScore,
      glycemicFiberScore: fiberScore,
      satietyScore: satietyScore,
      totalCalories: totalCals,
      totalProteinGrams: double.parse(totalProtein.toStringAsFixed(1)),
      totalCarbsGrams: double.parse(totalCarbs.toStringAsFixed(1)),
      totalFatsGrams: double.parse(totalFats.toStringAsFixed(1)),
      totalFiberGrams: double.parse(totalFiber.toStringAsFixed(1)),
      calibrationSuggestions: suggestions,
      metabolicImpactSummary: summary,
    );
  }
}
