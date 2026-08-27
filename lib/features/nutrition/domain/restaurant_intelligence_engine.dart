import 'nutrition_models.dart';

class RestaurantChainPreset {
  final String chainName;
  final String regionalName;
  final String cuisineType;
  final List<FoodItem> menuItems;
  final List<SmartFoodSwap> recommendedSwaps;

  const RestaurantChainPreset({
    required this.chainName,
    required this.regionalName,
    required this.cuisineType,
    required this.menuItems,
    required this.recommendedSwaps,
  });
}

class SmartFoodSwap {
  final String badItemName;
  final String goodItemName;
  final String caloriesSaved;
  final String proteinGain;
  final String rationale;

  const SmartFoodSwap({
    required this.badItemName,
    required this.goodItemName,
    required this.caloriesSaved,
    required this.proteinGain,
    required this.rationale,
  });
}

class RestaurantIntelligenceEngine {
  static const List<SmartFoodSwap> universalDiningSwaps = [
    SmartFoodSwap(
      badItemName: 'Butter Naan (320 kcal)',
      goodItemName: 'Tandoori Roti (110 kcal)',
      caloriesSaved: '-210 kcal',
      proteinGain: 'Same Protein',
      rationale: 'Avoids refined maida and butter brushing; saves 210 surplus calories per bread.',
    ),
    SmartFoodSwap(
      badItemName: 'Paneer Makhani / Butter Masala',
      goodItemName: 'Paneer Tikka (Tandoori)',
      caloriesSaved: '-180 kcal',
      proteinGain: '+8g Protein',
      rationale: 'Skips heavy cashew-cream gravy while maximizing direct curd-marinated paneer protein.',
    ),
    SmartFoodSwap(
      badItemName: 'Sweet Mango Lassi (290 kcal)',
      goodItemName: 'Masala Chaas / Buttermilk (45 kcal)',
      caloriesSaved: '-245 kcal',
      proteinGain: '+3g Protein, 0g Sugar',
      rationale: 'Cuts 40g refined sugar while providing active probiotics and electrolytes.',
    ),
    SmartFoodSwap(
      badItemName: 'Fried Samosa (280 kcal)',
      goodItemName: 'Sprouts Chaat / Moong Chilla',
      caloriesSaved: '-140 kcal',
      proteinGain: '+10g Protein',
      rationale: 'Replaces deep-fried palm oil crust with high-fiber sprouted legume protein.',
    ),
  ];

  static const List<RestaurantChainPreset> chainPresets = [
    RestaurantChainPreset(
      chainName: 'Dhaba & North Indian Restaurant',
      regionalName: 'ढाबा एवं उत्तर भारतीय भोजन',
      cuisineType: 'North Indian / Mughlai',
      menuItems: [
        FoodItem(
          id: 'resto_tandoori_chicken',
          name: 'Tandoori Chicken (Half)',
          regionalName: 'तंदूरी चिकन (आधा)',
          servingUnit: '2 large pieces (250g)',
          calories: 320,
          proteinGrams: 46.0,
          carbsGrams: 4.0,
          fatsGrams: 12.0,
          fiberGrams: 1.0,
          isVegetarian: false,
          category: 'Tandoor',
        ),
        FoodItem(
          id: 'resto_paneer_tikka',
          name: 'Tandoori Paneer Tikka',
          regionalName: 'पनीर टिक्का (तंदूरी)',
          servingUnit: '6 pieces (200g)',
          calories: 340,
          proteinGrams: 24.0,
          carbsGrams: 8.0,
          fatsGrams: 22.0,
          fiberGrams: 2.0,
          category: 'Tandoor',
        ),
        FoodItem(
          id: 'resto_tandoori_roti',
          name: 'Plain Tandoori Roti',
          regionalName: 'तंदूरी रोटी (बिना मक्खन)',
          servingUnit: '1 roti (45g)',
          calories: 110,
          proteinGrams: 3.5,
          carbsGrams: 22.0,
          fatsGrams: 0.5,
          fiberGrams: 2.5,
          category: 'Roti',
        ),
      ],
      recommendedSwaps: [
        SmartFoodSwap(
          badItemName: 'Butter Chicken Gravy',
          goodItemName: 'Tandoori Chicken + Green Chutney',
          caloriesSaved: '-260 kcal',
          proteinGain: '+14g Protein',
          rationale: 'Avoids heavy cashew cream gravy while maximizing lean tandoori protein.',
        ),
      ],
    ),
    RestaurantChainPreset(
      chainName: 'Udupi / South Indian Cafe',
      regionalName: 'उडुपी / दक्षिण भारतीय कैफे',
      cuisineType: 'South Indian',
      menuItems: [
        FoodItem(
          id: 'resto_steamed_idli',
          name: 'Steamed Idlis with Sambar',
          regionalName: 'इडली सांभर (3 पीस)',
          servingUnit: '3 idlis + 1 bowl sambar',
          calories: 230,
          proteinGrams: 8.5,
          carbsGrams: 46.0,
          fatsGrams: 1.5,
          fiberGrams: 4.5,
          category: 'South Indian',
        ),
        FoodItem(
          id: 'resto_plain_dosa',
          name: 'Plain Paper Dosa (No Ghee)',
          regionalName: 'प्लेन डोसा',
          servingUnit: '1 large dosa',
          calories: 220,
          proteinGrams: 5.5,
          carbsGrams: 38.0,
          fatsGrams: 4.0,
          fiberGrams: 2.0,
          category: 'South Indian',
        ),
      ],
      recommendedSwaps: [
        SmartFoodSwap(
          badItemName: 'Ghee Roast Masala Dosa (480 kcal)',
          goodItemName: 'Steamed Idli + Extra Sambar (230 kcal)',
          caloriesSaved: '-250 kcal',
          proteinGain: '+3g Protein',
          rationale: 'Cuts 25g saturated ghee while doubling legume lentil intake from sambar.',
        ),
      ],
    ),
  ];
}
