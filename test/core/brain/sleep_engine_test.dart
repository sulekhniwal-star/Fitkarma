import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/illness_detector.dart';
import 'package:fitkarma/core/brain/sleep_engine.dart';

void main() {
  group('Sleep Engine & Illness Detector Tests', () {
    const sleepEngine = SleepEngine();
    const illnessDetector = IllnessDetector();

    test('4-pillar sleep score calculates correctly with high duration & efficiency', () {
      final result = sleepEngine.calculateSleepPerformance(
        actualSleepHours: 8.0,
        sleepNeedHours: 8.0,
        efficiencyRatio: 0.90,
        deepSleepRatio: 0.22,
        midpointShiftMinutes: 10.0,
      );

      expect(result.overallScore, greaterThanOrEqualTo(90));
      expect(result.durationScore, equals(100.0));
    });

    test('Circadian penalty applies when midpoint shifts > 45 minutes', () {
      final result = sleepEngine.calculateSleepPerformance(
        actualSleepHours: 8.0,
        sleepNeedHours: 8.0,
        midpointShiftMinutes: 90.0, // 45 minutes excess shift
      );

      expect(result.circadianScore, lessThan(100.0));
    });

    test('Illness Detector triggers alarm when RHR increases by +7 bpm', () {
      final result = illnessDetector.checkIllnessAlarm(
        currentRhr: 68,
        baselineRhr: 60, // +8 bpm spike
        currentHrv: 55.0,
        baselineHrv: 55.0,
      );

      expect(result.isAlarmTriggered, isTrue);
      expect(result.reason, contains('Resting HR elevated'));
    });

    test('Illness Detector triggers alarm when HRV drops below 70% baseline', () {
      final result = illnessDetector.checkIllnessAlarm(
        currentRhr: 60,
        baselineRhr: 60,
        currentHrv: 35.0,
        baselineHrv: 60.0, // 58% ratio
      );

      expect(result.isAlarmTriggered, isTrue);
      expect(result.reason, contains('HRV dropped'));
    });
  });
}
