/// §P5-O Nutrition Reliability Score & Data Confidence Shield
///
/// Pure-Dart 7-day rolling nutrition reliability calculator (Logged Days * 40 + Protein Tracking * 30 + Water Logs * 30),
/// 70% target lockout threshold, and low-confidence warning message generator to prevent starvation cascades.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Log quality record for a single day.
class DailyLogQualityRecord {
  const DailyLogQualityRecord({
    required this.date,
    required this.mealsLoggedCount,
    required this.wasProteinTargetMet,
    required this.wasWaterTargetMet,
  });

  final DateTime date;
  final int mealsLoggedCount;
  final bool wasProteinTargetMet;
  final bool wasWaterTargetMet;
}

/// Result payload output from [DataConfidenceShieldEngine].
class DataConfidenceShieldResult {
  const DataConfidenceShieldResult({
    required this.reliabilityScorePct,
    required this.isLockoutActive,
    required this.validLogDaysCount,
    required this.proteinTrackingDaysCount,
    required this.waterTrackingDaysCount,
    required this.shieldMessage,
    required this.statusTier,
  });

  /// 0.0 to 100.0 Rolling 7-Day Reliability Percentage
  final double reliabilityScorePct;

  /// Active when reliability < 70.0%
  final bool isLockoutActive;

  final int validLogDaysCount;
  final int proteinTrackingDaysCount;
  final int waterTrackingDaysCount;
  final String shieldMessage;
  final String statusTier;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class DataConfidenceShieldEngine {
  const DataConfidenceShieldEngine();

  /// Minimum rolling 7-day reliability percentage required to unlock target adaptations (70%).
  static const double minimumReliabilityThresholdPct = 70.0;

  /// Evaluates rolling 7-day logging quality against the §P5-O Reliability Equation:
  /// Reliability % = (Logged Days [>=3 meals] * 40 + Protein Tracking * 30 + Water Logs * 30) / 100
  DataConfidenceShieldResult evaluateLoggingQuality({
    required List<DailyLogQualityRecord> past7DayLogs,
    double weightPlateauWeeks = 0.0,
  }) {
    if (past7DayLogs.isEmpty) {
      return const DataConfidenceShieldResult(
        reliabilityScorePct: 0.0,
        isLockoutActive: true,
        validLogDaysCount: 0,
        proteinTrackingDaysCount: 0,
        waterTrackingDaysCount: 0,
        shieldMessage:
            '⚠️ Low logging confidence. Maintain 3 meals/day logging for 5 days to unlock metabolic target adjustments.',
        statusTier: 'Low Confidence - Target Lock Active',
      );
    }

    // Limit to 7 days window
    final logs7 = past7DayLogs.take(7).toList();

    int validLogDays = 0;
    int proteinTrackingDays = 0;
    int waterTrackingDays = 0;

    for (final log in logs7) {
      if (log.mealsLoggedCount >= 3) validLogDays++;
      if (log.wasProteinTargetMet) proteinTrackingDays++;
      if (log.wasWaterTargetMet) waterTrackingDays++;
    }

    final loggingRatio = validLogDays / 7.0;
    final proteinRatio = proteinTrackingDays / 7.0;
    final hydrationRatio = waterTrackingDays / 7.0;

    final rawScore =
        (loggingRatio * 40.0) + (proteinRatio * 30.0) + (hydrationRatio * 30.0);
    final reliabilityScorePct = double.parse(
      (rawScore * 100.0 / 100.0).clamp(0.0, 100.0).toStringAsFixed(1),
    );

    final isLockoutActive =
        reliabilityScorePct < minimumReliabilityThresholdPct;

    String message = '';
    String tier = 'High Confidence - Targets Unlocked';

    if (isLockoutActive) {
      tier = 'Low Confidence - Target Lock Active';
      if (weightPlateauWeeks > 0) {
        message =
            '⚠️ Your weight loss has plateaued, but your log reliability is only ${reliabilityScorePct.round()}%. We cannot safely lower your calories without stable logging. Focus on logging all 3 meals daily for 5 consecutive days to re-enable target adaptations.';
      } else {
        message =
            '⚠️ Metabolic target lock active. Current logging reliability (${reliabilityScorePct.round()}%) is too low to compute safe target updates. Maintain consistent 3-meal logging for 5 days.';
      }
    } else {
      message =
          '🟢 Data confidence high (${reliabilityScorePct.round()}%). Metabolic adaptation engine targets unlocked.';
    }

    return DataConfidenceShieldResult(
      reliabilityScorePct: reliabilityScorePct,
      isLockoutActive: isLockoutActive,
      validLogDaysCount: validLogDays,
      proteinTrackingDaysCount: proteinTrackingDays,
      waterTrackingDaysCount: waterTrackingDays,
      shieldMessage: message,
      statusTier: tier,
    );
  }
}
