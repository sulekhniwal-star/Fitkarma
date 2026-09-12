import '../models/nutrition_models.dart';

class IndianFoodSwapEngine {
  const IndianFoodSwapEngine();

  /// Curated Indian Food Substitution Catalog
  static const List<FoodSwap> curatedSwaps = [
    FoodSwap(
      id: 'swap_white_rice_to_ragi',
      originalFoodName: 'Steamed White Rice (1 Katori)',
      swapFoodName: 'Ragi Mudde / Millet Bowl',
      swapFoodNameHindi: 'रागी मुड्डे या कंगनी मिलेट',
      category: 'Staple',
      reason: 'Reduces glycemic index from 73 to 44, preventing post-prandial insulin spikes.',
      reasonHindi: 'ग्लाइसेमिक इंडेक्स ७३ से घटकर ४४ हो जाता है, जिससे इंसुलिन स्पाइक नहीं होता।',
      glycemicReductionPercent: 39.7,
      proteinGainPercent: 12.5,
      calorieDifference: -80,
    ),
    FoodSwap(
      id: 'swap_maida_naan_to_jowar',
      originalFoodName: 'Butter Naan / Rumali Roti (Maida)',
      swapFoodName: 'Jowar & Bajra Bhakri (Multi-millet)',
      swapFoodNameHindi: 'ज्वार व बाजरे की भाकरी',
      category: 'Staple',
      reason: 'Eliminates inflammatory refined flour (maida) and provides 4.5g of slow-digesting fiber.',
      reasonHindi: 'मैदा हटाकर ४.५ ग्राम फाइबर प्रदान करता है जो पाचन और तृप्ति में सहायक है।',
      glycemicReductionPercent: 35.0,
      proteinGainPercent: 22.0,
      calorieDifference: -120,
    ),
    FoodSwap(
      id: 'swap_samosa_to_makhana',
      originalFoodName: 'Deep Fried Potato Samosa',
      swapFoodName: 'Air-popped Roasted Salted Makhana',
      swapFoodNameHindi: 'भुना हुआ कुरकुरा मखाना',
      category: 'Street Food & Snacks',
      reason: 'Saves 145 kcal and reduces saturated fats by 88% while offering high magnesium and calcium.',
      reasonHindi: '१४५ कैलोरी बचाता है और ८८% सैचुरेटेड फैट कम करता है।',
      glycemicReductionPercent: 51.2,
      proteinGainPercent: 18.0,
      calorieDifference: -145,
    ),
    FoodSwap(
      id: 'swap_bhujia_to_roasted_chana',
      originalFoodName: 'Haldiram Aloo Bhujia / Sev (50g)',
      swapFoodName: 'Roasted Black Chana with Skin (50g)',
      swapFoodNameHindi: 'भुना हुआ छिलके वाला चना',
      category: 'Snack',
      reason: 'Replaces palm oil and refined starch with 11g of plant protein and 8g of resistant starch.',
      reasonHindi: 'पाम ऑयल की जगह ११ ग्राम प्रोटीन और ८ ग्राम फाइबर प्रदान करता है।',
      glycemicReductionPercent: 62.0,
      proteinGainPercent: 140.0,
      calorieDifference: -95,
    ),
    FoodSwap(
      id: 'swap_chai_sugar_to_kadha',
      originalFoodName: 'Full Cream Chai with 2 tsp Sugar',
      swapFoodName: 'Cinnamon Spiced Kadha / Green Tea',
      swapFoodNameHindi: 'दालचीनी युक्त मसाला काढ़ा या ग्रीन टी',
      category: 'Beverage',
      reason: 'Cinnamon naturally sensitizes insulin receptors and eliminates 12g of empty liquid sucrose.',
      reasonHindi: 'दालचीनी इंसुलिन संवेदनशीलता बढ़ाती है और १२ ग्राम अतिरिक्त चीनी बचाती है।',
      glycemicReductionPercent: 100.0,
      proteinGainPercent: 0.0,
      calorieDifference: -80,
    ),
    FoodSwap(
      id: 'swap_gulab_jamun_to_paneer_kheer',
      originalFoodName: 'Fried Gulab Jamun (2 pcs in Sugar Syrup)',
      swapFoodName: 'Stevia Sweetened Paneer / Makhana Kheer',
      swapFoodNameHindi: 'स्टीविया पनीर या मखाना खीर',
      category: 'Sweets',
      reason: 'Transforms a pure sugar-fat bomb into a high-protein, low-carb dessert with 12g protein.',
      reasonHindi: '१२ ग्राम शुद्ध प्रोटीन युक्त मिठाई जो ब्लड शुगर को नियंत्रित रखती है।',
      glycemicReductionPercent: 70.0,
      proteinGainPercent: 200.0,
      calorieDifference: -210,
    ),
  ];

  /// Find applicable swaps for a given food name
  List<FoodSwap> findSwapsFor(String foodName) {
    final lower = foodName.toLowerCase().trim();
    return curatedSwaps.where((s) {
      return s.originalFoodName.toLowerCase().contains(lower) || lower.contains(s.originalFoodName.toLowerCase());
    }).toList();
  }

  /// Get all swaps grouped by category
  Map<String, List<FoodSwap>> getSwapsByCategory() {
    final Map<String, List<FoodSwap>> map = {};
    for (final swap in curatedSwaps) {
      map.putIfAbsent(swap.category, () => []).add(swap);
    }
    return map;
  }
}
