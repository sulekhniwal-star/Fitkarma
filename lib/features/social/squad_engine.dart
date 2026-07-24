/// §P9-B Squad System — Engine & Models
///
/// Pure Dart logic for squad mission progress, challenge eligibility (>=60% High readiness),
/// average readiness score calculations, and collective streak tracking matching §P9-B spec.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Models (§P9-B Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum SquadMemberReadinessTier {
  high('High', 80.0, 100.0, '🟩'),
  moderate('Moderate', 60.0, 79.9, '🟨'),
  low('Low', 0.0, 59.9, '🟥');

  const SquadMemberReadinessTier(
    this.displayName,
    this.minScore,
    this.maxScore,
    this.indicatorEmoji,
  );

  final String displayName;
  final double minScore;
  final double maxScore;
  final String indicatorEmoji;

  static SquadMemberReadinessTier fromScore(double score) {
    if (score >= 80.0) return SquadMemberReadinessTier.high;
    if (score >= 60.0) return SquadMemberReadinessTier.moderate;
    return SquadMemberReadinessTier.low;
  }
}

class SquadGroup {
  const SquadGroup({
    required this.squadId,
    required this.squadName,
    required this.creatorId,
    required this.collectiveStreakDays,
    required this.createdAt,
  });

  final String squadId;
  final String squadName;
  final String creatorId;
  final int collectiveStreakDays;
  final DateTime createdAt;
}

class SquadMemberItem {
  const SquadMemberItem({
    required this.userId,
    required this.squadId,
    required this.name,
    required this.readinessScore,
    required this.hasLoggedToday,
    this.isCurrentUser = false,
  });

  final String userId;
  final String squadId;
  final String name;
  final double readinessScore;
  final bool hasLoggedToday;
  final bool isCurrentUser;

  SquadMemberReadinessTier get readinessTier =>
      SquadMemberReadinessTier.fromScore(readinessScore);
}

class SquadMissionData {
  const SquadMissionData({
    required this.id,
    required this.squadId,
    required this.title,
    required this.description,
    required this.targetMetricValue,
    required this.currentAverageValue,
    required this.unit,
  });

  final String id;
  final String squadId;
  final String title;
  final String description;
  final double targetMetricValue;
  final double currentAverageValue;
  final String unit;

  double get progressPercent =>
      targetMetricValue > 0 ? (currentAverageValue / targetMetricValue).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => currentAverageValue >= targetMetricValue;
}

class SquadChallengeData {
  const SquadChallengeData({
    required this.id,
    required this.squadId,
    required this.title,
    required this.description,
    this.minHighReadinessRatio = 0.60, // 60% requirement
    required this.isUnlocked,
    required this.isAccepted,
  });

  final String id;
  final String squadId;
  final String title;
  final String description;
  final double minHighReadinessRatio;
  final bool isUnlocked;
  final bool isAccepted;
}

// ─────────────────────────────────────────────────────────────────────────────
// SquadEngine (§P9-B Specification)
// ─────────────────────────────────────────────────────────────────────────────

class SquadEngine {
  const SquadEngine();

  /// Computes mean readiness score across squad members.
  double computeAverageReadiness(List<SquadMemberItem> members) {
    if (members.isEmpty) return 70.0;
    final total = members.fold<double>(0.0, (sum, m) => sum + m.readinessScore);
    return double.parse((total / members.length).toStringAsFixed(1));
  }

  /// Challenge eligibility rule (§P9-B spec):
  /// Returns true if >= 60% of squad members have High readiness (score >= 80).
  bool isChallengeEligible(List<SquadMemberItem> members) {
    if (members.isEmpty) return false;
    final highCount = members.where((m) => m.readinessTier == SquadMemberReadinessTier.high).length;
    final ratio = highCount / members.length.toDouble();
    return ratio >= 0.60;
  }

  /// Evaluates collective squad streak logic.
  /// If all members logged today, returns current streak + 1; otherwise retains or resets.
  int evaluateCollectiveStreak({
    required List<SquadMemberItem> members,
    required int currentStreakDays,
  }) {
    if (members.isEmpty) return currentStreakDays;
    final allLoggedToday = members.every((m) => m.hasLoggedToday);
    if (allLoggedToday) return currentStreakDays + 1;
    return currentStreakDays;
  }
}
