import 'dart:math';

enum HabitTriggerType {
  postWorkoutProtein,
  sleepWindDown,
  adaptiveWater,
  elevatedHrBreathing,
  postMealWalk,
}

class HabitAutomationTrigger {
  final String id;
  final HabitTriggerType type;
  final String title;
  final String message;
  final DateTime scheduledTime;
  final bool isTriggered;
  final Map<String, dynamic> contextualPayload;

  const HabitAutomationTrigger({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.scheduledTime,
    this.isTriggered = false,
    this.contextualPayload = const {},
  });

  HabitAutomationTrigger copyWith({
    bool? isTriggered,
    DateTime? scheduledTime,
  }) {
    return HabitAutomationTrigger(
      id: id,
      type: type,
      title: title,
      message: message,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isTriggered: isTriggered ?? this.isTriggered,
      contextualPayload: contextualPayload,
    );
  }
}

/// Pure-Dart Habit Automation System per §P7-C spec
/// Implements contextual smart triggers (NOT fixed-time static reminders)
class HabitAutomationSystem {
  const HabitAutomationSystem();

  /// 1. "Protein reminder" fires 30 min after workout completed
  HabitAutomationTrigger evaluatePostWorkoutProtein({
    required DateTime workoutEndTime,
    required double loggedProteinGrams,
    required double targetProteinGrams,
  }) {
    final scheduled = workoutEndTime.add(const Duration(minutes: 30));
    final bool needed = loggedProteinGrams < (targetProteinGrams * 0.8);

    return HabitAutomationTrigger(
      id: 'habit_protein_30m',
      type: HabitTriggerType.postWorkoutProtein,
      title: '🥩 Anabolic Window Protein Nudge',
      message: needed
          ? '30 mins post-workout! Log your whey/paneer now to hit your $targetProteinGrams g target.'
          : 'Great workout! Protein target is already met.',
      scheduledTime: scheduled,
      isTriggered: false,
    );
  }

  /// 2. "Sleep wind-down" fires based on usual sleep time ± 30 min (e.g. usual Bedtime - 45 mins)
  HabitAutomationTrigger evaluateSleepWindDown({
    required DateTime usualBedtime,
    required double sleepDebtHours,
  }) {
    final int advanceMinutes = (45 + (sleepDebtHours * 10).round()).clamp(30, 90);
    final scheduled = usualBedtime.subtract(Duration(minutes: advanceMinutes));

    return HabitAutomationTrigger(
      id: 'habit_sleep_winddown',
      type: HabitTriggerType.sleepWindDown,
      title: '🌙 Sleep OS Wind-Down Routine',
      message: 'Bedtime in $advanceMinutes mins. Dim lights, turn off screens, and start your 15m relaxation.',
      scheduledTime: scheduled,
      isTriggered: false,
    );
  }

  /// 3. "Water reminder" adjusts for today's temperature + activity level
  HabitAutomationTrigger evaluateAdaptiveWater({
    required double ambientTempCelsius,
    required int stepsCount,
    required double currentWaterLiters,
  }) {
    double baseTargetLiters = 2.5;
    if (ambientTempCelsius > 32.0) baseTargetLiters += 0.8;
    if (stepsCount > 8000) baseTargetLiters += 0.5;

    final remaining = max(0.0, baseTargetLiters - currentWaterLiters);

    return HabitAutomationTrigger(
      id: 'habit_adaptive_water',
      type: HabitTriggerType.adaptiveWater,
      title: '💧 Smart Hydration Nudge',
      message: ambientTempCelsius > 32.0
          ? 'High temp (${ambientTempCelsius.round()}°C) & $stepsCount steps! ${remaining.toStringAsFixed(1)}L remaining to hit today\'s adaptive target.'
          : '${remaining.toStringAsFixed(1)}L remaining to hit today\'s hydration goal.',
      scheduledTime: DateTime.now().add(const Duration(hours: 2)),
      isTriggered: false,
      contextualPayload: {
        'targetLiters': baseTargetLiters,
        'remainingLiters': remaining,
      },
    );
  }

  /// 4. "Breathing exercise" fires when resting HR is above baseline (+5 bpm)
  HabitAutomationTrigger evaluateElevatedHrBreathing({
    required int currentRhr,
    required int baselineRhr,
  }) {
    final bool isElevated = (currentRhr - baselineRhr) >= 5;

    return HabitAutomationTrigger(
      id: 'habit_elevated_hr_breathing',
      type: HabitTriggerType.elevatedHrBreathing,
      title: '🧘 Parasympathetic Breathing Prompt',
      message: isElevated
          ? 'Resting HR is elevated (+${currentRhr - baselineRhr} bpm above baseline). Take 3 minutes for 4-7-8 box breathing.'
          : 'Heart rate is calm and within normal baseline.',
      scheduledTime: DateTime.now(),
      isTriggered: false,
    );
  }

  /// 5. "Post-meal walk" nudge fires 20 min after food logged
  HabitAutomationTrigger evaluatePostMealWalk({
    required DateTime mealLoggedTime,
    required double mealCarbsGrams,
  }) {
    final scheduled = mealLoggedTime.add(const Duration(minutes: 20));

    return HabitAutomationTrigger(
      id: 'habit_post_meal_walk',
      type: HabitTriggerType.postMealWalk,
      title: '🚶 10-Minute Postprandial Walk',
      message: '20 mins after your ${mealCarbsGrams.round()}g carb meal! A 10-minute light stroll prevents glucose spikes.',
      scheduledTime: scheduled,
      isTriggered: false,
    );
  }
}
