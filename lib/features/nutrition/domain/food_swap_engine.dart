import 'nutrition_models.dart';

enum SwapCategory {
  proteinBoost(
    label: 'Protein Upgrade',
    regionalLabel: 'प्रोटीन वृद्धि',
    colorCode: 0xff22C55E, // Karma Green
    iconName: 'fitness_center_rounded',
  ),
  glycemicControl(
    label: 'Low GI / Fiber Boost',
    regionalLabel: 'ग्लाइसेमिक एवं फाइबर नियंत्रण',
    colorCode: 0xff3B82F6, // Focus Blue
    iconName: 'show_chart_rounded',
  ),
  calorieReduction(
    label: 'Caloric Deficit / Fat Cut',
    regionalLabel: 'कैलोरी एवं वसा कटौती',
    colorCode: 0xffFF9100, // Energy Orange
    iconName: 'local_fire_department_rounded',
  ),
  ayurvedicGut(
    label: 'Digestive & Gut Synergy',
    regionalLabel: 'पाचन एवं आंत स्वास्थ्य',
    colorCode: 0xff7C4DFF, // AI Purple
    iconName: 'spa_rounded',
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String iconName;

  const SwapCategory({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.iconName,
  });
}

class IndianFoodSwap {
  final String id;
  final SwapCategory category;
  final FoodItem originalItem;
  final FoodItem suggestedItem;
  final int tasteFidelityScore; // 1 to 5 Stars (cultural satisfaction)
  final String culinaryPreparationTip;
  final String physiologicalAdvantage;

  const IndianFoodSwap({
    required this.id,
    required this.category,
    required this.originalItem,
    required this.suggestedItem,
    required this.tasteFidelityScore,
    required this.culinaryPreparationTip,
    required this.physiologicalAdvantage,
  });

