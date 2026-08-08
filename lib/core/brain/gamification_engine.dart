import 'dart:math';

/// Level Calculation Result with Karma Title & Bounds per §P7-A spec
class LevelResult {
  final int currentLevel;
  final String levelName;
  final int totalXp;
  final int xpInCurrentLevel;
  final int xpNeededForNextLevel;
  final double levelProgressRatio;
  final bool didLevelUp;

  int get xpForNextLevel => totalXp + (xpNeededForNextLevel - xpInCurrentLevel);

  const LevelResult({
    required this.currentLevel,
    required this.levelName,
    required this.totalXp,
    required this.xpInCurrentLevel,
    required this.xpNeededForNextLevel,
    required this.levelProgressRatio,
    required this.didLevelUp,
  });
}

/// Karma Level Definition Map per §P7-A spec table
class KarmaLevelConfig {
  final int level;
  final String name;
  final int xpRequired;

  const KarmaLevelConfig({
    required this.level,
    required this.name,
    required this.xpRequired,
  });

  static const List<KarmaLevelConfig> levels = [
    KarmaLevelConfig(level: 1, name: 'Beginner', xpRequired: 0),
    KarmaLevelConfig(level: 2, name: 'Seeker', xpRequired: 200),
    KarmaLevelConfig(level: 3, name: 'Striver', xpRequired: 500),
    KarmaLevelConfig(level: 4, name: 'Builder', xpRequired: 1000),
    KarmaLevelConfig(level: 5, name: 'Achiever', xpRequired: 2000),
    KarmaLevelConfig(level: 8, name: 'Warrior', xpRequired: 5000),
    KarmaLevelConfig(level: 10, name: 'Champion', xpRequired: 10000),
    KarmaLevelConfig(level: 15, name: 'Elite', xpRequired: 25000),
    KarmaLevelConfig(level: 20, name: 'Legend', xpRequired: 60000),
  ];
}

/// Outcome-Based Gamification Engine per §P7-A spec
/// Rule: Zero XP awarded for logging actions (inputs). XP awarded ONLY for health outcomes & milestones.
class GamificationEngine {
  const GamificationEngine();

  /// Calculate level and Karma name based on total outcome XP
  LevelResult calculateLevel(int totalXp, {int previousLevel = 1}) {
    KarmaLevelConfig current = KarmaLevelConfig.levels.first;
    KarmaLevelConfig? next;

    for (int i = 0; i < KarmaLevelConfig.levels.length; i++) {
      if (totalXp >= KarmaLevelConfig.levels[i].xpRequired) {
        current = KarmaLevelConfig.levels[i];
        if (i + 1 < KarmaLevelConfig.levels.length) {
          next = KarmaLevelConfig.levels[i + 1];
        } else {
          next = null; // Max level reached
        }
      } else {
        break;
      }
    }

    final int xpInCurrent = totalXp - current.xpRequired;
    final int xpNeeded = next != null ? (next.xpRequired - current.xpRequired) : 10000;
    final double ratio = next != null ? (xpInCurrent / xpNeeded.toDouble()).clamp(0.0, 1.0) : 1.0;

    return LevelResult(
      currentLevel: current.level,
      levelName: current.name,
      totalXp: totalXp,
      xpInCurrentLevel: xpInCurrent,
      xpNeededForNextLevel: xpNeeded,
      levelProgressRatio: ratio,
      didLevelUp: current.level > previousLevel,
    );
  }

  /// Evaluates outcome-only XP rewards per §P7-A spec table
  int getOutcomeXpReward(String actionType) {
    switch (actionType) {
      case 'protein_target_met':
        return 50; // Outcome: nutrition goal met
      case 'sleep_streak_7d':
        return 80; // Outcome: sleep consistency
      case 'readiness_improved_weekly':
        return 100; // Outcome: recovery improving
      case 'workout_completed_full_intensity':
        return 60; // Outcome: training compliance
      case 'steps_goal_hit':
        return 30; // Outcome: movement goal
      case 'water_goal_achieved':
        return 20; // Outcome: hydration goal
      case 'program_week_completed':
        return 150; // Milestone: training phase
      case 'streak_milestone_7d':
        return 100;
      case 'streak_milestone_14d':
        return 150;
      case 'streak_milestone_30d':
        return 200;
      case 'streak_milestone_90d':
        return 500;
      case 'bmi_category_improved':
        return 300; // Major health outcome
      case 'risk_alert_resolved':
        return 200; // Meaningful health improvement
      case 'squad_challenge_won':
        return 100; // Social + performance

      // Strictly Zero XP for logging inputs per §P7-A anti-incentive directive
      case 'log_food':
      case 'log_meal':
      case 'log_water':
      case 'log_vitals':
      case 'log_sleep':
      case 'log_workout':
        return 0;

      default:
        return 0;
    }
  }
}
