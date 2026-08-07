import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';
import 'package:fitkarma/features/nutrition/models/meal_analysis_pipeline.dart';
import 'package:fitkarma/features/nutrition/widgets/meal_analysis_result_sheet.dart';

void main() {
  group('§P5-B Meal Analysis Pipeline End-to-End Tests', () {
    const pipeline = MealAnalysisPipeline();

    test('processMealEntry runs 5-stage pipeline: Macros, 5D Score, Readiness/Goal Impact, Fix Suggestions', () {
      final item = SeededIndianFoodDatabase.items.firstWhere((i) => i.id == 'f6'); // Poha
      final result = pipeline.processMealEntry(foodItem: item, servings: 1.0, userGoal: 'Fat Loss');

      // Stage 2: Macros
      expect(result.totalCalories, equals(250.0));
      expect(result.totalProteinGrams, equals(6.5));

      // Stage 3: 5D Score
      expect(result.quality.overallScore, greaterThan(0));

      // Stage 4: Readiness & Goal Impact
      expect(result.readinessImpact, isNotEmpty);
      expect(result.goalImpact, isNotEmpty);

      // Stage 5: Fix Suggestions
      expect(result.fixSuggestions, isNotEmpty);
      expect(result.fixSuggestions.any((s) => s.contains('Paneer') || s.contains('eggs')), isTrue);
    });

    test('processMealEntry generates clean result for balanced high-protein item', () {
      final item = SeededIndianFoodDatabase.items.firstWhere((i) => i.id == 'f8'); // Chicken Curry
      final result = pipeline.processMealEntry(foodItem: item, servings: 1.0, userGoal: 'Fat Loss');

      expect(result.totalProteinGrams, equals(28.0));
      expect(result.quality.overallScore, greaterThan(70));
    });

    testWidgets('MealAnalysisResultSheet renders pipeline outputs correctly', (tester) async {
      final item = SeededIndianFoodDatabase.items.firstWhere((i) => i.id == 'f1'); // Paneer Tikka
      final result = pipeline.processMealEntry(foodItem: item, servings: 1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealAnalysisResultSheet(
              result: result,
              onConfirmLog: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Paneer Tikka'), findsOneWidget);
      expect(find.text('280 kcal · 1.0 serving(s)'), findsOneWidget);
      expect(find.text('Readiness Impact'), findsOneWidget);
      expect(find.text('Goal Impact'), findsOneWidget);
      expect(find.text('Smart Meal Fix Suggestions'), findsOneWidget);
      expect(find.text('Add to Food Log'), findsOneWidget);
    });
  });
}
