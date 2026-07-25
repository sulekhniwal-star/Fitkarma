/// §P11-C Wearable-Free Body Composition Estimation Algorithm
///
/// Computes accurate body fat %, lean mass (kg), fat mass (kg), and body composition categories
/// using U.S. Navy circumference formulas combined with photo silhouette calibration matching §P11-C spec.
library;

import 'dart:math' as math;

/// Photo-derived anthropometric silhouette signals (§P11-C spec).
class PhotoAnthropometricMetrics {
  const PhotoAnthropometricMetrics({
    required this.shoulderToWaistRatio,
    required this.waistToHipRatioPhoto,
    this.bodySilhouetteDensityIndex = 1.0,
  });

  final double shoulderToWaistRatio; // e.g. 1.35 (V-taper)
  final double waistToHipRatioPhoto; // e.g. 0.82
  final double bodySilhouetteDensityIndex;
}

/// Comprehensive body composition estimation result (§P11-C spec).
class BodyCompositionResult {
  const BodyCompositionResult({
    required this.bodyFatPct,
    required this.fatMassKg,
    required this.leanMassKg,
    required this.categoryLabel,
    required this.waistToHeightRatio,
    this.waistToHipRatio,
    required this.visceralFatLevelEstimate,
    required this.methodName,
  });

  final double bodyFatPct;
  final double fatMassKg;
  final double leanMassKg;
  final String categoryLabel;
  final double waistToHeightRatio;
  final double? waistToHipRatio;
  final int visceralFatLevelEstimate;
  final String methodName;
}

class BodyCompositionEstimator {
  const BodyCompositionEstimator();

  /// Estimates body composition (body fat %, lean mass kg, fat mass kg, category)
  /// using U.S. Navy formulas with optional photo silhouette calibration (§P11-C spec).
  BodyCompositionResult estimate({
    required double heightCm,
    required double weightKg,
    required double waistCm,
    required double neckCm,
    double? hipCm,
    required String gender,
    required int age,
    PhotoAnthropometricMetrics? photoMetrics,
  }) {
    final isFemale = gender.toLowerCase() == 'female' || gender.toLowerCase() == 'f';

    double bodyFatPct;
    String method = 'U.S. Navy Method';

    if (isFemale) {
      final effectiveHip = hipCm ?? (waistCm * 1.15); // Fallback hip estimate if unsupplied
      final val = waistCm + effectiveHip - neckCm;

      if (val <= 0 || heightCm <= 0) {
        bodyFatPct = 25.0; // Default female safety fallback
      } else {
        final denom = 1.29579 - (0.35004 * _log10(val)) + (0.22100 * _log10(heightCm));
        bodyFatPct = (495.0 / denom) - 450.0;
      }
    } else {
      final val = waistCm - neckCm;

      if (val <= 0 || heightCm <= 0) {
        bodyFatPct = 18.0; // Default male safety fallback
      } else {
        final denom = 1.0324 - (0.19077 * _log10(val)) + (0.15456 * _log10(heightCm));
        bodyFatPct = (495.0 / denom) - 450.0;
      }
    }

    // Photo Silhouette Calibration (§P11-C Photo-assisted adaptation)
    if (photoMetrics != null) {
      method = 'U.S. Navy + Photo Silhouette Calibration';
      // High shoulder-to-waist ratio (V-taper > 1.30) indicates higher muscle density
      if (!isFemale && photoMetrics.shoulderToWaistRatio >= 1.30) {
        final vTaperBonus = ((photoMetrics.shoulderToWaistRatio - 1.30) * 4.0).clamp(0.0, 2.5);
        bodyFatPct -= vTaperBonus;
      }
    }

    // Clamp body fat % within biological bounds
    bodyFatPct = bodyFatPct.clamp(isFemale ? 8.0 : 4.0, 55.0);

    // Calculate Fat Mass and Lean Mass
    final fatMassKg = (weightKg * (bodyFatPct / 100.0)).clamp(0.0, weightKg);
    final leanMassKg = (weightKg - fatMassKg).clamp(0.0, weightKg);

    // Category Labeling
    final category = _determineCategory(bodyFatPct, isFemale);

    // Ratios & Visceral Fat Estimate
    final whtr = waistCm / heightCm;
    final whr = (hipCm != null && hipCm > 0) ? (waistCm / hipCm) : null;
    final visceralEstimate = _estimateVisceralFatLevel(whtr, bodyFatPct, isFemale);

    return BodyCompositionResult(
      bodyFatPct: double.parse(bodyFatPct.toStringAsFixed(1)),
      fatMassKg: double.parse(fatMassKg.toStringAsFixed(1)),
      leanMassKg: double.parse(leanMassKg.toStringAsFixed(1)),
      categoryLabel: category,
      waistToHeightRatio: double.parse(whtr.toStringAsFixed(2)),
      waistToHipRatio: whr != null ? double.parse(whr.toStringAsFixed(2)) : null,
      visceralFatLevelEstimate: visceralEstimate,
      methodName: method,
    );
  }

  double _log10(double x) => math.log(x) / math.ln10;

  String _determineCategory(double bfPct, bool isFemale) {
    if (isFemale) {
      if (bfPct < 14.0) return 'Essential Fat';
      if (bfPct < 21.0) return 'Athletic';
      if (bfPct < 25.0) return 'Fitness';
      if (bfPct < 32.0) return 'Average';
      return 'Elevated';
    } else {
      if (bfPct < 6.0) return 'Essential Fat';
      if (bfPct < 14.0) return 'Athletic';
      if (bfPct < 18.0) return 'Fitness';
      if (bfPct < 25.0) return 'Average';
      return 'Elevated';
    }
  }

  int _estimateVisceralFatLevel(double whtr, double bfPct, bool isFemale) {
    int level = 1;
    if (whtr > 0.50) level += 3;
    if (whtr > 0.58) level += 4;

    if (isFemale) {
      if (bfPct > 28.0) level += 2;
      if (bfPct > 35.0) level += 3;
    } else {
      if (bfPct > 20.0) level += 2;
      if (bfPct > 26.0) level += 3;
    }

    return level.clamp(1, 20);
  }
}
