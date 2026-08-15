import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';
import 'package:fitkarma/features/nutrition/providers/nutrition_provider.dart';
import 'package:fitkarma/features/nutrition/screens/food_home_screen.dart';

void main() {
  group('§P5-A Food Screen Home & Nutrition Engine Tests', () {
    const engine = NutritionEngine();

    // ── NutritionEngine Unit Tests ───────────────────────────────────────────

    test(
        'calculateMealQuality computes 5-dimension score, readiness & goal impact',
        () {
      final item = SeededIndianFoodDatabase.items
          .firstWhere((i) => i.id == 'f1'); // Paneer Tikka
      final result = engine.calculateMealQuality(item);

      expect(result.overallScore, greaterThan(0));
      expect(result.readinessImpact, contains('support recovery'));
      expect(result.goalImpact, contains('fat-loss goal'));
    });

    test('isProteinDeficitAlert triggers when logged protein < 70% of target',
        () {
      expect(
          engine.isProteinDeficitAlert(
              loggedProtein: 50.0, targetProtein: 110.0),
          isTrue); // 50 < 77
      expect(
          engine.isProteinDeficitAlert(
              loggedProtein: 80.0, targetProtein: 110.0),
          isFalse); // 80 >= 77
    });

    test('generateProteinAlertText returns expected rule-based guidance string',
        () {
      final text = engine.generateProteinAlertText();
      expect(text, contains('Protein low'));
      expect(text, contains('paneer'));
    });

    // ── NutritionNotifier Unit Tests ─────────────────────────────────────────

    test(
        'NutritionNotifier initializes with sample logged meals and computes macros',
        () {
      final notifier = NutritionNotifier(const NutritionEngine());
      expect(notifier.state.loggedMeals, isNotEmpty);
      expect(notifier.state.totalCalories, greaterThan(0));
      expect(notifier.state.totalProtein, greaterThan(0));
    });

    test('logMeal adds new entry and updates macro totals', () {
      final notifier = NutritionNotifier(const NutritionEngine());
      final prevCals = notifier.state.totalCalories;

      notifier.logMeal(
        type: MealType.dinner,
        foodItem: SeededIndianFoodDatabase.items
            .firstWhere((i) => i.id == 'f8'), // Chicken Curry
      );

      expect(notifier.state.totalCalories, greaterThan(prevCals));
      expect(notifier.state.loggedMeals.last.foodItem.name,
          equals('Chicken Curry'));
    });

    test('toggleSection collapses and expands section visibility', () {
      final notifier = NutritionNotifier(const NutritionEngine());
      expect(notifier.state.sectionExpanded[MealType.breakfast], isTrue);

      notifier.toggleSection(MealType.breakfast);
      expect(notifier.state.sectionExpanded[MealType.breakfast], isFalse);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'FoodHomeScreen renders Summary card, meal sections, and DIP insight',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: FoodHomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Indian Nutrition'), findsOneWidget);
      expect(find.text('Today\'s Nutrition Summary'), findsOneWidget);
      expect(find.text('🌅 Breakfast'), findsOneWidget);
      expect(find.text('☀️ Lunch'), findsOneWidget);
      expect(find.text('🌙 Dinner'), findsOneWidget);
      expect(find.text('🍎 Snacks'), findsOneWidget);
      expect(find.text('Daily Intelligence Insight'), findsOneWidget);
    });
  });
}
