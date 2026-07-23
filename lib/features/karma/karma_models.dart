/// §P7-A Karma System Design — Models & Level Tables
///
/// Implements outcome-rewarding XP event types and level progression tiers
/// matching §P7-A specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Outcome-Rewarding XP Event Types (§P7-A Specification Table)
// ─────────────────────────────────────────────────────────────────────────────

enum KarmaEventType {
  /// Outcome: nutrition goal met (+50 XP)
  proteinTargetHit(50, 'Protein target achieved'),

  /// Outcome: sleep consistency (+80 XP)
  sleepStreak7d(80, '7-day sleep streak (≥ 7h)'),

  /// Outcome: recovery improving (+100 XP)
  readinessImproved(100, 'Readiness improved vs last week'),

  /// Outcome: training compliance (+60 XP)
  workoutFullIntensity(60, 'Workout completed at full intensity'),

  /// Outcome: movement goal (+30 XP)
  stepsGoalHit(30, 'Steps goal hit'),

  /// Outcome: hydration goal (+20 XP)
  waterGoalHit(20, 'Water goal achieved'),

  /// Milestone: training phase (+150 XP)
  programWeekCompleted(150, 'Program week completed'),

  /// Milestone: 7-day streak (+100 XP)
  streakMilestone7d(100, '7-day streak milestone'),

  /// Milestone: 14-day streak (+150 XP)
  streakMilestone14d(150, '14-day streak milestone'),

  /// Milestone: 30-day streak (+200 XP)
  streakMilestone30d(200, '30-day streak milestone'),

  /// Milestone: 90-day streak (+500 XP)
  streakMilestone90d(500, '90-day streak milestone'),

  /// Major outcome: body composition (+300 XP)
  bmiCategoryImproved(300, 'BMI category improvement'),

  /// Outcome: health risk resolution (+200 XP)
  riskAlertResolved(200, 'Risk alert resolved'),

  /// Social/performance: squad challenge (+100 XP)
  squadChallengeWon(100, 'Squad challenge won');

  const KarmaEventType(this.baseXp, this.displayName);

  final int baseXp;
  final String displayName;
}

// ─────────────────────────────────────────────────────────────────────────────
// Karma Level (§P7-A Specification Table)
// ─────────────────────────────────────────────────────────────────────────────

class KarmaLevel {
  const KarmaLevel({
    required this.levelNumber,
    required this.name,
    required this.xpRequired,
  });

  final int levelNumber;
  final String name;
  final int xpRequired;
}

abstract class KarmaLevelTable {
  static const List<KarmaLevel> levels = [
    KarmaLevel(levelNumber: 1, name: 'Beginner', xpRequired: 0),
    KarmaLevel(levelNumber: 2, name: 'Seeker', xpRequired: 200),
    KarmaLevel(levelNumber: 3, name: 'Striver', xpRequired: 500),
    KarmaLevel(levelNumber: 4, name: 'Builder', xpRequired: 1000),
    KarmaLevel(levelNumber: 5, name: 'Achiever', xpRequired: 2000),
    KarmaLevel(levelNumber: 8, name: 'Warrior', xpRequired: 5000),
    KarmaLevel(levelNumber: 10, name: 'Champion', xpRequired: 10000),
    KarmaLevel(levelNumber: 15, name: 'Elite', xpRequired: 25000),
    KarmaLevel(levelNumber: 20, name: 'Legend', xpRequired: 60000),
  ];

  /// Finds the KarmaLevel for a given cumulative XP amount.
  static KarmaLevel getLevelForXp(int xp) {
    KarmaLevel current = levels.first;
    for (final level in levels) {
      if (xp >= level.xpRequired) {
        current = level;
      } else {
        break;
      }
    }
    return current;
  }

  /// Finds the next KarmaLevel, or null if already at max level (Legend).
  static KarmaLevel? getNextLevel(int currentLevelNumber) {
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].levelNumber > currentLevelNumber) {
        return levels[i];
      }
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Log Record Model
// ─────────────────────────────────────────────────────────────────────────────

class KarmaEventRecord {
  const KarmaEventRecord({
    required this.id,
    required this.eventType,
    required this.xpAwarded,
    required this.timestamp,
    required this.description,
  });

  final String id;
  final KarmaEventType eventType;
  final int xpAwarded;
  final DateTime timestamp;
  final String description;
}
