/// §P9-E Activity Feed & Sharing Architecture — Models
///
/// Defines feed item types, privacy levels, workout/GPS route/transformation payloads,
/// and FollowSystem data models matching §P9-E specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Payloads (§P9-E Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum FeedItemType { workout, routeShare, transformation, milestone }

enum SharePrivacy { public, followersOnly, squadOnly, private }

class FollowRecord {
  const FollowRecord({
    required this.followerId,
    required this.followingId,
    required this.timestamp,
    this.isAccepted = true,
  });

  final String followerId;
  final String followingId;
  final DateTime timestamp;
  final bool isAccepted;
}

class WorkoutPayload {
  const WorkoutPayload({
    required this.exerciseName,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.formQualityScore,
  });

  final String exerciseName;
  final int durationMinutes;
  final int caloriesBurned;
  final int formQualityScore;
}

class GPSRouteSummary {
  const GPSRouteSummary({
    required this.routeId,
    required this.routeName,
    required this.distanceKm,
    required this.durationMinutes,
    required this.elevationGainM,
    required this.averagePace,
  });

  final String routeId;
  final String routeName;
  final double distanceKm;
  final int durationMinutes;
  final double elevationGainM;
  final String averagePace;
}

class TransformationPayload {
  const TransformationPayload({
    required this.weightDeltaKg,
    required this.fatLossPct,
    required this.muscleGainPct,
    required this.streakDays,
    required this.healthScoreDelta,
  });

  final double weightDeltaKg;
  final int fatLossPct;
  final int muscleGainPct;
  final int streakDays;
  final int healthScoreDelta;
}

class MilestonePayload {
  const MilestonePayload({
    required this.milestoneTitle,
    required this.streakDays,
    required this.xpEarned,
  });

  final String milestoneTitle;
  final int streakDays;
  final int xpEarned;
}

// ─────────────────────────────────────────────────────────────────────────────
// FeedItem (§P9-E Specification)
// ─────────────────────────────────────────────────────────────────────────────

class FeedItem {
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
    required this.highFiveCount,
    required this.highFivedUserIds,
    this.privacy = SharePrivacy.public,
  });

  final String localId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final FeedItemType type;
  final DateTime timestamp;

  final WorkoutPayload? workoutPayload;
  final GPSRouteSummary? routePayload;
  final TransformationPayload? transformationPayload;
  final MilestonePayload? milestonePayload;

  final int highFiveCount;
  final List<String> highFivedUserIds;
  final SharePrivacy privacy;

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