  int get deltaCalories => suggestedItem.calories - originalItem.calories;
  double get deltaProtein => double.parse((suggestedItem.proteinGrams - originalItem.proteinGrams).toStringAsFixed(1));
  double get deltaCarbs => double.parse((suggestedItem.carbsGrams - originalItem.carbsGrams).toStringAsFixed(1));
  double get deltaFats => double.parse((suggestedItem.fatsGrams - originalItem.fatsGrams).toStringAsFixed(1));
  double get deltaFiber => double.parse((suggestedItem.fiberGrams - originalItem.fiberGrams).toStringAsFixed(1));
}

class FoodSwapEngine {
  static const List<IndianFoodSwap> stapleSwaps = [
    // 1. Protein Upgrades
    IndianFoodSwap(
      id: 'swap_aloo_to_sattu_paratha',
      category: SwapCategory.proteinBoost,
      originalItem: FoodItem(
        id: 'orig_aloo_paratha',
        name: 'Aloo Paratha (with Butter)',
        regionalName: 'आलू पराठा (मक्खन सहित)',
        servingUnit: '1 paratha (120g)',
        calories: 320,
        proteinGrams: 5.5,
        carbsGrams: 42.0,
        fatsGrams: 14.0,
        fiberGrams: 3.0,
        category: 'Roti/Bread',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_sattu_paratha',
        name: 'Sattu Stuffed Paratha',
        regionalName: 'सत्तू भरा पराठा (कम तेल)',
        servingUnit: '1 paratha (120g)',
        calories: 260,
        proteinGrams: 15.0,
        carbsGrams: 34.0,
        fatsGrams: 6.5,
        fiberGrams: 7.5,
        category: 'Roti/Bread',
      ),
      tasteFidelityScore: 5,
      culinaryPreparationTip: 'Knead with ajwain, roasted jeera, and fresh green chillies for authentic Bihari flavor.',
      physiologicalAdvantage: '+9.5g high-DIAAS roasted chickpea protein with 2.5x dietary fiber.',
    ),
    IndianFoodSwap(
      id: 'swap_white_rice_to_soya_pulao',
      category: SwapCategory.proteinBoost,
      originalItem: FoodItem(
        id: 'orig_white_rice',
        name: 'White Polished Rice',
        regionalName: 'सफेद चावल (१ कटोरी)',
        servingUnit: '1 katori (150g)',
        calories: 195,
        proteinGrams: 3.8,
        carbsGrams: 42.0,
        fatsGrams: 0.5,
        fiberGrams: 0.6,
        category: 'Roti/Bread',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_soya_pulao',
        name: 'Soya Chunks & Veg Pulao',
        regionalName: 'सोया चंक्स वेज पुलाव',
        servingUnit: '1 katori (150g)',
        calories: 210,
        proteinGrams: 17.5,
        carbsGrams: 28.0,
        fatsGrams: 3.0,
        fiberGrams: 4.8,
        category: 'Roti/Bread',
      ),
      tasteFidelityScore: 5,
      culinaryPreparationTip: 'Boil soya chunks in mild salted turmeric water, squeeze thoroughly, and saute with whole garam masala.',
      physiologicalAdvantage: '+13.7g protein per bowl; turns high-glycemic starch into an anabolic complete meal.',
    ),

    // 2. Glycemic & Fiber Swaps
    IndianFoodSwap(
      id: 'swap_maida_naan_to_ragi_roti',
      category: SwapCategory.glycemicControl,
      originalItem: FoodItem(
        id: 'orig_butter_naan',
        name: 'Butter Naan (Maida)',
        regionalName: 'बटर नान (मैदा)',
        servingUnit: '1 piece (90g)',
        calories: 290,
        proteinGrams: 6.0,
        carbsGrams: 48.0,
        fatsGrams: 9.0,
        fiberGrams: 1.2,
        category: 'Roti/Bread',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_ragi_missi_roti',
        name: 'Ragi & Besan Missi Roti',
        regionalName: 'रागी-बेसन मिस्सी रोटी',
        servingUnit: '1 roti (60g)',
        calories: 155,
        proteinGrams: 6.8,
        carbsGrams: 24.0,
        fatsGrams: 3.0,
        fiberGrams: 5.5,
        category: 'Roti/Bread',
      ),
      tasteFidelityScore: 4,
      culinaryPreparationTip: 'Mix 50% Ragi and 50% Besan with kasuri methi and warm water for soft texture.',
      physiologicalAdvantage: 'Reduces Glycemic Load by 60%; rich in bioavailable Calcium and slow-digesting polyphenols.',
    ),
    IndianFoodSwap(
      id: 'swap_white_poha_to_sprouted_moong_poha',
      category: SwapCategory.glycemicControl,
      originalItem: FoodItem(
        id: 'orig_plain_poha',
        name: 'Traditional Aloo Poha',
        regionalName: 'आलू पोहा (१ प्लेट)',
        servingUnit: '1 plate (160g)',
        calories: 270,
        proteinGrams: 4.0,
        carbsGrams: 48.0,
        fatsGrams: 7.0,
        fiberGrams: 2.0,
        category: 'Snack',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_sprout_poha',
        name: 'Sprouted Moong & Veg Poha',
        regionalName: 'अंकुरित मूंग वेज पोहा',
        servingUnit: '1 plate (160g)',
        calories: 220,
        proteinGrams: 12.5,
        carbsGrams: 32.0,
        fatsGrams: 4.5,
        fiberGrams: 6.0,
        category: 'Snack',
      ),
      tasteFidelityScore: 5,
      culinaryPreparationTip: 'Add 50% sprouted moong + 50% red rice poha with mustard seeds, curry leaves, and lemon juice.',
      physiologicalAdvantage: 'Prevents 10:30 AM mid-morning energy crashes by flattening the insulin spike.',
    ),

    // 3. Caloric Deficit & Fat Cut Swaps
    IndianFoodSwap(
      id: 'swap_samosa_to_roasted_makhana',
      category: SwapCategory.calorieReduction,
      originalItem: FoodItem(
        id: 'orig_fried_samosa',
        name: 'Deep-Fried Punjabi Samosa',
        regionalName: 'तला हुआ समोसा (२ पीस)',
        servingUnit: '2 pieces (160g)',
        calories: 520,
        proteinGrams: 7.0,
        carbsGrams: 58.0,
        fatsGrams: 29.0,
        fiberGrams: 3.5,
        category: 'Snack',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_roasted_makhana',
        name: 'Ghee-Roasted Spiced Makhana',
        regionalName: 'भुना मसाला मखाना (१ बड़ा कटोरा)',
        servingUnit: '1 bowl (40g)',
        calories: 165,
        proteinGrams: 4.5,
        carbsGrams: 26.0,
        fatsGrams: 4.8,
        fiberGrams: 4.2,
        category: 'Snack',
      ),
      tasteFidelityScore: 4,
      culinaryPreparationTip: 'Roast with 1/2 tsp pure A2 desi ghee, rock salt (sendha namak), chaat masala, and black pepper.',
      physiologicalAdvantage: 'Saves 355 kcal and eliminates oxidized trans-fats; rich in anti-aging flavonoids.',
    ),
    IndianFoodSwap(
      id: 'swap_malai_paneer_to_lowfat_paneer',
      category: SwapCategory.calorieReduction,
      originalItem: FoodItem(
        id: 'orig_malai_paneer',
        name: 'Full-Fat Malai Paneer',
        regionalName: 'मलाई पनीर (१५० ग्राम)',
        servingUnit: '150g raw',
        calories: 450,
        proteinGrams: 27.0,
        carbsGrams: 4.5,
        fatsGrams: 36.0,
        fiberGrams: 0.0,
        category: 'Dairy',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_lowfat_paneer',
        name: 'Low-Fat Cow Milk Paneer',
        regionalName: 'लो-फैट पनीर (१५० ग्राम)',
        servingUnit: '150g raw',
        calories: 255,
        proteinGrams: 36.0,
        carbsGrams: 6.0,
        fatsGrams: 8.5,
        fiberGrams: 0.0,
        category: 'Dairy',
      ),
      tasteFidelityScore: 5,
      culinaryPreparationTip: 'Soak diced low-fat paneer in warm salted water for 5 minutes before cooking for ultra-soft texture.',
      physiologicalAdvantage: 'Saves 195 kcal while increasing bioavailable casein protein by +9.0g.',
    ),

    // 4. Ayurvedic & Gut Health Swaps
    IndianFoodSwap(
      id: 'swap_sweet_tea_to_masala_chaas',
      category: SwapCategory.ayurvedicGut,
      originalItem: FoodItem(
        id: 'orig_sweet_chai',
        name: 'Full Cream Chai (2 tsp Sugar)',
        regionalName: 'मीठी मसाला चाय (२ कप)',
        servingUnit: '2 cups (300ml)',
        calories: 220,
        proteinGrams: 5.0,
        carbsGrams: 30.0,
        fatsGrams: 8.8,
        fiberGrams: 0.0,
        category: 'Dairy',
      ),
      suggestedItem: FoodItem(
        id: 'sugg_spiced_chaas',
        name: 'Spiced Mint Buttermilk (Chaas)',
        regionalName: 'पुदीना-जीरा छाछ (२ गिलास)',
        servingUnit: '2 glasses (400ml)',
        calories: 75,
        proteinGrams: 6.5,
        carbsGrams: 8.0,
        fatsGrams: 1.8,
        fiberGrams: 0.5,
        category: 'Dairy',
      ),
      tasteFidelityScore: 5,
      culinaryPreparationTip: 'Whisk dahi with cold water, roasted jeera, fresh mint, black salt, and a pinch of hing.',
      physiologicalAdvantage: 'Pitta-pacifying probiotic culture that accelerates gastric digestion without blood sugar spikes.',
    ),
  ];

  /// Find recommended swaps for a logged food item or category
  static List<IndianFoodSwap> getSwapsForCategory(SwapCategory? category) {
    if (category == null) return stapleSwaps;
    return stapleSwaps.where((s) => s.category == category).toList();
  }

  static IndianFoodSwap? findSwapForFoodName(String foodName) {
    final lower = foodName.toLowerCase();
    return stapleSwaps.firstWhere(
      (s) => s.originalItem.name.toLowerCase().contains(lower) || s.suggestedItem.name.toLowerCase().contains(lower),
      orElse: () => stapleSwaps.first,
    );
  }
}
