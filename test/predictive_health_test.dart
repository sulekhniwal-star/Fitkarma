import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/predictive_health/domain/models/predictive_health_models.dart';
import 'package:fitkarma/features/predictive_health/domain/services/biological_age_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/services/cardiometabolic_risk_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/services/injury_risk_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/services/stress_detection_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/services/clinical_lab_intelligence_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/services/medication_safety_engine.dart';
import 'package:fitkarma/features/predictive_health/data/predictive_health_repository.dart';

void main() {
  group('BiologicalAgeEngine Tests', () {
    const engine = BiologicalAgeEngine();

    test('Athletic biometrics reduce biological age below chronological age', () {
      final estimate = engine.calculateBiologicalAge(
        id: 'bio-1',
        userId: 'u1',
        chronologicalAge: 35,
        restingHeartRateBpm: 54.0, // -2.5 yrs
        hrvRmsddMs: 72.0, // -2.0 yrs
        bmi: 21.8, // -1.5 yrs
        systolicBp: 115.0, // -1.2 yrs
        averageDailySteps: 11500, // -2.0 yrs
        averageSleepHours: 8.0, // -1.2 yrs
        calculatedAt: DateTime.now(),
      );

      expect(estimate.biologicalAge, lessThan(35.0));
      expect(estimate.ageDelta, lessThan(0.0));
      expect(estimate.contributors.length, equals(6));
      expect(estimate.contributors.every((c) => c.isProtective), isTrue);
    });

    test('Elevated risk biometrics increase biological age', () {
      final estimate = engine.calculateBiologicalAge(
        id: 'bio-2',
        userId: 'u2',
        chronologicalAge: 40,
        restingHeartRateBpm: 84.0, // +2.8 yrs
        hrvRmsddMs: 25.0, // +2.5 yrs
        bmi: 27.5, // +2.8 yrs
        systolicBp: 145.0, // +3.2 yrs
        averageDailySteps: 3500, // +2.2 yrs
        averageSleepHours: 5.5, // +2.2 yrs
        calculatedAt: DateTime.now(),
      );

      expect(estimate.biologicalAge, greaterThan(40.0));
      expect(estimate.ageDelta, greaterThan(10.0));
    });
  });

  group('CardiometabolicRiskEngine Tests', () {
    const engine = CardiometabolicRiskEngine();

    test('Flags Asian-Indian Metabolic Syndrome when 3+ criteria met', () {
      final profile = engine.evaluateRisk(
        gender: 'male',
        age: 42,
        waistCircumferenceCm: 94.0, // Men >= 90cm (Criterion 1)
        systolicBp: 138.0, // >= 130 mmHg (Criterion 2)
        diastolicBp: 88.0,
        fastingGlucoseMgDl: 110.0, // >= 100 mg/dL (Criterion 3)
        triglyceridesMgDl: 180.0, // >= 150 mg/dL (Criterion 4)
        hdlCholesterolMgDl: 38.0, // < 40 mg/dL (Criterion 5)
      );

      expect(profile.metabolicSyndromeFlag, isTrue);
      expect(profile.metSynCriteriaMetCount, equals(5));
      expect(profile.cardioRisk, isNot(CardioRiskLevel.low));
    });

    test('Evaluates normal profile with 0 criteria met', () {
      final profile = engine.evaluateRisk(
        gender: 'female',
        age: 28,
        waistCircumferenceCm: 74.0, // Women < 80cm
        systolicBp: 112.0,
        diastolicBp: 74.0,
        fastingGlucoseMgDl: 88.0,
        triglyceridesMgDl: 95.0,
        hdlCholesterolMgDl: 62.0,
      );

      expect(profile.metabolicSyndromeFlag, isFalse);
      expect(profile.metSynCriteriaMetCount, equals(0));
      expect(profile.cardioRisk, equals(CardioRiskLevel.low));
    });
  });

  group('InjuryRiskEngine Tests', () {
    const engine = InjuryRiskEngine();

    test('ACWR in 0.8–1.3 range resolves to sweetSpot status', () {
      final assessment = engine.evaluateWorkloadRatio(
        past7DaysLoadKg: 20000,
        past28DaysLoadKg: 80000, // Chronic avg = 20000 => ACWR = 1.0
      );

      expect(assessment.acwr, equals(1.0));
      expect(assessment.status, equals(AcwrStatus.sweetSpot));
      expect(assessment.recommendation, contains('Optimal sweet spot'));
    });

    test('ACWR > 1.5 resolves to dangerZone status', () {
      final assessment = engine.evaluateWorkloadRatio(
        past7DaysLoadKg: 35000,
        past28DaysLoadKg: 60000, // Chronic avg = 15000 => ACWR = 2.33
      );

      expect(assessment.acwr, greaterThan(1.5));
      expect(assessment.status, equals(AcwrStatus.dangerZone));
      expect(assessment.recommendation, contains('High injury risk'));
    });
  });

  group('StressDetectionEngine Tests', () {
    const engine = StressDetectionEngine();

    test('Suppressed HRV and elevated HR resolve to high physiological stress', () {
      final stress = engine.evaluateStress(
        todayNocturnalHrvMs: 38.0,
        baselineHrvMs: 65.0, // >35% drop
        todayRestingHrBpm: 68.0,
        baselineRestingHrBpm: 58.0, // +10 bpm
        sleepEfficiencyPct: 0.72,
      );

      expect(stress.level, equals(StressLevel.high));
      expect(stress.score, greaterThanOrEqualTo(75.0));
    });

    test('Robust HRV resolves to restored parasympathetic state', () {
      final stress = engine.evaluateStress(
        todayNocturnalHrvMs: 75.0,
        baselineHrvMs: 65.0,
        todayRestingHrBpm: 56.0,
        baselineRestingHrBpm: 58.0,
        sleepEfficiencyPct: 0.94,
      );

      expect(stress.level, equals(StressLevel.restored));
      expect(stress.score, lessThan(25.0));
    });
  });

  group('ClinicalLabIntelligenceEngine Tests', () {
    const engine = ClinicalLabIntelligenceEngine();

    test('Biomarker inside reference range evaluates as optimal', () {
      final result = engine.evaluateBiomarker(
        markerKey: 'hba1c',
        name: 'HbA1c',
        nameHindi: 'एचबीए1सी',
        value: 5.3,
        unit: '%',
        referenceMin: 4.0,
        referenceMax: 5.6,
      );

      expect(result.status, equals(LabMarkerStatus.optimal));
      expect(result.interpretation, contains('optimal'));
    });

    test('Critical vitamin deficiency is flagged', () {
      final result = engine.evaluateBiomarker(
        markerKey: 'vitamin_d3',
        name: 'Vitamin D3',
        nameHindi: 'विटामिन डी३',
        value: 12.0, // Critical deficiency (< 20)
        unit: 'ng/mL',
        referenceMin: 30.0,
        referenceMax: 100.0,
      );

      expect(result.status, equals(LabMarkerStatus.critical));
    });
  });

  group('MedicationSafetyEngine Tests', () {
    const engine = MedicationSafetyEngine();

    test('Provides Metformin meal guidance and B12 warning', () {
      final warning = engine.getFoodInteractionWarning('Metformin 500mg');
      expect(warning, isNotNull);
      expect(warning, contains('Take with or immediately after meals'));
      expect(warning, contains('Vitamin B12'));
    });

    test('Provides Levothyroxine empty stomach guidance', () {
      final warning = engine.getFoodInteractionWarning('Thyronorm 50mcg');
      expect(warning, isNotNull);
      expect(warning, contains('empty stomach'));
    });
  });

  group('PredictiveHealthRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late PredictiveHealthRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = PredictiveHealthRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveBiologicalAgeEstimate persists record & queues outbox mutation', () async {
      final estimate = BiologicalAgeEstimate(
        id: 'bio-101',
        userId: 'user-001',
        chronologicalAge: 34,
        biologicalAge: 31.5,
        ageDelta: -2.5,
        confidenceScore: 0.92,
        contributors: [],
        topImprovementAction: 'Maintain Zone 2 cardio',
        topImprovementActionHindi: 'कार्डियो बनाए रखें',
        calculatedAt: DateTime.now(),
      );

      await repo.saveBiologicalAgeEstimate(estimate);

      final record = await repo.getLatestBiologicalAge('user-001');
      expect(record, isNotNull);
      expect(record!.biologicalAge, equals(31.5));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'biological_age_estimates'), isTrue);
    });

    test('saveClinicalLabReport serializes results and persists report', () async {
      final report = ClinicalLabReport(
        id: 'rep-1',
        userId: 'user-001',
        labName: 'Dr Lal PathLabs',
        testDate: DateTime.now(),
        results: [
          const LabBiomarkerResult(
            markerKey: 'hba1c',
            name: 'HbA1c',
            nameHindi: 'एचबीए1सी',
            value: 5.4,
            unit: '%',
            referenceMin: 4.0,
            referenceMax: 5.6,
            status: LabMarkerStatus.optimal,
            interpretation: 'Optimal glycemic control',
            interpretationHindi: 'ग्लूकोज नियंत्रण सामान्य',
          ),
        ],
        executiveSummary: 'All biomarkers optimal',
        executiveSummaryHindi: 'सभी बायोमार्कर्स सामान्य',
        uploadedAt: DateTime.now(),
      );

      await repo.saveClinicalLabReport(report);

      final dbReports = await db.select(db.localClinicalLabReports).get();
      expect(dbReports.length, equals(1));
      expect(dbReports.first.labName, equals('Dr Lal PathLabs'));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'clinical_lab_reports'), isTrue);
    });

    test('saveMedication persists with automatic safety warning', () async {
      await repo.saveMedication(
        id: 'med-101',
        userId: 'user-001',
        medicationName: 'Thyronorm',
        dosage: '75 mcg',
        frequency: 'Daily',
        timingCategory: 'Morning Empty Stomach',
      );

      final meds = await db.select(db.localMedications).get();
      expect(meds.length, equals(1));
      expect(meds.first.foodInteractionWarning, contains('empty stomach'));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'medications'), isTrue);
    });

    test('createDoctorGrant creates temporary access PIN and queues outbox', () async {
      final grant = DoctorAccessGrant(
        id: 'grant-1',
        userId: 'user-001',
        doctorName: 'Dr. Ramesh Sharma',
        clinicHospital: 'Fortis Hospital',
        accessPin: '938104',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      await repo.createDoctorGrant(grant);

      final grants = await db.select(db.localDoctorGrants).get();
      expect(grants.length, equals(1));
      expect(grants.first.accessPin, equals('938104'));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'doctor_access_grants'), isTrue);
    });
  });
}
