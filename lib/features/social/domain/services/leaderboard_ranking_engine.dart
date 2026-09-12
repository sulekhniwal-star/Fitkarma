import '../models/social_models.dart';

class LeaderboardRankingEngine {
  const LeaderboardRankingEngine();

  /// Rank individual users by total Karma points
  List<LeaderboardRank> rankUsersByKarma({
    required List<LeaderboardRank> rawEntries,
    required String currentUserId,
  }) {
    final sorted = List<LeaderboardRank>.from(rawEntries)
      ..sort((a, b) {
        final karmaCmp = b.totalKarma.compareTo(a.totalKarma);
        if (karmaCmp != 0) return karmaCmp;
        return b.streakDays.compareTo(a.streakDays);
      });

    final List<LeaderboardRank> ranked = [];
    for (int i = 0; i < sorted.length; i++) {
      final item = sorted[i];
      final rankNum = i + 1;
      String badge = item.cohortBadge;

      if (rankNum == 1) {
        badge = '👑 Golden Yogi (#1)';
      } else if (rankNum <= 3) {
        badge = '⚡ Podium Elite (Top 3)';
      } else if (rankNum <= 10) {
        badge = '🔥 Top 10 Champion';
      }

      ranked.add(LeaderboardRank(
        rank: rankNum,
        entityId: item.entityId,
        name: item.name,
        avatarUrl: item.avatarUrl,
        totalKarma: item.totalKarma,
        streakDays: item.streakDays,
        cohortBadge: badge,
        isCurrentUser: item.entityId == currentUserId,
      ));
    }

    return ranked;
  }

  /// Rank squads by combined karma & active members
  List<Squad> rankSquads(List<Squad> squads) {
    return List<Squad>.from(squads)
      ..sort((a, b) {
        final karmaCmp = b.totalKarma.compareTo(a.totalKarma);
        if (karmaCmp != 0) return karmaCmp;
        return b.streakDays.compareTo(a.streakDays);
      });
  }
}
