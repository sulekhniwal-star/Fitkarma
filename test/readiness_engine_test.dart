import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/readiness_engine/data/readiness_repository.dart';
import 'package:fitkarma/features/readiness_engine/domain/models/readiness_input.dart';
import 'package:fitkarma/features/readiness_engine/domain/models/readiness_result.dart';
import 'package:fitkarma/features/readiness_engine/domain/services/readiness_calculation_engine.dart';
import 'package:fitkarma/features/readiness_engine/domain/services/sleep_intelligence_engine.dart';
import 'package:fitkarma/features/readiness_engine/domain/services/recovery_os_engine.dart';

void main() {
  group('SleepIntelligenceEngine', () {
    const engine = SleepIntelligenceEngine();

    test('Calculates sleep debt correctly when duration is below target', () {
      final assessment = engine.assessSleep(
        sleepDurationHours: 6.0,
        sleepTargetHours: 8.0,
      );

      expect(assessment.sleepDebtHours, equals(2.0));
      expect(assessment.sleepInsight, contains('sleep debt'));
    });

    test('Calculates zero sleep debt when target is met or exceeded', () {
      final assessment = engine.assessSleep(
        sleepDurationHours: 8.5,
        sleepTargetHours: 8.0,
      );

      expect(assessment.sleepDebtHours, equals(0.0));
    });
  });

  group('RecoveryOSEngine', () {
    const engine = RecoveryOSEngine();

    test('Prescribes 4-7-8 Pranayama when sleep debt exceeds 1 hour', () {
      final prescriptions = engine.generatePrescriptions(
        readinessScore: 70,
        sorenessList: [],
        sleepDebtHours: 1.5,
      );

      expect(prescriptions.protocols.any((p) => p.contains('Pranayama')), isTrue);
    });

    test('Prescribes targeted foam rolling when high muscle soreness is logged', () {
      final prescriptions = engine.generatePrescriptions(
        readinessScore: 75,
        sorenessList: [
          const MuscleSorenessEntry(muscleGroup: 'quads', severity: 4),
        ],
        sleepDebtHours: 0.0,
      );

      expect(prescriptions.protocols.any((p) => p.contains('quads')), isTrue);
    });
  });

  group('ReadinessCalculationEngine (Three-Tier Confidence)', () {
    const engine = ReadinessCalculationEngine();

    test('Tier 1 (High Confidence): Full biometrics yields Prime readiness when HRV and sleep are optimal', () {
      const input = ReadinessInput(
        hrvRmssdMs: 70.0,
        hrvBaselineMs: 60.0, // Above baseline (+16%)
        restingHeartRateBpm: 48,
        restingHeartRateBaselineBpm: 52, // Lower RHR (-4 bpm)
        deepSleepMinutes: 90,
        remSleepMinutes: 100,
        sleepDurationHours: 8.0,
        sleepTargetHours: 8.0,
        perceivedEnergy: 5,
        perceivedStress: 1,
        sorenessList: [],
      );

      final result = engine.computeReadiness(input: input, chronologicalAge: 28);

      expect(result.confidenceTier, equals(ConfidenceTier.high));
      expect(result.score, greaterThanOrEqualTo(80));
      expect(result.state, equals(ReadinessState.prime));
      expect(result.strainCapacityBudget, greaterThan(14.0));
      expect(result.recoveryAgeYears, lessThan(28));
    });

    test('Tier 2 (Moderate Confidence): Sleep duration + subjective check-in yields steady score', () {
      const input = ReadinessInput(
        sleepDurationHours: 7.0,
        sleepTargetHours: 8.0,
        perceivedEnergy: 3,
        perceivedStress: 2,
        sorenessList: [
          MuscleSorenessEntry(muscleGroup: 'back', severity: 2),
        ],
      );

      final result = engine.computeReadiness(input: input, chronologicalAge: 30);

      expect(result.confidenceTier, equals(ConfidenceTier.moderate));
      expect(result.score, inInclusiveRange(60, 90));
    });

    test('Tier 3 (Low Confidence / Manual): High stress and severe DOMS triggers Recovery state', () {
      const input = ReadinessInput(
        sleepDurationHours: 5.0,
        sleepTargetHours: 8.0,
        perceivedEnergy: 1,
        perceivedStress: 5,
        sorenessList: [
          MuscleSorenessEntry(muscleGroup: 'chest', severity: 5),
          MuscleSorenessEntry(muscleGroup: 'quads', severity: 5),
          MuscleSorenessEntry(muscleGroup: 'calves', severity: 4),
        ],
      );

      final result = engine.computeReadiness(input: input, chronologicalAge: 25);

      expect(result.confidenceTier, equals(ConfidenceTier.moderate)); // duration present
      expect(result.score, lessThan(60));
      expect(result.state, equals(ReadinessState.recovery));
      expect(result.recoveryAgeYears, greaterThan(25));
    });
  });

  group('ReadinessRepository (Drift Local Persistence & Outbox)', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late ReadinessRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db);
      repo = ReadinessRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      syncWorker.dispose();
      await db.close();
    });

    test('calculateAndSaveReadiness persists score and soreness to Drift and enqueues Supabase outbox write', () async {
      const input = ReadinessInput(
        sleepDurationHours: 7.5,
        perceivedEnergy: 4,
        perceivedStress: 2,
        sorenessList: [
          MuscleSorenessEntry(muscleGroup: 'chest', severity: 3),
        ],
      );

      final result = await repo.calculateAndSaveReadiness(
        userId: 'user-readiness-test',
        input: input,
        chronologicalAge: 26,
      );

      expect(result.score, greaterThan(0));

      // Verify Local Score
      final savedScore = await repo.getLatestLocalReadiness('user-readiness-test');
      expect(savedScore, isNotNull);
      expect(savedScore!.score, equals(result.score));

      // Verify Local Soreness
      final sorenessList = await repo.getRecentSorenessLogs('user-readiness-test');
      expect(sorenessList.length, equals(1));
      expect(sorenessList.first.muscleGroup, equals('chest'));
      expect(sorenessList.first.severity, equals(3));

      // Verify Outbox Queue has readiness mutation
      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((m) => m.targetTable == 'readiness_scores'), isTrue);
    });
  });
}
