import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/glycemic_pipeline_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/glycemic_pipeline_models.dart';

void main() {
  group('GlycemicPipelineEngine Deterministic Offline Tests', () {
    const engine = GlycemicPipelineEngine();

    test(
        'Processes multi-day optimal glucose dataset with CV < 33% and high TIR',
        () {
      final now = DateTime(2026, 9, 9, 12, 0);
      final samples = <HistoricalGlucoseSample>[];

      // 7 days of steady glucose (80 to 120 mg/dL)
      for (int day = 0; day < 7; day++) {
        final d = now.subtract(Duration(days: day));
        samples.add(HistoricalGlucoseSample(
          timestamp: DateTime(d.year, d.month, d.day, 6, 0),
          glucoseValueMgDl: 85.0,
        ));
        samples.add(HistoricalGlucoseSample(
          timestamp: DateTime(d.year, d.month, d.day, 10, 0),
          glucoseValueMgDl: 110.0,
        ));
        samples.add(HistoricalGlucoseSample(
          timestamp: DateTime(d.year, d.month, d.day, 14, 0),
          glucoseValueMgDl: 118.0,
        ));
        samples.add(HistoricalGlucoseSample(
          timestamp: DateTime(d.year, d.month, d.day, 20, 0),
          glucoseValueMgDl: 105.0,
        ));
        samples.add(HistoricalGlucoseSample(
          timestamp: DateTime(d.year, d.month, d.day, 2, 0),
          glucoseValueMgDl: 82.0,
        ));
      }

      final report = engine.processRetrospectiveGlucoseTelemetry(
        samples: samples,
        mealExcursions: const [],
        executionTime: now,
      );

      expect(report.totalDaysAnalyzed, equals(7));
      expect(report.totalSamplesProcessed, equals(35));
      expect(report.overallMeanGlucose, equals(100.0));
      expect(report.timeInRangePercent, equals(100.0));
      expect(report.timeAboveRangePercent, equals(0.0));
      expect(report.timeBelowRangePercent, equals(0.0));
      expect(report.coefficientOfVariationPercent, lessThan(33.0));
      expect(report.stabilityZone, equals(GlycemicStabilityZone.optimalStable));
      expect(report.circadianWindows.length, equals(5));
      expect(report.glucoseManagementIndicatorGmi, closeTo(5.70, 0.05));
    });

    test(
        'Detects high dysglycemia when large excursions and high CV are present',
        () {
      final now = DateTime(2026, 9, 9, 12, 0);
      final samples = <HistoricalGlucoseSample>[
        HistoricalGlucoseSample(
            timestamp: now.subtract(const Duration(hours: 20)),
            glucoseValueMgDl: 60.0),
        HistoricalGlucoseSample(
            timestamp: now.subtract(const Duration(hours: 18)),
            glucoseValueMgDl: 210.0),
        HistoricalGlucoseSample(
            timestamp: now.subtract(const Duration(hours: 14)),
            glucoseValueMgDl: 190.0),
        HistoricalGlucoseSample(
            timestamp: now.subtract(const Duration(hours: 8)),
            glucoseValueMgDl: 65.0),
        HistoricalGlucoseSample(
            timestamp: now.subtract(const Duration(hours: 2)),
            glucoseValueMgDl: 185.0),
      ];

      final report = engine.processRetrospectiveGlucoseTelemetry(
        samples: samples,
        mealExcursions: const [],
        executionTime: now,
      );

      expect(
          report.stabilityZone, equals(GlycemicStabilityZone.highDysglycemia));
      expect(report.timeAboveRangePercent, greaterThan(0.0));
      expect(report.timeBelowRangePercent, greaterThan(0.0));
      expect(report.coefficientOfVariationPercent, greaterThan(38.0));
    });

    test(
        'Circadian windows segment samples into distinct time buckets correctly',
        () {
      final baseDate = DateTime(2026, 9, 9);
      final samples = [
        HistoricalGlucoseSample(
            timestamp: DateTime(2026, 9, 9, 5, 30),
            glucoseValueMgDl: 92.0), // dawn
        HistoricalGlucoseSample(
            timestamp: DateTime(2026, 9, 9, 9, 15),
            glucoseValueMgDl: 125.0), // breakfast
        HistoricalGlucoseSample(
            timestamp: DateTime(2026, 9, 9, 13, 0),
            glucoseValueMgDl: 130.0), // lunch
        HistoricalGlucoseSample(
            timestamp: DateTime(2026, 9, 9, 20, 30),
            glucoseValueMgDl: 115.0), // dinner
        HistoricalGlucoseSample(
            timestamp: DateTime(2026, 9, 9, 1, 0),
            glucoseValueMgDl: 85.0), // nocturnal
      ];

      final report = engine.processRetrospectiveGlucoseTelemetry(
        samples: samples,
        mealExcursions: const [],
        executionTime: baseDate,
      );

      expect(report.circadianWindows.length, equals(5));
      final dawnWindow = report.circadianWindows
          .firstWhere((w) => w.window == ChronoGlycemicWindow.dawnFasting);
      expect(dawnWindow.meanGlucose, equals(92.0));

      final breakfastWindow = report.circadianWindows
          .firstWhere((w) => w.window == ChronoGlycemicWindow.postBreakfast);
      expect(breakfastWindow.meanGlucose, equals(125.0));

      final lunchWindow = report.circadianWindows
          .firstWhere((w) => w.window == ChronoGlycemicWindow.postLunch);
      expect(lunchWindow.meanGlucose, equals(130.0));
    });

    test('Handles empty telemetry list gracefully without crashing', () {
      final report = engine.processRetrospectiveGlucoseTelemetry(
        samples: const [],
        mealExcursions: const [],
      );

      expect(report.totalSamplesProcessed, equals(0));
      expect(report.overallMeanGlucose, equals(0.0));
      expect(report.circadianWindows, isEmpty);
    });
  });
}
