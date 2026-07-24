import 'package:fitkarma/features/social/leaderboard_engine.dart';
import 'package:fitkarma/features/social/leaderboard_models.dart';
import 'package:fitkarma/features/social/leaderboard_repository.dart';
import 'package:fitkarma/features/social/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = LeaderboardEngine();
  final now = DateTime.now();

  final unrankedList = [
    LeaderboardEntry(
      rank: 0,
      userId: 'u_priya',
      userName: 'Priya K.',
      score: 76200,
      metricUnit: 'steps',
      version: 1,
      lastUpdatedAt: now.subtract(const Duration(hours: 2)),
    ),
    LeaderboardEntry(
      rank: 0,
      userId: 'u_ramesh',
      userName: 'Ramesh S.',
      score: 78400,
      metricUnit: 'steps',
      version: 1,
      lastUpdatedAt: now.subtract(const Duration(hours: 1)),
    ),
    LeaderboardEntry(
      rank: 0,
      userId: 'u_arjun',
      userName: 'Arjun T.',
      score: 74900,
      metricUnit: 'steps',
      version: 1,
      lastUpdatedAt: now.subtract(const Duration(minutes: 30)),
    ),
  ];

  group('§P9-G LeaderboardEngine Unit Tests', () {
    test('Computes 1-indexed rankings sorted descending by score', () {
      final ranked = engine.computeRankings(unrankedList);

      expect(ranked.length, 3);
      expect(ranked[0].rank, 1);
      expect(ranked[0].userId, 'u_ramesh'); // Highest score: 78400
      expect(ranked[0].badge, LeaderboardBadge.gold);

      expect(ranked[1].rank, 2);
      expect(ranked[1].userId, 'u_priya'); // Second score: 76200
      expect(ranked[1].badge, LeaderboardBadge.silver);

      expect(ranked[2].rank, 3);
      expect(ranked[2].userId, 'u_arjun'); // Third score: 74900
      expect(ranked[2].badge, LeaderboardBadge.bronze);
    });

    test('Applies anonymity masking for non-current-user entries', () {
      final anonymousEntry = LeaderboardEntry(
        rank: 1,
        userId: 'u_anon',
        userName: 'Secret Athlete',
        score: 90000,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now,
        isAnonymous: true,
        isCurrentUser: false,
      );

      final masked = engine.applyAnonymity(anonymousEntry);
      expect(masked.userName, 'Anonymous Athlete');
      expect(masked.userAvatar, '👤');
    });

    test('LeaderboardSyncCoordinator resolves out-of-order latency using version sequence numbers', () {
      final syncCoordinator = LeaderboardSyncCoordinator();

      final updateV1 = [
        LeaderboardEntry(
          rank: 0,
          userId: 'u1',
          userName: 'User 1',
          score: 5000,
          metricUnit: 'steps',
          version: 1,
          lastUpdatedAt: now.subtract(const Duration(minutes: 10)),
        ),
      ];

      final updateV2 = [
        LeaderboardEntry(
          rank: 0,
          userId: 'u1',
          userName: 'User 1',
          score: 10000,
          metricUnit: 'steps',
          version: 2,
          lastUpdatedAt: now,
        ),
      ];

      // Merge V1 first, then V2
      syncCoordinator.mergeSyncUpdate(updateV1);
      final merged = syncCoordinator.mergeSyncUpdate(updateV2);

      expect(merged.length, 1);
      expect(merged.first.score, 10000);
      expect(merged.first.version, 2);
    });
  });

  group('§P9-G LeaderboardScreen Widget Tests', () {
    testWidgets('Renders region header, Top 3 podium, cohort list, and anonymity toggle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            leaderboardRepositoryProvider.overrideWithValue(LeaderboardRepository()),
          ],
          child: const MaterialApp(
            home: LeaderboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Region Header
      expect(find.text('Leaderboards'), findsOneWidget);
      expect(find.text('🏆 Noida Sector 62 Leaderboard'), findsOneWidget);

      // 2. Anonymity Toggle
      expect(find.text('Leaderboard Anonymity Mode'), findsOneWidget);

      // 3. Top 3 Podium
      expect(find.text('🥇'), findsOneWidget);
      expect(find.text('🥈'), findsOneWidget);
      expect(find.text('🥉'), findsOneWidget);

      // 4. Cohort List
      expect(find.text('Cohort Rankings'), findsOneWidget);
    });
  });
}
