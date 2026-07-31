import 'dart:math';

/// Level Calculation Result
class LevelResult {
  final int currentLevel;
  final int totalXp;
  final int xpForNextLevel;
  final double levelProgressRatio;
  final bool didLevelUp;

  const LevelResult({
    required this.currentLevel,
    required this.totalXp,
    required this.xpForNextLevel,
    required this.levelProgressRatio,
    required this.didLevelUp,
  });
}

/// Outcome-Based Gamification Engine (Zero XP for logging)
class GamificationEngine {
  const GamificationEngine();

  /// Calculate level from total outcome XP: Level = floor(sqrt(XP / 100)) + 1
  LevelResult calculateLevel(int totalXp, {int previousLevel = 1}) {
    final level = (sqrt(totalXp / 100.0)).floor() + 1;
    final currentLevelBaseXp = ((level - 1) * (level - 1)) * 100;
    final nextLevelBaseXp = (level * level) * 100;
    final range = nextLevelBaseXp - currentLevelBaseXp;
    final progress = range > 0 ? (totalXp - currentLevelBaseXp) / range : 0.0;

    return LevelResult(
      currentLevel: level,
      totalXp: totalXp,
      xpForNextLevel: nextLevelBaseXp,
      levelProgressRatio: progress.clamp(0.0, 1.0),
      didLevelUp: level > previousLevel,
    );
  }

  /// Evaluate XP award for actions (Returns 0 XP for logging actions)
  int getOutcomeXpReward(String actionType) {
    switch (actionType) {
      case 'workout_completed':
        return 150;
      case 'protein_target_met':
        return 100;
      case 'readiness_streak_7d':
        return 300;
      case 'log_meal':
      case 'log_vitals':
      case 'log_sleep':
        return 0; // Strict rule: Zero XP for logging
      default:
        return 0;
    }
  }
}
