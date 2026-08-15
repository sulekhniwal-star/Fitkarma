import 'dart:math';

enum ClubType { geolocation, interestCircle }

class GroupMetrics {
  final int memberCount;
  final double averageAdherenceScore; // Team weekly adherence
  final int totalWeeklySteps;
  final int activeSquadMissionsCount;

  const GroupMetrics({
    required this.memberCount,
    required this.averageAdherenceScore,
    required this.totalWeeklySteps,
    required this.activeSquadMissionsCount,
  });
}

class HealthClub {
  final String clubId;
  final String name;
  final String description;
  final String city;
  final String?
      microLocation; // e.g. "Noida Sector 62", "Indiranagar Bangalore"
  final ClubType type;
  final double latitude;
  final double longitude;
  final List<String> memberUserIds;
  final GroupMetrics aggregateMetrics;

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
  });
}

class GeolocationClubMatch {
  final HealthClub club;
  final double distanceKm;
  final bool isNearby; // Within 15km

  const GeolocationClubMatch({
    required this.club,
    required this.distanceKm,
    required this.isNearby,
  });
}

/// Pure-Dart Geolocation Clubs & Interest Circles Engine per §P9-F spec
class GeolocationClubsEngine {
  const GeolocationClubsEngine();

  /// Calculates Haversine distance in kilometers between two GPS coordinates
  double calculateHaversineDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const r = 6371.0; // Earth radius in km
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Returns pre-seeded local Indian geolocation clubs and interest circles
  List<HealthClub> getPreSeededClubs() {
    return const [
      HealthClub(
        clubId: 'club_noida_62',
        name: 'Noida Sector 62 Striders',
        description: 'Morning walking & jogging club around Sector 62 parks.',
        city: 'Noida',
        microLocation: 'Noida Sector 62',
        type: ClubType.geolocation,
        latitude: 28.6280,
        longitude: 77.3649,
        memberUserIds: ['u1', 'u2', 'u3', 'u4'],
        aggregateMetrics: GroupMetrics(
          memberCount: 42,
          averageAdherenceScore: 84.5,
          totalWeeklySteps: 245000,
          activeSquadMissionsCount: 3,
        ),
      ),
      HealthClub(
        clubId: 'club_indiranagar_blr',
        name: 'Indiranagar Morning Runners',
        description: 'Paced 5K & 10K weekend morning runs in Bangalore.',
        city: 'Bangalore',
        microLocation: 'Indiranagar',
        type: ClubType.geolocation,
        latitude: 12.9784,
        longitude: 77.6408,
        memberUserIds: ['u5', 'u6', 'u7'],
        aggregateMetrics: GroupMetrics(
          memberCount: 68,
          averageAdherenceScore: 89.0,
          totalWeeklySteps: 410000,
          activeSquadMissionsCount: 5,
        ),
      ),
      HealthClub(
        clubId: 'circle_veg_muscle',
        name: 'Vegetarian Muscle Builders Circle',
        description:
            'Nationwide interest circle for Satvik & vegetarian strength athletes.',
        city: 'India Nationwide',
        microLocation: null,
        type: ClubType.interestCircle,
        latitude: 20.5937,
        longitude: 78.9629,
        memberUserIds: ['u1', 'u5', 'u8', 'u9'],
        aggregateMetrics: GroupMetrics(
          memberCount: 1120,
          averageAdherenceScore: 82.0,
          totalWeeklySteps: 8900000,
          activeSquadMissionsCount: 12,
        ),
      ),
    ];
  }

  /// Matches clubs based on user's current latitude & longitude (within 15km threshold)
  List<GeolocationClubMatch> matchNearbyClubs({
    required double userLat,
    required double userLon,
    double radiusKmThreshold = 15.0,
    List<HealthClub>? clubs,
  }) {
    final clubList = clubs ?? getPreSeededClubs();
    final matches = <GeolocationClubMatch>[];

    for (final club in clubList) {
      if (club.type == ClubType.interestCircle) {
        // Interest circles are nationwide (always matched)
        matches.add(
            GeolocationClubMatch(club: club, distanceKm: 0.0, isNearby: true));
        continue;
      }

      final dist = calculateHaversineDistanceKm(
        lat1: userLat,
        lon1: userLon,
        lat2: club.latitude,
        lon2: club.longitude,
      );

      matches.add(GeolocationClubMatch(
        club: club,
        distanceKm: dist,
        isNearby: dist <= radiusKmThreshold,
      ));
    }

    matches.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return matches;
  }
}
