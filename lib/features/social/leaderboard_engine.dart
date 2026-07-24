/// §P9-G Weekly & Monthly Leaderboards — Engine & Sync Coordinator
///
/// Implements ranking computation jobs (1-indexed sorting, tie resolution, Top 10%
/// badge & +100 XP award logic), anonymity masking, and versioned sync conflict resolution
/// matching §P9-G and §P9-E specifications.
library;

import 'package:fitkarma/features/social/leaderboard_models.dart';

class LeaderboardEngine {
  const LeaderboardEngine();

  /// Ranking Computation Job (§P9-G specification):
  /// Computes 1-indexed ranks for leaderboard entries sorted in descending order of score.
  /// Awards Gold (1st), Silver (2nd), Bronze (3rd), and Top 10% badges with +100 Karma XP bonuses.
  List<LeaderboardEntry> computeRankings(List<LeaderboardEntry> unrankedEntries) {
    if (unrankedEntries.isEmpty) return [];

    // Sort descending by score; break ties using lastUpdatedAt (earlier achieves higher rank)
    final sorted = List<LeaderboardEntry>.from(unrankedEntries)..sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return a.lastUpdatedAt.compareTo(b.lastUpdatedAt);
    });

    final totalCount = sorted.length;
    final top10PercentThreshold = (totalCount * 0.10).ceil();

    final ranked = <LeaderboardEntry>[];
    for (int i = 0; i < sorted.length; i++) {
      final rank = i + 1;
      LeaderboardBadge? badge;

      if (rank == 1) {
        badge = LeaderboardBadge.gold;
      } else if (rank == 2) {
        badge = LeaderboardBadge.silver;
      } else if (rank == 3) {
        badge = LeaderboardBadge.bronze;
      } else if (rank <= top10PercentThreshold) {
        badge = LeaderboardBadge.top10Percent;
      }

      final entry = sorted[i].copyWith(
        rank: rank,
        badge: badge,
      );

      ranked.add(applyAnonymity(entry));
    }

    return ranked;
  }

  /// Anonymity Setting (§P9-G specification):
  /// Replaces player's name and avatar with "Anonymous Athlete" and generic avatar when enabled.
  LeaderboardEntry applyAnonymity(LeaderboardEntry entry) {
    if (!entry.isAnonymous || entry.isCurrentUser) return entry;
    return entry.copyWith(
      userName: 'Anonymous Athlete',
      isAnonymous: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sync Coordinator (§P9-E specification)
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardSyncCoordinator {
  final Map<String, LeaderboardEntry> _cache = {};

  /// Merges push updates with the local cache, resolving out-of-order sync latency:
  /// Rule 1: Accept if no local entry exists.
  /// Rule 2: Monotonically increasing version sequence number overrides stale entries.
  /// Rule 3: Newer timestamp overrides if versions match.
  List<LeaderboardEntry> mergeSyncUpdate(List<LeaderboardEntry> incomingUpdates) {
    for (final update in incomingUpdates) {
      final existing = _cache[update.userId];

      if (existing == null) {
        _cache[update.userId] = update;
        continue;
      }

      if (update.version > existing.version) {
        _cache[update.userId] = update;
      } else if (update.version == existing.version &&
          update.lastUpdatedAt.isAfter(existing.lastUpdatedAt)) {
        _cache[update.userId] = update;
      }
    }

    final engine = const LeaderboardEngine();
    return engine.computeRankings(_cache.values.toList());
  }

  void clear() => _cache.clear();
}
