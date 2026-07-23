/// §P7-A Karma System Design — Karma Engine
///
/// Deterministic logic for calculating Karma profile metrics: total XP,
/// level resolution, progress percentage, and level-up detection.
library;

import 'package:fitkarma/features/karma/karma_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Profile Summary Output Model
// ─────────────────────────────────────────────────────────────────────────────

class KarmaProfileSummary {
  const KarmaProfileSummary({
    required this.totalXp,
    required this.currentLevel,
    required this.nextLevel,
    required this.progressToNextLevel,
    required this.xpInCurrentLevel,
    required this.xpNeededForNextLevel,
  });

  final int totalXp;
  final KarmaLevel currentLevel;
  final KarmaLevel? nextLevel;

  /// Progress from current level start to next level target (0.0 to 1.0).
  final double progressToNextLevel;

  final int xpInCurrentLevel;
  final int xpNeededForNextLevel;

  bool get isMaxLevel => nextLevel == null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine
// ─────────────────────────────────────────────────────────────────────────────

class KarmaEngine {
  const KarmaEngine();

  /// Computes a full profile summary for a cumulative XP total.
  KarmaProfileSummary calculateProfile(int totalXp) {
    final currentLevel = KarmaLevelTable.getLevelForXp(totalXp);
    final nextLevel = KarmaLevelTable.getNextLevel(currentLevel.levelNumber);

    if (nextLevel == null) {
      // User is at max level (Legend)
      return KarmaProfileSummary(
        totalXp: totalXp,
        currentLevel: currentLevel,
        nextLevel: null,
        progressToNextLevel: 1.0,
        xpInCurrentLevel: totalXp - currentLevel.xpRequired,
        xpNeededForNextLevel: 0,
      );
    }

    final levelRange = nextLevel.xpRequired - currentLevel.xpRequired;
    final xpInLevel = totalXp - currentLevel.xpRequired;
    final xpNeeded = nextLevel.xpRequired - totalXp;
    final progress = levelRange > 0 ? (xpInLevel / levelRange).clamp(0.0, 1.0) : 1.0;

    return KarmaProfileSummary(
      totalXp: totalXp,
      currentLevel: currentLevel,
      nextLevel: nextLevel,
      progressToNextLevel: progress,
      xpInCurrentLevel: xpInLevel,
      xpNeededForNextLevel: xpNeeded,
    );
  }

  /// Calculates XP awarded for an event type. Returns 0 for non-outcome inputs.
  int calculateXpForEvent(KarmaEventType eventType) {
    return eventType.baseXp;
  }

  /// Checks if adding [eventXp] to [previousXp] triggers a level up.
  bool isLevelUp(int previousXp, int eventXp) {
    final oldLevel = KarmaLevelTable.getLevelForXp(previousXp);
    final newLevel = KarmaLevelTable.getLevelForXp(previousXp + eventXp);
    return newLevel.levelNumber > oldLevel.levelNumber;
  }
}
