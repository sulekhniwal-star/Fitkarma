import '../domain/nutrition_models.dart';

class IndianFoodDatabase {
  static const List<FoodItem> stapleIndianFoods = [
    // Grains / Rotis
    FoodItem(
      id: 'food_roti',
      name: 'Whole Wheat Phulka Roti',
      regionalName: 'गेहूं की फुल्का रोटी',
      servingUnit: '2 medium rotis (70g)',
      calories: 160,
      proteinGrams: 5.5,
      carbsGrams: 32.0,
      fatsGrams: 1.0,
      fiberGrams: 4.2,
      category: 'Roti/Bread',
    ),
    FoodItem(
      id: 'food_besan_chilla',
      name: 'Paneer Stuffed Besan Chilla',
      regionalName: 'पनीर बेसन चीला',
      servingUnit: '1 large chilla (140g)',
      calories: 230,
      proteinGrams: 16.0,
      carbsGrams: 18.0,
      fatsGrams: 10.0,
      fiberGrams: 4.8,
      category: 'Breakfast',
    ),
    FoodItem(
      id: 'food_rice',
      name: 'Steamed Basmati Rice',
      regionalName: 'उबले बासमती चावल',
      servingUnit: '1 medium katori (150g)',
      calories: 195,
      proteinGrams: 4.0,
      carbsGrams: 43.0,
      fatsGrams: 0.5,
      fiberGrams: 1.0,
      category: 'Grains',
    ),

    // Legumes & Daals
    FoodItem(
      id: 'food_yellow_daal',
      name: 'Tadka Moong / Toor Daal',
      regionalName: 'तड़का मूंग / अरहर दाल',
      servingUnit: '1 large katori (200g)',
      calories: 170,
      proteinGrams: 9.5,
      carbsGrams: 24.0,
      fatsGrams: 4.0,
      fiberGrams: 5.2,
      category: 'Daal',
    ),
    FoodItem(
      id: 'food_rajma',
      name: 'Punjabi Rajma Masala',
      regionalName: 'पंजाबी राजमा मसाला',
      servingUnit: '1 large katori (220g)',
      calories: 240,
      proteinGrams: 13.0,
      carbsGrams: 34.0,
      fatsGrams: 6.0,
      fiberGrams: 9.5,
      category: 'Daal',
    ),
    FoodItem(
      id: 'food_chole',
      name: 'Pindi Chana / Chole',
      regionalName: 'पिंडी छोले',
      servingUnit: '1 bowl (200g)',
      calories: 260,
      proteinGrams: 12.5,
      carbsGrams: 36.0,
      fatsGrams: 7.5,
      fiberGrams: 8.0,
      category: 'Daal',
    ),

    // Dairy & Plant Proteins
    FoodItem(
      id: 'food_paneer_bhurji',
      name: 'Paneer Bhurji / Grilled Paneer',
      regionalName: 'पनीर भुर्जी / ग्रिल्ड पनीर',
      servingUnit: '150g serving',
      calories: 340,
      proteinGrams: 24.0,
      carbsGrams: 6.0,
      fatsGrams: 26.0,
      fiberGrams: 1.2,
      category: 'Dairy',
    ),
    FoodItem(
      id: 'food_curd',
      name: 'Set Dahi / Plain Greek Yogurt',
      regionalName: 'ताजा दही',
      servingUnit: '1 medium katori (150g)',
      calories: 110,
      proteinGrams: 7.0,
      carbsGrams: 8.0,
      fatsGrams: 5.5,
      fiberGrams: 0.0,
      category: 'Dairy',
    ),
    FoodItem(
      id: 'food_soya_chunks',
      name: 'Soya Chunks Curry',
      regionalName: 'सोया बड़ी करी',
      servingUnit: '50g dry equiv (1 bowl)',
      calories: 220,
      proteinGrams: 26.0,
      carbsGrams: 16.0,
      fatsGrams: 1.5,
      fiberGrams: 6.5,
      isVegan: true,
      category: 'Plant Protein',
    ),

    // Non-Veg Options
    FoodItem(
      id: 'food_boiled_eggs',
      name: 'Boiled Eggs (2 whole + 2 whites)',
      regionalName: 'उबले अंडे',
      servingUnit: '4 eggs (2 whole, 2 whites)',
      calories: 210,
      proteinGrams: 22.0,
      carbsGrams: 1.5,
      fatsGrams: 11.0,
      fiberGrams: 0.0,
      isVegetarian: false,
      category: 'Non-Veg',
    ),
    FoodItem(
      id: 'food_chicken_breast',
      name: 'Tandoori Grilled Chicken Breast',
      regionalName: 'तंदूरी चिकन ब्रेस्ट',
      servingUnit: '150g grilled',
      calories: 245,
      proteinGrams: 39.0,
      carbsGrams: 3.0,
      fatsGrams: 7.0,
      fiberGrams: 0.5,
      isVegetarian: false,
      category: 'Non-Veg',
    ),

    // Snacks & Beverages
    FoodItem(
      id: 'food_poha',
      name: 'Kanda Poha with Peanuts',
      regionalName: 'कांदा पोहा',
      servingUnit: '1 medium plate (180g)',
      calories: 240,
      proteinGrams: 6.5,
      carbsGrams: 42.0,
      fatsGrams: 5.5,
      fiberGrams: 3.2,
      category: 'Breakfast',
    ),
    FoodItem(
      id: 'food_makhana',
      name: 'Roasted Makhana (Foxnuts)',
      regionalName: 'भुने हुए मखाने',
      servingUnit: '1 bowl (40g)',
      calories: 145,
      proteinGrams: 4.0,
      carbsGrams: 26.0,
      fatsGrams: 2.0,
      fiberGrams: 3.8,
      category: 'Snack',
    ),
    FoodItem(
      id: 'food_sattu',
      name: 'Chana Sattu Sharbat',
      regionalName: 'चना सत्तू नमकीन शरबत',
      servingUnit: '1 tall glass (40g sattu)',
      calories: 165,
      proteinGrams: 10.5,
      carbsGrams: 25.0,
      fatsGrams: 2.2,
      fiberGrams: 6.0,
      category: 'Snack',
    ),
  ];

  static List<FoodItem> search(String query) {
    if (query.trim().isEmpty) return stapleIndianFoods;
    final lower = query.toLowerCase();
    return stapleIndianFoods
        .where((f) =>
            f.name.toLowerCase().contains(lower) ||
            f.regionalName.toLowerCase().contains(lower) ||
            f.category.toLowerCase().contains(lower))
        .toList();
  }
}
