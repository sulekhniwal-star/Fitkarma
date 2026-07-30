import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/nutrition_engine.dart';
import '../models/indian_food_item.dart';

class NutritionState {
  final List<IndianFoodItem> loggedMeals;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double targetCalories;
  final double targetProtein;
  final bool isProteinDeficit;

  const NutritionState({
    this.loggedMeals = const [],
    this.totalCalories = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
    this.targetCalories = 2200.0,
    this.targetProtein = 120.0,
    this.isProteinDeficit = false,
  });

  NutritionState copyWith({
    List<IndianFoodItem>? loggedMeals,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? targetCalories,
    double? targetProtein,
    bool? isProteinDeficit,
  }) {
    return NutritionState(
      loggedMeals: loggedMeals ?? this.loggedMeals,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      isProteinDeficit: isProteinDeficit ?? this.isProteinDeficit,
    );
  }
}

class NutritionNotifier extends StateNotifier<NutritionState> {
  final NutritionEngine _engine;

  NutritionNotifier(this._engine) : super(const NutritionState());

  void logFood(IndianFoodItem item) {
    final updatedList = [...state.loggedMeals, item];
    final calories = state.totalCalories + item.calories;
    final protein = state.totalProtein + item.proteinGrams;
    final carbs = state.totalCarbs + item.carbsGrams;
    final fat = state.totalFat + item.fatGrams;

    final hasDeficit = _engine.isProteinDeficitAlert(
      loggedProtein: protein,
      targetProtein: state.targetProtein,
    );

    state = state.copyWith(
      loggedMeals: updatedList,
      totalCalories: calories,
      totalProtein: protein,
      totalCarbs: carbs,
      totalFat: fat,
      isProteinDeficit: hasDeficit,
    );
  }
}

final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, NutritionState>((ref) {
  return NutritionNotifier(const NutritionEngine());
});
