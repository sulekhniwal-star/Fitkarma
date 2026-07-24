/// §P9-F Local Geolocation Clubs & Interest Circles — Models
///
/// Defines ClubType, GroupMetrics, and HealthClub models matching §P9-F specification.
library;

enum ClubType { geolocation, interestCircle }

class GroupMetrics {
  const GroupMetrics({
    required this.memberCount,
    required this.averageAdherenceScore,
    required this.totalWeeklySteps,
    required this.activeSquadMissionsCount,
  });

  final int memberCount;
  final double averageAdherenceScore;
  final int totalWeeklySteps;
  final int activeSquadMissionsCount;

  GroupMetrics copyWith({
    int? memberCount,
    double? averageAdherenceScore,
    int? totalWeeklySteps,
    int? activeSquadMissionsCount,
  }) {
    return GroupMetrics(
      memberCount: memberCount ?? this.memberCount,
      averageAdherenceScore: averageAdherenceScore ?? this.averageAdherenceScore,
      totalWeeklySteps: totalWeeklySteps ?? this.totalWeeklySteps,
      activeSquadMissionsCount: activeSquadMissionsCount ?? this.activeSquadMissionsCount,
    );
  }
}

class HealthClub {
  const HealthClub({
    required this.clubId,
    required this.name,
    required this.description,
    required this.city,
    this.microLocation,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.memberUserIds,
    required this.aggregateMetrics,
    this.interestTag,
    this.isJoined = false,
  });

  final String clubId;
  final String name;
  final String description;
  final String city;
  final String? microLocation;
  final ClubType type;
  final double latitude;
  final double longitude;
  final List<String> memberUserIds;
  final GroupMetrics aggregateMetrics;
  final String? interestTag;
  final bool isJoined;

  HealthClub copyWith({
    List<String>? memberUserIds,
    GroupMetrics? aggregateMetrics,
    bool? isJoined,
  }) {
    return HealthClub(
      clubId: clubId,
      name: name,
      description: description,
      city: city,
      microLocation: microLocation,
      type: type,
      latitude: latitude,
      longitude: longitude,
      memberUserIds: memberUserIds ?? this.memberUserIds,
      aggregateMetrics: aggregateMetrics ?? this.aggregateMetrics,
      interestTag: interestTag,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
