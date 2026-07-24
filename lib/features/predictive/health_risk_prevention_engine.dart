/// §P10-A Health Risk Prevention System — Engine & Models
///
/// Implements deterministic rule-based risk evaluation for all 6 tracked health risk patterns
/// matching §P10-A specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P10-A Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum HealthRiskCategory {
  hypertension('Hypertension Risk', '🫀'),
  type2Diabetes('Type 2 Diabetes Risk', '🩸'),
  heartDisease('Heart Disease Risk', '❤️'),
  metabolicSyndrome('Metabolic Syndrome Risk', '⚖️'),
  burnoutOvertraining('Burnout / Overtraining Risk', '🔋'),
  vitaminDDeficiency('Vitamin D Deficiency Risk', '☀️');

  const HealthRiskCategory(this.displayName, this.iconSymbol);

  final String displayName;
  final String iconSymbol;
}

enum RiskSeverity {
  low('Low Watch', 1),
  moderate('Moderate Watch', 2),
  high('High Warning', 3),
  critical('Critical Alert', 4);

  const RiskSeverity(this.displayName, this.priorityLevel);

  final String displayName;
  final int priorityLevel;
}

class UserHealthTelemetry {
  const UserHealthTelemetry({
    required this.systolicBpMmHg,
    required this.diastolicBpMmHg,
    required this.isBpRising,
    required this.stepsDecliningDays,
    required this.fastingGlucoseMgDl,
    required this.isGlucoseRising,
    required this.bmi,
    required this.restingHrBpm,
    required this.isRestingHrElevated,
    required this.stressScore,
    required this.sleepHoursAvg,
    required this.waistCircumferenceCm,
    required this.isMale,
    required this.hrvMs,
    required this.isHrvDeclining,
    required this.isPerformanceDropping,
    required this.dailyStepsAvg,
    required this.highFatigueDays,
  });

  final double systolicBpMmHg;
  final double diastolicBpMmHg;
  final bool isBpRising;
  final int stepsDecliningDays;
  final double fastingGlucoseMgDl;
  final bool isGlucoseRising;
  final double bmi;
  final double restingHrBpm;
  final bool isRestingHrElevated;
  final double stressScore;
  final double sleepHoursAvg;
  final double waistCircumferenceCm;
  final bool isMale;
  final double hrvMs;
  final bool isHrvDeclining;
  final bool isPerformanceDropping;
  final int dailyStepsAvg;
  final int highFatigueDays;
}

class HealthRiskFlag {
  const HealthRiskFlag({
    required this.riskCategory,
    required this.severity,
    required this.triggerDescription,
    required this.inputSignals,
    required this.recommendedAction,
    required this.timestamp,
  });

  final HealthRiskCategory riskCategory;
  final RiskSeverity severity;
  final String triggerDescription;
  final List<String> inputSignals;
  final String recommendedAction;
  final DateTime timestamp;
}

// ─────────────────────────────────────────────────────────────────────────────
// PreventiveIntelligenceEngine (§P10-A Specification)
// ─────────────────────────────────────────────────────────────────────────────

class PreventiveIntelligenceEngine {
  const PreventiveIntelligenceEngine();

  /// Evaluates all 6 health risk patterns and returns active risk flags.
  List<HealthRiskFlag> evaluateAllRisks(UserHealthTelemetry telemetry) {
    final flags = <HealthRiskFlag>[];
    final now = DateTime.now();

    // 1. Hypertension: BP rising + steps declining 7+ days
    final htFlag = evaluateHypertension(telemetry, now);
    if (htFlag != null) flags.add(htFlag);

    // 2. Type 2 Diabetes: Glucose up + BMI >= 27
    final dbFlag = evaluateType2Diabetes(telemetry, now);
    if (dbFlag != null) flags.add(dbFlag);

    // 3. Heart Disease: Resting HR elevated + BP elevated (Systolic >= 130) + poor sleep (< 6.0h)
    final hdFlag = evaluateHeartDisease(telemetry, now);
    if (hdFlag != null) flags.add(hdFlag);

    // 4. Metabolic Syndrome: 3+ risk factors present (Waist >= 90/80cm, BP >= 130/85, Fasting Glucose >= 100 mg/dL, BMI >= 25)
    final msFlag = evaluateMetabolicSyndrome(telemetry, now);
    if (msFlag != null) flags.add(msFlag);

    // 5. Burnout / Overtraining: HRV declining + HR elevated + performance dropping
    final boFlag = evaluateBurnoutOvertraining(telemetry, now);
    if (boFlag != null) flags.add(boFlag);

    // 6. Vitamin D Deficiency: Low steps (< 4000/day) + high fatigue 5+ days
    final vdFlag = evaluateVitaminDDeficiency(telemetry, now);
    if (vdFlag != null) flags.add(vdFlag);

    return flags;
  }

