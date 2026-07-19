import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/coach/coach_escalation_service.dart';
import 'package:fitkarma/core/preventive/preventive_intelligence_engine.dart';

void main() {
  late PreventiveIntelligenceEngine engine;

  setUp(() {
    engine = PreventiveIntelligenceEngine();
  });

  group('PreventiveIntelligenceEngine Tests', () {
    test('Hypertension rule triggers when all conditions met', () {
      const data = UserHealthData(
        bpTrend: Trend.rising,
        sleepTrend: Trend.declining,
        weightTrend: Trend.rising,
        stepsTrend: Trend.declining,
        glucoseTrend: Trend.stable,
        bmi: 23.5,
        stepAvg7d: 8000,
      );

      final alerts = engine.analyze(data);
      expect(alerts.length, 1);
      expect(alerts.first.risk, 'Hypertension');
      expect(alerts.first.severity, RiskSeverity.medium);
      expect(alerts.first.actions.contains('Log a 20-min walk'), isTrue);
    });

    test('Type 2 Diabetes rule triggers when all conditions met', () {
      const data = UserHealthData(
        bpTrend: Trend.stable,
        sleepTrend: Trend.stable,
        weightTrend: Trend.stable,
        stepsTrend: Trend.stable,
        glucoseTrend: Trend.rising,
        bmi: 28.2,
        stepAvg7d: 4500,
      );

      final alerts = engine.analyze(data);
      expect(alerts.length, 1);
      expect(alerts.first.risk, 'Type 2 Diabetes');
      expect(alerts.first.severity, RiskSeverity.medium);
      expect(alerts.first.actions.contains('Walk after meals'), isTrue);
    });

    test('Both rules trigger simultaneously when all parameters are high-risk', () {
      const data = UserHealthData(
        bpTrend: Trend.rising,
        sleepTrend: Trend.declining,
        weightTrend: Trend.rising,
        stepsTrend: Trend.declining,
        glucoseTrend: Trend.rising,
        bmi: 27.5,
        stepAvg7d: 3000,
      );

      final alerts = engine.analyze(data);
      expect(alerts.length, 2);
      
      final risks = alerts.map((a) => a.risk).toList();
      expect(risks.contains('Hypertension'), isTrue);
      expect(risks.contains('Type 2 Diabetes'), isTrue);
    });

    test('No alerts returned when data is healthy/stable', () {
      const data = UserHealthData(
        bpTrend: Trend.stable,
        sleepTrend: Trend.rising, // Sleep improving
        weightTrend: Trend.declining, // Weight going down
        stepsTrend: Trend.rising, // Steps increasing
        glucoseTrend: Trend.stable,
        bmi: 22.0,
        stepAvg7d: 10000,
      );

      final alerts = engine.analyze(data);
      expect(alerts.isEmpty, isTrue);
    });
  });
}
