import 'dart:math' as math;

class BodyCompositionResult {
  final double bodyFatPct;
  final double leanMassKg;
  final double fatMassKg;
  final String bfCategory;
  final String estimationMethod;
  final String confidence;

  const BodyCompositionResult({
    required this.bodyFatPct,
    required this.leanMassKg,
    required this.fatMassKg,
    required this.bfCategory,
    required this.estimationMethod,
    required this.confidence,
  });
}

/// Pure-Dart Body Composition Estimator per §P11-C spec
/// Primary: U.S. Navy Formula (±3-4% accuracy)
/// Fallback: BMI-based formula (±5-6% accuracy) when neck/waist measurements are absent
class BodyCompositionEstimator {
  const BodyCompositionEstimator();

  BodyCompositionResult estimate({
    required double heightCm,
    required double weightKg,
    double? waistCm,
    double? neckCm,
    double? hipCm,
    required String gender,
    required int age,
  }) {
    double bodyFatPct;
    String method;
    String confidence;

    final isMale = gender.toLowerCase() == 'male';

    // Primary: U.S. Navy Formula
    if (waistCm != null && neckCm != null && (isMale || hipCm != null)) {
      if (isMale) {
        final diff = waistCm - neckCm;
        if (diff <= 0) {
          bodyFatPct = _bmiFallback(heightCm, weightKg, age, isMale);
          method = 'BMI-based estimate';
          confidence = 'Fallback (±5-6%)';
        } else {
          final logWaistNeck = _log10(diff);
          final logHeight = _log10(heightCm);
          bodyFatPct = 495 / (1.0324 - 0.19077 * logWaistNeck + 0.15456 * logHeight) - 450;
          method = 'U.S. Navy Formula';
          confidence = 'Medium (±3-4%)';
        }
      } else {
        final sumDiff = waistCm + hipCm! - neckCm;
        if (sumDiff <= 0) {
          bodyFatPct = _bmiFallback(heightCm, weightKg, age, isMale);
          method = 'BMI-based estimate';
          confidence = 'Fallback (±5-6%)';
        } else {
          final logWaistHipNeck = _log10(sumDiff);
          final logHeight = _log10(heightCm);
          bodyFatPct = 495 / (1.29579 - 0.35004 * logWaistHipNeck + 0.22100 * logHeight) - 450;
          method = 'U.S. Navy Formula';
          confidence = 'Medium (±3-4%)';
        }
      }
    } else {
      // Fallback: BMI-based estimate formula
      // Adult BF% = (1.20 × BMI) + (0.23 × Age) - (10.8 × gender) - 5.4  (gender: male=1, female=0)
      bodyFatPct = _bmiFallback(heightCm, weightKg, age, isMale);
      method = 'BMI-based estimate';
      confidence = 'Fallback (±5-6%)';
    }

    bodyFatPct = bodyFatPct.clamp(3.0, 60.0);
    final roundedBf = double.parse(bodyFatPct.toStringAsFixed(1));
    final fatMassKg = double.parse((weightKg * (roundedBf / 100.0)).toStringAsFixed(1));
    final leanMassKg = double.parse((weightKg - fatMassKg).toStringAsFixed(1));

    return BodyCompositionResult(
      bodyFatPct: roundedBf,
      leanMassKg: leanMassKg,
      fatMassKg: fatMassKg,
      bfCategory: classifyBfCategory(roundedBf, gender),
      estimationMethod: method,
      confidence: confidence,
    );
  }

  double _bmiFallback(double heightCm, double weightKg, int age, bool isMale) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);
    final genderFactor = isMale ? 1 : 0;
    return (1.20 * bmi) + (0.23 * age) - (10.8 * genderFactor) - 5.4;
  }

  String classifyBfCategory(double bfPct, String gender) {
    final isMale = gender.toLowerCase() == 'male';
    if (isMale) {
      if (bfPct < 6) return 'Essential Fat';
      if (bfPct < 14) return 'Athletes';
      if (bfPct < 18) return 'Fitness';
      if (bfPct < 25) return 'Average';
      return 'Obese';
    } else {
      if (bfPct < 14) return 'Essential Fat';
      if (bfPct < 21) return 'Athletes';
      if (bfPct < 25) return 'Fitness';
      if (bfPct < 32) return 'Average';
      return 'Obese';
    }
  }

  double _log10(double x) => math.log(x) / math.ln10;
}
