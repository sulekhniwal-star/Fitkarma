import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/feed_curation_engine.dart';

void main() {
  group('§P9-E Activity Feed & Sharing Architecture Tests', () {
    const curationEngine = FeedCurationEngine();
    const engagementEngine = FeedEngagementEngine();

    test(
        'isActionEligibleForFeedShare requires workouts >= 20 mins and > 100 active calories',
        () {
      const shortWorkout = WorkoutSummaryPayload(
          workoutTitle: 'Quick Stretch',
          durationMinutes: 10,
          caloriesBurned: 50);
      const validWorkout = WorkoutSummaryPayload(
          workoutTitle: 'Athletic Lean Build',
          durationMinutes: 45,
          caloriesBurned: 320);

      expect(
          curationEngine.isActionEligibleForFeedShare(
              type: FeedItemType.workout, workout: shortWorkout),
          isFalse);
      expect(
          curationEngine.isActionEligibleForFeedShare(
              type: FeedItemType.workout, workout: validWorkout),
          isTrue);
      expect(
          curationEngine.isActionEligibleForFeedShare(
              type: FeedItemType.milestone),
          isTrue);
    });

    test('scanFeedLink enforces HTTPS and allowed domain whitelist', () {
      expect(
          curationEngine.scanFeedLink('https://fitkarma.com/route/12'), isTrue);
      expect(curationEngine.scanFeedLink('https://strava.com/activities/99'),
          isTrue);
      expect(curationEngine.scanFeedLink('http://fitkarma.com/route/12'),
          isFalse); // Non-HTTPS
      expect(curationEngine.scanFeedLink('https://phishing-site.xyz/login'),
          isFalse); // Domain not whitelisted
      expect(
          curationEngine
              .scanFeedLink('https://fitkarma.com?redirect=http://evil.com'),
          isFalse); // Redirect parameter
    });

    test('validatePayload blocks images > 5MB and GPX > 2000 trackpoints', () {
      const oversizedImage = FeedItemPayload(imageSizeBytes: 6 * 1024 * 1024);
      const validImage = FeedItemPayload(imageSizeBytes: 2 * 1024 * 1024);

      expect(curationEngine.validatePayload(oversizedImage), isFalse);
      expect(curationEngine.validatePayload(validImage), isTrue);

      final validGpx =
          FeedItemPayload(gpxData: '<gpx><trkpt lat="28.6" lon="77.2"/></gpx>');
      final invalidGpx =
          FeedItemPayload(gpxData: 'plain text data without XML tags');

      expect(curationEngine.validatePayload(validGpx), isTrue);
      expect(curationEngine.validatePayload(invalidGpx), isFalse);
    });

    test('processHighFive awards +2 XP to poster and respects daily caps', () {
      final initialItem = FeedItem(
        localId: 'feed_01',
        userId: 'u_poster',
        userName: 'Priya',
        type: FeedItemType.workout,
        timestamp: DateTime.now(),
        workoutPayload: const WorkoutSummaryPayload(
            workoutTitle: 'Morning Run',
            durationMinutes: 30,
            caloriesBurned: 220),
      );

      // First High-Five -> +2 XP awarded
      final res1 = engagementEngine.processHighFive(
        item: initialItem,
        actionUserId: 'u_giver1',
        giverDailyHighFiveCount: 2,
        posterTodayXpReceived: 0,
      );

      expect(res1.updatedItem.highFiveCount, equals(1));
      expect(res1.updatedItem.highFivedUserIds.contains('u_giver1'), isTrue);
      expect(res1.xpAwardedToPoster, equals(2));

      // Second High-Five when poster is at 9 XP -> capped at 1 XP to reach 10 max
      final res2 = engagementEngine.processHighFive(
        item: res1.updatedItem,
        actionUserId: 'u_giver2',
        giverDailyHighFiveCount: 3,
        posterTodayXpReceived: 9,
      );

      expect(res2.updatedItem.highFiveCount, equals(2));
      expect(res2.xpAwardedToPoster, equals(1));
    });
  });
}
