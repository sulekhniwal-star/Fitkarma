import 'dart:math';
import 'benchmarking_models.dart';

class BenchmarkingEngine {
  /// Deterministic Z-score calculation
  static double calculateZScore(
    double userValue,
    double cohortMean,
    double cohortStdDev, {
    bool lowerIsBetter = false,
  }) {
    if (cohortStdDev <= 0) return 0.0;
    final z = (userValue - cohortMean) / cohortStdDev;
    return lowerIsBetter ? -z : z;
  }

  /// Deterministic cumulative normal distribution approximation:
  /// Phi(Z) = 1 / (1 + exp(-1.702 * Z)) * 100
  static double calculatePercentileFromZ(double zScore) {
    final double phi = 1.0 / (1.0 + exp(-1.702 * zScore));
    final double percentile = phi * 100.0;
    return double.parse(percentile.clamp(1.0, 99.9).toStringAsFixed(1));
  }

  /// Maps percentile to athletic classification tier
  static FitnessPercentileTier determineTier(double percentile) {
    if (percentile >= 99.0) {
      return FitnessPercentileTier.legendary;
    } else if (percentile >= 90.0) {
      return FitnessPercentileTier.elite;
    } else if (percentile >= 75.0) {
      return FitnessPercentileTier.superior;
    } else if (percentile >= 50.0) {
      return FitnessPercentileTier.average;
    } else {
      return FitnessPercentileTier.developing;
    }
  }

  /// Builds a benchmark metric with deterministic percentile computation
  static BenchmarkMetric evaluateMetric({
    required String id,
    required String name,
    required String regionalName,
    required BenchmarkCategory category,
    required double userValue,
    required String unit,
    required double cohortMean,
    required double cohortStdDev,
    bool lowerIsBetter = false,
    required String contextualInsight,
    required String regionalContextualInsight,
  }) {
    final z = calculateZScore(userValue, cohortMean, cohortStdDev, lowerIsBetter: lowerIsBetter);
    final percentile = calculatePercentileFromZ(z);
    final tier = determineTier(percentile);

    return BenchmarkMetric(
      id: id,
      name: name,
      regionalName: regionalName,
      category: category,
      userValue: userValue,
      unit: unit,
      cohortMean: cohortMean,
      cohortStdDev: cohortStdDev,
      percentile: percentile,
      tier: tier,
      contextualInsight: contextualInsight,
      regionalContextualInsight: regionalContextualInsight,
    );
  }

  /// Generates complete benchmark report calibrated for Indian demographic cohorts
  static FitnessBenchmarkReport generateCohortReport({
    required DemographicCohortProfile cohortProfile,
    required List<BenchmarkMetric> evaluatedMetrics,
  }) {
    if (evaluatedMetrics.isEmpty) {
      return FitnessBenchmarkReport(
        cohortProfile: cohortProfile,
        compositeFitnessPercentile: 50.0,
        overallTier: FitnessPercentileTier.average,
        allMetrics: const [],
        primaryStrengthDomain: 'General Movement',
        primaryGrowthDomain: 'Cardiovascular Work Capacity',
      );
    }

    final double avgPercentile = evaluatedMetrics.fold(0.0, (sum, m) => sum + m.percentile) / evaluatedMetrics.length;
    final double compositePercentile = double.parse(avgPercentile.clamp(1.0, 99.9).toStringAsFixed(1));
    final overallTier = determineTier(compositePercentile);

    // Identify highest and lowest ranking metrics
    final sorted = List<BenchmarkMetric>.from(evaluatedMetrics)..sort((a, b) => b.percentile.compareTo(a.percentile));
    final strength = sorted.first.name;
    final growth = sorted.last.name;

    return FitnessBenchmarkReport(
      cohortProfile: cohortProfile,
      compositeFitnessPercentile: compositePercentile,
      overallTier: overallTier,
      allMetrics: evaluatedMetrics,
      primaryStrengthDomain: strength,
      primaryGrowthDomain: growth,
    );
  }
}
