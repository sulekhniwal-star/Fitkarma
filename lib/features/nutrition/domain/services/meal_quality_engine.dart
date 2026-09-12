import '../models/nutrition_models.dart';

class MealQualityEngine {
  const MealQualityEngine();

  /// Computes Multi-Dimensional Meal Quality Score (0 to 100)
  MealQualityScore evaluateMeal({
    required double caloriesKcal,
    required double proteinGrams,
    required double carbsGrams,
    required double fatGrams,
    required double fiberGrams,
  }) {
    if (caloriesKcal <= 0) {
      return const MealQualityScore(
        overallScore: 0,
        proteinScore: 0,
        fiberScore: 0,
        glycemicScore: 0,
        feedback: 'No nutritional content detected.',
        feedbackHindi: 'कोई पोषण सामग्री दर्ज नहीं की गई।',
        improvementTips: [],
      );
    }

    // 1. Protein Adequacy (Target: 15% to 30% of total calories from protein)
    final proteinCals = proteinGrams * 4.0;
    final proteinRatio = proteinCals / caloriesKcal;
    int proteinScore;
    if (proteinRatio >= 0.25) {
      proteinScore = 100;
    } else if (proteinRatio >= 0.18) {
      proteinScore = 80;
    } else if (proteinRatio >= 0.12) {
      proteinScore = 60;
    } else {
      proteinScore = 30;
    }

    // 2. Fiber Density (Target: >= 5g per main meal)
    int fiberScore;
    if (fiberGrams >= 8.0) {
      fiberScore = 100;
    } else if (fiberGrams >= 5.0) {
      fiberScore = 80;
    } else if (fiberGrams >= 2.5) {
      fiberScore = 55;
    } else {
      fiberScore = 25;
    }

    // 3. Glycemic Balance (Carb to Fiber Ratio)
    final netCarbs = (carbsGrams - fiberGrams).clamp(0.0, double.infinity);
    final netCarbRatio = (netCarbs * 4.0) / caloriesKcal;
    int glycemicScore;
    if (netCarbRatio <= 0.45 && fiberGrams >= 4.0) {
      glycemicScore = 95;
    } else if (netCarbRatio <= 0.60) {
      glycemicScore = 75;
    } else {
      glycemicScore = 40; // High glycemic load
    }

    // Weighted Overall Score: 40% Protein + 30% Fiber + 30% Glycemic Balance
    final overall = ((proteinScore * 0.40) + (fiberScore * 0.30) + (glycemicScore * 0.30)).round();

    String feedback;
    String feedbackHindi;
    final List<String> tips = [];

    if (overall >= 80) {
      feedback = 'Optimal Indian Plate Balance. Excellent protein and prebiotic fiber distribution.';
      feedbackHindi = 'उत्कृष्ट भारतीय संतुलित थाली। प्रोटीन और फाइबर का आदर्श अनुपात।';
    } else if (overall >= 60) {
      feedback = 'Moderate Nutritional Balance. High carbohydrate concentration with modest protein.';
      feedbackHindi = 'मध्यम पोषण संतुलन। कार्बोहाइड्रेट अधिक है और प्रोटीन की मात्रा बढ़ाई जा सकती है।';
    } else {
      feedback = 'High Glycemic Excursion Risk. Heavy refined carbs/fats with low protein & fiber.';
      feedbackHindi = 'इंसुलिन स्पाइक का उच्च जोखिम। रिफाइंड कार्ब्स अधिक और प्रोटीन अत्यंत कम हैं।';
    }

    if (proteinRatio < 0.18) {
      tips.add('Add 100g Paneer, 1 boiled egg, or a bowl of sprouted moong to boost lean protein.');
    }
    if (fiberGrams < 4.0) {
      tips.add('Incorporate a raw cucumber/tomato salad (Kachumber) or switch to Jowar/Bajra rotis.');
    }
    if (netCarbRatio > 0.60) {
      tips.add('Reduce rice/roti portion by 25% and fill half the thali with green vegetables/dal.');
    }

    return MealQualityScore(
      overallScore: overall,
      proteinScore: proteinScore,
      fiberScore: fiberScore,
      glycemicScore: glycemicScore,
      feedback: feedback,
      feedbackHindi: feedbackHindi,
      improvementTips: tips,
    );
  }

  /// Predict Satiety Index (Fullness duration in hours)
  double predictSatietyDurationHours({
    required double caloriesKcal,
    required double proteinGrams,
    required double fiberGrams,
    required double fatGrams,
  }) {
    if (caloriesKcal < 100) return 1.0;

    // Protein (1.5x) and Fiber (2.0x) delay gastric emptying significantly
    final satietyIndex = (proteinGrams * 0.12) + (fiberGrams * 0.18) + (fatGrams * 0.05) + (caloriesKcal * 0.003);

    return double.parse(satietyIndex.clamp(1.5, 5.5).toStringAsFixed(1));
  }
}
