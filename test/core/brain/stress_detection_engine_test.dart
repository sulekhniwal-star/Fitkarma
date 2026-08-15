import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/stress_detection_engine.dart';
import 'package:fitkarma/shared/widgets/proactive_stress_alert_card.dart';

void main() {
  group('§P10-E Stress Detection Engine Tests', () {
    const engine = StressDetectionEngine();

    test('detect computes High stress level for 7+ accumulated stress signals',
        () {
      const inputs = StressHealthInputData(
        hrv7dTrend: TrendDirection.declining,
        hrv: 40.0,
        baselineHRV: 55.0, // -27% drop (+3 pts)
        restingHR: 75.0,
        baselineHR: 65.0, // elevated (+2 pts)
        sleepQuality7dAvg: 2.5, // declining (+2 pts)
        missedWorkoutsLast7Days: 3, // (+1 pt)
        appOpenFrequencyDrop: 0.50, // (+1 pt)
        lateNightLogsPerWeek: 4, // (+1 pt)
        stressLevelLastWeek: 2,
      );

      final assessment = engine.detect(inputs);

      expect(assessment.level, equals(StressLevel.high));
      expect(assessment.signals, greaterThanOrEqualTo(7));
      expect(assessment.trendingUp, isTrue);
      expect(assessment.detectedSignalDescriptions.length,
          greaterThanOrEqualTo(5));
    });

    test(
        'detect computes Normal stress level when no stress thresholds breached',
        () {
      const inputs = StressHealthInputData(
        hrv7dTrend: TrendDirection.improving,
        hrv: 60.0,
        baselineHRV: 58.0,
        restingHR: 62.0,
        baselineHR: 64.0,
        sleepQuality7dAvg: 4.2,
        missedWorkoutsLast7Days: 0,
        appOpenFrequencyDrop: 0.0,
        lateNightLogsPerWeek: 0,
        stressLevelLastWeek: 1,
      );

      final assessment = engine.detect(inputs);

      expect(assessment.level, equals(StressLevel.normal));
      expect(assessment.signals, equals(0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'ProactiveStressAlertCard renders stress trending up alert card correctly',
        (tester) async {
      const assessment = StressAssessment(
        level: StressLevel.elevated,
        signals: 5,
        trendingUp: true,
        recommendation:
            'Reduce training intensity by 20% and prioritize sleep.',
        detectedSignalDescriptions: [
          'HRV: -16% below baseline',
          'Resting HR: +8 bpm above baseline',
          'Sleep quality declining (<3.0 avg score)',
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProactiveStressAlertCard(
              assessment: assessment,
              onDecompressPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('📊 Stress Trending Up'), findsOneWidget);
      expect(find.text('ELEVATED'), findsOneWidget);
      expect(find.textContaining('HRV: -16% below baseline'), findsOneWidget);
      expect(find.text('Start 20-Min Decompression Session'), findsOneWidget);
    });
  });
}
