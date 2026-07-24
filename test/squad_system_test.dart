import 'package:fitkarma/features/social/squad_details_screen.dart';
import 'package:fitkarma/features/social/squad_engine.dart';
import 'package:fitkarma/features/social/squad_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = SquadEngine();

  group('§P9-B SquadEngine Unit Tests', () {
    test('Calculates average readiness score correctly', () {
      const members = [
        SquadMemberItem(userId: '1', squadId: 'sq1', name: 'A', readinessScore: 90, hasLoggedToday: true),
        SquadMemberItem(userId: '2', squadId: 'sq1', name: 'B', readinessScore: 80, hasLoggedToday: true),
        SquadMemberItem(userId: '3', squadId: 'sq1', name: 'C', readinessScore: 70, hasLoggedToday: true),
      ];

      final avg = engine.computeAverageReadiness(members);
      expect(avg, 80.0);
    });

    test('Challenge eligibility returns true when >= 60% members have High readiness', () {
      // 3 of 5 members have score >= 80 -> 60% High readiness -> Eligible
      const eligibleMembers = [
        SquadMemberItem(userId: '1', squadId: 'sq1', name: 'A', readinessScore: 85, hasLoggedToday: true),
        SquadMemberItem(userId: '2', squadId: 'sq1', name: 'B', readinessScore: 82, hasLoggedToday: true),
        SquadMemberItem(userId: '3', squadId: 'sq1', name: 'C', readinessScore: 80, hasLoggedToday: true),
        SquadMemberItem(userId: '4', squadId: 'sq1', name: 'D', readinessScore: 65, hasLoggedToday: true),
        SquadMemberItem(userId: '5', squadId: 'sq1', name: 'E', readinessScore: 50, hasLoggedToday: true),
      ];

      expect(engine.isChallengeEligible(eligibleMembers), true);
    });

    test('Challenge eligibility returns false when < 60% members have High readiness', () {
      // 2 of 5 members have score >= 80 -> 40% High readiness -> Not eligible
      const ineligibleMembers = [
        SquadMemberItem(userId: '1', squadId: 'sq1', name: 'A', readinessScore: 85, hasLoggedToday: true),
        SquadMemberItem(userId: '2', squadId: 'sq1', name: 'B', readinessScore: 82, hasLoggedToday: true),
        SquadMemberItem(userId: '3', squadId: 'sq1', name: 'C', readinessScore: 70, hasLoggedToday: true),
        SquadMemberItem(userId: '4', squadId: 'sq1', name: 'D', readinessScore: 65, hasLoggedToday: true),
        SquadMemberItem(userId: '5', squadId: 'sq1', name: 'E', readinessScore: 50, hasLoggedToday: true),
      ];

      expect(engine.isChallengeEligible(ineligibleMembers), false);
    });

    test('Increments collective streak when all members logged today', () {
      const membersLogged = [
        SquadMemberItem(userId: '1', squadId: 'sq1', name: 'A', readinessScore: 85, hasLoggedToday: true),
        SquadMemberItem(userId: '2', squadId: 'sq1', name: 'B', readinessScore: 82, hasLoggedToday: true),
      ];

      final newStreak = engine.evaluateCollectiveStreak(
        members: membersLogged,
        currentStreakDays: 14,
      );

      expect(newStreak, 15);
    });
  });

  group('§P9-B SquadDetailsScreen Widget Tests', () {
    testWidgets('Renders squad details screen elements and member roster', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            squadRepositoryProvider.overrideWithValue(SquadRepository()),
          ],
          child: const MaterialApp(
            home: SquadDetailsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Header Banner
      expect(find.text('Squad Management'), findsOneWidget);
      expect(find.text('Noida Ground Shakers'), findsOneWidget);
      expect(find.textContaining('14 Days Streak'), findsOneWidget);

      // 2. Challenge Eligibility Banner
      expect(find.textContaining('Challenge Eligible'), findsOneWidget);

      // 3. Active Mission Card
      expect(find.text('🎯 Team Protein Challenge'), findsOneWidget);
      expect(find.textContaining('78% Completed'), findsOneWidget);

      // 4. Member Roster
      expect(find.text('Squad Member Roster'), findsOneWidget);
      expect(find.text('You (You)'), findsOneWidget);
      expect(find.text('Priya'), findsOneWidget);
      expect(find.text('Sneha'), findsOneWidget);
    });
  });
}
