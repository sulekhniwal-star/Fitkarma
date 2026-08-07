import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/grocery_models.dart';
import 'package:fitkarma/features/nutrition/models/grocery_optimization_engine.dart';
import 'package:fitkarma/features/nutrition/screens/grocery_optimization_screen.dart';

void main() {
  group('§P5-F Grocery Optimization Engine 2.0 Tests', () {
    const engine = GroceryOptimizationEngine();

    final expensivePlan = List.generate(7, (i) {
      return DayMealPlan(
        dayName: 'Day ${i + 1}',
        ingredients: const [
          GroceryItem(id: 'g1', name: 'Greek Yogurt', quantityGrams: 200, price: 180, proteinG: 20, category: FoodCategory.protein),
          GroceryItem(id: 'g2', name: 'Salmon Fillet', quantityGrams: 150, price: 450, proteinG: 34, category: FoodCategory.protein),
        ],
      );
    });

    test('proteinCostIndex maps soya_chunks, eggs, curd, paneer INR per gram of protein correctly', () {
      expect(GroceryOptimizationEngine.proteinCostIndex['soya_chunks'], equals(0.15));
      expect(GroceryOptimizationEngine.proteinCostIndex['eggs'], equals(0.38));
      expect(GroceryOptimizationEngine.proteinCostIndex['double_toned_curd'], equals(0.45));
      expect(GroceryOptimizationEngine.proteinCostIndex['paneer'], equals(0.75));
    });

    test('optimize performs protein-per-rupee swaps when raw cost exceeds monthly budget', () {
      final result = engine.optimize(
        weekPlan: expensivePlan,
        monthlyBudgetInr: 3000.0, // Limit ~700 INR/week
        dailyProteinTargetG: 110,
      );

      expect(result.appliedSwaps, isNotEmpty);
      expect(result.items.any((i) => i.name.contains('Budget Swap')), isTrue);
      expect(result.costInr, lessThan(4410.0)); // Less than raw 7 * (180+450)
    });

    test('optimize edge-case: generates clear warning when budget is too low even after swaps', () {
      final result = engine.optimize(
        weekPlan: expensivePlan,
        monthlyBudgetInr: 500.0, // Extremely low budget
        dailyProteinTargetG: 150,
      );

      expect(result.isWithinBudget, isFalse);
      expect(result.budgetWarning, contains('Your current meal plan requires'));
    });

    testWidgets('GroceryOptimizationScreen renders budget sliders, cost summaries, and swap list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: GroceryOptimizationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Grocery Optimizer 2.0'), findsOneWidget);
      expect(find.text('Monthly Budget Limit:'), findsOneWidget);
      expect(find.text('Weekly Cost'), findsOneWidget);
      expect(find.text('Optimized Shopping List:'), findsOneWidget);
    });
  });
}
