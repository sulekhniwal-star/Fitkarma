/// §P10-E Stress Detection Engine — Models & Inferred Stress Logic
///
/// Implements inferred-stress detection algorithm combining physiological (HRV, Resting HR, Sleep)
/// and behavioral signals (missed logging streaks, late-night logging) matching §P10-E spec.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P10-E Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum StressLevel {
  low('Low Stress', 0, 29, '🟩'),
  moderate('Moderate Stress', 30, 59, '🟨'),
  high('High Stress', 60, 79, '🟧'),
  extreme('Extreme Stress', 80, 100, '🟥');

  const StressLevel(this.displayName, this.minScore, this.maxScore, this.indicatorEmoji);

  final String displayName;
  final int minScore;
  final int maxScore;
  final String indicatorEmoji;

  int get priorityLevel {
    switch (this) {
      case StressLevel.low: return 1;
      case StressLevel.moderate: return 2;
      case StressLevel.high: return 3;
      case StressLevel.extreme: return 4;
    }
  }

  static StressLevel fromScore(double score) {
    if (score >= 80.0) return StressLevel.extreme;
    if (score >= 60.0) return StressLevel.high;
    if (score >= 30.0) return StressLevel.moderate;
    return StressLevel.low;
  }
}

class StressSignalInputs {
  const StressSignalInputs({
    required this.hrvMs,
    this.baselineHrvMs = 50.0,
    required this.restingHrBpm,
    this.baselineRestingHrBpm = 65.0,
    required this.sleepDurationHours,
    required this.sleepQualityScore,
    required this.missedLoggingCount,
    required this.hasLateNightLogging,
  });

  final double hrvMs;
  final double baselineHrvMs;
  final double restingHrBpm;
  final double baselineRestingHrBpm;
  final double sleepDurationHours;
  final double sleepQualityScore; // 0-100%
  final int missedLoggingCount;
  final bool hasLateNightLogging;
}

class InferredStressResult {
  const InferredStressResult({
    required this.stressScore,
    required this.stressLevel,
    required this.primaryContributors,
    required this.recommendedIntervention,
    required this.timestamp,
  });

  final double stressScore; // 0 - 100
  final StressLevel stressLevel;
  final List<String> primaryContributors;
  final String recommendedIntervention;
  final DateTime timestamp;
}

// ─────────────────────────────────────────────────────────────────────────────
// StressDetectionEngine (§P10-E Specification)
// ─────────────────────────────────────────────────────────────────────────────

class StressDetectionEngine {
  const StressDetectionEngine();

  /// Evaluates inferred stress using weighted multi-factor regression (§P10-E spec):
  ///
  /// - HRV Suppression (Weight: 35%): Drop below baseline indicates sympathetic dominance.
  /// - Resting HR Elevation (Weight: 25%): Elevation above baseline signals strain.
  /// - Sleep Deficit & Quality (Weight: 25%): Duration < 6.5h or quality < 60% increases stress.
  /// - Behavioral Friction Signals (Weight: 15%): Late-night activity & missed logging.
  InferredStressResult evaluateInferredStress(StressSignalInputs inputs) {
    double totalScore = 0.0;
    final contributors = <String>[];

    // 1. HRV Suppression (Weight: 35%)
    if (inputs.hrvMs < inputs.baselineHrvMs) {
      final hrvDropPct = ((inputs.baselineHrvMs - inputs.hrvMs) / inputs.baselineHrvMs).clamp(0.0, 1.0);
      final hrvScoreComponent = hrvDropPct * 35.0;
      totalScore += hrvScoreComponent;

      if (hrvDropPct >= 0.15) {
        contributors.add('HRV suppressed (${inputs.hrvMs.round()}ms vs ${inputs.baselineHrvMs.round()}ms baseline)');
      }
    }

    // 2. Resting HR Elevation (Weight: 25%)
    if (inputs.restingHrBpm > inputs.baselineRestingHrBpm) {
      final hrElevation = (inputs.restingHrBpm - inputs.baselineRestingHrBpm);
      final hrScoreComponent = (hrElevation / 15.0).clamp(0.0, 1.0) * 25.0;
      totalScore += hrScoreComponent;

      if (hrElevation >= 4.0) {
        contributors.add('Resting HR elevated (${inputs.restingHrBpm.round()}bpm vs ${inputs.baselineRestingHrBpm.round()}bpm baseline)');
      }
    }

    // 3. Sleep Deficit & Quality (Weight: 25%)
    double sleepScoreComponent = 0.0;
    if (inputs.sleepDurationHours < 7.0) {
      final deficitHours = (7.0 - inputs.sleepDurationHours).clamp(0.0, 3.0);
      sleepScoreComponent += (deficitHours / 3.0) * 15.0;
    }
    if (inputs.sleepQualityScore < 70.0) {
      final qualityDeficit = (70.0 - inputs.sleepQualityScore).clamp(0.0, 50.0);
      sleepScoreComponent += (qualityDeficit / 50.0) * 10.0;
    }
    totalScore += sleepScoreComponent.clamp(0.0, 25.0);

    if (inputs.sleepDurationHours < 6.5 || inputs.sleepQualityScore < 60.0) {
      contributors.add('Sleep deficit (${inputs.sleepDurationHours.toStringAsFixed(1)}h, quality ${inputs.sleepQualityScore.round()}%)');
    }

    // 4. Behavioral Signals (Weight: 15%)
    double behaviorScoreComponent = 0.0;
    if (inputs.hasLateNightLogging) {
      behaviorScoreComponent += 8.0;
      contributors.add('Late-night activity log detected (circadian shift)');
    }
    if (inputs.missedLoggingCount >= 2) {
      behaviorScoreComponent += 7.0;
      contributors.add('Routine habit disruption (${inputs.missedLoggingCount} missed logs)');
    }
    totalScore += behaviorScoreComponent.clamp(0.0, 15.0);

    final finalStressScore = double.parse(totalScore.clamp(0.0, 100.0).toStringAsFixed(1));
    final level = StressLevel.fromScore(finalStressScore);

    String intervention;
    switch (level) {
      case StressLevel.extreme:
        intervention = 'Emergency Stress Protocol: Take a 15-min NSDR reset session & cancel heavy workouts today.';
      case StressLevel.high:
        intervention = 'High Stress Alert: Schedule 10 mins box breathing & prioritize 8h sleep tonight.';
      case StressLevel.moderate:
        intervention = 'Moderate Stress: Maintain light hydration, evening stroll, and limit late caffeine.';
      case StressLevel.low:
        intervention = 'Stress System Optimal: Recovery and autonomic balance operating in sweet spot.';
    }

    if (contributors.isEmpty) {
      contributors.add('Physiological & behavioral stress markers balanced');
    }

    return InferredStressResult(
      stressScore: finalStressScore,
      stressLevel: level,
      primaryContributors: contributors,
      recommendedIntervention: intervention,
      timestamp: DateTime.now(),
    );
  }
}
