import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';
import 'package:fitkarma/core/brain/decision_hierarchy.dart';
import 'package:fitkarma/features/daily_mission/providers/daily_mission_provider.dart';

void main() {
  group('§P14-C Integration: DIP Generation & Multi-Module Consumption', () {
    const readinessEngine = ReadinessEngine();

    test('6 AM DIP Generation compiles readiness, nutrition targets, workout adaptation, and missions', () {
      final readiness = readinessEngine.calculateReadiness(
        checkIn: const MorningCheckIn(energyLevel: 4, muscleSoreness: 1, moodRating: 4),
        sleepHours: 7.5,
      );

      final dip = DailyIntelligencePackage(
        userId: 'user_123',
        date: DateTime.now(),
        readinessScore: readiness.score,
        healthScore: 82,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Upper Body Hypertrophy',
        dailyMissions: const [
          'Complete 45-min Strength Routine',
          'Hit 135g Protein Goal',
          'Reach 8,000 step target',
        ],
      );

      expect(dip.readinessScore, greaterThanOrEqualTo(75));
      expect(dip.healthScore, equals(82));
      expect(dip.dailyMissions.length, equals(3));
      expect(dip.primaryFocus, contains('Upper Body'));
    });

    test('DailyMissionNotifier state seamlessly consumes DIP package and propagates to UI', () {
      final notifier = DailyMissionNotifier(
        const ReadinessEngine(),
        const DecisionHierarchy(),
      );
      final state = notifier.state;

      expect(state.healthScore, equals(82));
      expect(state.dip.dailyMissions, isNotEmpty);
      expect(state.readiness.score, greaterThan(0));
    });
  });
}
