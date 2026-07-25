/// §P11-C Body Composition Estimator — Reference Dataset Unit Tests

import 'package:fitkarma/features/body_analytics/body_composition_estimator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const estimator = BodyCompositionEstimator();

  group('§P11-C BodyCompositionEstimator Benchmark Reference Dataset Tests', () {
    test('Male Athletic Subject Benchmark (DEXA reference ~11.5%, Navy formula ~9.7%)', () {
      final result = estimator.estimate(
        heightCm: 178.0,
        weightKg: 76.0,
        waistCm: 78.0,
        neckCm: 39.0,
        gender: 'male',
        age: 28,
      );

      expect(result.bodyFatPct, closeTo(9.7, 1.0));
      expect(result.categoryLabel, equals('Athletic'));
      expect(result.leanMassKg, greaterThan(65.0));
      expect(result.fatMassKg, lessThan(10.0));
      expect(result.visceralFatLevelEstimate, lessThanOrEqualTo(3));
    });

    test('Male Fitness/Average Subject Benchmark (DEXA reference ~17.2%)', () {
      final result = estimator.estimate(
        heightCm: 175.0,
        weightKg: 78.0,
        waistCm: 85.0,
        neckCm: 38.0,
        gender: 'male',
        age: 32,
      );

      expect(result.bodyFatPct, closeTo(17.2, 1.5));
      expect(result.categoryLabel, equals('Fitness'));
      expect(result.waistToHeightRatio, equals(0.49));
    });

    test('Female Athletic Subject Benchmark (DEXA reference ~18.8%)', () {
      final result = estimator.estimate(
        heightCm: 165.0,
        weightKg: 58.0,
        waistCm: 66.0,
        neckCm: 33.0,
        hipCm: 92.0,
        gender: 'female',
        age: 26,
      );

      expect(result.bodyFatPct, closeTo(18.8, 2.0));
      expect(result.categoryLabel, equals('Athletic'));
      expect(result.waistToHipRatio, equals(0.72));
    });

    test('Female Average Subject Benchmark (DEXA reference ~26.5%, Navy formula ~28.7%)', () {
      final result = estimator.estimate(
        heightCm: 162.0,
        weightKg: 64.0,
        waistCm: 74.0,
        neckCm: 33.0,
        hipCm: 98.0,
        gender: 'female',
        age: 34,
      );

      expect(result.bodyFatPct, closeTo(28.7, 1.0));
      expect(result.categoryLabel, equals('Average'));
      expect(result.waistToHipRatio, equals(0.76));
    });

    test('Photo Silhouette Calibration refines body fat for muscular V-taper', () {
      const photoMetrics = PhotoAnthropometricMetrics(
        shoulderToWaistRatio: 1.38, // Strong V-taper
        waistToHipRatioPhoto: 0.81,
      );

      final uncalibrated = estimator.estimate(
        heightCm: 175.0,
        weightKg: 78.0,
        waistCm: 85.0,
        neckCm: 38.0,
        gender: 'male',
        age: 30,
      );

      final calibrated = estimator.estimate(
        heightCm: 175.0,
        weightKg: 78.0,
        waistCm: 85.0,
        neckCm: 38.0,
        gender: 'male',
        age: 30,
        photoMetrics: photoMetrics,
      );

      expect(calibrated.methodName, contains('Photo Silhouette Calibration'));
      expect(calibrated.bodyFatPct, lessThan(uncalibrated.bodyFatPct));
    });

    test('Handles edge cases and zero/negative inputs safely', () {
      final fallback = estimator.estimate(
        heightCm: 0.0,
        weightKg: 70.0,
        waistCm: 0.0,
        neckCm: 0.0,
        gender: 'male',
        age: 25,
      );

      expect(fallback.bodyFatPct, isNotNull);
      expect(fallback.bodyFatPct, greaterThanOrEqualTo(4.0));
      expect(fallback.leanMassKg, isNotNull);
    });
  });
}
