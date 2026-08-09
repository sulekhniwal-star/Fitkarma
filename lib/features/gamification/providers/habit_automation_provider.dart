import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/habit_automation_system.dart';

class HabitAutomationState {
  final List<HabitAutomationTrigger> activeTriggers;
  final int completedHabitsToday;

  const HabitAutomationState({
    required this.activeTriggers,
    required this.completedHabitsToday,
  });

  factory HabitAutomationState.initial() {
    const engine = HabitAutomationSystem();
    final now = DateTime.now();

    final protein = engine.evaluatePostWorkoutProtein(
      workoutEndTime: now.subtract(const Duration(minutes: 30)),
      loggedProteinGrams: 40,
      targetProteinGrams: 120,
    );

    final sleep = engine.evaluateSleepWindDown(
      usualBedtime: now.add(const Duration(hours: 2)),
      sleepDebtHours: 1.5,
    );

    final water = engine.evaluateAdaptiveWater(
      ambientTempCelsius: 34.0,
      stepsCount: 9500,
      currentWaterLiters: 1.8,
    );

    final breathing = engine.evaluateElevatedHrBreathing(
      currentRhr: 74,
      baselineRhr: 65,
    );

    final walk = engine.evaluatePostMealWalk(
      mealLoggedTime: now.subtract(const Duration(minutes: 20)),
      mealCarbsGrams: 65.0,
    );

    return HabitAutomationState(
      activeTriggers: [protein, sleep, water, breathing, walk],
      completedHabitsToday: 2,
    );
  }

  HabitAutomationState copyWith({
    List<HabitAutomationTrigger>? activeTriggers,
    int? completedHabitsToday,
  }) {
    return HabitAutomationState(
      activeTriggers: activeTriggers ?? this.activeTriggers,
      completedHabitsToday: completedHabitsToday ?? this.completedHabitsToday,
    );
  }
}

class HabitAutomationNotifier extends StateNotifier<HabitAutomationState> {
  HabitAutomationNotifier() : super(HabitAutomationState.initial());

  void markTriggerCompleted(String triggerId) {
    final updated = state.activeTriggers.map((t) {
      if (t.id == triggerId) {
        return t.copyWith(isTriggered: true);
      }
      return t;
    }).toList();

    state = state.copyWith(
      activeTriggers: updated,
      completedHabitsToday: state.completedHabitsToday + 1,
    );
  }
}

final habitAutomationProvider =
    StateNotifierProvider<HabitAutomationNotifier, HabitAutomationState>((ref) {
  return HabitAutomationNotifier();
});
