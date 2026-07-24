/// §P9-F Local Geolocation Clubs — Engine
///
/// Pure Dart logic for Haversine geolocation distance calculation, proximity sorting,
/// interest circle profile matching, and club membership toggling.
library;

import 'dart:math' as math;
import 'package:fitkarma/features/social/club_models.dart';

class ClubEngine {
  const ClubEngine();

  /// Calculates geographical distance in kilometers between two lat/long coordinates
  /// using the Haversine formula (§P9-F spec).
  double computeDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const rEarth = 6371.0; // Earth radius in km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return double.parse((rEarth * c).toStringAsFixed(1));
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  /// Filters and sorts geolocation clubs by proximity (within maxRadiusKm).
  List<HealthClub> filterNearbyClubs({
    required List<HealthClub> clubs,
    required double userLat,
    required double userLon,
    double maxRadiusKm = 10.0,
  }) {
    final nearby = clubs.where((club) {
      if (club.type != ClubType.geolocation) return false;
      final dist = computeDistanceKm(userLat, userLon, club.latitude, club.longitude);
      return dist <= maxRadiusKm;
    }).toList();

    nearby.sort((a, b) {
      final distA = computeDistanceKm(userLat, userLon, a.latitude, a.longitude);
      final distB = computeDistanceKm(userLat, userLon, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });

    return nearby;
  }

  /// Filters interest circles matching user profile tags.
  List<HealthClub> matchInterestCircles({
    required List<HealthClub> clubs,
    required String interestTag,
  }) {
    return clubs.where((club) {
      if (club.type != ClubType.interestCircle) return false;
      return club.interestTag?.toLowerCase() == interestTag.toLowerCase();
    }).toList();
  }

  /// Toggles membership status for a club and updates member count metrics.
  HealthClub toggleClubMembership(HealthClub club, String userId) {
    final members = List<String>.from(club.memberUserIds);
    final newIsJoined = !club.isJoined;

    if (newIsJoined) {
      if (!members.contains(userId)) members.add(userId);
    } else {
      members.remove(userId);
    }

    final newCount = members.length;
    final newMetrics = club.aggregateMetrics.copyWith(memberCount: newCount);

    return club.copyWith(
      memberUserIds: members,
      aggregateMetrics: newMetrics,
      isJoined: newIsJoined,
    );
  }
}
