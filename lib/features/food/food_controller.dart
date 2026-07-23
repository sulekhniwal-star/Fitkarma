import 'package:fitkarma/features/food/protein_timing_evaluator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
  });

  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String mealType; // 'Breakfast', 'Lunch', 'Dinner', 'Snacks'

  FoodItem copyWith({
    String? id,
    String? name,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    String? mealType,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      mealType: mealType ?? this.mealType,
    );
  }
}

class FoodState {
  const FoodState({
    required this.caloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.loggedItems,
    required this.searchQuery,
    required this.searchResults,
    required this.recentMeals,
    required this.isLoading,
  });

  final int caloriesTarget;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;
  final List<FoodItem> loggedItems;
  final String searchQuery;
  final List<FoodItem> searchResults;
  final List<FoodItem> recentMeals;
  final bool isLoading;

  FoodState copyWith({
    int? caloriesTarget,
    int? proteinTarget,
    int? carbsTarget,
    int? fatTarget,
    List<FoodItem>? loggedItems,
    String? searchQuery,
    List<FoodItem>? searchResults,
    List<FoodItem>? recentMeals,
    bool? isLoading,
  }) {
    return FoodState(
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatTarget: fatTarget ?? this.fatTarget,
      loggedItems: loggedItems ?? this.loggedItems,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      recentMeals: recentMeals ?? this.recentMeals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FoodNotifier extends Notifier<FoodState> {
  static const List<FoodItem> _foodDatabase = [
    FoodItem(id: 'db_1', name: 'Egg Bhurji', calories: 250, protein: 18, carbs: 4, fat: 18, mealType: 'Breakfast'),
    FoodItem(id: 'db_2', name: 'Paneer Butter Masala', calories: 380, protein: 14, carbs: 12, fat: 30, mealType: 'Lunch'),
    FoodItem(id: 'db_3', name: 'Roti', calories: 120, protein: 3, carbs: 25, fat: 1, mealType: 'Lunch'),
    FoodItem(id: 'db_4', name: 'Chicken Tikka', calories: 280, protein: 30, carbs: 5, fat: 15, mealType: 'Dinner'),
    FoodItem(id: 'db_5', name: 'Dal Tadka', calories: 180, protein: 8, carbs: 24, fat: 6, mealType: 'Dinner'),
    FoodItem(id: 'db_6', name: 'Oats with Milk', calories: 220, protein: 10, carbs: 35, fat: 4, mealType: 'Breakfast'),
  ];

  @override
  FoodState build() {
    return const FoodState(
      caloriesTarget: 2000,
      proteinTarget: 110,
      carbsTarget: 220,
      fatTarget: 65,
      loggedItems: [
        FoodItem(id: 'init_1', name: 'Masala Dosa', calories: 350, protein: 6, carbs: 55, fat: 12, mealType: 'Breakfast'),
      ],
      searchQuery: '',
      searchResults: [],
      recentMeals: [
        FoodItem(id: 'rec_1', name: 'Egg Bhurji', calories: 250, protein: 18, carbs: 4, fat: 18, mealType: 'Breakfast'),
        FoodItem(id: 'rec_2', name: 'Roti', calories: 120, protein: 3, carbs: 25, fat: 1, mealType: 'Lunch'),
      ],
      isLoading: false,
    );
  }

  void searchFood(String query) {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', searchResults: []);
      return;
    }

    final lower = query.toLowerCase();
    final results = _foodDatabase.where((item) => item.name.toLowerCase().contains(lower)).toList();
    state = state.copyWith(searchQuery: query, searchResults: results);
  }

  void addFood(FoodItem item) {
    final newItem = item.copyWith(id: 'item_${DateTime.now().millisecondsSinceEpoch}');
    final newList = List<FoodItem>.from(state.loggedItems)..add(newItem);

    // Also add to recents if not already there
    final existsInRecents = state.recentMeals.any((element) => element.name.toLowerCase() == item.name.toLowerCase());
    List<FoodItem> newRecents = state.recentMeals;
    if (!existsInRecents) {
      newRecents = List<FoodItem>.from(state.recentMeals)..insert(0, item.copyWith(id: 'rec_${DateTime.now().millisecondsSinceEpoch}'));
      if (newRecents.length > 5) {
        newRecents.removeLast();
      }
    }

    state = state.copyWith(
      loggedItems: newList,
      recentMeals: newRecents,
      searchQuery: '',
      searchResults: [],
    );
  }

  void removeFood(String id) {
    final newList = state.loggedItems.where((element) => element.id != id).toList();
    state = state.copyWith(loggedItems: newList);
  }
}

final foodProvider = NotifierProvider<FoodNotifier, FoodState>(
  FoodNotifier.new,
);

final proteinTimingEvaluatorProvider = Provider<ProteinTimingEvaluator>((ref) {
  return const ProteinTimingEvaluator();
});

final proteinTimingProvider = Provider<ProteinTimingResult>((ref) {
  final foodState = ref.watch(foodProvider);
  final evaluator = ref.watch(proteinTimingEvaluatorProvider);
  return evaluator.evaluateDistribution(foodState.loggedItems);
});
