import 'leaderboard_models.dart';

/// Pure Dart Deterministic Engine for Leaderboard Sorting,
/// Percentile Calculations, and Shreshthata Ranking.
class LeaderboardEngine {
  const LeaderboardEngine._();

  /// Calculates athlete's percentile from rank and total pool size
  static double calculatePercentileRank({
    required int rank,
    required int totalAthletes,
  }) {
    if (totalAthletes <= 1) return 99.0;
    final fraction = 1.0 - ((rank - 1.0) / totalAthletes);
    return (fraction * 100.0).clamp(1.0, 99.9);
  }

  /// Extracts the top 3 podium entries
  static List<LeaderboardEntry> extractPodium(List<LeaderboardEntry> entries) {
    if (entries.length <= 3) return entries;
    return entries.sublist(0, 3);
  }

  /// Calculates score gap to reach next rank
  static double calculatePointsToNextRank({
    required LeaderboardEntry userEntry,
    required List<LeaderboardEntry> allEntries,
  }) {
    if (userEntry.rank <= 1) return 0.0;
    final prevEntry = allEntries.firstWhere(
      (e) => e.rank == userEntry.rank - 1,
      orElse: () => userEntry,
    );
    return (prevEntry.scoreValue - userEntry.scoreValue).clamp(0.0, 99999.0);
  }
}
