enum FeedItemType { workout, routeShare, transformation, milestone }

enum SharePrivacy { public, followersOnly, squadOnly, private }

class GPSRouteSummary {
  final String routeId;
  final String routeName;
  final double distanceKm;
  final Duration duration;
  final double elevationGainM;
  final String averagePace;

  const GPSRouteSummary({
    required this.routeId,
    required this.routeName,
    required this.distanceKm,
    required this.duration,
    required this.elevationGainM,
    required this.averagePace,
  });
}

class TransformationPayload {
  final double weightDeltaKg;
  final int fatLossPct;
  final int muscleGainPct;
  final int streakDays;
  final int healthScoreDelta;

  const TransformationPayload({
    required this.weightDeltaKg,
    required this.fatLossPct,
    required this.muscleGainPct,
    required this.streakDays,
    required this.healthScoreDelta,
  });
}

class MilestonePayload {
  final String milestoneTitle;
  final String description;
  final int xpAwarded;

  const MilestonePayload({
    required this.milestoneTitle,
    required this.description,
    required this.xpAwarded,
  });
}

class WorkoutSummaryPayload {
  final String workoutTitle;
  final int durationMinutes;
  final int caloriesBurned;

  const WorkoutSummaryPayload({
    required this.workoutTitle,
    required this.durationMinutes,
    required this.caloriesBurned,
  });
}

class FeedItem {
  final String localId;
  final String userId;
  final String userName;
  final String? userAvatar; // Anonymized fitness avatar
  final FeedItemType type;
  final DateTime timestamp;

  // Shared payloads
  final WorkoutSummaryPayload? workoutPayload;
  final GPSRouteSummary? routePayload;
  final TransformationPayload? transformationPayload;
  final MilestonePayload? milestonePayload;

  // Engagement
  final int highFiveCount;
  final List<String> highFivedUserIds;
  final SharePrivacy privacy;

  const FeedItem({
    required this.localId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.type,
    required this.timestamp,
    this.workoutPayload,
    this.routePayload,
    this.transformationPayload,
    this.milestonePayload,
    this.highFiveCount = 0,
    this.highFivedUserIds = const [],
    this.privacy = SharePrivacy.public,
  });

  FeedItem copyWith({
    int? highFiveCount,
    List<String>? highFivedUserIds,
  }) {
    return FeedItem(
      localId: localId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      type: type,
      timestamp: timestamp,
      workoutPayload: workoutPayload,
      routePayload: routePayload,
      transformationPayload: transformationPayload,
      milestonePayload: milestonePayload,
      highFiveCount: highFiveCount ?? this.highFiveCount,
      highFivedUserIds: highFivedUserIds ?? this.highFivedUserIds,
      privacy: privacy,
    );
  }
}

class FeedItemPayload {
  final String? imageUrl;
  final int? imageSizeBytes;
  final String? gpxData; // raw GPX string
  final String? linkUrl;

  const FeedItemPayload({
    this.imageUrl,
    this.imageSizeBytes,
    this.gpxData,
    this.linkUrl,
  });
}

/// Pure-Dart Feed Curation & Spam Prevention Engine per §P9-E spec
class FeedCurationEngine {
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxGpxTrackpoints = 2000;

  static const Set<String> _allowedDomains = {
    'fitkarma.com',
    'strava.com',
    'komoot.com',
    'garmin.com',
    'google.com',
  };

  const FeedCurationEngine();

  /// Deterministic Action Gate: Auto-sharing is restricted strictly to high-impact achievements.
  /// Micro-logs (water intake, individual meal logs, biometric weight) are strictly private.
  bool isActionEligibleForFeedShare({
    required FeedItemType type,
    WorkoutSummaryPayload? workout,
    MilestonePayload? milestone,
  }) {
    if (type == FeedItemType.workout) {
      if (workout == null) return false;
      // Workout must be >= 20 mins and > 100 active calories burned
      return workout.durationMinutes >= 20 && workout.caloriesBurned > 100;
    }

    if (type == FeedItemType.milestone || type == FeedItemType.transformation || type == FeedItemType.routeShare) {
      return true;
    }

    return false;
  }

