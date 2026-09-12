import '../models/readiness_input.dart';
import '../models/readiness_result.dart';
import 'recovery_os_engine.dart';
import 'sleep_intelligence_engine.dart';

/// ReadinessCalculationEngine (Pure Dart / Deterministic / Three-Tier Model)
/// Computes daily readiness score (0-100) based on data availability tier.
class ReadinessCalculationEngine {
  final SleepIntelligenceEngine sleepEngine;
  final RecoveryOSEngine recoveryEngine;

  const ReadinessCalculationEngine({
    this.sleepEngine = const SleepIntelligenceEngine(),
    this.recoveryEngine = const RecoveryOSEngine(),
  });

  ReadinessResult computeReadiness({
    required ReadinessInput input,
    required int chronologicalAge,
  }) {
    final tier = input.detectedTier;

    // 1. Evaluate Sleep Metrics
    final sleepAssessment = sleepEngine.assessSleep(
      sleepDurationHours: input.sleepDurationHours,
      sleepTargetHours: input.sleepTargetHours,
      deepSleepMinutes: input.deepSleepMinutes,
      remSleepMinutes: input.remSleepMinutes,
    );

    // 2. Evaluate Muscle Soreness Index (0 - 100, where 100 is fresh with 0 soreness)
    double sorenessPenalty = 0.0;
    for (final s in input.sorenessList) {
      sorenessPenalty += (s.severity * 5.0);
    }
    final sorenessScore = (100.0 - sorenessPenalty).clamp(10.0, 100.0);

    // 3. Subjective Mood/Energy Score (0 - 100)
    final energyScore = (input.perceivedEnergy / 5.0) * 100.0;
    final stressScore = ((6 - input.perceivedStress) / 5.0) * 100.0;
    final subjectiveComposite = (energyScore * 0.6) + (stressScore * 0.4);

    double rawScore = 75.0;

    switch (tier) {
      case ConfidenceTier.high:
        // Tier 1: Biometrics + Wearables
        final hrvBase = input.hrvBaselineMs ?? 55.0;
        final hrvScore = ((input.hrvRmssdMs! / hrvBase) * 85.0).clamp(20.0, 100.0);

        final rhrBase = input.restingHeartRateBaselineBpm ?? 55;
        final rhrDiff = input.restingHeartRateBpm! - rhrBase;
        final rhrScore = (100.0 - (rhrDiff * 4.0)).clamp(20.0, 100.0);

        rawScore = (hrvScore * 0.30) +
            (rhrScore * 0.20) +
            (sleepAssessment.sleepEfficiencyScore * 0.25) +
            (sorenessScore * 0.15) +
            (subjectiveComposite * 0.10);
        break;

      case ConfidenceTier.moderate:
        // Tier 2: Sleep Duration + Check-in
        rawScore = (sleepAssessment.sleepEfficiencyScore * 0.45) +
            (sorenessScore * 0.30) +
            (subjectiveComposite * 0.25);
        break;

      case ConfidenceTier.low:
        // Tier 3: Manual Morning Ritual Check-in
        rawScore = (energyScore * 0.40) +
            (stressScore * 0.30) +
            (sorenessScore * 0.30);
        break;
    }

    final finalScore = rawScore.round().clamp(0, 100);

    // 4. Generate Recovery Prescriptions
    final prescriptions = recoveryEngine.generatePrescriptions(
      readinessScore: finalScore,
      sorenessList: input.sorenessList,
      sleepDebtHours: sleepAssessment.sleepDebtHours,
    );

    return ReadinessResult.fromScore(
      score: finalScore,
      tier: tier,
      chronologicalAge: chronologicalAge,
      sleepDebt: sleepAssessment.sleepDebtHours,
      sleepEfficiency: sleepAssessment.sleepEfficiencyScore,
      prescriptions: prescriptions.protocols,
      prescriptionsHindi: prescriptions.protocolsHindi,
    );
  }
}
