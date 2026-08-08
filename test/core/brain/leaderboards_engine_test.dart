import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/leaderboards_engine.dart';

void main() {
  group('§P9-G Weekly & Monthly Leaderboards Tests', () {
    const engine = LeaderboardsEngine();

    test('generateRankedLeaderboard assigns Gold, Silver, Bronze, and Top 10% badges correctly', () {
      final rawEntries = List.generate(20, (i) {
        return LeaderboardUserEntry(
          userId: 'user_$i',
          displayName: 'Runner $i',
          metricValue: 80000 - (i * 1000),
          rank: 0,
        );
      });

      final ranked = engine.generateRankedLeaderboard(
        rawEntries: rawEntries,
        currentUserId: 'user_2',
      );

      expect(ranked.first.rank, equals(1));
      expect(ranked.first.badge, equals(LeaderboardBadge.gold));
      expect(ranked[1].rank, equals(2));
      expect(ranked[1].badge, equals(LeaderboardBadge.silver));
      expect(ranked[2].rank, equals(3));
      expect(ranked[2].badge, equals(LeaderboardBadge.bronze));

      // Top 10% of 20 = Top 2
      expect(ranked[3].badge, equals(LeaderboardBadge.none));
    });

    test('applyAnonymityToggle replaces name and photo with "Anonymous Athlete" when anonymized', () {
      const entry = LeaderboardUserEntry(
        userId: 'u1',
        displayName: 'Rahul Sharma',
        avatarUrl: 'https://fitkarma.com/avatar.png',
        metricValue: 75000,
        rank: 1,
        isAnonymized: true,
      );

      final anonymized = engine.applyAnonymityToggle(entry);
      expect(anonymized.displayName, equals('Anonymous Athlete'));
      expect(anonymized.avatarUrl, isNull);
    });

    test('evaluateWeeklyRewards awards Golden Karma Aura and +100 XP for Top 10% placement', () {
      final topResult = engine.evaluateWeeklyRewards(userRank: 2, totalParticipants: 30);
      final normalResult = engine.evaluateWeeklyRewards(userRank: 15, totalParticipants: 30);

      expect(topResult.isTop10Percent, isTrue);
      expect(topResult.hasGoldenKarmaAura, isTrue);
      expect(topResult.xpBonus, equals(100));

      expect(normalResult.isTop10Percent, isFalse);
      expect(normalResult.hasGoldenKarmaAura, isFalse);
      expect(normalResult.xpBonus, equals(0));
    });
  });
}