  /// Scans links in social posts to block phishing, link hijacking, or spam domains.
  bool scanFeedLink(String url) {
    if (url.trim().isEmpty) return true;

    try {
      final uri = Uri.parse(url);
      if (uri.scheme != 'https') return false;

      final host = uri.host.toLowerCase();
      final isWhitelisted = _allowedDomains.any((domain) => host == domain || host.endsWith('.$domain'));
      if (!isWhitelisted) return false;

      if (uri.queryParameters.containsKey('redirect') ||
          uri.queryParameters.containsKey('next') ||
          uri.path.contains('/login') ||
          uri.path.contains('/signin')) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Validates route GPX structures and photo sizes to prevent database bloat and abuse
  bool validatePayload(FeedItemPayload payload) {
    if (payload.imageSizeBytes != null && payload.imageSizeBytes! > maxImageSizeBytes) {
      return false;
    }

    if (payload.gpxData != null) {
      final gpx = payload.gpxData!;
      if (!gpx.contains('<gpx') || !gpx.contains('</gpx>')) {
        return false;
      }

      int trackpointCount = 0;
      int index = 0;
      while ((index = gpx.indexOf('<trkpt', index)) != -1) {
        trackpointCount++;
        index += 6;
      }

      if (trackpointCount > maxGpxTrackpoints) {
        return false;
      }
    }

    if (payload.linkUrl != null && !scanFeedLink(payload.linkUrl!)) {
      return false;
    }

    return true;
  }
}

/// Pure-Dart Feed Engagement & Reaction Engine per §P9-E spec
class FeedEngagementResult {
  final FeedItem updatedItem;
  final int xpAwardedToPoster;
  final bool isCapped;

  const FeedEngagementResult({
    required this.updatedItem,
    required this.xpAwardedToPoster,
    required this.isCapped,
  });
}

class FeedEngagementEngine {
  static const int xpPerHighFive = 2;
  static const int maxPosterDailyXpCap = 10;
  static const int maxGiverDailyHighFives = 10;

  const FeedEngagementEngine();

  /// Processes High-Five reaction with XP-backed reward logic and daily anti-bot capping
  FeedEngagementResult processHighFive({
    required FeedItem item,
    required String actionUserId,
    required int giverDailyHighFiveCount,
    required int posterTodayXpReceived,
  }) {
    final hasAlreadyHighFived = item.highFivedUserIds.contains(actionUserId);

    if (hasAlreadyHighFived) {
      final updatedUserIds = List<String>.from(item.highFivedUserIds)..remove(actionUserId);
      final updatedItem = item.copyWith(
        highFiveCount: (item.highFiveCount - 1).clamp(0, 9999),
        highFivedUserIds: updatedUserIds,
      );
      return FeedEngagementResult(updatedItem: updatedItem, xpAwardedToPoster: 0, isCapped: false);
    }

    // Check Giver daily cap (max 10 high-fives given per day)
    if (giverDailyHighFiveCount >= maxGiverDailyHighFives) {
      return FeedEngagementResult(updatedItem: item, xpAwardedToPoster: 0, isCapped: true);
    }

    // Calculate poster XP award (capped at 10 XP per day received)
    int xpAward = 0;
    if (posterTodayXpReceived < maxPosterDailyXpCap) {
      xpAward = (posterTodayXpReceived + xpPerHighFive <= maxPosterDailyXpCap)
          ? xpPerHighFive
          : (maxPosterDailyXpCap - posterTodayXpReceived);
    }

    final updatedUserIds = [...item.highFivedUserIds, actionUserId];
    final updatedItem = item.copyWith(
      highFiveCount: item.highFiveCount + 1,
      highFivedUserIds: updatedUserIds,
    );

    return FeedEngagementResult(
      updatedItem: updatedItem,
      xpAwardedToPoster: xpAward,
      isCapped: posterTodayXpReceived >= maxPosterDailyXpCap,
    );
  }
}
