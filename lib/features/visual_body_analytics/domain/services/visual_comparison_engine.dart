import '../models/body_analytics_models.dart';

class VisualComparisonEngine {
  const VisualComparisonEngine();

  /// Compares baseline and latest progress photos and biometrics
  VisualComparisonResult comparePhotos({
    required ProgressPhotoEntry baseline,
    required ProgressPhotoEntry latest,
    double? baselineWeightKg,
    double? latestWeightKg,
    double? baselineBodyFatPct,
    double? latestBodyFatPct,
    double? baselineWaistCm,
    double? latestWaistCm,
  }) {
    final days = latest.recordedAt.difference(baseline.recordedAt).inDays;

    final weightDelta = (baselineWeightKg != null && latestWeightKg != null)
        ? double.parse((latestWeightKg - baselineWeightKg).toStringAsFixed(1))
        : null;

    final fatDelta = (baselineBodyFatPct != null && latestBodyFatPct != null)
        ? double.parse((latestBodyFatPct - baselineBodyFatPct).toStringAsFixed(1))
        : null;

    final waistDelta = (baselineWaistCm != null && latestWaistCm != null)
        ? double.parse((latestWaistCm - baselineWaistCm).toStringAsFixed(1))
        : null;

    return VisualComparisonResult(
      baselinePhoto: baseline,
      latestPhoto: latest,
      daysApart: days,
      weightDeltaKg: weightDelta,
      bodyFatDeltaPct: fatDelta,
      waistDeltaCm: waistDelta,
    );
  }
}
