/// §P5-J Nutrition Adherence Controller
///
/// Riverpod Notifier deriving daily adherence score breakdowns and Karma System awards
/// reactively from `foodProvider`.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/nutrition_adherence_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class AdherenceState {
  const AdherenceState({
    required this.breakdown,
    required this.karmaAward,
    this.streakDays = 3,
    this.isPerfectDay = false,
  });

  final AdherenceScoreBreakdown breakdown;
  final KarmaAwardResult karmaAward;
  final int streakDays;
  final bool isPerfectDay;

  AdherenceState copyWith({
    AdherenceScoreBreakdown? breakdown,
    KarmaAwardResult? karmaAward,
    int? streakDays,
    bool? isPerfectDay,
  }) {
    return AdherenceState(
      breakdown: breakdown ?? this.breakdown,
      karmaAward: karmaAward ?? this.karmaAward,
      streakDays: streakDays ?? this.streakDays,
      isPerfectDay: isPerfectDay ?? this.isPerfectDay,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final adherenceEngineProvider = Provider<NutritionAdherenceEngine>((ref) {
  return const NutritionAdherenceEngine();
});

class AdherenceNotifier extends Notifier<AdherenceState> {
  @override
  AdherenceState build() {
    final engine = ref.watch(adherenceEngineProvider);
    final foodState = ref.watch(foodProvider);

    int totalCalories = 0;
    int totalProtein = 0;
    final mealRecords = <MealLogRecord>[];

    for (final item in foodState.loggedItems) {
      totalCalories += item.calories;
      totalProtein += item.protein;
      mealRecords.add(
        MealLogRecord(
          mealType: item.mealType,
          loggedAt: DateTime.now(), // Simulating timestamp
        ),
      );
    }

    final breakdown = engine.calculateDailyScore(
      loggedCalories: totalCalories,
      targetCalories: foodState.caloriesTarget,
      loggedProteinG: totalProtein,
      targetProteinG: foodState.proteinTarget,
      mealsLoggedCount: foodState.loggedItems.length,
      mealRecords: mealRecords,
    );

    const currentStreak = 3;
    final karmaResult = engine.calculateKarmaAward(
      breakdown.totalScore,
      currentStreak,
    );

    return AdherenceState(
      breakdown: breakdown,
      karmaAward: karmaResult,
      streakDays: currentStreak,
      isPerfectDay: breakdown.totalScore >= 90.0,
    );
  }
}

final adherenceProvider = NotifierProvider<AdherenceNotifier, AdherenceState>(
  AdherenceNotifier.new,
);
