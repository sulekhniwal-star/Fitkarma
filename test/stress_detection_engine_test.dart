import 'package:fitkarma/features/predictive/stress_detection_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = StressDetectionEngine();

  group('§P10-E StressDetectionEngine Unit Tests', () {
    test('Optimal signals produce StressLevel.low (score < 30)', () {
      const optimalInputs = StressSignalInputs(
        hrvMs: 62.0, // Above baseline 50
        restingHrBpm: 60.0, // Below baseline 65
        sleepDurationHours: 7.8,
        sleepQualityScore: 85.0,
        missedLoggingCount: 0,
        hasLateNightLogging: false,
      );

      final result = engine.evaluateInferredStress(optimalInputs);

      expect(result.stressLevel, StressLevel.low);
      expect(result.stressScore, lessThan(30.0));
      expect(result.recommendedIntervention, contains('Stress System Optimal'));
    });

    test('HRV drop & sleep deficit trigger StressLevel.high (score >= 60)', () {
      const highStressInputs = StressSignalInputs(
        hrvMs: 25.0, // 50% drop vs 50ms baseline -> 17.5 pts
        restingHrBpm: 75.0, // 10bpm elevation -> 16.6 pts
        sleepDurationHours: 5.0, // Deficit -> 15 pts
        sleepQualityScore: 50.0, // Deficit -> 4 pts
        missedLoggingCount: 2, // -> 7 pts
        hasLateNightLogging: true, // -> 8 pts
      );

      final result = engine.evaluateInferredStress(highStressInputs);

      expect(result.stressLevel.priorityLevel, greaterThanOrEqualTo(3));
      expect(result.stressScore, greaterThanOrEqualTo(60.0));
      expect(result.primaryContributors, contains(contains('HRV suppressed')));
      expect(result.recommendedIntervention, contains('High Stress Alert'));
    });

    test('Extreme signals trigger StressLevel.extreme (score >= 80) and emergency protocol', () {
      const extremeInputs = StressSignalInputs(
        hrvMs: 15.0, // Massive drop -> 24.5 pts
        restingHrBpm: 82.0, // 17bpm elevation -> 25 pts
        sleepDurationHours: 4.0, // Massive deficit -> 25 pts
        sleepQualityScore: 30.0,
        missedLoggingCount: 3, // -> 7 pts
        hasLateNightLogging: true, // -> 8 pts
      );

      final result = engine.evaluateInferredStress(extremeInputs);

      expect(result.stressLevel, StressLevel.extreme);
      expect(result.stressScore, greaterThanOrEqualTo(80.0));
      expect(result.recommendedIntervention, contains('Emergency Stress Protocol'));
    });

    test('Behavioral signals add score contributions correctly', () {
      const behaviorOnlyInputs = StressSignalInputs(
        hrvMs: 50.0,
        restingHrBpm: 65.0,
        sleepDurationHours: 7.5,
        sleepQualityScore: 80.0,
        missedLoggingCount: 3, // 7 pts
        hasLateNightLogging: true, // 8 pts
      );

      final result = engine.evaluateInferredStress(behaviorOnlyInputs);

      expect(result.stressScore, 15.0);
      expect(result.primaryContributors, contains(contains('Late-night activity log')));
    });
  });
}
