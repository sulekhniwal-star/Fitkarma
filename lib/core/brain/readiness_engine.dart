import 'daily_intelligence_package.dart';

/// Morning Check-in Inputs (1–5 rating scale per v1.0 spec)
class MorningCheckIn {
  final int energyLevel; // 1 to 5
  final int muscleSoreness; // 1 to 5
  final int moodRating; // 1 to 5
  final bool isCompleted;

  const MorningCheckIn({
    this.energyLevel = 3,
    this.muscleSoreness = 1,
    this.moodRating = 4,
    this.isCompleted = false,
  });

  double get compositeScore {
    // 1-5 scale: max points per category is 5.
    // Soreness is inverted: 1 (fresh) is best, 5 (very sore) is worst.
    final sorenessInverted = 6 - muscleSoreness;
    final total = energyLevel + moodRating + sorenessInverted;
    // Total max is 15.
    return (total / 15.0) * 100.0;
  }

  MorningCheckIn copyWith({
    int? energyLevel,
    int? muscleSoreness,
    int? moodRating,
    bool? isCompleted,
  }) {
    return MorningCheckIn(
      energyLevel: energyLevel ?? this.energyLevel,
      muscleSoreness: muscleSoreness ?? this.muscleSoreness,
      moodRating: moodRating ?? this.moodRating,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Readiness Zones per §P2-A spec
enum ReadinessZone {
  high, // 80–100
  moderate, // 65–79
  low, // 50–64
  critical, // < 50
}

extension ReadinessZoneExtension on ReadinessZone {
  String get displayName {
    switch (this) {
      case ReadinessZone.high:
        return 'High';
      case ReadinessZone.moderate:
        return 'Moderate';
      case ReadinessZone.low:
        return 'Low';
      case ReadinessZone.critical:
        return 'Critical';
    }
  }

  String get workoutRecommendation {
    switch (this) {
      case ReadinessZone.high:
        return 'Full program intensity — push hard';
      case ReadinessZone.moderate:
        return 'Normal intensity — standard program';
      case ReadinessZone.low:
        return 'Reduced intensity (−30%), shorter sessions';
      case ReadinessZone.critical:
        return 'Rest or active recovery only';
    }
  }

  static ReadinessZone fromScore(int score) {
    if (score >= 80) return ReadinessZone.high;
    if (score >= 65) return ReadinessZone.moderate;
    if (score >= 50) return ReadinessZone.low;
    return ReadinessZone.critical;
  }
}

extension ReadinessTierConfidence on ReadinessTier {
  String get confidenceLabel {
    switch (this) {
      case ReadinessTier.basic:
        return 'Medium confidence';
      case ReadinessTier.enhanced:
        return 'High confidence';
      case ReadinessTier.premium:
        return 'Very high confidence';
    }
  }
}

/// Readiness Calculation Result
class ReadinessResult {
  final int score; // 0 to 100
  final ReadinessTier tier;
  final String confidenceLabel;
  final String adviceSummary;
  final ReadinessZone zone;

  const ReadinessResult({
    required this.score,
    required this.tier,
    required this.confidenceLabel,
    required this.adviceSummary,
    this.zone = ReadinessZone.high,
  });

  /// Display string per §P2-A spec (e.g. "Readiness 85 · Very high confidence")
  String get displayString => 'Readiness $score · $confidenceLabel';
}

/// Pure Dart Readiness Score Calculator per §P2-A spec
class ReadinessScoreCalculator {
  const ReadinessScoreCalculator();

  /// Calculate Readiness Score deterministically without AI
  ReadinessResult calculate({
    required int sleepQuality, // 1–5
    required int sleepDurationMin,
    required int sorenessLevel, // 1–5
    required int stressLevel, // 1–5
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    double score = 100.0;

    // Sleep quality (max 28 pts penalty if 1)
    final clampedSleepQual = sleepQuality.clamp(1, 5);
    score -= (5 - clampedSleepQual) * 7.0;

    // Sleep duration penalty
    if (sleepDurationMin < 360) score -= 10; // < 6h
    if (sleepDurationMin < 300) score -= 10; // < 5h (cumulative -20 if < 5h)

    // Soreness (max 20 pts penalty)
    final clampedSoreness = sorenessLevel.clamp(1, 5);
    score -= (clampedSoreness - 1) * 5.0;

    // Stress (max 20 pts penalty)
    final clampedStress = stressLevel.clamp(1, 5);
    score -= (clampedStress - 1) * 5.0;

    // HR deviation (max 15 pts penalty) — only if available
    if (restingHR != null && baselineHR != null && baselineHR > 0) {
      final hrDelta = (restingHR - baselineHR) / baselineHR;
      if (hrDelta > 0.1) score -= 10;
      if (hrDelta > 0.2) score -= 5;
    }

    // HRV deviation (max 10 pts penalty) — only if available
    if (hrv != null && baselineHRV != null && baselineHRV > 0) {
      final hrvDelta = (baselineHRV - hrv) / baselineHRV;
      if (hrvDelta > 0.15) score -= 10;
    }

    final tier = _determineTier(restingHR, hrv, baselineHR, baselineHRV);
    final finalScore = score.clamp(0.0, 100.0).round();
    final zone = ReadinessZoneExtension.fromScore(finalScore);

    return ReadinessResult(
      score: finalScore,
      tier: tier,
      confidenceLabel: tier.confidenceLabel,
      zone: zone,
      adviceSummary: zone.workoutRecommendation,
    );
  }

  ReadinessTier _determineTier(
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  ) {
    if (hrv != null && (baselineHRV != null || restingHR != null)) {
      return ReadinessTier.premium;
    }
    if (restingHR != null || hrv != null) {
      return ReadinessTier.enhanced;
    }
    return ReadinessTier.basic;
  }
}

/// Baseline User Targets before readiness adjustment
class UserTargets {
  final int calories;
  final double hydrationL;
  final int protein;

  const UserTargets({
    required this.calories,
    required this.hydrationL,
    required this.protein,
  });
}

/// Dynamically Adjusted Targets computed per §P2-A formula
class AdjustedTargets {
  final double workoutIntensityFactor; // 1.0, 0.85, 0.70, or 0.0
  final int calorieTarget;
  final double hydrationL;
  final int proteinTarget;

  const AdjustedTargets({
    required this.workoutIntensityFactor,
    required this.calorieTarget,
    required this.hydrationL,
    required this.proteinTarget,
  });
}

/// Computed Target Adjuster per §P2-A spec (Pure Dart, No AI)
class DailyTargetAdjuster {
  const DailyTargetAdjuster();

  AdjustedTargets adjust(int readinessScore, UserTargets baseTargets) {
    final factor = switch (readinessScore) {
      >= 80 => 1.0, // Full intensity
      >= 65 => 0.85, // Slight reduction
      >= 50 => 0.70, // Meaningful reduction
      _ => 0.0, // Rest day
    };

    return AdjustedTargets(
      workoutIntensityFactor: factor,
      calorieTarget: factor >= 0.7
          ? baseTargets.calories + (100 * (1 - factor)).round()
          : baseTargets.calories +
              200, // Recovery day: extra calories for repair
      hydrationL: baseTargets.hydrationL + (readinessScore < 65 ? 0.3 : 0.0),
      proteinTarget:
          factor >= 0.85 ? baseTargets.protein + 10 : baseTargets.protein,
    );
  }
}

/// Local Three-Tier Readiness Engine (Main wrapper)
class ReadinessEngine {
  final ReadinessScoreCalculator _calculator;

  const ReadinessEngine(
      {ReadinessScoreCalculator calculator = const ReadinessScoreCalculator()})
      : _calculator = calculator;

  /// Calculate Readiness Score locally across Basic, Enhanced, and Premium confidence tiers
  ReadinessResult calculateReadiness({
    required MorningCheckIn checkIn,
    double? sleepHours,
    double? hrvRatio,
    double? dailyStrain,
  }) {
    ReadinessTier tier;
    String confidenceLabel;

    if (hrvRatio != null) {
      tier = ReadinessTier.premium;
      confidenceLabel = ReadinessTier.premium.confidenceLabel;
    } else if (sleepHours != null) {
      tier = ReadinessTier.enhanced;
      confidenceLabel = ReadinessTier.enhanced.confidenceLabel;
    } else {
      tier = ReadinessTier.basic;
      confidenceLabel = ReadinessTier.basic.confidenceLabel;
    }

    final checkInScore = checkIn.compositeScore;
    final sleepScore = (sleepHours != null)
        ? ((sleepHours / 8.0) * 100.0).clamp(0.0, 100.0)
        : checkInScore;
    final hrvScore = (hrvRatio != null)
        ? (hrvRatio * 100.0).clamp(0.0, 100.0)
        : checkInScore;
    final strainPenalty = (dailyStrain != null && dailyStrain > 14.0)
        ? (dailyStrain - 14.0) * 4.0
        : 0.0;

    double rawScore;
    if (tier == ReadinessTier.premium) {
      rawScore = (0.35 * sleepScore) +
          (0.35 * hrvScore) +
          (0.30 * checkInScore) -
          strainPenalty;
    } else if (tier == ReadinessTier.enhanced) {
      rawScore = (0.50 * sleepScore) + (0.50 * checkInScore) - strainPenalty;
    } else {
      rawScore = checkInScore - strainPenalty;
    }

    final finalScore = rawScore.clamp(0.0, 100.0).round();
    final zone = ReadinessZoneExtension.fromScore(finalScore);

    return ReadinessResult(
      score: finalScore,
      tier: tier,
      confidenceLabel: confidenceLabel,
      adviceSummary: zone.workoutRecommendation,
      zone: zone,
    );
  }

  /// Calculates using §P2-A formula directly
  ReadinessResult calculateFromScoreFormula({
    required int sleepQuality,
    required int sleepDurationMin,
    required int sorenessLevel,
    required int stressLevel,
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    return _calculator.calculate(
      sleepQuality: sleepQuality,
      sleepDurationMin: sleepDurationMin,
      sorenessLevel: sorenessLevel,
      stressLevel: stressLevel,
      restingHR: restingHR,
      hrv: hrv,
      baselineHR: baselineHR,
      baselineHRV: baselineHRV,
    );
  }
}
