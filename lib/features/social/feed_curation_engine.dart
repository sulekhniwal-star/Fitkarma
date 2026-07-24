/// §P9-E Activity Feed — Feed Curation Engine & Security Scanner
///
/// Implements structural curation filter (auto-shares completed workouts >20 min,
/// GPS routes, milestone streaks; strictly excludes routine water/meal logs),
/// link security scanner, and High-Five reaction XP rules (+2 XP, max 10 XP cap).
library;

import 'package:fitkarma/features/social/feed_models.dart';

class FeedCurationEngine {
  const FeedCurationEngine();

  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const Set<String> allowedLinkDomains = {
    'fitkarma.com',
    'strava.com',
    'komoot.com',
    'garmin.com',
    'google.com',
  };

  /// Structural Curation Filter (§P9-E specification):
  /// Returns true ONLY for high-impact achievements (workouts >20 min with >100 kcal, GPS routes, milestones).
  /// Strictly filters out routine micro-logs (water intake, individual meal logs).
  bool shouldCurateItem({
    required FeedItemType type,
    int? workoutDurationMinutes,
    int? caloriesBurned,
  }) {
    switch (type) {
      case FeedItemType.workout:
        if (workoutDurationMinutes != null && caloriesBurned != null) {
          return workoutDurationMinutes >= 20 && caloriesBurned >= 100;
        }
        return true;
      case FeedItemType.routeShare:
      case FeedItemType.transformation:
      case FeedItemType.milestone:
        return true;
    }
  }

  /// Scans links in social posts to block HTTP, link hijacking, or unapproved domains.
  bool scanFeedLink(String url) {
    if (url.trim().isEmpty) return true;

    try {
      final uri = Uri.parse(url);

      // Enforce HTTPS
      if (uri.scheme != 'https') return false;

      final host = uri.host.toLowerCase();
      return allowedLinkDomains.any(
        (domain) => host == domain || host.endsWith('.$domain'),
      );
    } catch (_) {
      return false;
    }
  }

  /// High-Five Reaction XP Rule (§P9-E spec):
  /// Each High-Five awards +2 XP up to a maximum cap of 10 XP received per post.
  int calculateHighFiveXp(int currentXpEarnedOnPost) {
    if (currentXpEarnedOnPost >= 10) return 0;
    const bonus = 2;
    return (currentXpEarnedOnPost + bonus > 10)
        ? (10 - currentXpEarnedOnPost)
        : bonus;
  }
}
