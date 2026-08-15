enum LeaderboardMetric { steps, activeMinutes, adherenceScore }

enum LeaderboardBadge { gold, silver, bronze, top10Percent, none }

class LeaderboardUserEntry {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int
      metricValue; // Steps count, active minutes, or adherence score points
  final int rank;
  final LeaderboardBadge badge;
  final bool isCurrentUser;
  final bool isAnonymized;

  const LeaderboardUserEntry({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.metricValue,
    required this.rank,
    this.badge = LeaderboardBadge.none,
    this.isCurrentUser = false,
    this.isAnonymized = false,
  });
}

class LeaderboardRewardEvaluation {
  final bool isTop10Percent;
  final bool hasGoldenKarmaAura;
  final int xpBonus;

  const LeaderboardRewardEvaluation({
    required this.isTop10Percent,
    required this.hasGoldenKarmaAura,
    required this.xpBonus,
  });
}

/// Pure-Dart Weekly & Monthly Leaderboards Engine per §P9-G spec
class LeaderboardsEngine {
  const LeaderboardsEngine();

  /// Filters user display parameters based on Leaderboard Anonymity Toggle
  LeaderboardUserEntry applyAnonymityToggle(LeaderboardUserEntry entry) {
    if (!entry.isAnonymized) return entry;

    return LeaderboardUserEntry(
      userId: entry.userId,
      displayName: 'Anonymous Athlete',
      avatarUrl: null,
      metricValue: entry.metricValue,
      rank: entry.rank,
      badge: entry.badge,
      isCurrentUser: entry.isCurrentUser,
      isAnonymized: true,
    );
  }

  /// Calculates rank positions, assigns Gold/Silver/Bronze/Top10% badges, and applies anonymity settings
  List<LeaderboardUserEntry> generateRankedLeaderboard({
    required List<LeaderboardUserEntry> rawEntries,
    required String currentUserId,
    bool currentUserAnonymized = false,
  }) {
    // Sort descending by metric value
    final sorted = List<LeaderboardUserEntry>.from(rawEntries)
      ..sort((a, b) => b.metricValue.compareTo(a.metricValue));

    final totalCount = sorted.length;
    final ranked = <LeaderboardUserEntry>[];

    for (int i = 0; i < totalCount; i++) {
      final rank = i + 1;
      final raw = sorted[i];
      final isSelf = raw.userId == currentUserId;

      LeaderboardBadge badge = LeaderboardBadge.none;
      if (rank == 1) {
        badge = LeaderboardBadge.gold;
      } else if (rank == 2) {
        badge = LeaderboardBadge.silver;
      } else if (rank == 3) {
        badge = LeaderboardBadge.bronze;
      } else if (rank <= (totalCount * 0.10).ceil()) {
        badge = LeaderboardBadge.top10Percent;
      }

      final entry = LeaderboardUserEntry(
        userId: raw.userId,
        displayName: raw.displayName,
        avatarUrl: raw.avatarUrl,
        metricValue: raw.metricValue,
        rank: rank,
        badge: badge,
        isCurrentUser: isSelf,
        isAnonymized: isSelf ? currentUserAnonymized : raw.isAnonymized,
      );

      ranked.add(applyAnonymityToggle(entry));
    }

    return ranked;
  }

  /// Evaluates Top 10% Weekly Reward: unlocks Golden Karma Aura & +100 Karma XP bonus
  LeaderboardRewardEvaluation evaluateWeeklyRewards({
    required int userRank,
    required int totalParticipants,
  }) {
    if (totalParticipants == 0) {
      return const LeaderboardRewardEvaluation(
        isTop10Percent: false,
        hasGoldenKarmaAura: false,
        xpBonus: 0,
      );
    }

    final top10Threshold = (totalParticipants * 0.10).ceil();
    final isTop10 = userRank <= top10Threshold;

    return LeaderboardRewardEvaluation(
      isTop10Percent: isTop10,
      hasGoldenKarmaAura: isTop10,
      xpBonus: isTop10 ? 100 : 0,
    );
  }
}
