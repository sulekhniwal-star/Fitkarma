import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/body_analytics/domain/body_analytics_models.dart';
import 'package:fitkarma/features/body_analytics/domain/wearable_free_composition_engine.dart';

void main() {
  group('WearableFreeCompositionEngine Deterministic Tests', () {
    const engine = WearableFreeCompositionEngine();

    test('Computes multi-model ensemble consensus for lean male inputs', () {
      final report = engine.computeWearableFreeComposition(
        weightKg: 75.0,
        heightCm: 180.0,
        age: 30,
        sex: AnthropometricSex.male,
        waistCm: 80.0,
        neckCm: 39.0,
        applySouthAsianCalibrations: true,
      );

      expect(report.individualEstimates.length, equals(4));
      expect(report.ensembleBodyFatPercent, inInclusiveRange(12.0, 18.0));
      expect(report.ensembleLeanMassKg, greaterThan(60.0));
      expect(report.ensembleFatMassKg, lessThan(15.0));
      expect(report.ensembleBoneMassKg, closeTo(3.45, 0.1));
      expect(report.confidenceScorePercent, greaterThan(80.0));
      expect(report.southAsianSpecificCutoffsApplied, isTrue);
      expect(report.zone, isIn([BodyCompositionZone.athleticLean, BodyCompositionZone.fitHealthy]));
    });

    test('Computes ensemble consensus for female inputs', () {
      final report = engine.computeWearableFreeComposition(
        weightKg: 58.0,
        heightCm: 165.0,
        age: 28,
        sex: AnthropometricSex.female,
        waistCm: 68.0,
        neckCm: 32.0,
        hipsCm: 94.0,
        applySouthAsianCalibrations: true,
      );

      expect(report.individualEstimates.length, equals(4));
      expect(report.ensembleBodyFatPercent, inInclusiveRange(19.0, 27.0));
      expect(report.ensembleLeanMassKg, greaterThan(40.0));
      expect(report.zone, isIn([BodyCompositionZone.athleticLean, BodyCompositionZone.fitHealthy]));
    });

    test('Checks model weights sum to 1.0 in ensemble', () {
      final report = engine.computeWearableFreeComposition(
        weightKg: 70.0,
        heightCm: 175.0,
        age: 25,
        sex: AnthropometricSex.male,
        waistCm: 78.0,
        neckCm: 37.0,
      );

      final totalWeighting = report.individualEstimates.fold<double>(
        0.0,
        (acc, m) => acc + m.modelWeighting,
      );

      expect(totalWeighting, equals(1.0));
    });

    test('Model concordance interpretation reflects low standard deviation variance', () {
      final report = engine.computeWearableFreeComposition(
        weightKg: 74.0,
        heightCm: 178.0,
        age: 32,
        sex: AnthropometricSex.male,
        waistCm: 81.0,
        neckCm: 38.0,
      );

      expect(report.modelVarianceStdDev, isNonNegative);
      expect(report.clinicalInterpretation, isNotEmpty);
      expect(report.regionalInterpretation, isNotEmpty);
    });
  });
}
