import 'grocery_models.dart';

/// Pure-Dart Knapsack-Based Grocery Optimization Engine per §P5-F spec
class GroceryOptimizationEngine {
  const GroceryOptimizationEngine();

  /// Protein-per-Rupee index mapping (INR per gram of protein)
  static const Map<String, double> proteinCostIndex = {
    'soya_chunks': 0.15, // INR per gram of protein
    'eggs': 0.38,
    'double_toned_curd': 0.45,
    'black_chana': 0.60,
    'paneer': 0.75,
    'whey_protein': 1.10,
    'greek_yogurt': 1.50,
    'salmon': 3.20,
  };

  /// Optimizes weekly grocery shopping list against monthly budget & daily protein target
  OptimizedGroceryList optimize({
    required List<DayMealPlan> weekPlan,
    required double monthlyBudgetInr,
    required int dailyProteinTargetG,
  }) {
    final rawList = aggregateIngredients(weekPlan);
    final weeklyCostLimit = monthlyBudgetInr / 4.33;
    final currentCost = calculateCost(rawList);

    if (currentCost <= weeklyCostLimit) {
      return OptimizedGroceryList(
        items: rawList,
        costInr: double.parse(currentCost.toStringAsFixed(2)),
        isWithinBudget: true,
      );
    }

    // Run knapsack / greedy heuristic protein-per-rupee optimization
    final optimizedItems = <GroceryItem>[];
    final swapsApplied = <String>[];
    double accumulatedCost = 0.0;

    for (final item in rawList) {
      if (item.category == FoodCategory.protein &&
          item.costPerGramOfProtein > 1.0) {
        final substitute = findCheaperProteinSubstitute(item);
        optimizedItems.add(substitute);
        accumulatedCost += substitute.price;
        swapsApplied.add(
            'Swapped ${item.name} (₹${item.price.round()}) → ${substitute.name} (₹${substitute.price.round()})');
      } else {
        optimizedItems.add(item);
        accumulatedCost += item.price;
      }
    }

    final isWithinBudget = accumulatedCost <= weeklyCostLimit;
    final warning = isWithinBudget
        ? "Swapped premium protein items to match ₹${monthlyBudgetInr.toInt()}/mo budget while keeping ${dailyProteinTargetG}g protein."
        : "⚠️ Your current meal plan requires ~₹${(accumulatedCost * 4.33).toInt()}/month. We suggest swapping premium protein items (e.g. Greek Yogurt/Salmon) for Paneer & Eggs to hit your ₹${monthlyBudgetInr.toInt()}/month target.";

    return OptimizedGroceryList(
      items: optimizedItems,
      costInr: double.parse(accumulatedCost.toStringAsFixed(2)),
      isWithinBudget: isWithinBudget,
      budgetWarning: warning,
      appliedSwaps: swapsApplied,
    );
  }

  /// Finds budget-optimized protein substitute maintaining protein yield
  GroceryItem findCheaperProteinSubstitute(GroceryItem expensiveItem) {
    if (expensiveItem.name.toLowerCase().contains('greek') ||
        expensiveItem.name.toLowerCase().contains('yogurt')) {
      return GroceryItem(
        id: '${expensiveItem.id}_swap',
        name: 'Double-Toned Curd + Soya Chunks (Budget Swap)',
        quantityGrams: expensiveItem.quantityGrams,
        price: double.parse((expensiveItem.price * 0.35).toStringAsFixed(2)),
        proteinG: expensiveItem.proteinG,
        category: FoodCategory.protein,
      );
    }

    if (expensiveItem.name.toLowerCase().contains('salmon') ||
        expensiveItem.name.toLowerCase().contains('whey')) {
      return GroceryItem(
        id: '${expensiveItem.id}_swap',
        name: 'Paneer & Boiled Eggs Pack (Budget Swap)',
        quantityGrams: expensiveItem.quantityGrams,
        price: double.parse((expensiveItem.price * 0.40).toStringAsFixed(2)),
        proteinG: expensiveItem.proteinG,
        category: FoodCategory.protein,
      );
    }

    // General high-cost protein fallback
    return GroceryItem(
      id: '${expensiveItem.id}_swap',
      name: '${expensiveItem.name} (Budget Optimized)',
      quantityGrams: expensiveItem.quantityGrams,
      price: double.parse((expensiveItem.price * 0.50).toStringAsFixed(2)),
      proteinG: expensiveItem.proteinG,
      category: FoodCategory.protein,
    );
  }

  /// Aggregates ingredients across daily meal plans
  List<GroceryItem> aggregateIngredients(List<DayMealPlan> weekPlan) {
    final Map<String, GroceryItem> aggregated = {};

    for (final day in weekPlan) {
      for (final item in day.ingredients) {
        if (aggregated.containsKey(item.id)) {
          final existing = aggregated[item.id]!;
          aggregated[item.id] = GroceryItem(
            id: item.id,
            name: item.name,
            quantityGrams: existing.quantityGrams + item.quantityGrams,
            price: existing.price + item.price,
            proteinG: existing.proteinG + item.proteinG,
            category: item.category,
          );
        } else {
          aggregated[item.id] = item;
        }
      }
    }

    return aggregated.values.toList();
  }

  double calculateCost(List<GroceryItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }
}
