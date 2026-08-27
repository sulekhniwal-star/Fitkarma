import '../domain/vision_meal_models.dart';

class FixMyMealTemplates {
  static const List<VisionMealAnalysisResult> preconfiguredTemplates = [
    // 1. Classic North Indian Thali
    VisionMealAnalysisResult(
      mealName: 'North Indian Thali (थली भोजन)',
      detectedFoods: [
        DetectedFoodItem(
          name: 'Whole Wheat Phulka Roti',
          regionalName: 'गेहूं की रोटी (2 फुल्के)',
          estimatedPortion: '2 rotis (70g)',
          calories: 160,
          proteinGrams: 5.5,
          carbsGrams: 32.0,
          fatsGrams: 1.0,
        ),
        DetectedFoodItem(
          name: 'Tadka Moong Daal',
          regionalName: 'तड़का मूंग दाल',
          estimatedPortion: '1 katori (180g)',
          calories: 165,
          proteinGrams: 9.0,
          carbsGrams: 23.0,
          fatsGrams: 4.0,
        ),
        DetectedFoodItem(
          name: 'Aloo Gobi Masala',
          regionalName: 'आलू गोभी सब्जी',
          estimatedPortion: '1 medium bowl (150g)',
          calories: 180,
          proteinGrams: 3.5,
          carbsGrams: 24.0,
          fatsGrams: 8.5,
        ),
        DetectedFoodItem(
          name: 'Steamed Rice',
          regionalName: 'चावल',
          estimatedPortion: '1/2 katori (80g)',
          calories: 105,
          proteinGrams: 2.0,
          carbsGrams: 23.0,
          fatsGrams: 0.3,
        ),
      ],
      totalCalories: 610,
      totalProteinGrams: 20.0,
      totalCarbsGrams: 102.0,
      totalFatsGrams: 13.8,
      fixMyMealSuggestions: [
        FixMyMealSuggestion(
          title: 'Swap 1 Roti for 100g Paneer Bhurji',
          regionalTitle: '1 रोटी की जगह 100g पनीर भुर्जी लें',
          description: 'Replaces refined carbs with high-quality dairy protein to stimulate muscle recovery.',
          macroImpact: '+18g Protein, -15g Carbs',
        ),
        FixMyMealSuggestion(
          title: 'Add 1 Katori Cucumber-Tomato Salad',
          regionalTitle: '1 कटोरी खीरा-टमाटर सलाद जोड़ें',
          description: 'Adds soluble fiber to slow glucose gastric emptying and reduce postprandial spike.',
          macroImpact: '+4g Fiber, 0 Glycemic Load',
        ),
        FixMyMealSuggestion(
          title: 'Reduce Tadka Ghee/Oil by 1 Tsp',
          regionalTitle: 'तड़के में 1 चम्मच तेल/घी कम करें',
          description: 'Cuts hidden saturated cooking fats without sacrificing taste.',
          macroImpact: '-90 kcal, -10g Fats',
        ),
      ],
    ),

    // 2. South Indian Tiffin
    VisionMealAnalysisResult(
      mealName: 'South Indian Tiffin (इडली व सांभर)',
      detectedFoods: [
        DetectedFoodItem(
          name: 'Steamed Rice Idlis',
          regionalName: 'इडली (3 पीस)',
          estimatedPortion: '3 idlis (150g)',
          calories: 195,
          proteinGrams: 6.0,
          carbsGrams: 42.0,
          fatsGrams: 0.5,
        ),
        DetectedFoodItem(
          name: 'Vegetable Sambar',
          regionalName: 'सांभर',
          estimatedPortion: '1 large bowl (200g)',
          calories: 130,
          proteinGrams: 6.5,
          carbsGrams: 18.0,
          fatsGrams: 3.5,
        ),
        DetectedFoodItem(
          name: 'Coconut Chutney',
          regionalName: 'नारियल चटनी',
          estimatedPortion: '2 tablespoons (40g)',
          calories: 140,
          proteinGrams: 1.5,
          carbsGrams: 4.0,
          fatsGrams: 13.0,
        ),
      ],
      totalCalories: 465,
      totalProteinGrams: 14.0,
      totalCarbsGrams: 64.0,
      totalFatsGrams: 17.0,
      fixMyMealSuggestions: [
        FixMyMealSuggestion(
          title: 'Pair with 2 Boiled Eggs or Sattu Drink',
          regionalTitle: '2 उबले अंडे या सत्तू ड्रिंक साथ लें',
          description: 'Boosts total meal protein from 14g to 26g to hit target satiety.',
          macroImpact: '+12g Protein, +140 kcal',
        ),
        FixMyMealSuggestion(
          title: 'Swap Coconut Chutney with Mint-Coriander Chutney',
          regionalTitle: 'पुदीना-धनिया चटनी का उपयोग करें',
          description: 'Cuts calorie-dense coconut fats by 70% while boosting antioxidants.',
          macroImpact: '-95 kcal, -10g Fats',
        ),
      ],
    ),
  ];
}
