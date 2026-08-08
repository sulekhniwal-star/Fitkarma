import 'dart:math';

class UserProfileData {
  final int age;
  final String gender; // 'Male', 'Female', 'Other'
  final String country; // 'India'

  const UserProfileData({
    required this.age,
    required this.gender,
    this.country = 'India',
  });
}

class UserHealthMetricsData {
  final double avgSteps7d;
  final double avgProtein7d;
  final double avgSleepH;
  final double workoutsPerWeek;

  const UserHealthMetricsData({
    required this.avgSteps7d,
    required this.avgProtein7d,
    required this.avgSleepH,
    required this.workoutsPerWeek,
  });
}

class BenchmarkDistribution {
  final double p25;
  final double p50;
  final double p75;
  final double p90;

  const BenchmarkDistribution({
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p90,
  });

  int percentileOf(double value) {
    if (value >= p90) {
      final bonus = ((value - p90) / (p90 * 0.2) * 9.0).clamp(0.0, 9.0);
      return (90 + bonus).round().clamp(1, 99);
    } else if (value >= p75) {
      final range = p90 - p75;
      final frac = range > 0 ? (value - p75) / range : 0.5;
      return (75 + frac * 15).round().clamp(75, 89);
    } else if (value >= p50) {
      final range = p75 - p50;
      final frac = range > 0 ? (value - p50) / range : 0.5;
      return (50 + frac * 25).round().clamp(50, 74);
    } else if (value >= p25) {
      final range = p50 - p25;
      final frac = range > 0 ? (value - p25) / range : 0.5;
      return (25 + frac * 25).round().clamp(25, 49);
    } else {
      final frac = p25 > 0 ? (value / p25) : 0.5;
      return (frac * 25).round().clamp(1, 24);
    }
  }
}

class CohortBenchmarks {
  final BenchmarkDistribution steps;
  final BenchmarkDistribution protein;
  final BenchmarkDistribution sleep;
  final BenchmarkDistribution workouts;

  const CohortBenchmarks({
    required this.steps,
    required this.protein,
    required this.sleep,
    required this.workouts,
  });
}

class BenchmarkResult {
  final int stepsPercentile;    // e.g. 78 -> Top 22%
  final int proteinPercentile;  // e.g. 55 -> Top 45%
  final int sleepPercentile;    // e.g. 62 -> Top 38%
  final int workoutsPercentile; // e.g. 82 -> Top 18%
  final int overallPercentile;  // composite e.g. 70th pct (Top 30%)
  final String cohortLabel;     // e.g., 'Age 28 · Male · India'
  final String biggestOpportunityArea;
  final String opportunityTip;

  const BenchmarkResult({
    required this.stepsPercentile,
    required this.proteinPercentile,
    required this.sleepPercentile,
    required this.workoutsPercentile,
    required this.overallPercentile,
    required this.cohortLabel,
    required this.biggestOpportunityArea,
    required this.opportunityTip,
  });

  String topLabel(int percentile) {
    final topPct = max(1, 100 - percentile);
    return 'Top $topPct%';
  }
}

/// Pure-Dart Benchmarking Engine per §P7-E spec
class BenchmarkingEngine {
  const BenchmarkingEngine();

  static const Map<String, CohortBenchmarks> _cohortDatabase = {
    '25-30_Male_India': CohortBenchmarks(
      steps: BenchmarkDistribution(p25: 5000, p50: 7500, p75: 9000, p90: 11500), // 9400 -> ~78th pct (Top 22%)
      protein: BenchmarkDistribution(p25: 50, p50: 74, p75: 95, p90: 120),       // 78g -> ~55th pct (Top 45%)
      sleep: BenchmarkDistribution(p25: 6.0, p50: 6.8, p75: 7.8, p90: 8.5),       // 7.1h -> ~62nd pct (Top 38%)
      workouts: BenchmarkDistribution(p25: 1.5, p50: 2.5, p75: 3.8, p90: 5.0),   // 4.2 -> ~82nd pct (Top 18%)
    ),
    '25-30_Female_India': CohortBenchmarks(
      steps: BenchmarkDistribution(p25: 4500, p50: 6800, p75: 8500, p90: 10500),
      protein: BenchmarkDistribution(p25: 35, p50: 55, p75: 70, p90: 90),
      sleep: BenchmarkDistribution(p25: 6.2, p50: 7.0, p75: 7.8, p90: 8.5),
      workouts: BenchmarkDistribution(p25: 1.0, p50: 2.0, p75: 3.2, p90: 4.5),
    ),
    'default': CohortBenchmarks(
      steps: BenchmarkDistribution(p25: 4800, p50: 7000, p75: 8800, p90: 11000),
      protein: BenchmarkDistribution(p25: 40, p50: 60, p75: 80, p90: 100),
      sleep: BenchmarkDistribution(p25: 6.1, p50: 6.9, p75: 7.6, p90: 8.3),
      workouts: BenchmarkDistribution(p25: 1.2, p50: 2.2, p75: 3.5, p90: 4.8),
    ),
  };

  String resolveAgeRange(int age) {
    if (age >= 18 && age <= 24) return '18-24';
    if (age >= 25 && age <= 30) return '25-30';
    if (age >= 31 && age <= 40) return '31-40';
    if (age >= 41 && age <= 50) return '41-50';
    return '50+';
  }

  BenchmarkResult compare({
    required UserProfileData user,
    required UserHealthMetricsData data,
  }) {
    final ageRange = resolveAgeRange(user.age);
    final key = '${ageRange}_${user.gender}_${user.country}';
    final benchmarks = _cohortDatabase[key] ?? _cohortDatabase['default']!;

    final stepsPct = benchmarks.steps.percentileOf(data.avgSteps7d);
    final proteinPct = benchmarks.protein.percentileOf(data.avgProtein7d);
    final sleepPct = benchmarks.sleep.percentileOf(data.avgSleepH);
    final workoutsPct = benchmarks.workouts.percentileOf(data.workoutsPerWeek);

    final overallPct = ((stepsPct * 0.25) + (proteinPct * 0.30) + (sleepPct * 0.20) + (workoutsPct * 0.25)).round().clamp(1, 99);

    // Find lowest percentile metric as biggest opportunity area
    final pcts = {
      'Protein': proteinPct,
      'Steps': stepsPct,
      'Sleep': sleepPct,
      'Workouts': workoutsPct,
    };

    final lowestEntry = pcts.entries.reduce((a, b) => a.value < b.value ? a : b);
    final oppArea = lowestEntry.key;

    String tip = '';
    if (oppArea == 'Protein') {
      tip = 'Protein is your lowest percentile. Hitting your 110g target would move you to Top 25%.';
    } else if (oppArea == 'Steps') {
      tip = 'Steps is your lowest percentile. Adding a 15-minute post-lunch walk moves you to Top 30%.';
    } else if (oppArea == 'Sleep') {
      tip = 'Sleep is your lowest percentile. Locking in a consistent 11 PM bedtime moves you to Top 20%.';
    } else {
      tip = 'Workouts is your lowest percentile. Completing 1 more session this week moves you to Top 20%.';
    }

    return BenchmarkResult(
      stepsPercentile: stepsPct,
      proteinPercentile: proteinPct,
      sleepPercentile: sleepPct,
      workoutsPercentile: workoutsPct,
      overallPercentile: overallPct,
      cohortLabel: 'Age ${user.age} · ${user.gender} · ${user.country}',
      biggestOpportunityArea: oppArea,
      opportunityTip: tip,
    );
  }
}
