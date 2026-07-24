/// §P9-F Local Geolocation Clubs — Persistence Repository
///
/// In-memory repository for storing HealthClub records across major Indian regions
/// (Noida, Bangalore, Mumbai, Gurgaon) matching §P9-F specification.
library;

import 'package:fitkarma/features/social/club_engine.dart';
import 'package:fitkarma/features/social/club_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubRepository {
  ClubRepository() {
    _initializeDefaultClubs();
  }

  final ClubEngine _engine = const ClubEngine();
  late List<HealthClub> _clubs;

  void _initializeDefaultClubs() {
    _clubs = [
      // 1. Geolocation Club: Noida Sector 62 Striders (Noida coordinates: 28.6280, 77.3649)
      const HealthClub(
        clubId: 'club_noida_sec62',
        name: 'Noida Sec 62 Striders',
        description: 'Morning walking & running club around Sector 62 Park',
        city: 'Noida',
        microLocation: 'Sector 62',
        type: ClubType.geolocation,
        latitude: 28.6280,
        longitude: 77.3649,
        memberUserIds: ['user_priya', 'user_rohan', 'user_me'],
        aggregateMetrics: GroupMetrics(
          memberCount: 142,
          averageAdherenceScore: 82.5,
          totalWeeklySteps: 1250000,
          activeSquadMissionsCount: 3,
        ),
        isJoined: true,
      ),

      // 2. Geolocation Club: Cyber City Walkers Gurugram (Gurgaon coordinates: 28.4950, 77.0890)
      const HealthClub(
        clubId: 'club_gurugram_cybercity',
        name: 'Cyber City Walkers',
        description: 'Post-work steps & evening jog community in DLF Cyber City',
        city: 'Gurugram',
        microLocation: 'Cyber City',
        type: ClubType.geolocation,
        latitude: 28.4950,
        longitude: 77.0890,
        memberUserIds: ['user_amit'],
        aggregateMetrics: GroupMetrics(
          memberCount: 98,
          averageAdherenceScore: 76.0,
          totalWeeklySteps: 890000,
          activeSquadMissionsCount: 2,
        ),
        isJoined: false,
      ),

      // 3. Geolocation Club: Indiranagar Runners Bangalore (Bangalore coordinates: 12.9784, 77.6408)
      const HealthClub(
        clubId: 'club_blore_indiranagar',
        name: 'Indiranagar Runners',
        description: 'Weekend 10k runners & strength training circle',
        city: 'Bengaluru',
        microLocation: 'Indiranagar 100ft Road',
        type: ClubType.geolocation,
        latitude: 12.9784,
        longitude: 77.6408,
        memberUserIds: [],
        aggregateMetrics: GroupMetrics(
          memberCount: 215,
          averageAdherenceScore: 84.0,
          totalWeeklySteps: 2100000,
          activeSquadMissionsCount: 4,
        ),
        isJoined: false,
      ),

      // 4. Interest Circle: Vegetarian Muscle Builders India
      const HealthClub(
        clubId: 'circle_veg_muscle',
        name: 'Vegetarian Muscle Builders',
        description: 'High-protein vegetarian meal plans & progressive overload lifting',
        city: 'All India',
        type: ClubType.interestCircle,
        latitude: 28.6139,
        longitude: 77.2090,
        interestTag: 'veg_muscle',
        memberUserIds: ['user_me'],
        aggregateMetrics: GroupMetrics(
          memberCount: 9100,
          averageAdherenceScore: 88.0,
          totalWeeklySteps: 45000000,
          activeSquadMissionsCount: 12,
        ),
        isJoined: true,
      ),
    ];
  }

  List<HealthClub> get clubs => List.unmodifiable(_clubs);

  /// Gets nearby clubs using user lat/lon (default Noida user: 28.6280, 77.3649).
  List<HealthClub> getNearbyClubs({
    double userLat = 28.6280,
    double userLon = 77.3649,
    double radiusKm = 15.0,
  }) {
    return _engine.filterNearbyClubs(
      clubs: _clubs,
      userLat: userLat,
      userLon: userLon,
      maxRadiusKm: radiusKm,
    );
  }

  /// Toggles membership for a club.
  void toggleMembership(String clubId, String currentUserId) {
    final index = _clubs.indexWhere((c) => c.clubId == clubId);
    if (index != -1) {
      _clubs[index] = _engine.toggleClubMembership(_clubs[index], currentUserId);
    }
  }
}

final clubRepositoryProvider = Provider<ClubRepository>((_) {
  return ClubRepository();
});
