// ──────────────────────────────────────────────────────────────────────────────
// Domain models for §P1-E AI Diet Plan Results Screen
// ──────────────────────────────────────────────────────────────────────────────

/// A single meal within a day's plan.
class DietMeal {
  const DietMeal({
    required this.name,
    required this.mealType,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.tip,
  });

  final String name;

  /// e.g. 'breakfast', 'lunch', 'dinner', 'snack'
  final String mealType;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String? tip;

  factory DietMeal.fromJson(Map<String, dynamic> json) {
    return DietMeal(
      name: (json['name'] as String?) ?? 'Meal',
      mealType: (json['type'] as String?) ?? 'meal',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['protein'] as num?)?.toDouble() ?? 0,
      carbsG: (json['carbs'] as num?)?.toDouble() ?? 0,
      fatG: (json['fat'] as num?)?.toDouble() ?? 0,
      tip: json['tip'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': mealType,
    'calories': calories,
    'protein': proteinG,
    'carbs': carbsG,
    'fat': fatG,
    if (tip != null) 'tip': tip,
  };
}

/// One day in the 7-day plan.
class DietDay {
  const DietDay({required this.day, required this.meals});

  final String day; // 'Monday', 'Tuesday', …
  final List<DietMeal> meals;

  int get totalCalories => meals.fold(0, (s, m) => s + m.calories);
  double get totalProteinG => meals.fold(0.0, (s, m) => s + m.proteinG);

  factory DietDay.fromJson(Map<String, dynamic> json) {
    final rawMeals = (json['meals'] as List<dynamic>?) ?? [];
    return DietDay(
      day: (json['day'] as String?) ?? '',
      meals: rawMeals
          .map((m) => DietMeal.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'meals': meals.map((m) => m.toJson()).toList(),
  };
}

/// The full 7-day plan returned by the AI or the deterministic fallback.
class DietPlan {
  const DietPlan({
    required this.days,
    required this.dailyCalorieTarget,
    required this.dailyProteinTargetG,
    this.isAiGenerated = true,
  });

  final List<DietDay> days;
  final int dailyCalorieTarget;
  final int dailyProteinTargetG;

  /// `false` when we fell back to the deterministic local blueprint.
  final bool isAiGenerated;

  factory DietPlan.fromJson(
    Map<String, dynamic> json, {
    required int calorieTarget,
    required int proteinTarget,
    bool isAiGenerated = true,
  }) {
    final rawDays = (json['days'] as List<dynamic>?) ?? [];
    return DietPlan(
      days: rawDays
          .map((d) => DietDay.fromJson(d as Map<String, dynamic>))
          .toList(),
      dailyCalorieTarget: calorieTarget,
      dailyProteinTargetG: proteinTarget,
      isAiGenerated: isAiGenerated,
    );
  }

  Map<String, dynamic> toJson() => {
    'days': days.map((d) => d.toJson()).toList(),
  };
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier state
// ──────────────────────────────────────────────────────────────────────────────

enum DietPlanStatus { idle, loading, loaded, error }

class DietPlanState {
  const DietPlanState({
    this.status = DietPlanStatus.idle,
    this.plan,
    this.selectedDayIndex = 0,
    this.regeneratesLeft = 1,
    this.errorMessage,
  });

  final DietPlanStatus status;
  final DietPlan? plan;
  final int selectedDayIndex;
  final int regeneratesLeft;
  final String? errorMessage;

  bool get isLoading => status == DietPlanStatus.loading;
  bool get hasError => status == DietPlanStatus.error;
  bool get hasData => status == DietPlanStatus.loaded && plan != null;

  DietPlanState copyWith({
    DietPlanStatus? status,
    DietPlan? plan,
    int? selectedDayIndex,
    int? regeneratesLeft,
    String? errorMessage,
  }) {
    return DietPlanState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      regeneratesLeft: regeneratesLeft ?? this.regeneratesLeft,
      errorMessage: errorMessage,
    );
  }
}
