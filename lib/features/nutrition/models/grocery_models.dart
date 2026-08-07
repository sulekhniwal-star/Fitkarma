enum FoodCategory { protein, carbs, fats, produce, dairy, staples }

class GroceryItem {
  final String id;
  final String name;
  final double quantityGrams;
  final double price; // in INR
  final double proteinG;
  final FoodCategory category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantityGrams,
    required this.price,
    required this.proteinG,
    required this.category,
  });

  /// Cost in INR per gram of protein
  double get costPerGramOfProtein {
    if (proteinG <= 0) return 999.0;
    return price / proteinG;
  }
}

class OptimizedGroceryList {
  final List<GroceryItem> items;
  final double costInr;
  final bool isWithinBudget;
  final String? budgetWarning;
  final List<String> appliedSwaps;

  const OptimizedGroceryList({
    required this.items,
    required this.costInr,
    required this.isWithinBudget,
    this.budgetWarning,
    this.appliedSwaps = const [],
  });
}

class DayMealPlan {
  final String dayName;
  final List<GroceryItem> ingredients;

  const DayMealPlan({required this.dayName, required this.ingredients});
}
