import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/indian_food_database.dart';
import '../domain/nutrition_models.dart';

class DailyNutritionState {
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFats;
  final List<LoggedMealEntry> loggedMeals;

  const DailyNutritionState({
    this.targetCalories = 2100,
    this.targetProtein = 135,
    this.targetCarbs = 230,
    this.targetFats = 55,
    this.loggedMeals = const [],
  });

  int get consumedCalories => loggedMeals.fold(0, (sum, m) => sum + m.totalCalories);
  double get consumedProtein => double.parse(loggedMeals.fold(0.0, (sum, m) => sum + m.totalProtein).toStringAsFixed(1));
  double get consumedCarbs => double.parse(loggedMeals.fold(0.0, (sum, m) => sum + m.totalCarbs).toStringAsFixed(1));
  double get consumedFats => double.parse(loggedMeals.fold(0.0, (sum, m) => sum + m.totalFats).toStringAsFixed(1));

  int get remainingCalories => (targetCalories - consumedCalories).clamp(0, 10000);
  int get remainingProtein => (targetProtein - consumedProtein.round()).clamp(0, 1000);

  List<LoggedMealEntry> getMealsForPhase(MealPhase phase) =>
      loggedMeals.where((m) => m.phase == phase).toList();

  DailyNutritionState copyWith({
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFats,
    List<LoggedMealEntry>? loggedMeals,
  }) {
    return DailyNutritionState(
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
      loggedMeals: loggedMeals ?? this.loggedMeals,
    );
  }
}

class NutritionNotifier extends StateNotifier<DailyNutritionState> {
  NutritionNotifier()
      : super(
          DailyNutritionState(
            loggedMeals: [
              LoggedMealEntry(
                id: 'm_1',
                food: IndianFoodDatabase.stapleIndianFoods[1], // Besan Chilla
                servings: 1.0,
                phase: MealPhase.breakfast,
                loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
              ),
              LoggedMealEntry(
                id: 'm_2',
                food: IndianFoodDatabase.stapleIndianFoods[0], // Roti
                servings: 1.0,
                phase: MealPhase.lunch,
                loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
              LoggedMealEntry(
                id: 'm_3',
                food: IndianFoodDatabase.stapleIndianFoods[4], // Rajma
                servings: 1.0,
                phase: MealPhase.lunch,
                loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
            ],
          ),
        );

  void addMeal(FoodItem food, MealPhase phase, double servings) {
    final entry = LoggedMealEntry(
      id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
      food: food,
      servings: servings,
      phase: phase,
      loggedAt: DateTime.now(),
    );

    state = state.copyWith(loggedMeals: [...state.loggedMeals, entry]);
  }

  void removeMeal(String id) {
    state = state.copyWith(
      loggedMeals: state.loggedMeals.where((m) => m.id != id).toList(),
    );
  }
}

final nutritionProvider = StateNotifierProvider<NutritionNotifier, DailyNutritionState>((ref) {
  return NutritionNotifier();
});
