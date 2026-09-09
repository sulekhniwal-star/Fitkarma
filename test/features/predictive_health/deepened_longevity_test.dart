import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/deepened_longevity_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/deepened_longevity_models.dart';
import 'package:fitkarma/features/predictive_health/presentation/providers/deepened_longevity_provider.dart';

void main() {
  group('DeepenedLongevityEngine Tests', () {
    const engine = DeepenedLongevityEngine();

    test('Synthesizes optimal cellular resilience & all 7 hallmarks of aging', () {
      final report = engine.synthesizeDeepenedLongevity(
        chronologicalAge: 32.0,
        restingHeartRate: 54.0,
        hrvRmssd: 68.0,
        vo2MaxEstimate: 49.5,
        fastingGlucose: 84.0,
        systolicBp: 112.0,
        diastolicBp: 72.0,
        dailySteps: 12500.0,
        deepSleepMinutes: 105.0,
        skeletalMuscleMassKg: 36.0,
        hsCrpMgL: 0.5,
        triglycerideHdlRatio: 1.4,
        hasElevatedLpA: false,
        visceralFatIndex: 4.5,
      );

      expect(report.compositeCellularResilienceScore, greaterThanOrEqualTo(85.0));
      expect(report.hallmarkEvaluations.length, equals(7));

      // Check all 7 hallmarks
      final mito = report.hallmarkEvaluations.firstWhere((h) => h.hallmark == HallmarkOfAging.mitochondrialHealth);
      expect(mito.score, greaterThanOrEqualTo(90.0));
      expect(mito.isProtective, isTrue);

      final proto = report.hallmarkEvaluations.firstWhere((h) => h.hallmark == HallmarkOfAging.proteostasisAndAges);
      expect(proto.score, greaterThanOrEqualTo(85.0));
      expect(proto.isProtective, isTrue);

      final stem = report.hallmarkEvaluations.firstWhere((h) => h.hallmark == HallmarkOfAging.stemCellRegeneration);
      expect(stem.score, greaterThanOrEqualTo(90.0));

      // South Asian Phenotype
      expect(report.southAsianRisk.hasElevatedLpA, isFalse);
      expect(report.southAsianRisk.visceralAdiposityIndex, equals(4.5));
      expect(report.southAsianRisk.atherogenicIndexRatio, equals(1.4));

      // 90-Day Cellular Roadmap
      expect(report.cellularRoadmap.length, equals(3));
      expect(report.cellularRoadmap[0].ayurvedicRasayana, contains('Shilajit'));
      expect(report.cellularRoadmap[1].ayurvedicRasayana, contains('Ashwagandha'));
      expect(report.cellularRoadmap[2].ayurvedicRasayana, contains('Chyawanprash'));
    });

    test('Calibrates Thin-Fat phenotype risk penalties for high visceral fat and elevated Lp(a)', () {
      final report = engine.synthesizeDeepenedLongevity(
        chronologicalAge: 46.0,
        restingHeartRate: 78.0,
        hrvRmssd: 28.0,
        vo2MaxEstimate: 28.0,
        fastingGlucose: 118.0,
        systolicBp: 138.0,
        diastolicBp: 88.0,
        dailySteps: 4200.0,
        deepSleepMinutes: 40.0,
        skeletalMuscleMassKg: 24.0,
        hsCrpMgL: 2.8,
        triglycerideHdlRatio: 4.2,
        hasElevatedLpA: true,
        visceralFatIndex: 12.0,
      );

      expect(report.compositeCellularResilienceScore, lessThan(65.0));
      expect(report.southAsianRisk.hasElevatedLpA, isTrue);
      expect(report.southAsianRisk.clinicalInterpretation, contains('Thin-Fat phenotype profile detected'));
      expect(report.southAsianRisk.sarcopenicRiskIndex, greaterThan(50.0));

      final infl = report.hallmarkEvaluations.firstWhere((h) => h.hallmark == HallmarkOfAging.inflammaging);
      expect(infl.score, lessThan(60.0));
      expect(infl.biologicalAgeDeltaYears, greaterThan(0.0));
    });
  });

  group('DeepenedLongevityNotifier Tests', () {
    test('Initializes with baseline report and recalculates dynamically', () {
      final notifier = DeepenedLongevityNotifier();
      expect(notifier.state.hallmarkEvaluations.length, equals(7));
      expect(notifier.state.cellularRoadmap.length, equals(3));

      notifier.recalculate(
        chronologicalAge: 35.0,
        restingHeartRate: 50.0,
        hrvRmssd: 75.0,
        vo2MaxEstimate: 52.0,
        fastingGlucose: 82.0,
        systolicBp: 110.0,
        diastolicBp: 70.0,
        dailySteps: 14000.0,
        deepSleepMinutes: 110.0,
        skeletalMuscleMassKg: 38.0,
      );

      expect(notifier.state.compositeCellularResilienceScore, greaterThan(90.0));
    });
  });
}
