import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/transformation_journey_engine.dart';

void main() {
  group('§P8-A Transformation Journey Engine Tests', () {
    const engine = TransformationJourneyEngine();

    test(
        'TransformationMemory initializes longitudinal memory fields correctly',
        () {
      final memory = TransformationMemory.initial();
      expect(memory.weightHistory.length, equals(4));
      expect(memory.weightHistory.last.weightKg, equals(72.0));
      expect(memory.primaryPersonality, equals('Routine'));
      expect(memory.successPatterns.first, contains('7 AM workouts'));
    });

    test('ConsistencyTracker returns strong when riskScore < 2', () {
      const data = UserBehaviorData(
        appOpenFrequencyDropping: false,
        workoutsMissedInARow: 0,
        junkFoodLoggedDaysInARow: 0,
        sleepDecliningFor5Days: false,
        daysSinceLastAppOpen: 0,
        motivationRating: 5,
      );

      expect(engine.analyzeConsistency(data), equals(ConsistencyStatus.strong));
    });

    test('ConsistencyTracker returns moderate when riskScore is 2 or 3', () {
      const data = UserBehaviorData(
        appOpenFrequencyDropping: true,
        workoutsMissedInARow: 3, // signal 2
        junkFoodLoggedDaysInARow: 0,
        sleepDecliningFor5Days: false,
        daysSinceLastAppOpen: 0,
        motivationRating: 4,
      );

      expect(
          engine.analyzeConsistency(data), equals(ConsistencyStatus.moderate));
    });

    test('ConsistencyTracker returns highRelapse when riskScore >= 4', () {
      const data = UserBehaviorData(
        appOpenFrequencyDropping: true,
        workoutsMissedInARow: 3,
        junkFoodLoggedDaysInARow: 4,
        sleepDecliningFor5Days: true,
        daysSinceLastAppOpen: 2,
        motivationRating: 2,
      );

      expect(engine.analyzeConsistency(data),
          equals(ConsistencyStatus.highRelapse));
    });

    test('RelapseIntervention returns Day 1 gentle nudge for 1 missed day', () {
      final intervention =
          engine.getRelapseIntervention(consecutiveMissedDays: 1);
      expect(intervention.tier, equals(RelapseTier.day1GentleNudge));
      expect(intervention.message,
          contains('10-minute walk today counts as a win'));
    });

    test('RelapseIntervention returns Day 2 Lite plan switch for 2 missed days',
        () {
      final intervention =
          engine.getRelapseIntervention(consecutiveMissedDays: 2);
      expect(intervention.tier, equals(RelapseTier.day2PlanAdjustment));
      expect(intervention.message,
          contains('switched you to the Lite Plan for 3 days'));
    });

    test(
        'RelapseIntervention returns Day 3 emergency reframe for 3 missed days',
        () {
      final intervention = engine.getRelapseIntervention(
          consecutiveMissedDays: 3, previousStreakDays: 14);
      expect(intervention.tier, equals(RelapseTier.day3EmergencyReframe));
      expect(
          intervention.message, contains('doesn\'t erase your 14-day streak'));
    });

    test('RelapseIntervention returns Day 5 squad connection for 5 missed days',
        () {
      final intervention = engine.getRelapseIntervention(
          consecutiveMissedDays: 5, squadMemberName: 'Ananya');
      expect(intervention.tier, equals(RelapseTier.day5SquadConnection));
      expect(intervention.message, contains('Ananya logged a workout today'));
    });
  });
}
