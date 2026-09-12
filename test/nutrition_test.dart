import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/nutrition/data/nutrition_repository.dart';
import 'package:fitkarma/features/nutrition/domain/models/nutrition_models.dart';
import 'package:fitkarma/features/nutrition/domain/services/festival_nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/domain/services/indian_food_swap_engine.dart';
import 'package:fitkarma/features/nutrition/domain/services/indian_nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/domain/services/meal_quality_engine.dart';

void main() {
  group('IndianNutritionEngine Tests', () {
    const engine = IndianNutritionEngine();

    test('Seeded Indian food database contains staples from various Indian regions', () {
      expect(IndianNutritionEngine.seededIndianFoods.isNotEmpty, isTrue);
      expect(IndianNutritionEngine.seededIndianFoods.any((f) => f.name.contains('Roti')), isTrue);
      expect(IndianNutritionEngine.seededIndianFoods.any((f) => f.name.contains('Paneer')), isTrue);
      expect(IndianNutritionEngine.seededIndianFoods.any((f) => f.name.contains('Idli')), isTrue);
    });

    test('Search foods matches English and Hindi names', () {
      final rotiResults = engine.searchFoods('roti');
      expect(rotiResults.isNotEmpty, isTrue);

      final paneerResults = engine.searchFoods('पनीर');
      expect(paneerResults.isNotEmpty, isTrue);
      expect(paneerResults.first.name, contains('Paneer'));
    });

    test('buildMealFromComponents sums macros and calories accurately', () {
      final roti = IndianNutritionEngine.seededIndianFoods.firstWhere((f) => f.id == 'food_roti_wheat');
      final paneer = IndianNutritionEngine.seededIndianFoods.firstWhere((f) => f.id == 'food_paneer_raw');

      final meal = engine.buildMealFromComponents(
        id: 'meal_1',
        userId: 'user_1',
        name: 'Lunch Thali',
        mealType: MealType.lunch,
        components: [
          MealComponent(food: roti, quantity: 2), // 85*2 = 170 kcal, 3.1*2 = 6.2g P
          MealComponent(food: paneer, quantity: 1), // 265 kcal, 18.3g P
        ],
      );

      expect(meal.caloriesKcal, 435.0);
      expect(meal.proteinGrams, 24.5);
    });
  });

  group('MealQualityEngine Tests', () {
    const engine = MealQualityEngine();

    test('High protein and high fiber meal yields optimal quality score >= 80', () {
      final score = engine.evaluateMeal(
        caloriesKcal: 500,
        proteinGrams: 35, // 28% cals from protein
        carbsGrams: 45,
        fatGrams: 15,
        fiberGrams: 9, // High fiber
      );

      expect(score.overallScore, greaterThanOrEqualTo(80));
      expect(score.feedback, contains('Optimal Indian Plate Balance'));
    });

    test('High carb low protein refined meal yields low quality score', () {
      final score = engine.evaluateMeal(
        caloriesKcal: 700,
        proteinGrams: 8, // ~4.5% cals
        carbsGrams: 120,
        fatGrams: 22,
        fiberGrams: 1.5,
      );

      expect(score.overallScore, lessThan(60));
      expect(score.improvementTips.isNotEmpty, isTrue);
    });

    test('Satiety index prediction returns longer duration for high protein/fiber meals', () {
      final highSatiety = engine.predictSatietyDurationHours(
        caloriesKcal: 550,
        proteinGrams: 32,
        fiberGrams: 8,
        fatGrams: 14,
      );

      final lowSatiety = engine.predictSatietyDurationHours(
        caloriesKcal: 550,
        proteinGrams: 6,
        fiberGrams: 1,
        fatGrams: 14,
      );

      expect(highSatiety, greaterThan(lowSatiety));
    });
  });

  group('IndianFoodSwapEngine Tests', () {
    const engine = IndianFoodSwapEngine();

    test('Find swaps for white rice returns Ragi / Millet alternative', () {
      final swaps = engine.findSwapsFor('White Rice');
      expect(swaps.isNotEmpty, isTrue);
      expect(swaps.first.swapFoodName, contains('Ragi'));
      expect(swaps.first.glycemicReductionPercent, greaterThan(30.0));
    });

    test('Find swaps for deep fried samosa returns roasted makhana with lower calories', () {
      final swaps = engine.findSwapsFor('Samosa');
      expect(swaps.isNotEmpty, isTrue);
      expect(swaps.first.swapFoodName, contains('Makhana'));
      expect(swaps.first.calorieDifference, lessThan(0));
    });
  });

  group('FestivalNutritionEngine Tests', () {
    const engine = FestivalNutritionEngine();

    test('Navratri protocol recommends Kuttu & Singhara and limits fried Sabudana', () {
      final navratri = engine.getProtocol(FestivalType.navratri);
      expect(navratri.title, contains('Navratri'));
      expect(navratri.allowedFoods.any((f) => f.contains('Kuttu')), isTrue);
      expect(navratri.foodsToLimit.any((f) => f.contains('Sabudana')), isTrue);
    });

    test('Ramadan protocol includes Suhoor complex carbs and Iftar hydration strategies', () {
      final ramadan = engine.getProtocol(FestivalType.ramadan);
      expect(ramadan.title, contains('Ramadan'));
      expect(ramadan.allowedFoods.any((f) => f.contains('Suhoor')), isTrue);
    });
  });

  group('NutritionRepository Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late NutritionRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repository = NutritionRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('seedInitialRecipesIfEmpty seeds recipes and allows offline search', () async {
      await repository.seedInitialRecipesIfEmpty();
      final foods = await repository.searchLocalFoods('roti');
      expect(foods.isNotEmpty, isTrue);
      expect(foods.first.name, contains('Roti'));
    });

    test('logMeal writes to LocalMeals and enqueues Outbox mutation', () async {
      final roti = IndianNutritionEngine.seededIndianFoods.firstWhere((f) => f.id == 'food_roti_wheat');
      final logged = await repository.logMeal(
        userId: 'user_nutri_1',
        name: 'Morning Breakfast',
        mealType: MealType.breakfast,
        components: [MealComponent(food: roti, quantity: 2)],
      );

      expect(logged.caloriesKcal, 170.0);

      final todayMeals = await repository.getTodayMeals('user_nutri_1');
      expect(todayMeals.length, 1);
      expect(todayMeals.first.name, 'Morning Breakfast');

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.length, 1);
      expect(pending.first.targetTable, 'meals');
      expect(pending.first.action, 'INSERT');

      final summary = await repository.getTodayMacroSummary('user_nutri_1');
      expect(summary['calories'], 170.0);
      expect(summary['protein'], 6.2);
    });
  });
}
