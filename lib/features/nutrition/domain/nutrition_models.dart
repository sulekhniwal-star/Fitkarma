enum MealPhase {
  breakfast(name: 'Breakfast / Nashta', regionalName: 'नाश्ता', recommendedCaloriesPercent: 0.25),
  lunch(name: 'Lunch / Dopahar Ka Khana', regionalName: 'दोपहर का भोजन', recommendedCaloriesPercent: 0.35),
  eveningSnack(name: 'Evening Snack / Chai Nashta', regionalName: 'शाम का नाश्ता', recommendedCaloriesPercent: 0.15),
  dinner(name: 'Dinner / Raat Ka Khana', regionalName: 'रात का भोजन', recommendedCaloriesPercent: 0.25);

  final String name;
  final String regionalName;
  final double recommendedCaloriesPercent;

  const MealPhase({
    required this.name,
    required this.regionalName,
    required this.recommendedCaloriesPercent,
  });
}

class FoodItem {
  final String id;
  final String name;
  final String regionalName;
  final String servingUnit; // e.g. '1 katori (150g)', '2 rotis (70g)'
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatsGrams;
  final double fiberGrams;
  final bool isVegetarian;
  final bool isVegan;
  final String category; // 'Daal', 'Roti/Bread', 'Sabzi', 'Dairy', 'Snack', 'Non-Veg'

  const FoodItem({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.servingUnit,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.fiberGrams,
    this.isVegetarian = true,
    this.isVegan = false,
    required this.category,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map, String id) {
    return FoodItem(
      id: id,
      name: map['name'] as String? ?? 'Indian Food Item',
      regionalName: map['regionalName'] as String? ?? '',
      servingUnit: map['servingUnit'] as String? ?? '1 serving',
      calories: (map['calories'] as num?)?.toInt() ?? 100,
      proteinGrams: (map['proteinGrams'] as num?)?.toDouble() ?? 5.0,
      carbsGrams: (map['carbsGrams'] as num?)?.toDouble() ?? 15.0,
      fatsGrams: (map['fatsGrams'] as num?)?.toDouble() ?? 2.0,
      fiberGrams: (map['fiberGrams'] as num?)?.toDouble() ?? 2.0,
      isVegetarian: map['isVegetarian'] as bool? ?? true,
      isVegan: map['isVegan'] as bool? ?? false,
      category: map['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regionalName': regionalName,
      'servingUnit': servingUnit,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatsGrams': fatsGrams,
      'fiberGrams': fiberGrams,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'category': category,
    };
  }
}

class LoggedMealEntry {
  final String id;
  final FoodItem food;
  final double servings; // e.g. 1.5 servings
  final MealPhase phase;
  final DateTime loggedAt;

  const LoggedMealEntry({
    required this.id,
    required this.food,
    this.servings = 1.0,
    required this.phase,
    required this.loggedAt,
  });

  int get totalCalories => (food.calories * servings).round();
  double get totalProtein => double.parse((food.proteinGrams * servings).toStringAsFixed(1));
  double get totalCarbs => double.parse((food.carbsGrams * servings).toStringAsFixed(1));
  double get totalFats => double.parse((food.fatsGrams * servings).toStringAsFixed(1));
  double get totalFiber => double.parse((food.fiberGrams * servings).toStringAsFixed(1));
}
