import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';
import 'package:fitkarma/features/transformation/transformation_memory_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = TransformationJourneyEngine();
  const tracker = ConsistencyTracker();
  const interventionEngine = RelapseInterventionEngine();

  group('§P8-A JourneyStage Detection Tests', () {
    test('Detects correct journey stage across day thresholds', () {
      expect(engine.detectStage(5), JourneyStage.onboarding);
      expect(engine.detectStage(7), JourneyStage.onboarding);
      expect(engine.detectStage(8), JourneyStage.momentum);
      expect(engine.detectStage(25), JourneyStage.momentum);
      expect(engine.detectStage(31), JourneyStage.adaptation);
      expect(engine.detectStage(60), JourneyStage.adaptation);
      expect(engine.detectStage(61), JourneyStage.transformation);
      expect(engine.detectStage(90), JourneyStage.transformation);
      expect(engine.detectStage(91), JourneyStage.mastery);
      expect(engine.detectStage(150), JourneyStage.mastery);
    });
  });

  group('§P8-A ConsistencyTracker Tests', () {
    test('Healthy signals yield strong consistency', () {
      final status = tracker.analyze(UserBehaviorSignals.healthy());
      expect(status, ConsistencyStatus.strong);
    });

    test('2 risk signals yield moderate consistency status', () {
      const signals = UserBehaviorSignals(
        appOpenFrequencyDropping: true,
        workoutsMissedInARow: 3, // signal 2
        junkFoodLoggedDaysInARow: 0,
        sleepDecliningDaysInARow: 0,
        daysSinceLastAppOpen: 0,
        motivationRating: 4,
      );

      final status = tracker.analyze(signals);
      expect(status, ConsistencyStatus.moderate);
    });

    test('4 or more risk signals yield highRelapse consistency status', () {
      const signals = UserBehaviorSignals(
        appOpenFrequencyDropping: true,
        workoutsMissedInARow: 3,
        junkFoodLoggedDaysInARow: 4,
        sleepDecliningDaysInARow: 5,
        daysSinceLastAppOpen: 3,
        motivationRating: 2,
      );

      final status = tracker.analyze(signals);
      expect(status, ConsistencyStatus.highRelapse);
    });
  });

  group('§P8-A RelapseInterventionEngine Tests', () {
    test('Returns Day 1 gentle nudge for 1 day inactive', () {
      final intervention = interventionEngine.getIntervention(1);
      expect(intervention.title, contains('Day 1'));
      expect(intervention.actionPlan, contains('10-minute walk'));
    });

    test('Returns Day 2 Lite Plan adjustment for 2 days inactive', () {
      final intervention = interventionEngine.getIntervention(2);
      expect(intervention.title, contains('Day 2'));
      expect(intervention.message, contains('Lite Plan'));
    });

    test('Returns Day 3 emergency reframe for 3-4 days inactive', () {
      final intervention = interventionEngine.getIntervention(3);
      expect(intervention.title, contains('Day 3'));
      expect(intervention.message, contains("doesn't erase your progress"));
    });

    test('Returns Day 5 squad connection for 5+ days inactive', () {
      final intervention = interventionEngine.getIntervention(5);
      expect(intervention.title, contains('Day 5'));
      expect(intervention.message, contains('squad member logged a workout'));
    });
  });

  group('§P8-A Transformation Forecast & Memory Repository Tests', () {
    test('Calculates 90-day weight forecast bounds min and max', () {
      final forecast = engine.calculateForecast(
        currentWeightKg: 75.0,
        adherenceScorePercent: 100.0,
      );

      // With 100% adherence, projected loss is ~6.4kg
      // Min: 75 - 6.43 - 1.5 = 67.1, Max: 75 - 6.43 + 1.5 = 70.1
      expect(forecast.projectedMinKg, lessThan(forecast.currentWeightKg));
      expect(forecast.projectedMaxKg, greaterThan(forecast.projectedMinKg));
    });

    test('TransformationMemoryRepository stores weight checkpoints', () {
      final repo = TransformationMemoryRepository();
      expect(repo.memory.weightHistory, isEmpty);

      final now = DateTime.now();
      repo.addWeightCheckpoint(now, 72.5);

      expect(repo.memory.weightHistory.length, 1);
      expect(repo.memory.weightHistory.first.weightKg, 72.5);
    });
  });
}
