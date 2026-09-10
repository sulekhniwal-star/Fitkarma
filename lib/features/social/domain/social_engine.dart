import 'social_models.dart';

/// Pure Dart Deterministic Engine for Social Energy, Squad Multipliers,
/// Intergenerational Care Alerts, and Feed Prioritization.
class SocialEngine {
  const SocialEngine._();

  /// Calculates the collective Squad Multiplier (1.00x to 1.35x)
  static double calculateSquadMultiplier({
    required int activeStreakDays,
    required double squadAdherenceScore,
  }) {
    final streakFactor = (activeStreakDays / 30.0).clamp(0.0, 1.0) * 0.20;
    final adherenceFactor =
        (squadAdherenceScore / 100.0).clamp(0.0, 1.0) * 0.15;
    return (1.0 + streakFactor + adherenceFactor).clamp(1.0, 1.35);
  }

  /// Filters social feed items based on selected filter tab
  static List<SocialFeedItem> filterFeed({
    required List<SocialFeedItem> allItems,
    required SocialFeedFilter filter,
  }) {
    switch (filter) {
      case SocialFeedFilter.all:
        return allItems;
      case SocialFeedFilter.squad:
        return allItems
            .where((i) =>
                i.eventType == SocialEventType.workoutCompleted ||
                i.eventType == SocialEventType.shatpawaliStreak ||
                i.eventType == SocialEventType.milestoneUnlocked)
            .toList();
      case SocialFeedFilter.family:
        return allItems
            .where((i) =>
                i.eventType == SocialEventType.familyCheckIn ||
                i.eventType == SocialEventType.shatpawaliStreak)
            .toList();
      case SocialFeedFilter.localClubs:
        return allItems
            .where((i) =>
                i.eventType == SocialEventType.workoutCompleted ||
                i.eventType == SocialEventType.karmaTierPromotion)
            .toList();
    }
  }

  /// Evaluates intergenerational family status
  static bool evaluateFamilyAlertRequired({
    required int todaySteps,
    required int dailyTarget,
    required int hourOfDay,
  }) {
    // If it is evening (past 18:00) and steps are below 40% of target, prompt gentle alert
    if (hourOfDay >= 18 && todaySteps < (dailyTarget * 0.40)) {
      return true;
    }
    return false;
  }
}
