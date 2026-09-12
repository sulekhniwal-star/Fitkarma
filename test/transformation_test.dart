import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/transformation/domain/models/transformation_models.dart';
import 'package:fitkarma/features/transformation/domain/services/transformation_journey_engine.dart';
import 'package:fitkarma/features/transformation/domain/services/habit_identity_engine.dart';
import 'package:fitkarma/features/transformation/data/transformation_repository.dart';

void main() {
  group('TransformationJourneyEngine Tests', () {
    const engine = TransformationJourneyEngine();

    test('evaluateProgress computes accurate loss deltas & rates', () {
      final logs = [
        BodyTransformationPoint(
          id: 'log-1',
          userId: 'user-1',
          weightKg: 85.0,
          waistCm: 94.0,
          hipCm: 100.0,
          bodyFatPct: 24.0,
          loggedAt: DateTime(2026, 1, 1),
        ),
        BodyTransformationPoint(
          id: 'log-2',
          userId: 'user-1',
          weightKg: 80.0,
          waistCm: 88.0,
          hipCm: 96.0,
          bodyFatPct: 20.5,
          loggedAt: DateTime(2026, 2, 1),
        ),
      ];

      final summary = engine.evaluateProgress(
        logs: logs,
        consistentWeeks: 4,
        currentMilestones: [],
      );

      expect(summary.initialWeightKg, equals(85.0));
      expect(summary.currentWeightKg, equals(80.0));
      expect(summary.totalWeightLossKg, equals(5.0));
      expect(summary.waistLossCm, equals(6.0));
      expect(summary.initialWaistToHipRatio, equals(0.94));
      expect(summary.currentWaistToHipRatio, equals(0.92));
      expect(summary.identityStage, equals(HabitIdentityStage.disciplinedPractitioner));
    });

    test('Maps 12+ weeks and 5kg+ loss to transformedMaster', () {
      final logs = [
        BodyTransformationPoint(
          id: 'log-1',
          userId: 'user-1',
          weightKg: 85.0,
          waistCm: 94.0,
          hipCm: 100.0,
          bodyFatPct: 24.0,
          loggedAt: DateTime(2026, 1, 1),
        ),
        BodyTransformationPoint(
          id: 'log-2',
          userId: 'user-1',
          weightKg: 78.0,
          waistCm: 86.0,
          hipCm: 94.0,
          bodyFatPct: 18.0,
          loggedAt: DateTime(2026, 4, 1),
        ),
      ];

      final summary = engine.evaluateProgress(
        logs: logs,
        consistentWeeks: 13,
        currentMilestones: [],
      );

      expect(summary.identityStage, equals(HabitIdentityStage.transformedMaster));
      expect(summary.stageTitle, contains('Transformed Master'));
    });
  });

  group('HabitIdentityEngine Tests', () {
    const engine = HabitIdentityEngine();

    test('evaluateNewMilestones unlocks baseline, firstKg, 5kg, and 4-week milestones', () {
      final milestones = engine.evaluateNewMilestones(
        userId: 'user-101',
        initialWeightKg: 85.0,
        currentWeightKg: 79.5, // 5.5 kg lost
        currentWaistCm: 88.0,
        streakDays: 30, // > 28 days
        alreadyUnlocked: [],
      );

      expect(milestones.any((m) => m.type == MilestoneType.baselineSet), isTrue);
      expect(milestones.any((m) => m.type == MilestoneType.firstKgLost), isTrue);
      expect(milestones.any((m) => m.type == MilestoneType.first5kgLost), isTrue);
      expect(milestones.any((m) => m.type == MilestoneType.fourWeekConsistency), isTrue);
    });

    test('does not duplicate already unlocked milestones', () {
      final alreadyUnlocked = [
        TransformationMilestone(
          id: 'milestone_baseline_user-101',
          userId: 'user-101',
          type: MilestoneType.baselineSet,
          title: 'Baseline',
          titleHindi: 'आधार',
          description: 'Desc',
          achievedAt: DateTime.now(),
        ),
      ];

      final newMilestones = engine.evaluateNewMilestones(
        userId: 'user-101',
        initialWeightKg: 85.0,
        currentWeightKg: 84.5,
        currentWaistCm: 90.0,
        streakDays: 5,
        alreadyUnlocked: alreadyUnlocked,
      );

      expect(newMilestones.any((m) => m.type == MilestoneType.baselineSet), isFalse);
    });
  });

  group('TransformationRepository Local DB & Outbox Integration', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late TransformationRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = TransformationRepository(
        db: db,
        syncWorker: syncWorker,
        journeyEngine: const TransformationJourneyEngine(),
        identityEngine: const HabitIdentityEngine(),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('logBodyTransformation inserts local record & queues outbox mutation', () async {
      final logId = await repo.logBodyTransformation(
        id: 'log-101',
        userId: 'user-001',
        weightKg: 76.5,
        waistCm: 84.0,
        hipCm: 95.0,
        bodyFatPct: 18.2,
        loggedAt: DateTime.now(),
      );

      expect(logId, equals('log-101'));

      // Check DB select
      final logs = await db.select(db.localBodyTransformationLogs).get();
      expect(logs.length, equals(1));
      expect(logs.first.weightKg, equals(76.5));
      expect(logs.first.waistCm, equals(84.0));

      // Check Outbox
      final pendingMutations = await db.select(db.pendingMutations).get();
      expect(pendingMutations.length, equals(1));
      expect(pendingMutations.first.targetTable, equals('body_transformation_logs'));
      expect(pendingMutations.first.action, equals('INSERT'));
    });

    test('evaluateTransformation processes multiple logs and unlocks milestones automatically', () async {
      await repo.logBodyTransformation(
        id: 'log-1',
        userId: 'user-001',
        weightKg: 85.0,
        waistCm: 92.0,
        hipCm: 100.0,
        bodyFatPct: 24.0,
        loggedAt: DateTime(2026, 1, 1),
      );

      await repo.logBodyTransformation(
        id: 'log-2',
        userId: 'user-001',
        weightKg: 79.5, // 5.5 kg lost
        waistCm: 86.0, // 6 cm lost
        hipCm: 95.0,
        bodyFatPct: 20.0,
        loggedAt: DateTime(2026, 2, 1),
      );

      final summary = await repo.evaluateTransformation(
        userId: 'user-001',
        consistentWeeks: 6,
        streakDays: 35,
      );

      expect(summary.currentWeightKg, equals(79.5));
      expect(summary.initialWeightKg, equals(85.0));
      expect(summary.totalWeightLossKg, equals(5.5));
      expect(summary.waistLossCm, equals(6.0));
      expect(summary.identityStage, equals(HabitIdentityStage.healthAthlete));
      expect(summary.unlockedMilestones.isNotEmpty, isTrue);

      // Verify milestones were also persisted to local DB
      final savedMilestones = await db.select(db.localTransformationMilestones).get();
      expect(savedMilestones.isNotEmpty, isTrue);
    });
  });
}
