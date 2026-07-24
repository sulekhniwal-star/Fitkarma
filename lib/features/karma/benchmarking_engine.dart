/// §P7-E Benchmarking Engine (Fitness Percentile vs. Cohort)
///
/// Compares user health metrics against demographic cohort distributions
/// to compute fitness percentiles matching §P7-E specifications.
library;

import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class CohortKey {
  const CohortKey({
    required this.ageRange,
    required this.gender,
    required this.country,
  });

  final String ageRange; // e.g. "25-30"
  final String gender;   // "Male", "Female"
  final String country;  // "India"

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CohortKey &&
          runtimeType == other.runtimeType &&
          ageRange == other.ageRange &&
          gender == other.gender &&
          country == other.country;

  @override
  int get hashCode => ageRange.hashCode ^ gender.hashCode ^ country.hashCode;

  String get displayName => 'Age $ageRange · $gender · $country';
}

class BenchmarkDistribution {
  const BenchmarkDistribution({
    required this.mean,
    required this.stdDev,
  });

  final double mean;
  final double stdDev;

  /// Calculates percentile (0 to 100) of a given value using normal distribution CDF approximation.
  int percentileOf(double value) {
    if (stdDev <= 0.0) return 50;

    final z = (value - mean) / stdDev;
    // Abramowitz and Stegun approximation for standard normal CDF: Phi(z)
    final p = 0.5 * (1.0 + _erf(z / math.sqrt(2.0)));
    return (p * 100.0).clamp(1.0, 99.0).round();
  }

  // Error function approximation
  static double _erf(double x) {
    final sign = x < 0 ? -1.0 : 1.0;
    final a = x.abs();

    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;
    const p = 0.3275911;

    final t = 1.0 / (1.0 + p * a);
    final y = 1.0 - (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t) * math.exp(-a * a);

    return sign * y;
  }
}

class UserHealthData {
  const UserHealthData({
    required this.avgSteps7d,
    required this.avgProtein7d,
    required this.avgSleepH,
    required this.workoutsPerWeek,
  });

  final double avgSteps7d;
  final double avgProtein7d;
  final double avgSleepH;
  final double workoutsPerWeek;
}

class UserProfile {
  const UserProfile({
    required this.age,
    required this.gender,
    required this.country,
  });

  final int age;
  final String gender;
  final String country;

  String get ageRange {
    if (age < 25) return '18-24';
    if (age <= 30) return '25-30';
    if (age <= 40) return '31-40';
    return '41+';
  }

  CohortKey get cohortKey => CohortKey(
        ageRange: ageRange,
        gender: gender,
        country: country,
      );
}

class BenchmarkResult {
  const BenchmarkResult({
    required this.stepsPercentile,
    required this.proteinPercentile,
    required this.sleepPercentile,
    required this.workoutsPercentile,
    required this.overallPercentile,
    required this.cohortLabel,
    required this.biggestOpportunityMetric,
    required this.biggestOpportunityTip,
  });

  final int stepsPercentile;
  final int proteinPercentile;
  final int sleepPercentile;
  final int workoutsPercentile;
  final int overallPercentile;
  final String cohortLabel;
  final String biggestOpportunityMetric;
  final String biggestOpportunityTip;

  /// Human-readable top X% badge label (e.g., overall 70th pct -> "Top 30%").
  String get topPercentageLabel => 'Top ${100 - overallPercentile}%';
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine & Cohort Database
// ─────────────────────────────────────────────────────────────────────────────

class BenchmarkingEngine {
  const BenchmarkingEngine();

  // Cohort benchmark distributions (Mean, StdDev) for Indian demographics
  static final Map<CohortKey, Map<String, BenchmarkDistribution>> _cohortDatabase = {
    const CohortKey(ageRange: '25-30', gender: 'Male', country: 'India'): {
      'steps': const BenchmarkDistribution(mean: 6500, stdDev: 2500),
      'protein': const BenchmarkDistribution(mean: 65, stdDev: 20),
      'sleep': const BenchmarkDistribution(mean: 6.5, stdDev: 1.0),
      'workouts': const BenchmarkDistribution(mean: 2.5, stdDev: 1.2),
    },
    const CohortKey(ageRange: '25-30', gender: 'Female', country: 'India'): {
      'steps': const BenchmarkDistribution(mean: 5800, stdDev: 2200),
      'protein': const BenchmarkDistribution(mean: 55, stdDev: 18),
      'sleep': const BenchmarkDistribution(mean: 6.8, stdDev: 1.0),
      'workouts': const BenchmarkDistribution(mean: 2.0, stdDev: 1.0),
    },
  };

  /// Compares user health data against demographic cohort benchmarks.
  BenchmarkResult compare({
    required UserProfile user,
    required UserHealthData data,
  }) {
    final key = user.cohortKey;
    final fallbackKey = const CohortKey(ageRange: '25-30', gender: 'Male', country: 'India');
    final benchmarks = _cohortDatabase[key] ?? _cohortDatabase[fallbackKey]!;

    final stepsPct = benchmarks['steps']!.percentileOf(data.avgSteps7d);
    final proteinPct = benchmarks['protein']!.percentileOf(data.avgProtein7d);
    final sleepPct = benchmarks['sleep']!.percentileOf(data.avgSleepH);
    final workoutsPct = benchmarks['workouts']!.percentileOf(data.workoutsPerWeek);

    // Weighted overall percentile: Steps 30%, Workouts 30%, Protein 20%, Sleep 20%
    final overallPct = ((stepsPct * 0.30) +
            (workoutsPct * 0.30) +
            (proteinPct * 0.20) +
            (sleepPct * 0.20))
        .round()
        .clamp(1, 99);

    // Identify lowest percentile metric as biggest opportunity
    final metrics = [
      MapEntry('Steps', stepsPct),
      MapEntry('Protein', proteinPct),
      MapEntry('Sleep', sleepPct),
      MapEntry('Workouts', workoutsPct),
    ]..sort((a, b) => a.value.compareTo(b.value));

    final lowest = metrics.first;
    final tip = _generateOpportunityTip(lowest.key, data);

    return BenchmarkResult(
      stepsPercentile: stepsPct,
      proteinPercentile: proteinPct,
      sleepPercentile: sleepPct,
      workoutsPercentile: workoutsPct,
      overallPercentile: overallPct,
      cohortLabel: key.displayName,
      biggestOpportunityMetric: lowest.key,
      biggestOpportunityTip: tip,
    );
  }

  String _generateOpportunityTip(String metricKey, UserHealthData data) {
    switch (metricKey) {
      case 'Protein':
        return 'Protein is your lowest percentile. Hitting your 110g target would move you to Top 25%.';
      case 'Steps':
        return 'Steps is your lowest percentile. Adding 2,000 steps/day would move you to Top 20%.';
      case 'Sleep':
        return 'Sleep is your lowest percentile. Adding 45 minutes of sleep would boost recovery significantly.';
      case 'Workouts':
        return 'Workouts is your lowest percentile. Adding 1 workout session per week would move you to Top 20%.';
      default:
        return 'Consistent daily progress will elevate your cohort ranking!';
    }
  }
}
