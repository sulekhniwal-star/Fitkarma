import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = PreventiveIntelligenceEngine();

  const healthyTelemetry = UserHealthTelemetry(
    systolicBpMmHg: 118,
    diastolicBpMmHg: 78,
    isBpRising: false,
    stepsDecliningDays: 0,
    fastingGlucoseMgDl: 88,
    isGlucoseRising: false,
    bmi: 22.5,
    restingHrBpm: 62,
    isRestingHrElevated: false,
    stressScore: 25,
    sleepHoursAvg: 7.8,
    waistCircumferenceCm: 78,
    isMale: true,
    hrvMs: 65,
    isHrvDeclining: false,
    isPerformanceDropping: false,
    dailyStepsAvg: 9500,
    highFatigueDays: 0,
  );

  group('§P10-A PreventiveIntelligenceEngine Unit Tests', () {
    test('Clean bill of health produces zero risk flags', () {
      final flags = engine.evaluateAllRisks(healthyTelemetry);
      expect(flags, isEmpty);
    });

    test('Rule 1: Triggers Hypertension Risk flag when BP rising & steps declining >= 7 days', () {
      const htTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 135,
        diastolicBpMmHg: 88,
        isBpRising: true,
        stepsDecliningDays: 8,
        fastingGlucoseMgDl: 90,
        isGlucoseRising: false,
        bmi: 24.0,
        restingHrBpm: 68,
        isRestingHrElevated: false,
        stressScore: 65,
        sleepHoursAvg: 7.0,
        waistCircumferenceCm: 82,
        isMale: true,
        hrvMs: 50,
        isHrvDeclining: false,
        isPerformanceDropping: false,
        dailyStepsAvg: 4500,
        highFatigueDays: 1,
      );

      final flag = engine.evaluateHypertension(htTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.hypertension);
      expect(flag.severity, RiskSeverity.high);
      expect(flag.triggerDescription, contains('BP rising trend detected'));
    });

    test('Rule 2: Triggers Type 2 Diabetes Risk flag when Glucose rising & BMI >= 27.0', () {
      const dbTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 120,
        diastolicBpMmHg: 80,
        isBpRising: false,
        stepsDecliningDays: 2,
        fastingGlucoseMgDl: 115,
        isGlucoseRising: true,
        bmi: 28.5,
        restingHrBpm: 72,
        isRestingHrElevated: false,
        stressScore: 40,
        sleepHoursAvg: 7.0,
        waistCircumferenceCm: 85,
        isMale: true,
        hrvMs: 45,
        isHrvDeclining: false,
        isPerformanceDropping: false,
        dailyStepsAvg: 6000,
        highFatigueDays: 1,
      );

      final flag = engine.evaluateType2Diabetes(dbTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.type2Diabetes);
      expect(flag.severity, RiskSeverity.high);
    });

    test('Rule 3: Triggers Heart Disease Risk flag when Resting HR elevated, BP >= 130, sleep < 6.0h', () {
      const hdTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 138,
        diastolicBpMmHg: 90,
        isBpRising: false,
        stepsDecliningDays: 3,
        fastingGlucoseMgDl: 95,
        isGlucoseRising: false,
        bmi: 25.0,
        restingHrBpm: 84,
        isRestingHrElevated: true,
        stressScore: 75,
        sleepHoursAvg: 5.2,
        waistCircumferenceCm: 84,
        isMale: true,
        hrvMs: 35,
        isHrvDeclining: false,
        isPerformanceDropping: false,
        dailyStepsAvg: 5000,
        highFatigueDays: 2,
      );

      final flag = engine.evaluateHeartDisease(hdTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.heartDisease);
      expect(flag.severity, RiskSeverity.critical);
    });

    test('Rule 4: Triggers Metabolic Syndrome Risk flag when 3+ risk factors present', () {
      const msTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 135,
        diastolicBpMmHg: 88,
        isBpRising: false,
        stepsDecliningDays: 1,
        fastingGlucoseMgDl: 108,
        isGlucoseRising: false,
        bmi: 27.2,
        restingHrBpm: 75,
        isRestingHrElevated: false,
        stressScore: 50,
        sleepHoursAvg: 6.8,
        waistCircumferenceCm: 94, // Risk factor 1 (Male >= 90)
        isMale: true,
        hrvMs: 40,
        isHrvDeclining: false,
        isPerformanceDropping: false,
        dailyStepsAvg: 5500,
        highFatigueDays: 2,
      );

      final flag = engine.evaluateMetabolicSyndrome(msTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.metabolicSyndrome);
      expect(flag.triggerDescription, contains('risk factors present'));
    });

    test('Rule 5: Triggers Burnout / Overtraining Risk flag when HRV declining, HR elevated, performance dropping', () {
      const boTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 122,
        diastolicBpMmHg: 82,
        isBpRising: false,
        stepsDecliningDays: 0,
        fastingGlucoseMgDl: 90,
        isGlucoseRising: false,
        bmi: 23.0,
        restingHrBpm: 82,
        isRestingHrElevated: true,
        stressScore: 80,
        sleepHoursAvg: 5.5,
        waistCircumferenceCm: 80,
        isMale: true,
        hrvMs: 25,
        isHrvDeclining: true,
        isPerformanceDropping: true,
        dailyStepsAvg: 8000,
        highFatigueDays: 4,
      );

      final flag = engine.evaluateBurnoutOvertraining(boTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.burnoutOvertraining);
      expect(flag.severity, RiskSeverity.high);
    });

    test('Rule 6: Triggers Vitamin D Deficiency Risk flag when steps < 4000 & fatigue >= 5 days', () {
      const vdTelemetry = UserHealthTelemetry(
        systolicBpMmHg: 118,
        diastolicBpMmHg: 78,
        isBpRising: false,
        stepsDecliningDays: 5,
        fastingGlucoseMgDl: 88,
        isGlucoseRising: false,
        bmi: 22.0,
        restingHrBpm: 65,
        isRestingHrElevated: false,
        stressScore: 40,
        sleepHoursAvg: 7.0,
        waistCircumferenceCm: 78,
        isMale: true,
        hrvMs: 55,
        isHrvDeclining: false,
        isPerformanceDropping: false,
        dailyStepsAvg: 2800, // < 4000
        highFatigueDays: 6, // >= 5
      );

      final flag = engine.evaluateVitaminDDeficiency(vdTelemetry, DateTime.now());
      expect(flag, isNotNull);
      expect(flag!.riskCategory, HealthRiskCategory.vitaminDDeficiency);
      expect(flag.severity, RiskSeverity.moderate);
    });
  });
}
