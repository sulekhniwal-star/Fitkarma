import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/glycemic_scoring_controller.dart';
import 'package:fitkarma/features/food/glycemic_scoring_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _makeTestDb() => AppDatabase.executor(NativeDatabase.memory());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlycemicScoringEngine Unit Tests', () {
    const engine = GlycemicScoringEngine();

    test('spike delta < 25 mg/dL yields 10.0 score (Optimal Energy Stability)', () {
      final eval = engine.computeFoodScore(
        baselineGlucose: 90.0,
        peakGlucose90Min: 110.0, // Delta = 20 mg/dL
        foodName: 'Oats & Almonds',
      );

      expect(eval.score, 10.0);
      expect(eval.tierName, 'Optimal Energy Stability');
      expect(eval.recommendation, contains('Great personal glycemic response'));
    });

    test('spike delta 25-45 mg/dL yields 7.0 score (Moderate Glycemic Variance)', () {
      final eval = engine.computeFoodScore(
        baselineGlucose: 95.0,
        peakGlucose90Min: 130.0, // Delta = 35 mg/dL
        foodName: 'Roti & Dal',
      );

      expect(eval.score, 7.0);
      expect(eval.tierName, 'Moderate Glycemic Variance');
      expect(eval.recommendation, contains('Keep portion size in check'));
    });

    test('spike delta > 45 mg/dL yields 3.0 score & generates blunting recommendation', () {
      final eval = engine.computeFoodScore(
        baselineGlucose: 92.0,
        peakGlucose90Min: 145.0, // Delta = 53 mg/dL
        foodName: 'Banana Smoothie',
      );

      expect(eval.score, 3.0);
      expect(eval.tierName, 'Poor Glycemic Response');
      expect(eval.recommendation, contains('High glucose spike detected (+53 mg/dL)'));
      expect(eval.recommendation, contains('almonds'));
    });
  });

  group('RetrospectiveGlycemicPipeline Unit Tests', () {
    const pipeline = RetrospectiveGlycemicPipeline();

    test('processMealHistory matches 90-min CGM readings and derives personal scores', () {
      final now = DateTime.now();
      final meals = [
        const FoodItem(id: '1', name: 'White Rice & Curry', calories: 450, protein: 12, carbs: 70, fat: 12, mealType: 'Lunch'),
      ];

      final readings = [
        GlucoseReading(id: 101, glucoseValue: 90.0, mealTag: 'Pre-Meal', measuredAt: now.subtract(const Duration(minutes: 95))),
        GlucoseReading(id: 102, glucoseValue: 142.0, mealTag: 'Post-Meal (1-hour)', measuredAt: now.subtract(const Duration(minutes: 30))),
      ];

      final evals = pipeline.processMealHistory(
        loggedMeals: meals,
        glucoseReadings: readings,
        defaultBaseline: 90.0,
      );

      expect(evals, isNotEmpty);
      expect(evals.first.foodName, 'White Rice & Curry');
      expect(evals.first.spikeDelta, 52.0); // 142 - 90 = 52
      expect(evals.first.score, 3.0);
    });
  });

  group('glycemicScoringProvider Integration Tests', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = _makeTestDb();
      container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('glycemicScoringProvider computes evaluations from foodProvider reactively', () {
      final initial = container.read(glycemicScoringProvider);
      expect(initial.evaluations, isNotEmpty);

      // Add high carb food to foodProvider
      container.read(foodProvider.notifier).addFood(
        const FoodItem(id: 'carb_1', name: 'Gulab Jamun', calories: 300, protein: 3, carbs: 55, fat: 10, mealType: 'Snacks'),
      );

      final updated = container.read(glycemicScoringProvider);
      expect(updated.evaluations.length, greaterThan(initial.evaluations.length));
    });
  });
}
