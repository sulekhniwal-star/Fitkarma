import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/body_analytics/domain/body_analytics_engine.dart';
import 'package:fitkarma/features/body_analytics/domain/body_analytics_models.dart';

void main() {
  group('BodyAnalyticsEngine Deterministic Offline Tests', () {
    const engine = BodyAnalyticsEngine();

    test('Computes lean athletic body composition for optimal male measurements', () {
      const circumferences = BodyCircumferences(
        neckCm: 39.0,
        chestCm: 104.0,
        waistCm: 80.0,
        hipsCm: 95.0,
        bicepLeftCm: 36.0,
        bicepRightCm: 36.0,
        thighLeftCm: 56.5,
        thighRightCm: 56.5,
        calfLeftCm: 37.0,
        calfRightCm: 37.0,
      );

      final report = engine.computeBodyAnalytics(
        weightKg: 75.0,
        heightCm: 180.0,
        sex: AnthropometricSex.male,
        chronologicalAge: 30,
        circumferences: circumferences,
      );

      expect(report.weightKg, equals(75.0));
      expect(report.heightCm, equals(180.0));
      expect(report.bodyFatPercent, lessThan(16.0));
      expect(report.leanMuscleMassKg, greaterThan(62.0));
      expect(report.waistToHeightRatio, lessThan(0.50));
      expect(report.waistToHipRatio, closeTo(0.84, 0.02));
      expect(report.symmetryIndexScore, equals(100.0));
      expect(report.zone, isIn([BodyCompositionZone.athleticLean, BodyCompositionZone.fitHealthy]));
      expect(report.dhatuProfile.mamsaQualityScore, greaterThan(80.0));
      expect(report.dhatuProfile.shukraQualityScore, greaterThan(75.0));
    });

    test('Computes accurate body composition for female anthropometric formula', () {
      const circumferences = BodyCircumferences(
        neckCm: 32.0,
        chestCm: 88.0,
        waistCm: 68.0,
        hipsCm: 94.0,
        bicepLeftCm: 26.0,
        bicepRightCm: 26.0,
        thighLeftCm: 52.0,
        thighRightCm: 52.0,
        calfLeftCm: 33.0,
        calfRightCm: 33.0,
      );

      final report = engine.computeBodyAnalytics(
        weightKg: 58.0,
        heightCm: 165.0,
        sex: AnthropometricSex.female,
        chronologicalAge: 28,
        circumferences: circumferences,
      );

      expect(report.weightKg, equals(58.0));
      expect(report.bodyFatPercent, inInclusiveRange(18.0, 26.0));
      expect(report.waistToHeightRatio, lessThan(0.50));
      expect(report.zone, isIn([BodyCompositionZone.athleticLean, BodyCompositionZone.fitHealthy]));
      expect(report.basalMetabolicRateKcal, greaterThan(1200.0));
    });

    test('Detects bilateral limb asymmetry and applies symmetry penalty', () {
      const asymmetricCircumferences = BodyCircumferences(
        neckCm: 38.0,
        chestCm: 100.0,
        waistCm: 82.0,
        hipsCm: 96.0,
        bicepLeftCm: 33.0,
        bicepRightCm: 36.0, // 3cm diff
        thighLeftCm: 54.0,
        thighRightCm: 57.0, // 3cm diff
        calfLeftCm: 36.0,
        calfRightCm: 37.0, // 1cm diff
      );

      final report = engine.computeBodyAnalytics(
        weightKg: 74.0,
        heightCm: 175.0,
        sex: AnthropometricSex.male,
        chronologicalAge: 32,
        circumferences: asymmetricCircumferences,
      );

      // (3 + 3 + 1) * 5 = 35% penalty -> 65% symmetry
      expect(report.symmetryIndexScore, equals(65.0));
      expect(report.dhatuProfile.majjaQualityScore, equals(65.0));
    });

    test('Classifies elevated adiposity when waist circumference is high relative to height', () {
      const elevatedCircumferences = BodyCircumferences(
        neckCm: 37.0,
        chestCm: 106.0,
        waistCm: 98.0,
        hipsCm: 104.0,
        bicepLeftCm: 33.0,
        bicepRightCm: 33.0,
        thighLeftCm: 58.0,
        thighRightCm: 58.0,
        calfLeftCm: 38.0,
        calfRightCm: 38.0,
      );

      final report = engine.computeBodyAnalytics(
        weightKg: 88.0,
        heightCm: 170.0,
        sex: AnthropometricSex.male,
        chronologicalAge: 40,
        circumferences: elevatedCircumferences,
      );

      expect(report.waistToHeightRatio, greaterThan(0.55));
      expect(report.bodyFatPercent, greaterThan(24.0));
      expect(report.zone, equals(BodyCompositionZone.elevatedAdiposity));
      expect(report.actionableBodyRecommendation, contains('visceral'));
    });
  });
}
