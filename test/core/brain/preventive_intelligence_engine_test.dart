import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/preventive_intelligence_engine.dart';

void main() {
  group('PreventiveIntelligenceEngine 6 Risk Patterns & Trend Analysis Test', () {
    const engine = PreventiveIntelligenceEngine();

    test('Pattern 1: Hypertension risk triggers on elevated BP', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 140.0,
        diastolicBp: 90.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 120.0,
        hrvDropRatio: 0.10,
        cumulativeSleepDeficitHours: 2.0,
        consecutiveSedentaryDays: 1,
        rhrSpikeBpm: 2,
      );

      expect(alerts.any((a) => a.id == 'p1_hypertension'), isTrue);
      expect(alerts.firstWhere((a) => a.id == 'p1_hypertension').actions, isNotEmpty);
    });

    test('Pattern 1 Override: Hypertension risk triggers on multi-factor trend alignment', () {
      final snapshot = UserHealthDataSnapshot(
        bpTrend: TrendDirection.rising,
        sleepTrend: TrendDirection.declining,
        weightTrend: TrendDirection.rising,
        stepsTrend: TrendDirection.declining,
        systolicBp: 120.0,
        diastolicBp: 78.0,
      );

      final alerts = engine.analyze(snapshot);
      final alert = alerts.firstWhere((a) => a.id == 'p1_hypertension');

      expect(alert, isNotNull);
      expect(alert.severity, equals(RiskSeverity.moderate));
      expect(alert.actions, contains('Log a 20-min walk'));
    });

    test('Pattern 2: Glycemic instability triggers on postprandial glucose spike', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 120.0,
        diastolicBp: 80.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 175.0,
        hrvDropRatio: 0.10,
        cumulativeSleepDeficitHours: 2.0,
        consecutiveSedentaryDays: 1,
        rhrSpikeBpm: 2,
      );

      expect(alerts.any((a) => a.id == 'p2_glycemic'), isTrue);
    });

    test('Pattern 2 Override: Type 2 Diabetes pattern triggers on rising glucose + BMI >= 27 + low steps', () {
      final snapshot = UserHealthDataSnapshot(
        glucoseTrend: TrendDirection.rising,
        bmi: 28.5,
        stepAvg7d: 3800,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 125.0,
      );

      final alerts = engine.analyze(snapshot);
      final alert = alerts.firstWhere((a) => a.id == 'p2_glycemic');

      expect(alert, isNotNull);
      expect(alert.patternName, equals('Type 2 Diabetes Pattern'));
      expect(alert.actions, contains('Walk after meals'));
    });

    test('Pattern 3: HRV Collapse triggers on 25%+ drop', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 120.0,
        diastolicBp: 80.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 120.0,
        hrvDropRatio: 0.30,
        cumulativeSleepDeficitHours: 2.0,
        consecutiveSedentaryDays: 1,
        rhrSpikeBpm: 2,
      );

      expect(alerts.any((a) => a.id == 'p3_hrv_collapse'), isTrue);
    });

    test('Pattern 4: Sleep Debt Accumulation triggers at 6+ hours deficit', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 120.0,
        diastolicBp: 80.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 120.0,
        hrvDropRatio: 0.10,
        cumulativeSleepDeficitHours: 7.5,
        consecutiveSedentaryDays: 1,
        rhrSpikeBpm: 2,
      );

      expect(alerts.any((a) => a.id == 'p4_sleep_debt'), isTrue);
    });

    test('Pattern 5: Sedentary Stagnation triggers at 4+ days', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 120.0,
        diastolicBp: 80.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 120.0,
        hrvDropRatio: 0.10,
        cumulativeSleepDeficitHours: 2.0,
        consecutiveSedentaryDays: 5,
        rhrSpikeBpm: 2,
      );

      expect(alerts.any((a) => a.id == 'p5_sedentary'), isTrue);
    });

    test('Pattern 6: RHR Spike triggers at +10 bpm spike', () {
      final alerts = engine.evaluateRiskPatterns(
        systolicBp: 120.0,
        diastolicBp: 80.0,
        fastingGlucoseMgDl: 95.0,
        postprandialGlucoseMgDl: 120.0,
        hrvDropRatio: 0.10,
        cumulativeSleepDeficitHours: 2.0,
        consecutiveSedentaryDays: 1,
        rhrSpikeBpm: 12,
      );

      expect(alerts.any((a) => a.id == 'p6_rhr_spike'), isTrue);
      expect(alerts.firstWhere((a) => a.id == 'p6_rhr_spike').severity, equals(RiskSeverity.critical));
    });
  });
}
