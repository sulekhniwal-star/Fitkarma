import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/geolocation_clubs_engine.dart';

void main() {
  group('§P9-F Local Geolocation Clubs & Interest Circles Tests', () {
    const engine = GeolocationClubsEngine();

    test('calculateHaversineDistanceKm calculates distance between Noida Sector 62 and Connaught Place Delhi correctly (~18km)', () {
      // Noida Sector 62: 28.6280, 77.3649
      // Connaught Place Delhi: 28.6315, 77.2167
      final dist = engine.calculateHaversineDistanceKm(
        lat1: 28.6280,
        lon1: 77.3649,
        lat2: 28.6315,
        lon2: 77.2167,
      );

      expect(dist, greaterThan(14.0));
      expect(dist, lessThan(22.0));
    });

    test('matchNearbyClubs returns nearby clubs within 15km threshold and includes interest circles', () {
      // User located in Noida Sector 63 (28.6250, 77.3750)
      final matches = engine.matchNearbyClubs(
        userLat: 28.6250,
        userLon: 77.3750,
        radiusKmThreshold: 15.0,
      );

      expect(matches.length, equals(3));
      final noidaMatch = matches.firstWhere((m) => m.club.clubId == 'club_noida_62');
      expect(noidaMatch.isNearby, isTrue);
      expect(noidaMatch.distanceKm, lessThan(3.0));

      final blrMatch = matches.firstWhere((m) => m.club.clubId == 'club_indiranagar_blr');
      expect(blrMatch.isNearby, isFalse);

      final circleMatch = matches.firstWhere((m) => m.club.clubId == 'circle_veg_muscle');
      expect(circleMatch.isNearby, isTrue); // Interest circles are nationwide
    });
  });
}
