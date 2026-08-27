import 'nutrition_models.dart';

class DetectedFoodItem {
  final String name;
  final String regionalName;
  final String estimatedPortion;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatsGrams;

  const DetectedFoodItem({
    required this.name,
    required this.regionalName,
    required this.estimatedPortion,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
  });

  factory DetectedFoodItem.fromMap(Map<String, dynamic> map) {
    return DetectedFoodItem(
      name: map['name'] as String? ?? 'Indian Dish',
      regionalName: map['regionalName'] as String? ?? '',
      estimatedPortion: map['estimatedPortion'] as String? ?? '1 serving',
      calories: (map['calories'] as num?)?.toInt() ?? 150,
      proteinGrams: (map['proteinGrams'] as num?)?.toDouble() ?? 5.0,
      carbsGrams: (map['carbsGrams'] as num?)?.toDouble() ?? 20.0,
      fatsGrams: (map['fatsGrams'] as num?)?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regionalName': regionalName,
      'estimatedPortion': estimatedPortion,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatsGrams': fatsGrams,
    };
  }

  FoodItem toFoodItem() {
    return FoodItem(
      id: 'detected_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      regionalName: regionalName,
      servingUnit: estimatedPortion,
      calories: calories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatsGrams: fatsGrams,
      fiberGrams: 3.0,
      category: 'AI Detected',
    );
  }
}

class FixMyMealSuggestion {
  final String title;
  final String regionalTitle;
  final String description;
  final String macroImpact; // e.g. '+14g Protein, -60 kcal'
  final bool isApplied;

  const FixMyMealSuggestion({
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.macroImpact,
    this.isApplied = false,
  });

  FixMyMealSuggestion copyWith({bool? isApplied}) {
    return FixMyMealSuggestion(
      title: title,
      regionalTitle: regionalTitle,
      description: description,
      macroImpact: macroImpact,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

class VisionMealAnalysisResult {
  final String mealName;
  final List<DetectedFoodItem> detectedFoods;
  final int totalCalories;
  final double totalProteinGrams;
  final double totalCarbsGrams;
  final double totalFatsGrams;
  final List<FixMyMealSuggestion> fixMyMealSuggestions;
  final bool fromCache;

  const VisionMealAnalysisResult({
    required this.mealName,
    required this.detectedFoods,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.totalCarbsGrams,
    required this.totalFatsGrams,
    required this.fixMyMealSuggestions,
    this.fromCache = false,
  });
}
