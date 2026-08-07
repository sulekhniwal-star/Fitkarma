import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/festival_nutrition_adapter.dart';
import 'package:fitkarma/features/nutrition/screens/festival_nutrition_adaptation_screen.dart';

void main() {
  group('§P5-K Smart Festival Nutrition Adaptation Tests', () {
    const adapter = FestivalNutritionAdapter();

    const double baseCalories = 2000.0;
    const double baseProtein = 120.0;
    const double baseCarbs = 220.0;
    const double baseWater = 2.5;

    test('adjustTargets executes Diwali Pre-Compensation Protocol correctly across phases', () {
      // 1. Pre-3Days (-150 kcal buffer)
      final pre = adapter.adjustTargets(
        baseCalories: baseCalories,
        baseProteinG: baseProtein,
        baseCarbsG: baseCarbs,
        baseWaterLers: baseWater,
        festivalType: FestivalType.diwali,
        relativeDay: FestivalDayRelative.pre3Days,
      );

      expect(pre.calories, equals(1850.0));
      expect(pre.alertMessage, contains('Pre-Compensation'));

      // 2. Festival Day (+400 kcal, +15g protein)
      final festival = adapter.adjustTargets(
        baseCalories: baseCalories,
        baseProteinG: baseProtein,
        baseCarbsG: baseCarbs,
        baseWaterLers: baseWater,
        festivalType: FestivalType.diwali,
        relativeDay: FestivalDayRelative.festivalDay,
      );

      expect(festival.calories, equals(2400.0));
      expect(festival.proteinG, equals(135.0));
      expect(festival.alertMessage, contains('Diwali sweets are expected today'));

      // 3. Post-1Day (+1L water, recovery walk)
      final post = adapter.adjustTargets(
        baseCalories: baseCalories,
        baseProteinG: baseProtein,
        baseCarbsG: baseCarbs,
        baseWaterLers: baseWater,
        festivalType: FestivalType.diwali,
        relativeDay: FestivalDayRelative.post1Day,
      );

      expect(post.waterLers, equals(3.5));
      expect(post.recoveryWalkRecommendation, contains('45-minute steady-state recovery walk'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('FestivalNutritionAdaptationScreen renders timeline selector, adapted stats, and satiety alert', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FestivalNutritionAdaptationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Festival Nutrition Adaptation'), findsOneWidget);
      expect(find.text('Active Festival Protocol'), findsOneWidget);
      expect(find.text('Adapted Nutrition Targets'), findsOneWidget);
      expect(find.textContaining('Diwali sweets are expected today'), findsOneWidget);
    });
  });
}
