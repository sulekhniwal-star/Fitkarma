import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/health_tracking/data/health_tracking_repository.dart';
import 'package:fitkarma/features/health_tracking/domain/models/health_models.dart';
import 'package:fitkarma/features/health_tracking/domain/services/preventive_intelligence_engine.dart';
import 'package:fitkarma/features/health_tracking/domain/services/wearable_comparison_engine.dart';

void main() {
  group('PreventiveIntelligenceEngine Tests', () {
    const engine = PreventiveIntelligenceEngine();

    test('ADAG HbA1c estimation calculates correct values and categories', () {
      // (100 + 46.7) / 28.7 = 5.11 -> 5.1%
      final opt = engine.estimateHbA1c(100.0);
      expect(opt.estimatedHbA1c, 5.1);
      expect(opt.glycemicCategory, contains('Optimal'));

      // (130 + 46.7) / 28.7 = 6.15 -> 6.2%
      final pre = engine.estimateHbA1c(130.0);
      expect(pre.estimatedHbA1c, 6.2);
      expect(pre.glycemicCategory, contains('Prediabetes'));

      // (180 + 46.7) / 28.7 = 7.89 -> 7.9%
      final dia = engine.estimateHbA1c(180.0);
      expect(dia.estimatedHbA1c, 7.9);
      expect(dia.glycemicCategory, contains('Elevated'));
    });

    test('Blood Pressure classification identifies normal, stage 1, stage 2, and crisis', () {
      final normal = engine.classifyBloodPressure(systolicMmHg: 118, diastolicMmHg: 76);
      expect(normal.category, BPCategory.normal);
      expect(normal.pulsePressure, 42);

      final stage1 = engine.classifyBloodPressure(systolicMmHg: 132, diastolicMmHg: 84);
      expect(stage1.category, BPCategory.stage1Hypertension);

      final stage2 = engine.classifyBloodPressure(systolicMmHg: 145, diastolicMmHg: 92);
      expect(stage2.category, BPCategory.stage2Hypertension);

      final crisis = engine.classifyBloodPressure(systolicMmHg: 190, diastolicMmHg: 125);
      expect(crisis.category, BPCategory.crisis);
    });

    test('Thin-Fat Phenotype evaluator flags normal BMI with elevated metabolic metrics', () {
      // Normal BMI (22.0) with high fasting glucose and high BP
      final atRisk = engine.evaluateThinFatPhenotype(
        bmi: 22.0,
        fastingGlucoseMgDl: 110.0,
        systolicBp: 130,
        restingHeartRate: 78,
      );
      expect(atRisk.isAtRisk, isTrue);
      expect(atRisk.riskScore, greaterThan(50.0));
      expect(atRisk.mitigationActions.isNotEmpty, isTrue);

      // Normal BMI with healthy markers
      final healthy = engine.evaluateThinFatPhenotype(
        bmi: 21.0,
        fastingGlucoseMgDl: 88.0,
        systolicBp: 115,
        restingHeartRate: 62,
      );
      expect(healthy.isAtRisk, isFalse);
    });
  });

  group('WearableComparisonEngine Tests', () {
    const engine = WearableComparisonEngine();

    test('Device confidence weighting assigns proper tier weights', () {
      expect(engine.getDeviceConfidence('apple_watch'), 1.0);
      expect(engine.getDeviceConfidence('garmin_forerunner'), 1.0);
      expect(engine.getDeviceConfidence('fitbit_charge'), 0.85);
      expect(engine.getDeviceConfidence('boat_storm'), 0.65);
      expect(engine.getDeviceConfidence('manual_entry'), 0.50);
    });

    test('Reconcile steps avoids double-counting and prioritizes Tier 1 source', () {
      final now = DateTime.now();
      final samples = [
        WearableSample(
          id: '1',
          source: 'boat_storm',
          metric: 'steps',
          value: 9200,
          unit: 'count',
          timestamp: now,
        ),
        WearableSample(
          id: '2',
          source: 'apple_watch',
          metric: 'steps',
          value: 8400,
          unit: 'count',
          timestamp: now,
        ),
      ];

      final steps = engine.calculateReconciledDailySteps(samples);
      // Apple Watch has higher confidence (1.0 vs 0.65) so its 8400 steps is selected
      expect(steps, 8400);
    });

    test('Reconcile resting HR computes confidence-weighted average', () {
      final now = DateTime.now();
      final samples = [
        WearableSample(
          id: '1',
          source: 'garmin', // weight 1.0
          metric: 'heart_rate',
          value: 60.0,
          unit: 'bpm',
          timestamp: now,
        ),
        WearableSample(
          id: '2',
          source: 'boat', // weight 0.65
          metric: 'heart_rate',
          value: 80.0,
          unit: 'bpm',
          timestamp: now,
        ),
      ];

      final rhr = engine.calculateReconciledRestingHeartRate(samples);
      // (60*1.0 + 80*0.65) / 1.65 = (60 + 52) / 1.65 = 112 / 1.65 = 67.87 -> 68
      expect(rhr, 68);
    });
  });

  group('HealthTrackingRepository Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late HealthTrackingRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repository = HealthTrackingRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('Record wearable sample persists to Drift and queues Outbox mutation', () async {
      final now = DateTime.now();
      await repository.recordWearableSample(
        userId: 'user_123',
        source: 'apple_watch',
        metric: 'steps',
        value: 5000,
        unit: 'count',
        timestamp: now,
      );

      final samples = await repository.getWearableSamples(userId: 'user_123', metric: 'steps');
      expect(samples.length, 1);
      expect(samples.first.value, 5000);
      expect(samples.first.source, 'apple_watch');

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.length, 1);
      expect(pending.first.targetTable, 'wearable_samples');
      expect(pending.first.action, 'INSERT');
    });

    test('Record biomarker persists BP and queues Outbox mutation', () async {
      final now = DateTime.now();
      await repository.recordBiomarkerReading(
        userId: 'user_123',
        source: 'manual',
        type: BiomarkerType.bloodPressure,
        primaryValue: 120,
        secondaryValue: 80,
        unit: 'mmHg',
        note: 'Morning reading',
        measuredAt: now,
      );

      final biomarkers = await repository.getBiomarkers(
        userId: 'user_123',
        type: BiomarkerType.bloodPressure,
      );
      expect(biomarkers.length, 1);
      expect(biomarkers.first.primaryValue, 120);
      expect(biomarkers.first.secondaryValue, 80);

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.length, 1);
      expect(pending.first.targetTable, 'biomarkers');
    });

    test('Record CGM telemetry persists point and queues Outbox mutation', () async {
      final now = DateTime.now();
      await repository.recordCgmTelemetryPoint(
        userId: 'user_123',
        glucoseMgDl: 105.5,
        trendArrow: 'flat',
        associatedMealId: 'meal_abc',
        recordedAt: now,
      );

      final cgm = await repository.getCgmTelemetry(userId: 'user_123');
      expect(cgm.length, 1);
      expect(cgm.first.glucoseMgDl, 105.5);
      expect(cgm.first.trendArrow, 'flat');

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.length, 1);
      expect(pending.first.targetTable, 'cgm_telemetry');
    });
  });
}
