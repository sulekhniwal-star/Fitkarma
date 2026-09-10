import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/stress_detection_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/stress_detection_models.dart';

void main() {
  group('StressDetectionEngine Tests', () {
    const engine = StressDetectionEngine();

    test('Infers calm / low stress state when autonomic signals match baseline',
        () {
      final report = engine.inferStressState(
        currentRmssd: 55.0,
        baselineRmssd: 52.0,
        currentRestingHeartRate: 59.0,
        baselineRestingHeartRate: 60.0,
        currentRespirationRate: 13.0,
        baselineRespirationRate: 13.5,
        nocturnalRestlessnessCount: 1,
        daytimeSedentaryPulseSpikes: 0,
      );

      expect(report.currentStressScore, lessThanOrEqualTo(25.0));
      expect(report.currentTier, equals(StressLevelTier.calm));
      expect(report.activeSignals.length, equals(4));
      expect(report.intradayTimeline24h.length, equals(24));
      expect(report.recommendedProtocols.isNotEmpty, isTrue);
    });

    test(
        'Infers acute sympathetic overload when HRV is suppressed and pulse spikes',
        () {
      final report = engine.inferStressState(
        currentRmssd: 22.0,
        baselineRmssd: 55.0,
        currentRestingHeartRate: 88.0,
        baselineRestingHeartRate: 60.0,
        currentRespirationRate: 21.0,
        baselineRespirationRate: 13.0,
        nocturnalRestlessnessCount: 8,
        daytimeSedentaryPulseSpikes: 6,
      );

      expect(report.currentStressScore, greaterThan(75.0));
      expect(report.currentTier, equals(StressLevelTier.acuteOverload));
      expect(
          report.recommendedProtocols.any((p) => p.id.contains('478')), isTrue);
    });
  });
}
