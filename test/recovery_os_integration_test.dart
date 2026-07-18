import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/recovery_os.dart';

void main() {
  group('Sleep Intelligence Layer Tests', () {
    test('SleepNeedCalculator incorporates debt, strain, stress, sickness, and caps at 600m', () {
      final calculator = SleepNeedCalculator();

      // Baseline only
      expect(calculator.calculateSleepNeed(), 480);

      // Deficit and strain added
      final needWithExtras = calculator.calculateSleepNeed(
        baselineNeedMins: 480,
        sleepDebtMins: 30.0,
        yesterdayStrain: 14.0, // (14/21) * 60 = 40 mins
        stressLevel: 3,        // (3-1) * 7.5 = 15 mins
        isSick: false,
      );
      // 480 + 30 + 40 + 15 = 565 mins
      expect(needWithExtras, 565);

      // Sickness + High debt + strain exceeding cap
      final needExceedingCap = calculator.calculateSleepNeed(
        baselineNeedMins: 480,
        sleepDebtMins: 100.0,   // Capped at 90 mins
        yesterdayStrain: 21.0,  // Adds 60 mins
        stressLevel: 5,         // Adds 30 mins
        isSick: true,           // Adds 60 mins
      );
      // 480 + 90 + 60 + 30 + 60 = 720 mins. Hard capped at 600 mins.
      expect(needExceedingCap, 600);
    });

    test('SleepPerformanceScore aggregates duration, efficiency, consistency, and opportunity', () {
      final scorer = SleepPerformanceScore();

      final score = scorer.calculateScore(
        actualSleepMins: 400,
        sleepNeedMins: 500,        // Duration: (400/500)*40 = 32
        efficiency: 0.90,          // Efficiency: 0.90*30 = 27
        consistencyScore: 0.85,    // Consistency: 0.85*20 = 17
        opportunityMins: 450,      // Opportunity: (450/510)*10 = 8.8
      );
      // 32 + 27 + 17 + 8.8 = 84.8 -> 85
      expect(score, 85);
    });

    test('BedtimeCoach calculates correct bedtime and generates a personalized nudge', () {
      final coach = BedtimeCoach();

      // Sleep need: 500 mins (8h 20m), target wake: 6:30 AM
      final targetWake = DateTime(2026, 7, 18, 6, 30);
      final bedtime = coach.calculateBedtime(sleepNeedMins: 500, targetWakeTime: targetWake);

      // Bedtime should be 500 + 15 = 515 mins before 6:30 AM
      // 515 mins = 8 hours and 35 minutes
      // 6:30 AM minus 8h 35m = 9:55 PM (previous night)
      expect(bedtime.hour, 21);
      expect(bedtime.minute, 55);

      final nudge = coach.generateNudge(sleepNeedMins: 500, bedtime: bedtime);
      expect(nudge, contains('8h 20m'));
      expect(nudge, contains('9:55 PM'));
    });
  });

  group('Recovery Capacity & Strain System Tests', () {
    test('DailyStrainCalculator computes exponential strain score from zones and steps', () {
      final calculator = DailyStrainCalculator();

      // Heavy cardio workout + steps
      final strain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          1: 10, // 10 * 0.05 = 0.5
          2: 20, // 20 * 0.15 = 3.0
          3: 30, // 30 * 0.35 = 10.5
          4: 15, // 15 * 0.70 = 10.5
          5: 5,  // 5 * 1.50 = 7.5
        }, // Total cardiac impulse = 32.0
        dailySteps: 12000, // Steps impulse = 1.2 * 2.25 = 2.7
        heatIndexCelsius: 30.0, // No heat factor adjustment (<32)
      );
      // Total Impulse = 32.0 + 2.7 = 34.7
      // Strain = 21 * (1 - e^(-0.015 * 34.7)) = 21 * (1 - 0.594) = 8.5
      expect(strain, 8.5);

      // Extreme workout under high environmental heat index
      final heatStrain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          4: 45, // 45 * 0.7 = 31.5
          5: 10, // 10 * 1.5 = 15.0
        }, // Cardiac = 46.5
        dailySteps: 15000, // Steps = 1.5 * 2.25 = 3.375
        heatIndexCelsius: 38.0, // Heat factor: 1.0 + (38 - 32)*0.02 = 1.12
      );
      // Total Impulse = (46.5 + 3.375) * 1.12 = 55.86
      // Strain = 21 * (1 - e^(-0.015 * 55.86)) = 21 * (1 - 0.432) = 11.9
      expect(heatStrain, 11.9);
    });

    test('DailyStrainCalculator estimates zones correctly on missing telemetry data', () {
      final calculator = DailyStrainCalculator();

      final estimatedZones = calculator.estimateZonesFromTelemetry(
        dailySteps: 5000,
        activeMinutes: 0,
        dailyActivities: [
          ActivityLog(activityType: 'running', durationMinutes: 30, intensity: 'high'),
          ActivityLog(activityType: 'strength', durationMinutes: 40, intensity: 'medium'),
        ],
      );

      // Running (high): Zone 3=12, Zone 4=12, Zone 5=6
      // Strength: Zone 1=20, Zone 2=12, Zone 3=8
      // Total: Z1=20, Z2=12, Z3=20, Z4=12, Z5=6
      expect(estimatedZones[1], 20);
      expect(estimatedZones[2], 12);
      expect(estimatedZones[3], 20);
      expect(estimatedZones[4], 12);
      expect(estimatedZones[5], 6);
    });

    test('RecoveryDecisionEngine maps readiness score and sleep debt to capacity bounds and advice', () {
      final engine = RecoveryDecisionEngine();

      // High capacity scenario
      final decisionHigh = engine.evaluate(readinessScore: 90, dailyStrain: 5.0, sleepDebtHours: 0.0);
      expect(decisionHigh.capacityScore, 90);
      expect(decisionHigh.strainCap, 16.2);
      expect(decisionHigh.trainingAdvice, contains("High Capacity"));

      // Low capacity scenario (compromised readiness and sleep debt)
      final decisionLow = engine.evaluate(readinessScore: 50, dailyStrain: 12.0, sleepDebtHours: 2.0);
      // capacityFactor = 0.5 - 2*0.1 = 0.3 -> capacityScore = 30
      expect(decisionLow.capacityScore, 30);
      // strainCap = 0.3 * 18 = 5.4
      expect(decisionLow.strainCap, 5.4);
      expect(decisionLow.trainingAdvice, contains("Low Capacity"));
    });
  });

  group('Recovery Actionable Behaviors and Sync Tests', () {
    test('RecoveryPrescriptionGenerator yields custom checklist actions based on capacity bounds', () {
      final generator = RecoveryPrescriptionGenerator();

      final lowCapList = generator.generate(capacityScore: 45);
      expect(lowCapList.length, 5);
      expect(lowCapList[0], contains("Active Recovery"));
      expect(lowCapList[4], contains("Restriction"));

      final highCapList = generator.generate(capacityScore: 85);
      expect(highCapList.length, 3);
      expect(highCapList[0], contains("Training"));
    });
  });

  group('Circadian, Environmental, and Drivers Tests', () {
    test('CircadianScoreCalculator tracks midpoint shift penalty and light exposure sync', () {
      final calculator = CircadianScoreCalculator();

      // Perfect alignment
      expect(calculator.calculateCircadianScore(midpointShiftMins: 10, morningLightExposure: false), 100);

      // Midpoint shifted by 90 minutes (90 - 60 = 30 mins deviation => -3 pts) + light bonus (+10 pts)
      expect(
        calculator.calculateCircadianScore(midpointShiftMins: 90, morningLightExposure: true),
        107.clamp(0, 100), // Capped at 100
      );

      // Midpoint shifted by 200 minutes (200 - 60 = 140 mins deviation => -14 pts)
      expect(calculator.calculateCircadianScore(midpointShiftMins: 200, morningLightExposure: false), 86);
    });

    test('IllnessDetector flags sickness deviation trigger', () {
      final detector = IllnessDetector();

      // Healthy baseline
      final healthyResult = detector.detect(
        restingHR: 65,
        baselineHR: 65,
        hrv: 55,
        baselineHRV: 55,
        sleepDurationMins: 480,
        baselineSleepMins: 480,
      );
      expect(healthyResult.illnessRiskStatus, 'low');
      expect(healthyResult.sicknessNudge, isNull);

      // Sick biometric deviations:
      // resting HR: 73 vs 65 (+12% elevated)
      // HRV: 40 vs 55 (-27% depressed)
      // Sleep: 600 vs 480 (+25% elevated)
      final sickResult = detector.detect(
        restingHR: 73,
        baselineHR: 65,
        hrv: 40,
        baselineHRV: 55,
        sleepDurationMins: 600,
        baselineSleepMins: 480,
      );
      expect(sickResult.illnessRiskStatus, 'high');
      expect(sickResult.sicknessNudge, contains("Warning: Elevated biometric signals"));
    });

    test('RecoveryDriversEngine breaks down contributors and detractors correctly', () {
      final engine = RecoveryDriversEngine();

      final drivers = engine.calculateDrivers(
        sleepQuality: 4,
        proteinG: 130,
        targetProteinG: 120,
        hydrationMl: 3000,
        targetHydrationMl: 3000,
        stressLevel: 4,
        aqi: 180,
        heatIndexCelsius: 37.0,
      );

      final List contributors = drivers['contributors'];
      final List detractors = drivers['detractors'];

      expect(contributors.any((c) => c['driver'] == 'Sleep Quality'), true);
      expect(contributors.any((c) => c['driver'] == 'Protein Intake'), true);
      expect(contributors.any((c) => c['driver'] == 'Hydration Target'), true);

      expect(detractors.any((d) => d['driver'] == 'Daily Stress'), true);
      expect(detractors.any((d) => d['driver'] == 'Poor Ambient AQI'), true);
      expect(detractors.any((d) => d['driver'] == 'Extreme Heat'), true);
    });
  });

  group('Recovery OS Integration Pipeline Test', () {
    test('Simulated user pipeline workflow calculates complete recovery profile', () {
      // 1. Initialize all engine elements
      final sleepNeedCalc = SleepNeedCalculator();
      final coach = BedtimeCoach();
      final strainCalc = DailyStrainCalculator();
      final decisionEngine = RecoveryDecisionEngine();
      final prescriptionGen = RecoveryPrescriptionGenerator();
      final illnessDetector = IllnessDetector();

      // 2. Compute Sleep Need and bedtime target
      final sleepNeedMins = sleepNeedCalc.calculateSleepNeed(
        baselineNeedMins: 480,
        sleepDebtMins: 45.0,
        yesterdayStrain: 12.0, // adds 34.2 mins
        stressLevel: 3,        // adds 15.0 mins
        isSick: false,
      );
      expect(sleepNeedMins, 574); // 480 + 45 + 34 + 15 = 574

      final wakeTime = DateTime(2026, 7, 18, 6, 0); // 6:00 AM
      final bedtime = coach.calculateBedtime(sleepNeedMins: sleepNeedMins, targetWakeTime: wakeTime);
      final nudge = coach.generateNudge(sleepNeedMins: sleepNeedMins, bedtime: bedtime);
      expect(nudge, contains('9h 34m'));

      // 3. User logs today's telemetry (workout + steps)
      final todayStrain = strainCalc.calculateStrain(
        zoneDurationsMinutes: {3: 40, 4: 10}, // cardiac = 40*0.35 + 10*0.7 = 21.0
        dailySteps: 8000,                     // steps = 0.8 * 2.25 = 1.8
        heatIndexCelsius: 34.0,               // heat factor = 1.0 + 2*0.02 = 1.04
      );
      // total impulse = (21 + 1.8) * 1.04 = 23.71
      // strain = 21 * (1 - e^(-0.015 * 23.71)) = 6.3
      expect(todayStrain, 6.3);

      // 4. Calculate Readiness and Recovery Capacity
      final decision = decisionEngine.evaluate(
        readinessScore: 78,
        dailyStrain: todayStrain,
        sleepDebtHours: 0.75, // 45 mins
      );
      expect(decision.capacityScore, 71); // 78 - 7.5 = 70.5 -> 71
      expect(decision.strainCap, 12.7);

      // 5. Generate active checklist prescriptions
      final prescription = prescriptionGen.generate(capacityScore: decision.capacityScore);
      expect(prescription.any((p) => p.contains("mobility")), true); // standard capacity checklist

      // 6. Check for illness signals
      final illness = illnessDetector.detect(
        restingHR: 66,
        baselineHR: 65,
        hrv: 52,
        baselineHRV: 55,
        sleepDurationMins: 480,
        baselineSleepMins: 480,
      );
      expect(illness.illnessRiskStatus, 'low');
    });
  });
}
