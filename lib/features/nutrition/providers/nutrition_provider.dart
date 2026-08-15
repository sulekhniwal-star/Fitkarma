import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/nutrition_engine.dart';
import '../models/indian_food_item.dart';

class NutritionState {
  final List<MealEntry> loggedMeals;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final bool isProteinDeficit;
  final String? dipNutritionFocus;
  final Map<MealType, bool> sectionExpanded;

  const NutritionState({
    this.loggedMeals = const [],
    this.totalCalories = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
    this.targetCalories = 2200.0,
    this.targetProtein = 110.0,
    this.targetCarbs = 250.0,
    this.targetFat = 65.0,
    this.isProteinDeficit = false,
    this.dipNutritionFocus =
        'Prioritize 30g protein at lunch & post-workout hydration',
    this.sectionExpanded = const {
      MealType.breakfast: true,
      MealType.lunch: true,
      MealType.dinner: true,
      MealType.snacks: true,
    },
  });

  NutritionState copyWith({
    List<MealEntry>? loggedMeals,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFat,
    bool? isProteinDeficit,
    String? dipNutritionFocus,
    Map<MealType, bool>? sectionExpanded,
  }) {
    return NutritionState(
      loggedMeals: loggedMeals ?? this.loggedMeals,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
      isProteinDeficit: isProteinDeficit ?? this.isProteinDeficit,
      dipNutritionFocus: dipNutritionFocus ?? this.dipNutritionFocus,
      sectionExpanded: sectionExpanded ?? this.sectionExpanded,
    );
  }

  List<MealEntry> getMealsForSection(MealType type) {
    return loggedMeals.where((m) => m.type == type).toList();
  }
}

class NutritionNotifier extends StateNotifier<NutritionState> {
  final NutritionEngine _engine;

  NutritionNotifier(this._engine) : super(_buildInitialState(_engine));

  static NutritionState _buildInitialState(NutritionEngine engine) {
    final now = DateTime.now();
    final sampleMeals = [
      MealEntry(
        id: 'm1',
        type: MealType.breakfast,
        foodItem: SeededIndianFoodDatabase.items
            .firstWhere((i) => i.id == 'f6'), // Poha
        quantityServings: 1.0,
        loggedAt: now.subtract(const Duration(hours: 6)),
      ),
      MealEntry(
        id: 'm2',
        type: MealType.breakfast,
        foodItem: SeededIndianFoodDatabase.items
            .firstWhere((i) => i.id == 'f1'), // Paneer Tikka
        quantityServings: 1.0,
        loggedAt: now.subtract(const Duration(hours: 6)),
      ),
      MealEntry(
        id: 'm3',
        type: MealType.lunch,
        foodItem: SeededIndianFoodDatabase.items
            .firstWhere((i) => i.id == 'f2'), // Dal Tadka
        quantityServings: 1.5,
        loggedAt: now.subtract(const Duration(hours: 3)),
      ),
      MealEntry(
        id: 'm4',
        type: MealType.lunch,
        foodItem: SeededIndianFoodDatabase.items
            .firstWhere((i) => i.id == 'f3'), // Roti
        quantityServings: 2.0,
        loggedAt: now.subtract(const Duration(hours: 3)),
      ),
    ];

    double cals = 0.0, prot = 0.0, carbs = 0.0, fat = 0.0;
    for (final entry in sampleMeals) {
      cals += entry.totalCalories;
      prot += entry.totalProtein;
      carbs += entry.totalCarbs;
      fat += entry.totalFat;
    }

    const targetProt = 110.0;
    final isDeficit = engine.isProteinDeficitAlert(
        loggedProtein: prot, targetProtein: targetProt);

    return NutritionState(
      loggedMeals: sampleMeals,
      totalCalories: cals,
      totalProtein: prot,
      totalCarbs: carbs,
      totalFat: fat,
      targetCalories: 2200.0,
      targetProtein: targetProt,
      isProteinDeficit: isDeficit,
    );
  }

  void toggleSection(MealType type) {
    final updatedMap = Map<MealType, bool>.from(state.sectionExpanded);
    updatedMap[type] = !(updatedMap[type] ?? true);
    state = state.copyWith(sectionExpanded: updatedMap);
  }

  void logFood(IndianFoodItem item) {
    logMeal(type: MealType.breakfast, foodItem: item);
  }

  void logMeal({
    required MealType type,
    required IndianFoodItem foodItem,
    double servings = 1.0,
  }) {
    final entry = MealEntry(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      foodItem: foodItem,
      quantityServings: servings,
      loggedAt: DateTime.now(),
    );

    final updatedList = [...state.loggedMeals, entry];
    final cals = state.totalCalories + entry.totalCalories;
    final prot = state.totalProtein + entry.totalProtein;
    final carbs = state.totalCarbs + entry.totalCarbs;
    final fat = state.totalFat + entry.totalFat;

    final isDeficit = _engine.isProteinDeficitAlert(
      loggedProtein: prot,
      targetProtein: state.targetProtein,
    );

    state = state.copyWith(
      loggedMeals: updatedList,
      totalCalories: cals,
      totalProtein: prot,
      totalCarbs: carbs,
      totalFat: fat,
      isProteinDeficit: isDeficit,
    );
  }

  void removeMeal(String id) {
    final updatedList = state.loggedMeals.where((m) => m.id != id).toList();

    double cals = 0.0, prot = 0.0, carbs = 0.0, fat = 0.0;
    for (final entry in updatedList) {
      cals += entry.totalCalories;
      prot += entry.totalProtein;
      carbs += entry.totalCarbs;
      fat += entry.totalFat;
    }

    final isDeficit = _engine.isProteinDeficitAlert(
      loggedProtein: prot,
      targetProtein: state.targetProtein,
    );

    state = state.copyWith(
      loggedMeals: updatedList,
      totalCalories: cals,
      totalProtein: prot,
      totalCarbs: carbs,
      totalFat: fat,
      isProteinDeficit: isDeficit,
    );
  }
}

final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, NutritionState>(
  (_) => NutritionNotifier(const NutritionEngine()),
);
