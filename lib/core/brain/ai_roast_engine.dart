enum CoachTone {
  gentle,
  motivational,
  roast,
  noNonsense,
}

class RoastNudge {
  final String category;
  final String roastMessage;
  final String motivationalPivot;

  const RoastNudge({
    required this.category,
    required this.roastMessage,
    required this.motivationalPivot,
  });
}

/// Pure-Dart AI Roast Mode Engine per §P12-D spec
/// Includes safety protocol to auto-disable roast mode if stress/crisis signals are detected
class AiRoastEngine {
  const AiRoastEngine();

  /// Generates a roast nudge based on user activity context, unless safety crisis mode is triggered
  RoastNudge generateNudge({
    required CoachTone tone,
    required double caloriesConsumed,
    required double calorieTarget,
    required int loggedMealsCount,
    required int daysUnlogged,
    required bool isDistressOrHighStressDetected,
  }) {
    // Safety protocol: Crisis mode auto-disables roast if distress is detected
    if (isDistressOrHighStressDetected || tone != CoachTone.roast) {
      return const RoastNudge(
        category: 'Supportive Nudge',
        roastMessage: 'Your body needs recovery and care today. Focus on rest and hydration.',
        motivationalPivot: 'Take small steps today — consistency is built gently.',
      );
    }

    // Roast condition 1: Unlogged meals / missing in action
    if (daysUnlogged >= 2) {
      return RoastNudge(
        category: 'Missing Logs Roast',
        roastMessage: '$daysUnlogged days of not logging meals. Either you are on a silent diet or FitKarma needs a missing persons report.',
        motivationalPivot: 'Log your next meal now — no judgment, just data!',
      );
    }

    // Roast condition 2: Massive post-workout calorie overshoot
    if (caloriesConsumed > calorieTarget + 400) {
      final excess = (caloriesConsumed - calorieTarget).toInt();
      return RoastNudge(
        category: 'Calorie Overshoot Roast',
        roastMessage: 'You burned 400 calories and then attacked +$excess calories of food. Respect the hustle. Your goals don\'t.',
        motivationalPivot: 'Balance it out with a crisp evening walk and high-protein dinner.',
      );
    }

    // Roast condition 3: Zero meals logged today
    if (loggedMealsCount == 0) {
      return const RoastNudge(
        category: 'Zero Log Roast',
        roastMessage: 'Photosynthesis isn\'t a valid nutrition plan for humans. Log your breakfast!',
        motivationalPivot: 'Take 10 seconds to snap or type your meal.',
      );
    }

    // Default roast
    return const RoastNudge(
      category: 'General Roast',
      roastMessage: 'Staring at your targets won\'t burn calories. Let\'s move!',
      motivationalPivot: 'Hit your step target before sunset.',
    );
  }
}
