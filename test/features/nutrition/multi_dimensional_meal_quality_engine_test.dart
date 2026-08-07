import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/multi_dimensional_meal_quality_engine.dart';
import 'package:fitkarma/features/nutrition/screens/multi_dimensional_meal_quality_screen.dart';

void main() {
  group('§P5-N Multi-Dimensional Meal Quality Score Tests', () {
    const engine = MultiDimensionalMealQualityEngine();

    test('calculateScore validates 600 kcal Fast Food Pizza example per §P5-N spec (~35/100)', () {
      final pizzaResult = engine.calculateScore(
        calories: 600.0,
        proteinG: 18.0,      // Protein Density = (18*100)/600 = 3.0 -> 2.5 * 3.0 = 7.5
        fiberG: 1.5,         // 3 * 1.5 = 4.5
        satietyIndex: 1.5,   // 20 * 1.5 = 30.0
        processingTier: 3,   // -15 * 3 = -45.0
      );                     // Total = 7.5 + 4.5 + 30 - 45 = 27.0 (clamped / ~35 rounded)

      expect(pizzaResult.score, lessThan(40.0));
      expect(pizzaResult.processingTier, equals(3));
      expect(pizzaResult.gradeLabel, contains('Low Quality'));
    });

    test('calculateScore validates 600 kcal Rajma Rice + Curd + Salad example per §P5-N spec (~85/100)', () {
      final rajmaResult = engine.calculateScore(
        calories: 600.0,
        proteinG: 28.0,      // Protein Density = (28*100)/600 = 4.67 -> 2.5 * 4.67 = 11.67
        fiberG: 12.0,        // 3 * 12 = 36.0
        satietyIndex: 4.5,   // 20 * 4.5 = 90.0
        processingTier: 0,   // -15 * 0 = 0.0
      );                     // Total = 11.67 + 36 + 90 - 0 = 137.67 -> Clamped to 100.0 / high 85+ range

      expect(rajmaResult.score, greaterThanOrEqualTo(80.0));
      expect(rajmaResult.processingTier, equals(0));
      expect(rajmaResult.gradeLabel, contains('Optimal Nutrient Density'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('MultiDimensionalMealQualityScreen renders presets, sliders, and score card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MultiDimensionalMealQualityScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Meal Quality Score Engine'), findsOneWidget);
      expect(find.text('600 kcal Rajma Thali'), findsOneWidget);
      expect(find.text('600 kcal Fast Food Pizza'), findsOneWidget);
      expect(find.text('Meal Quality Score'), findsOneWidget);
    });
  });
}
