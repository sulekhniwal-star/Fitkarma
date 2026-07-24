import 'package:fitkarma/features/social/club_engine.dart';
import 'package:fitkarma/features/social/club_models.dart';
import 'package:fitkarma/features/social/club_repository.dart';
import 'package:fitkarma/features/social/club_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = ClubEngine();

  const clubNoida = HealthClub(
    clubId: 'c_noida',
    name: 'Noida Sec 62 Striders',
    description: 'Noida walking group',
    city: 'Noida',
    microLocation: 'Sector 62',
    type: ClubType.geolocation,
    latitude: 28.6280,
    longitude: 77.3649,
    memberUserIds: ['u1', 'u2'],
    aggregateMetrics: GroupMetrics(
      memberCount: 2,
      averageAdherenceScore: 80.0,
      totalWeeklySteps: 50000,
      activeSquadMissionsCount: 1,
    ),
  );

  const clubBlore = HealthClub(
    clubId: 'c_blore',
    name: 'Indiranagar Runners',
    description: 'Bangalore running club',
    city: 'Bengaluru',
    microLocation: 'Indiranagar',
    type: ClubType.geolocation,
    latitude: 12.9784,
    longitude: 77.6408,
    memberUserIds: [],
    aggregateMetrics: GroupMetrics(
      memberCount: 0,
      averageAdherenceScore: 70.0,
      totalWeeklySteps: 0,
      activeSquadMissionsCount: 0,
    ),
  );

  group('§P9-F ClubEngine Unit Tests', () {
    test('Calculates Haversine distance correctly', () {
      // Distance between Noida Sec 62 (28.6280, 77.3649) and Gurugram Cyber City (28.4950, 77.0890) is ~30.6 km
      final dist = engine.computeDistanceKm(28.6280, 77.3649, 28.4950, 77.0890);
      expect(dist, greaterThan(25.0));
      expect(dist, lessThan(35.0));
    });

    test('Filters nearby clubs within 15km radius', () {
      final nearby = engine.filterNearbyClubs(
        clubs: [clubNoida, clubBlore],
        userLat: 28.6280,
        userLon: 77.3649,
        maxRadiusKm: 15.0,
      );

      expect(nearby.length, 1);
      expect(nearby.first.name, 'Noida Sec 62 Striders');
    });

    test('Toggles club membership and updates member count', () {
      final joined = engine.toggleClubMembership(clubNoida, 'user_me');
      expect(joined.isJoined, true);
      expect(joined.memberUserIds, contains('user_me'));
      expect(joined.aggregateMetrics.memberCount, 3);

      final left = engine.toggleClubMembership(joined, 'user_me');
      expect(left.isJoined, false);
      expect(left.memberUserIds.contains('user_me'), false);
      expect(left.aggregateMetrics.memberCount, 2);
    });
  });

  group('§P9-F ClubScreen Widget Tests', () {
    testWidgets('Renders filter tabs, club cards, location badges, and join buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            clubRepositoryProvider.overrideWithValue(ClubRepository()),
          ],
          child: const MaterialApp(
            home: ClubScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Filter Tabs
      expect(find.text('Clubs & Circles'), findsOneWidget);
      expect(find.text('Near Me (15 km)'), findsOneWidget);
      expect(find.text('My City'), findsOneWidget);
      expect(find.text('Interest Circles'), findsOneWidget);

      // 2. Nearby Club Cards
      expect(find.text('Noida Sec 62 Striders'), findsOneWidget);
      expect(find.textContaining('Sector 62'), findsWidgets);
      expect(find.text('Joined ✓'), findsWidgets);

      // 3. Switch to Interest Circles tab
      await tester.tap(find.text('Interest Circles'));
      await tester.pumpAndSettle();

      expect(find.text('Vegetarian Muscle Builders'), findsOneWidget);
    });
  });
}
