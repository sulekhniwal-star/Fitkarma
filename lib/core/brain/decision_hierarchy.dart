/// Decision Hierarchy priority levels
enum ActionPriority { medicalSafety, recoveryPrescription, workoutProgression, habitGuidance }

/// Decision Action item resolved by Decision Hierarchy
class DecisionAction {
  final String title;
  final String description;
  final ActionPriority priority;
  final bool isMandatoryRest;

  const DecisionAction({
    required this.title,
    required this.description,
    required this.priority,
    this.isMandatoryRest = false,
  });
}

/// Core Health OS Decision Hierarchy Resolver
class DecisionHierarchy {
  const DecisionHierarchy();

  /// Resolve conflicting actions based on strict priority hierarchy:
  /// Safety/Medical Alarms > Recovery Rest Prescriptions > Workout Progression > Habit Guidance
  List<DecisionAction> resolveActions({
    required int readinessScore,
    bool illnessAlarmTriggered = false,
    double? dailyStrain,
  }) {
    final actions = <DecisionAction>[];

    // Priority 1: Medical Alarms
    if (illnessAlarmTriggered) {
      actions.add(const DecisionAction(
        title: 'Biometric Illness Alert',
        description: 'Elevated resting HR & temperature detected. Take a rest day.',
        priority: ActionPriority.medicalSafety,
        isMandatoryRest: true,
      ));
      return actions; // Strict stop for safety
    }

    // Priority 2: Recovery Rest Prescriptions
    if (readinessScore < 45) {
      actions.add(const DecisionAction(
        title: 'Active Recovery Protocol',
        description: 'Readiness is under 45%. Substitute high-intensity training with 20min mobility walk.',
        priority: ActionPriority.recoveryPrescription,
        isMandatoryRest: true,
      ));
    }

    // Priority 3: Workout Progression
    if (readinessScore >= 75) {
      actions.add(const DecisionAction(
        title: 'Progressive Overload Target',
        description: 'Readiness is peak (75+). Attempt +2.5kg increment on primary compound lift.',
        priority: ActionPriority.workoutProgression,
      ));
    }

    // Priority 4: Habit Guidance
    actions.add(const DecisionAction(
      title: 'Hydration Target',
      description: 'Drink 3.5L of water throughout the day.',
      priority: ActionPriority.habitGuidance,
    ));

    return actions;
  }
}
