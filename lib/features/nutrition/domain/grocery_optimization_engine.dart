class GroceryItem {
  final String id;
  final String name;
  final String regionalName;
  final String quantity; // e.g. '1 kg', '2 dozen', '500g'
  final int estimatedPriceInr;
  final double totalProteinGrams;
  final String category; // 'Protein Staples', 'Produce & Greens', 'Grains', 'Pantry'
  final bool isChecked;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.quantity,
    required this.estimatedPriceInr,
    required this.totalProteinGrams,
    required this.category,
    this.isChecked = false,
  });

  double get costPerGramProtein => totalProteinGrams > 0
      ? double.parse((estimatedPriceInr / totalProteinGrams).toStringAsFixed(2))
      : 0.0;

  GroceryItem copyWith({bool? isChecked}) {
    return GroceryItem(
      id: id,
      name: name,
      regionalName: regionalName,
      quantity: quantity,
      estimatedPriceInr: estimatedPriceInr,
      totalProteinGrams: totalProteinGrams,
      category: category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class WeeklyGroceryPlan {
  final List<GroceryItem> items;
  final int totalEstimatedCostInr;
  final double totalProteinYieldGrams;
  final double averageCostPerGramProtein;

  const WeeklyGroceryPlan({
    required this.items,
    required this.totalEstimatedCostInr,
    required this.totalProteinYieldGrams,
    required this.averageCostPerGramProtein,
  });
}

class GroceryOptimizationEngine {
  /// Pure Dart deterministic compilation of a weekly budget-optimized Indian grocery list
  static WeeklyGroceryPlan generateWeeklyGroceryPlan({
    required int dailyProteinTargetGrams,
    bool isVegetarian = true,
  }) {
    final List<GroceryItem> items = [
      // 1. Protein Staples
      const GroceryItem(
        id: 'g_soya',
        name: 'Soya Chunks (Nutrela)',
        regionalName: 'सोया बड़ी',
        quantity: '500g pack',
        estimatedPriceInr: 55,
        totalProteinGrams: 260.0,
        category: 'Protein Staples',
      ),
      const GroceryItem(
        id: 'g_sattu',
        name: 'Roasted Chana Sattu',
        regionalName: 'चना सत्तू',
        quantity: '1 kg pack',
        estimatedPriceInr: 120,
        totalProteinGrams: 250.0,
        category: 'Protein Staples',
      ),
      const GroceryItem(
        id: 'g_moong_daal',
        name: 'Yellow Moong Daal & Sprouting Moong',
        regionalName: 'मूंग दाल व साबुत मूंग',
        quantity: '1 kg pack',
        estimatedPriceInr: 140,
        totalProteinGrams: 240.0,
        category: 'Protein Staples',
      ),
      const GroceryItem(
        id: 'g_paneer_dahi',
        name: 'Low-Fat Fresh Paneer & Dahi',
        regionalName: 'ताजा पनीर एवं दही',
        quantity: '1 kg paneer + 1 kg curd',
        estimatedPriceInr: 450,
        totalProteinGrams: 250.0,
        category: 'Protein Staples',
      ),

      if (!isVegetarian) ...[
        const GroceryItem(
          id: 'g_eggs',
          name: 'Farm Fresh Eggs',
          regionalName: 'अंडे',
          quantity: '2 crates (60 eggs)',
          estimatedPriceInr: 420,
          totalProteinGrams: 360.0,
          category: 'Protein Staples',
        ),
        const GroceryItem(
          id: 'g_chicken',
          name: 'Fresh Chicken Breast',
          regionalName: 'चिकन ब्रेस्ट',
          quantity: '1.5 kg',
          estimatedPriceInr: 420,
          totalProteinGrams: 450.0,
          category: 'Protein Staples',
        ),
      ],

      // 2. Produce & Greens
      const GroceryItem(
        id: 'g_palak',
        name: 'Fresh Spinach (Palak) & Methi',
        regionalName: 'पालक एवं मेथी',
        quantity: '1 kg',
        estimatedPriceInr: 60,
        totalProteinGrams: 28.0,
        category: 'Produce & Greens',
      ),
      const GroceryItem(
        id: 'g_cucumber_tomato',
        name: 'Salad Cucumbers & Tomatoes',
        regionalName: 'खीरा एवं टमाटर',
        quantity: '2 kg',
        estimatedPriceInr: 80,
        totalProteinGrams: 15.0,
        category: 'Produce & Greens',
      ),

      // 3. Grains & Complex Carbs
      const GroceryItem(
        id: 'g_atta',
        name: 'Multigrain / Whole Wheat Atta',
        regionalName: 'मल्टीग्रेन आटा',
        quantity: '5 kg bag',
        estimatedPriceInr: 240,
        totalProteinGrams: 600.0,
        category: 'Grains & Carbs',
      ),
      const GroceryItem(
        id: 'g_millet',
        name: 'Foxtail / Little Millets',
        regionalName: 'कंगनी / कुटकी बाजरा',
        quantity: '1 kg pack',
        estimatedPriceInr: 110,
        totalProteinGrams: 110.0,
        category: 'Grains & Carbs',
      ),
    ];

    final totalCost = items.fold<int>(0, (sum, i) => sum + i.estimatedPriceInr);
    final totalProtein = items.fold<double>(0.0, (sum, i) => sum + i.totalProteinGrams);
    final avgCostPerGram = totalProtein > 0 ? (totalCost / totalProtein) : 0.0;

    return WeeklyGroceryPlan(
      items: items,
      totalEstimatedCostInr: totalCost,
      totalProteinYieldGrams: double.parse(totalProtein.toStringAsFixed(1)),
      averageCostPerGramProtein: double.parse(avgCostPerGram.toStringAsFixed(2)),
    );
  }
}
