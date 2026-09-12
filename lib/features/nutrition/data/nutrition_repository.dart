import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/nutrition_models.dart';
import '../domain/services/indian_food_swap_engine.dart';
import '../domain/services/indian_nutrition_engine.dart';
import '../domain/services/meal_quality_engine.dart';

class NutritionRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final IndianNutritionEngine nutritionEngine;
  final MealQualityEngine qualityEngine;
  final IndianFoodSwapEngine swapEngine;
  final _uuid = const Uuid();

  NutritionRepository({
    required this.db,
    required this.syncWorker,
    this.nutritionEngine = const IndianNutritionEngine(),
    this.qualityEngine = const MealQualityEngine(),
    this.swapEngine = const IndianFoodSwapEngine(),
  });

  /// Seed initial Indian recipe database into Drift if empty
  Future<void> seedInitialRecipesIfEmpty() async {
    final count = await db.select(db.localRecipes).get();
    if (count.isNotEmpty) return;

    for (final food in IndianNutritionEngine.seededIndianFoods) {
      await db.into(db.localRecipes).insert(
            LocalRecipesCompanion.insert(
              id: food.id,
              name: food.name,
              nameHindi: food.nameHindi,
              region: food.region.name,
              dietaryType: food.dietaryType.name,
              caloriesKcal: food.caloriesKcal,
              proteinGrams: food.proteinGrams,
              carbsGrams: food.carbsGrams,
              fatGrams: food.fatGrams,
              fiberGrams: food.fiberGrams,
              glycemicIndex: food.glycemicIndex,
            ),
          );
    }
  }

  /// Search foods from local SQLite catalog
  Future<List<LocalRecipe>> searchLocalFoods(String query) async {
    await seedInitialRecipesIfEmpty();
    if (query.trim().isEmpty) {
      return db.select(db.localRecipes).get();
    }
    final pattern = '%${query.toLowerCase().trim()}%';
    return (db.select(db.localRecipes)
          ..where((t) => t.name.lower().like(pattern) | t.nameHindi.lower().like(pattern)))
        .get();
  }

  /// Log user meal (offline-first Drift -> Outbox)
  Future<LoggedMeal> logMeal({
    required String userId,
    required String name,
    required MealType mealType,
    required List<MealComponent> components,
    double visionConfidence = 1.0,
    String? photoUrl,
    DateTime? loggedAt,
  }) async {
    final mealId = _uuid.v4();
    final now = loggedAt ?? DateTime.now();

    final loggedMeal = nutritionEngine.buildMealFromComponents(
      id: mealId,
      userId: userId,
      name: name,
      mealType: mealType,
      components: components,
      visionConfidence: visionConfidence,
      photoUrl: photoUrl,
      loggedAt: now,
    );

    final quality = qualityEngine.evaluateMeal(
      caloriesKcal: loggedMeal.caloriesKcal,
      proteinGrams: loggedMeal.proteinGrams,
      carbsGrams: loggedMeal.carbsGrams,
      fatGrams: loggedMeal.fatGrams,
      fiberGrams: loggedMeal.fiberGrams,
    );

    // 1. Write to local Drift
    await db.into(db.localMeals).insert(
          LocalMealsCompanion.insert(
            id: mealId,
            userId: userId,
            name: name,
            mealType: mealType.name,
            caloriesKcal: loggedMeal.caloriesKcal,
            proteinGrams: loggedMeal.proteinGrams,
            carbsGrams: loggedMeal.carbsGrams,
            fatGrams: loggedMeal.fatGrams,
            fiberGrams: loggedMeal.fiberGrams,
            mealQualityScore: quality.overallScore,
            visionConfidence: Value(visionConfidence),
            photoUrl: Value(photoUrl),
            loggedAt: now,
          ),
        );

    // 2. Queue Outbox mutation for Supabase
    await syncWorker.enqueueMutation(
      tableName: 'meals',
      action: 'INSERT',
      payload: {
        'id': mealId,
        'user_id': userId,
        'name': name,
        'meal_type': mealType.name,
        'calories_kcal': loggedMeal.caloriesKcal,
        'protein_grams': loggedMeal.proteinGrams,
        'carbs_grams': loggedMeal.carbsGrams,
        'fat_grams': loggedMeal.fatGrams,
        'fiber_grams': loggedMeal.fiberGrams,
        'meal_quality_score': quality.overallScore,
        'vision_confidence': visionConfidence,
        'photo_url': photoUrl,
        'logged_at': now.toIso8601String(),
      },
    );

    return loggedMeal;
  }

  /// Get user meals for today
  Future<List<LocalMeal>> getTodayMeals(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (db.select(db.localMeals)
          ..where((t) => t.userId.equals(userId) & t.loggedAt.isBiggerOrEqualValue(startOfDay))
          ..orderBy([(t) => OrderingTerm(expression: t.loggedAt, mode: OrderingMode.asc)]))
        .get();
  }

  /// Aggregate today's macros
  Future<Map<String, double>> getTodayMacroSummary(String userId) async {
    final meals = await getTodayMeals(userId);
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    double fiber = 0;

    for (final m in meals) {
      calories += m.caloriesKcal;
      protein += m.proteinGrams;
      carbs += m.carbsGrams;
      fat += m.fatGrams;
      fiber += m.fiberGrams;
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
    };
  }

  /// Add grocery item
  Future<void> addGroceryItem({
    required String userId,
    required String name,
    required String nameHindi,
    required String category,
    required double quantity,
    required String unit,
    required double estimatedCostInr,
  }) async {
    final id = _uuid.v4();
    await db.into(db.localGroceryItems).insert(
          LocalGroceryItemsCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            nameHindi: nameHindi,
            category: category,
            quantity: quantity,
            unit: unit,
            estimatedCostInr: estimatedCostInr,
          ),
        );
  }

  /// Get active grocery list
  Future<List<LocalGroceryItem>> getGroceryList(String userId) async {
    return (db.select(db.localGroceryItems)..where((t) => t.userId.equals(userId))).get();
  }
}
