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

/// Readiness Calculation Result
class ReadinessResult {
  final int score; // 0 to 100
  final ReadinessTier tier;
  final String confidenceLabel;
  final String adviceSummary;

  const ReadinessResult({
    required this.score,
    required this.tier,
    required this.confidenceLabel,
    required this.adviceSummary,
  });
}

/// Local Three-Tier Readiness Engine
class ReadinessEngine {
  const ReadinessEngine();

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
      confidenceLabel = 'High Confidence (Wearable + HRV)';
    } else if (sleepHours != null) {
      tier = ReadinessTier.enhanced;
      confidenceLabel = 'Medium Confidence (Sleep Sync)';
    } else {
      tier = ReadinessTier.basic;
      confidenceLabel = 'Basic Confidence (Check-in Only)';
    }

    final checkInScore = checkIn.compositeScore;
    final sleepScore = (sleepHours != null) ? ((sleepHours / 8.0) * 100.0).clamp(0.0, 100.0) : checkInScore;
    final hrvScore = (hrvRatio != null) ? (hrvRatio * 100.0).clamp(0.0, 100.0) : checkInScore;
    final strainPenalty = (dailyStrain != null && dailyStrain > 14.0) ? (dailyStrain - 14.0) * 4.0 : 0.0;

    double rawScore;
    if (tier == ReadinessTier.premium) {
      rawScore = (0.35 * sleepScore) + (0.35 * hrvScore) + (0.30 * checkInScore) - strainPenalty;
    } else if (tier == ReadinessTier.enhanced) {
      rawScore = (0.50 * sleepScore) + (0.50 * checkInScore) - strainPenalty;
    } else {
      rawScore = checkInScore - strainPenalty;
    }

    final finalScore = rawScore.clamp(0.0, 100.0).round();

    String advice;
    if (finalScore >= 80) {
      advice = 'Peak Readiness — Ideal day for high-intensity training!';
    } else if (finalScore >= 50) {
      advice = 'Moderate Readiness — Focus on steady workout and balanced recovery.';
    } else {
      advice = 'Low Recovery — Priority REST day. Focus on hydration and gentle mobility.';
    }

    return ReadinessResult(
      score: finalScore,
      tier: tier,
      confidenceLabel: confidenceLabel,
      adviceSummary: advice,
    );
  }
}
