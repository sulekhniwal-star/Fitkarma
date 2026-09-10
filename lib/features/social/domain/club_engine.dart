import 'dart:math' as math;
import 'club_models.dart';

/// Pure Dart Deterministic Engine for Geolocation Calculations,
/// Haversine Distance Filters, and Local Club Rankings.
class LocalClubEngine {
  const LocalClubEngine._();

  /// Calculates great-circle distance between two coordinates in kilometers using Haversine formula
  static double calculateHaversineDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final lat1Rad = _degreesToRadians(lat1);
    final lat2Rad = _degreesToRadians(lat2);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) *
            math.sin(dLon / 2) *
            math.cos(lat1Rad) *
            math.cos(lat2Rad);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Filters and sorts clubs within specified radius
  static List<LocalGeoClub> filterClubsByRadius({
    required List<LocalGeoClub> clubs,
    required double maxRadiusKm,
  }) {
    final filtered =
        clubs.where((c) => c.distanceFromUserKm <= maxRadiusKm).toList();
    filtered
        .sort((a, b) => a.distanceFromUserKm.compareTo(b.distanceFromUserKm));
    return filtered;
  }
}
