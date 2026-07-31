/// Activity Feed Item Model
class ActivityFeedItem {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String title;
  final String description;
  final String timestamp;
  final int highFiveCount;
  final bool isHighFived;

  const ActivityFeedItem({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.highFiveCount,
    this.isHighFived = false,
  });

  ActivityFeedItem copyWith({
    String? id,
    String? userName,
    String? userAvatarUrl,
    String? title,
    String? description,
    String? timestamp,
    int? highFiveCount,
    bool? isHighFived,
  }) {
    return ActivityFeedItem(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      highFiveCount: highFiveCount ?? this.highFiveCount,
      isHighFived: isHighFived ?? this.isHighFived,
    );
  }
}

/// Leaderboard Entry Model
class LeaderboardEntry {
  final int rank;
  final String name;
  final int outcomeXp;
  final bool isAnonymous;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.outcomeXp,
    this.isAnonymous = false,
  });
}
