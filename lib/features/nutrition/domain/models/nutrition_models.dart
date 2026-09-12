enum MealType { breakfast, lunch, snack, dinner }

enum IndianRegion { north, south, west, east, panIndia }

enum DietaryPreference { vegetarian, eggetarian, nonVegetarian, vegan, jain }

class FoodItem {
  final String id;
  final String name;
  final String nameHindi;
  final IndianRegion region;
  final DietaryPreference dietaryType;
  final double servingSizeGrams;
  final String standardPortionUnit; // '1 Katori', '1 Roti', '1 Piece', '1 Cup'
  final double caloriesKcal;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;
  final double glycemicIndex; // 0 - 100
  final double ironMg;
  final double calciumMg;
  final double vitaminB12Mcg;

  const FoodItem({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.region,
    required this.dietaryType,
    required this.servingSizeGrams,
    required this.standardPortionUnit,
    required this.caloriesKcal,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
    required this.glycemicIndex,
    this.ironMg = 0.0,
    this.calciumMg = 0.0,
    this.vitaminB12Mcg = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_hindi': nameHindi,
        'region': region.name,
        'dietary_type': dietaryType.name,
        'serving_size_grams': servingSizeGrams,
        'standard_portion_unit': standardPortionUnit,
        'calories_kcal': caloriesKcal,
        'protein_grams': proteinGrams,
        'carbs_grams': carbsGrams,
        'fat_grams': fatGrams,
        'fiber_grams': fiberGrams,
        'glycemic_index': glycemicIndex,
        'iron_mg': ironMg,
        'calcium_mg': calciumMg,
        'vitamin_b12_mcg': vitaminB12Mcg,
      };
}

class MealComponent {
  final FoodItem food;
  final double quantity; // multiplier of standardPortionUnit (e.g. 2 for 2 Rotis)

  const MealComponent({
    required this.food,
    this.quantity = 1.0,
  });

  double get totalCalories => food.caloriesKcal * quantity;
  double get totalProtein => food.proteinGrams * quantity;
  double get totalCarbs => food.carbsGrams * quantity;
  double get totalFat => food.fatGrams * quantity;
  double get totalFiber => food.fiberGrams * quantity;
}

class LoggedMeal {
  final String id;
  final String userId;
  final String name;
  final MealType mealType;
  final List<MealComponent> components;
  final double caloriesKcal;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;
  final int mealQualityScore; // 0 to 100
  final double visionConfidence; // 0.0 to 1.0 (if logged via AI photo)
  final String? photoUrl;
  final DateTime loggedAt;

  const LoggedMeal({
    required this.id,
    required this.userId,
    required this.name,
    required this.mealType,
    required this.components,
    required this.caloriesKcal,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
    required this.mealQualityScore,
    this.visionConfidence = 1.0,
    this.photoUrl,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'meal_type': mealType.name,
        'calories_kcal': caloriesKcal,
        'protein_grams': proteinGrams,
        'carbs_grams': carbsGrams,
        'fat_grams': fatGrams,
        'fiber_grams': fiberGrams,
        'meal_quality_score': mealQualityScore,
        'vision_confidence': visionConfidence,
        'photo_url': photoUrl,
        'logged_at': loggedAt.toIso8601String(),
      };
}

class MealQualityScore {
  final int overallScore; // 0 to 100
  final int proteinScore; // 0 to 100
  final int fiberScore; // 0 to 100
  final int glycemicScore; // 0 to 100
  final String feedback;
  final String feedbackHindi;
  final List<String> improvementTips;

  const MealQualityScore({
    required this.overallScore,
    required this.proteinScore,
    required this.fiberScore,
    required this.glycemicScore,
    required this.feedback,
    required this.feedbackHindi,
    required this.improvementTips,
  });
}

class FoodSwap {
  final String id;
  final String originalFoodName;
  final String swapFoodName;
  final String swapFoodNameHindi;
  final String category; // 'Staple', 'Street Food', 'Snack', 'Sweets'
  final String reason;
  final String reasonHindi;
  final double glycemicReductionPercent;
  final double proteinGainPercent;
  final double calorieDifference;

  const FoodSwap({
    required this.id,
    required this.originalFoodName,
    required this.swapFoodName,
    required this.swapFoodNameHindi,
    required this.category,
    required this.reason,
    required this.reasonHindi,
    required this.glycemicReductionPercent,
    required this.proteinGainPercent,
    required this.calorieDifference,
  });
}

class GroceryItem {
  final String id;
  final String name;
  final String nameHindi;
  final String category; // 'Grains & Millets', 'Dals & Pulses', 'Vegetables', 'Dairy & Protein', 'Spices'
  final double quantity;
  final String unit; // 'kg', 'g', 'L', 'bunch'
  final double estimatedCostInr;
  final bool isPantryStaple;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.estimatedCostInr,
    this.isPantryStaple = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_hindi': nameHindi,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'estimated_cost_inr': estimatedCostInr,
        'is_pantry_staple': isPantryStaple,
      };
}
