/// §P9-G Weekly & Monthly Leaderboards — Models
///
/// Defines metrics, timeframes, badges, and leaderboard entry data structures
/// matching §P9-G specification.
library;

enum LeaderboardMetric {
  steps('Steps', 'steps', '👟'),
  activeMinutes('Active Mins', 'mins', '⚡'),
  adherenceScore('Adherence', '%', '🔥');

  const LeaderboardMetric(this.displayName, this.unitLabel, this.iconSymbol);

  final String displayName;
  final String unitLabel;
  final String iconSymbol;
}

enum LeaderboardTimeframe { weekly, monthly }

enum LeaderboardBadge {
  gold('Gold Badge', '🥇', 100),
  silver('Silver Badge', '🥈', 50),
  bronze('Bronze Badge', '🥉', 25),
  top10Percent('Golden Karma Aura', '✨', 100);

  const LeaderboardBadge(this.displayName, this.iconSymbol, this.xpBonus);

  final String displayName;
  final String iconSymbol;
  final int xpBonus;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    this.userAvatar = '🏃',
    required this.score,
    required this.metricUnit,
    this.badge,
    required this.version,
    required this.lastUpdatedAt,
    this.isCurrentUser = false,
    this.isAnonymous = false,
  });

  final int rank;
  final String userId;
  final String userName;
  final String userAvatar;
  final double score;
  final String metricUnit;
  final LeaderboardBadge? badge;
  final int version;
  final DateTime lastUpdatedAt;
  final bool isCurrentUser;
  final bool isAnonymous;

  LeaderboardEntry copyWith({
    int? rank,
    LeaderboardBadge? badge,
    bool? isAnonymous,
    String? userName,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      userId: userId,
      userName: userName ?? this.userName,
      userAvatar: isAnonymous == true ? '👤' : userAvatar,
      score: score,
      metricUnit: metricUnit,
      badge: badge ?? this.badge,
      version: version,
      lastUpdatedAt: lastUpdatedAt,
      isCurrentUser: isCurrentUser,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
