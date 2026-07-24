import 'package:fitkarma/features/social/feed_curation_engine.dart';
import 'package:fitkarma/features/social/feed_models.dart';
import 'package:fitkarma/features/social/feed_repository.dart';
import 'package:fitkarma/features/social/feed_screen.dart';
import 'package:fitkarma/features/social/follow_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final followSystem = FollowSystem();
  const curationEngine = FeedCurationEngine();

  group('§P9-E Follow System Unit Tests', () {
    test('Follows and unfollows user correctly', () {
      followSystem.followUser('me', 'priya');
      expect(followSystem.isFollowing('me', 'priya'), true);
      expect(followSystem.getFollowingList('me'), contains('priya'));

      followSystem.unfollowUser('me', 'priya');
      expect(followSystem.isFollowing('me', 'priya'), false);
    });

    test('Self-following throws ArgumentError', () {
      expect(
        () => followSystem.followUser('me', 'me'),
        throwsArgumentError,
      );
    });
  });

  group('§P9-E Feed Curation Engine & Security Scanner Tests', () {
    test('Curates workout >= 20 min and >= 100 kcal', () {
      final shouldCurate = curationEngine.shouldCurateItem(
        type: FeedItemType.workout,
        workoutDurationMinutes: 30,
        caloriesBurned: 220,
      );
      expect(shouldCurate, true);
    });

    test('Rejects short micro-workouts under 20 min', () {
      final shouldCurate = curationEngine.shouldCurateItem(
        type: FeedItemType.workout,
        workoutDurationMinutes: 10,
        caloriesBurned: 50,
      );
      expect(shouldCurate, false);
    });

    test('Link security scanner passes HTTPS allowed domain and blocks insecure/unapproved links', () {
      expect(curationEngine.scanFeedLink('https://fitkarma.com/route/123'), true);
      expect(curationEngine.scanFeedLink('https://strava.com/activity/456'), true);

      // Block non-HTTPS or unapproved domain
      expect(curationEngine.scanFeedLink('http://fitkarma.com/route/123'), false);
      expect(curationEngine.scanFeedLink('https://phishing-site.xyz/login'), false);
    });

    test('Calculates High-Five reaction XP with +2 XP and 10 XP max cap', () {
      expect(curationEngine.calculateHighFiveXp(0), 2);
      expect(curationEngine.calculateHighFiveXp(8), 2);
      expect(curationEngine.calculateHighFiveXp(10), 0); // Cap reached
    });
  });

  group('§P9-E ActivityFeedScreen Widget Tests', () {
    testWidgets('Renders activity feed cards, filter chips, and High-Five reactions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            feedRepositoryProvider.overrideWithValue(FeedRepository()),
          ],
          child: const MaterialApp(
            home: ActivityFeedScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Filter Bar
      expect(find.text('Activity Feed'), findsOneWidget);
      expect(find.text('All Activity'), findsOneWidget);
      expect(find.text('Workouts 🏋️'), findsOneWidget);
      expect(find.text('Routes 🗺️'), findsOneWidget);
      expect(find.text('Milestones 🏆'), findsOneWidget);

      // 2. Feed Cards
      expect(find.text('Priya Sharma'), findsOneWidget);
      expect(find.text('🏋️ Upper Body Power & Core'), findsOneWidget);
      expect(find.text('🗺️ Noida City Park Morning Loop'), findsOneWidget);

      // 3. High-Five Reaction Button
      expect(find.textContaining('High-Five'), findsWidgets);
    });
  });
}