  /// Rule 1: Hypertension Risk
  HealthRiskFlag? evaluateHypertension(UserHealthTelemetry t, DateTime now) {
    if (t.isBpRising && t.stepsDecliningDays >= 7) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.hypertension,
        severity: RiskSeverity.high,
        triggerDescription: 'BP rising trend detected with steps declining 7+ days',
        inputSignals: [
          'Systolic BP: ${t.systolicBpMmHg.round()} mmHg (Rising trend)',
          'Daily Steps: Declining for ${t.stepsDecliningDays} days',
          'Stress Score: ${t.stressScore.round()}',
        ],
        recommendedAction: 'Schedule a GP BP check and resume 30-min daily light walking.',
        timestamp: now,
      );
    }
    return null;
  }

  /// Rule 2: Type 2 Diabetes Risk
  HealthRiskFlag? evaluateType2Diabetes(UserHealthTelemetry t, DateTime now) {
    if (t.isGlucoseRising && t.bmi >= 27.0) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.type2Diabetes,
        severity: RiskSeverity.high,
        triggerDescription: 'Glucose rising trend with BMI >= 27.0',
        inputSignals: [
          'Fasting Glucose: ${t.fastingGlucoseMgDl.round()} mg/dL (Rising trend)',
          'BMI: ${t.bmi.toStringAsFixed(1)} kg/m²',
          'Daily Steps: ${t.dailyStepsAvg}',
        ],
        recommendedAction: 'Prioritize low-GI Indian meals & HbA1c screening.',
        timestamp: now,
      );
    }
    return null;
  }

  /// Rule 3: Heart Disease Risk
  HealthRiskFlag? evaluateHeartDisease(UserHealthTelemetry t, DateTime now) {
    if (t.isRestingHrElevated && t.systolicBpMmHg >= 130.0 && t.sleepHoursAvg < 6.0) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.heartDisease,
        severity: RiskSeverity.critical,
        triggerDescription: 'Resting HR & Systolic BP elevated with poor sleep (< 6.0h)',
        inputSignals: [
          'Resting HR: ${t.restingHrBpm.round()} bpm (Elevated)',
          'Systolic BP: ${t.systolicBpMmHg.round()} mmHg',
          'Sleep Average: ${t.sleepHoursAvg.toStringAsFixed(1)}h',
        ],
        recommendedAction: 'Consult cardiologist and enforce 7.5h sleep recovery protocol.',
        timestamp: now,
      );
    }
    return null;
  }

  /// Rule 4: Metabolic Syndrome Risk
  HealthRiskFlag? evaluateMetabolicSyndrome(UserHealthTelemetry t, DateTime now) {
    int riskFactorsCount = 0;

    final waistThreshold = t.isMale ? 90.0 : 80.0;
    if (t.waistCircumferenceCm >= waistThreshold) riskFactorsCount++;
    if (t.systolicBpMmHg >= 130.0 || t.diastolicBpMmHg >= 85.0) riskFactorsCount++;
    if (t.fastingGlucoseMgDl >= 100.0) riskFactorsCount++;
    if (t.bmi >= 25.0) riskFactorsCount++;

    if (riskFactorsCount >= 3) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.metabolicSyndrome,
        severity: RiskSeverity.high,
        triggerDescription: '$riskFactorsCount/4 metabolic risk factors present',
        inputSignals: [
          'Waist: ${t.waistCircumferenceCm.round()} cm (Threshold: ${waistThreshold.round()} cm)',
          'BP: ${t.systolicBpMmHg.round()}/${t.diastolicBpMmHg.round()} mmHg',
          'Glucose: ${t.fastingGlucoseMgDl.round()} mg/dL',
          'BMI: ${t.bmi.toStringAsFixed(1)} kg/m²',
        ],
        recommendedAction: 'Initiate metabolic reset: 10k daily steps + zero added sugar.',
        timestamp: now,
      );
    }
    return null;
  }

  /// Rule 5: Burnout / Overtraining Risk
  HealthRiskFlag? evaluateBurnoutOvertraining(UserHealthTelemetry t, DateTime now) {
    if (t.isHrvDeclining && t.isRestingHrElevated && t.isPerformanceDropping) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.burnoutOvertraining,
        severity: RiskSeverity.high,
        triggerDescription: 'HRV declining, HR elevated, and performance dropping',
        inputSignals: [
          'HRV: ${t.hrvMs.round()} ms (Declining trend)',
          'Resting HR: ${t.restingHrBpm.round()} bpm (Elevated)',
          'Performance: Dropping',
        ],
        recommendedAction: 'Mandatory 48-hour active recovery deload: light yoga & walking only.',
        timestamp: now,
      );
    }
    return null;
  }

  /// Rule 6: Vitamin D Deficiency Risk
  HealthRiskFlag? evaluateVitaminDDeficiency(UserHealthTelemetry t, DateTime now) {
    if (t.dailyStepsAvg < 4000 && t.highFatigueDays >= 5) {
      return HealthRiskFlag(
        riskCategory: HealthRiskCategory.vitaminDDeficiency,
        severity: RiskSeverity.moderate,
        triggerDescription: 'Outdoor activity proxy low (< 4000 steps/day) with fatigue 5+ days',
        inputSignals: [
          'Daily Steps Avg: ${t.dailyStepsAvg} (Low outdoor exposure proxy)',
          'Fatigue Days: ${t.highFatigueDays} consecutive days',
        ],
        recommendedAction: 'Schedule 25-OH Vitamin D serum test & get 20 mins morning sunlight.',
        timestamp: now,
      );
    }
    return null;
  }
}
