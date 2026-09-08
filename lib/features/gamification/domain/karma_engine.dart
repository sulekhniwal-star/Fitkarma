import 'dart:math';
import 'karma_models.dart';

class KarmaEngine {
  /// Deterministic Level calculation based on lifetime Karma points
  /// Level 1: 0 - 99 KP
  /// Level 2: 100 - 399 KP
  /// Level 3: 400 - 899 KP
  /// Formula: Level = floor(sqrt(lifetimeKP / 100)) + 1
  static int calculateLevel(int lifetimePoints) {
    if (lifetimePoints <= 0) return 1;
    return (sqrt(lifetimePoints / 100.0)).floor() + 1;
  }

  /// Calculates progress percent (0.0 to 1.0) towards the next level
  static double calculateLevelProgressPercent(int lifetimePoints) {
    final currentLevel = calculateLevel(lifetimePoints);
    final floorPoints = pow(currentLevel - 1, 2).toInt() * 100;
    final nextLevelPoints = pow(currentLevel, 2).toInt() * 100;
    final span = nextLevelPoints - floorPoints;
    if (span <= 0) return 1.0;
    final currentLevelEarned = lifetimePoints - floorPoints;
    return (currentLevelEarned / span).clamp(0.0, 1.0);
  }

  /// Calculates points remaining to reach next level
  static int calculatePointsToNextLevel(int lifetimePoints) {
    final currentLevel = calculateLevel(lifetimePoints);
    final nextLevelPoints = pow(currentLevel, 2).toInt() * 100;
    return max(0, nextLevelPoints - lifetimePoints);
  }

  /// Maps lifetime points to KarmaTier
  static KarmaTier determineTier(int lifetimePoints) {
    for (final tier in KarmaTier.values) {
      if (lifetimePoints >= tier.minPoints && lifetimePoints <= tier.maxPoints) {
        return tier;
      }
    }
    return KarmaTier.yogi;
  }

  /// Streak Multiplier Curve (Rewarding daily Indian lifestyle adherence)
  static double calculateStreakMultiplier(int streakDays) {
    if (streakDays < 3) return 1.0;
    if (streakDays < 7) return 1.10;
    if (streakDays < 14) return 1.25;
    if (streakDays < 30) return 1.50;
    if (streakDays < 60) return 1.75;
    return 2.0;
  }

  /// Evaluates Karma reward transaction for any user action
  static KarmaTransaction generateKarmaReward({
    required KarmaActionType action,
    required int streakDays,
    double formQualityScore = 1.0, // 0.8 to 1.25 multiplier based on Computer Vision HUD
    bool isReadinessAligned = true, // Bonus if training matches readiness zone
  }) {
    final streakMult = calculateStreakMultiplier(streakDays);
    final readinessBonus = isReadinessAligned ? 1.15 : 1.0;
    final effectiveMultiplier = double.parse((streakMult * formQualityScore * readinessBonus).toStringAsFixed(2));

    final totalPoints = (action.basePoints * effectiveMultiplier).round();

    return KarmaTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      actionType: action,
      basePoints: action.basePoints,
      multiplier: effectiveMultiplier,
      totalPointsAwarded: totalPoints,
      description: '${action.label} (x${effectiveMultiplier.toStringAsFixed(2)} multiplier)',
      regionalDescription: '${action.regionalLabel} (x${effectiveMultiplier.toStringAsFixed(2)} गुणक)',
    );
  }

  /// Evaluates and updates badge progress across all 5 gamification pillars
  static List<KarmaBadge> evaluateBadgeProgression({
    required List<KarmaBadge> currentBadges,
    required int lifetimePoints,
    required int streakDays,
    required int completedWorkouts,
    required int loggedShatpawaliCount,
    required int highQualityMealsCount,
    required int optimalSleepNightsCount,
  }) {
    return currentBadges.map((badge) {
      if (badge.isUnlocked) return badge;

      double newProgress = 0.0;
      bool unlock = false;

      switch (badge.id) {
        // Metabolic Mastery
        case 'badge_shatpawali_pioneer':
          newProgress = (loggedShatpawaliCount / 7.0).clamp(0.0, 1.0);
          unlock = loggedShatpawaliCount >= 7;
          break;
        case 'badge_shatpawali_master':
          newProgress = (loggedShatpawaliCount / 30.0).clamp(0.0, 1.0);
          unlock = loggedShatpawaliCount >= 30;
          break;
        case 'badge_sattvic_nutrition':
          newProgress = (highQualityMealsCount / 20.0).clamp(0.0, 1.0);
          unlock = highQualityMealsCount >= 20;
          break;

        // Kinematic Excellence
        case 'badge_iron_discipline_workouts':
          newProgress = (completedWorkouts / 10.0).clamp(0.0, 1.0);
          unlock = completedWorkouts >= 10;
          break;
        case 'badge_century_lifter':
          newProgress = (completedWorkouts / 100.0).clamp(0.0, 1.0);
          unlock = completedWorkouts >= 100;
          break;

        // Recovery & Circadian
        case 'badge_sleep_alchemist':
          newProgress = (optimalSleepNightsCount / 14.0).clamp(0.0, 1.0);
          unlock = optimalSleepNightsCount >= 14;
          break;

        // Consistency & Grit
        case 'badge_streak_starter':
          newProgress = (streakDays / 7.0).clamp(0.0, 1.0);
          unlock = streakDays >= 7;
          break;
        case 'badge_month_of_steel':
          newProgress = (streakDays / 30.0).clamp(0.0, 1.0);
          unlock = streakDays >= 30;
          break;
        case 'badge_unbreakable_100':
          newProgress = (streakDays / 100.0).clamp(0.0, 1.0);
          unlock = streakDays >= 100;
          break;

        // Cultural & Tier
        case 'badge_sadhak_ascension':
          newProgress = (lifetimePoints / 1000.0).clamp(0.0, 1.0);
          unlock = lifetimePoints >= 1000;
          break;
        case 'badge_abhyasi_ascension':
          newProgress = (lifetimePoints / 5000.0).clamp(0.0, 1.0);
          unlock = lifetimePoints >= 5000;
          break;
        case 'badge_yogi_mastery':
          newProgress = (lifetimePoints / 35000.0).clamp(0.0, 1.0);
          unlock = lifetimePoints >= 35000;
          break;

        default:
          newProgress = badge.progress;
      }

      if (unlock) {
        return badge.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
          progress: 1.0,
        );
      } else {
        return badge.copyWith(
          progress: newProgress,
        );
      }
    }).toList();
  }
}
