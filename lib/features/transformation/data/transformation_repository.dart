import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/transformation_models.dart';
import '../domain/services/transformation_journey_engine.dart';
import '../domain/services/habit_identity_engine.dart';

class TransformationRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final TransformationJourneyEngine journeyEngine;
  final HabitIdentityEngine identityEngine;

  TransformationRepository({
    required this.db,
    required this.syncWorker,
    this.journeyEngine = const TransformationJourneyEngine(),
    this.identityEngine = const HabitIdentityEngine(),
  });

  /// Log a body transformation point (weight, waist, hip, body fat %, photo)
  Future<String> logBodyTransformation({
    required String id,
    required String userId,
    required double weightKg,
    required double waistCm,
    required double hipCm,
    required double bodyFatPct,
    String? photoUrl,
    required DateTime loggedAt,
  }) async {
    // 1. Insert into local Drift DB
    await db.into(db.localBodyTransformationLogs).insertOnConflictUpdate(
      LocalBodyTransformationLogsCompanion(
        id: Value(id),
        userId: Value(userId),
        weightKg: Value(weightKg),
        waistCm: Value(waistCm),
        hipCm: Value(hipCm),
        bodyFatPct: Value(bodyFatPct),
        photoUrl: Value(photoUrl),
        loggedAt: Value(loggedAt),
      ),
    );

    // 2. Queue mutation in Outbox for offline sync
    await syncWorker.enqueueMutation(
      tableName: 'body_transformation_logs',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'weight_kg': weightKg,
        'waist_cm': waistCm,
        'hip_cm': hipCm,
        'body_fat_pct': bodyFatPct,
        if (photoUrl != null) 'photo_url': photoUrl,
        'logged_at': loggedAt.toIso8601String(),
      },
    );

    return id;
  }

  /// Unlock or save a transformation milestone
  Future<void> saveMilestone(TransformationMilestone milestone) async {
    await db.into(db.localTransformationMilestones).insertOnConflictUpdate(
      LocalTransformationMilestonesCompanion(
        id: Value(milestone.id),
        userId: Value(milestone.userId),
        type: Value(milestone.type.name),
        title: Value(milestone.title),
        titleHindi: Value(milestone.titleHindi),
        description: Value(milestone.description),
        achievedAt: Value(milestone.achievedAt),
        photoUrl: Value(milestone.photoUrl),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'transformation_milestones',
      action: 'INSERT',
      payload: milestone.toJson(),
    );
  }

  /// Stream all body transformation points for user
  Stream<List<BodyTransformationPoint>> watchBodyLogs(String userId) {
    return (db.select(db.localBodyTransformationLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
        .watch()
        .map((rows) => rows.map((r) => BodyTransformationPoint(
              id: r.id,
              userId: r.userId,
              weightKg: r.weightKg,
              waistCm: r.waistCm,
              hipCm: r.hipCm,
              bodyFatPct: r.bodyFatPct,
              photoUrl: r.photoUrl,
              loggedAt: r.loggedAt,
            )).toList());
  }

  /// Stream all unlocked milestones for user
  Stream<List<TransformationMilestone>> watchMilestones(String userId) {
    return (db.select(db.localTransformationMilestones)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.achievedAt)]))
        .watch()
        .map((rows) => rows.map((r) => TransformationMilestone(
              id: r.id,
              userId: r.userId,
              type: MilestoneType.values.firstWhere(
                (m) => m.name == r.type,
                orElse: () => MilestoneType.baselineSet,
              ),
              title: r.title,
              titleHindi: r.titleHindi,
              description: r.description,
              achievedAt: r.achievedAt,
              photoUrl: r.photoUrl,
            )).toList());
  }

  /// Evaluate journey metrics and automatically discover & unlock milestones
  Future<TransformationProgressSummary> evaluateTransformation({
    required String userId,
    int consistentWeeks = 4,
    int streakDays = 28,
  }) async {
    final logs = await (db.select(db.localBodyTransformationLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
        .get();

    final modelLogs = logs.map((r) => BodyTransformationPoint(
          id: r.id,
          userId: r.userId,
          weightKg: r.weightKg,
          waistCm: r.waistCm,
          hipCm: r.hipCm,
          bodyFatPct: r.bodyFatPct,
          photoUrl: r.photoUrl,
          loggedAt: r.loggedAt,
        )).toList();

    final existingMilestones = await (db.select(db.localTransformationMilestones)
          ..where((t) => t.userId.equals(userId)))
        .get();

    final modelMilestones = existingMilestones.map((r) => TransformationMilestone(
          id: r.id,
          userId: r.userId,
          type: MilestoneType.values.firstWhere(
            (m) => m.name == r.type,
            orElse: () => MilestoneType.baselineSet,
          ),
          title: r.title,
          titleHindi: r.titleHindi,
          description: r.description,
          achievedAt: r.achievedAt,
          photoUrl: r.photoUrl,
        )).toList();

    if (modelLogs.isNotEmpty) {
      final initial = modelLogs.first;
      final latest = modelLogs.last;

      final newMilestones = identityEngine.evaluateNewMilestones(
        userId: userId,
        initialWeightKg: initial.weightKg,
        currentWeightKg: latest.weightKg,
        currentWaistCm: latest.waistCm,
        streakDays: streakDays,
        alreadyUnlocked: modelMilestones,
      );

      for (final nm in newMilestones) {
        await saveMilestone(nm);
        modelMilestones.add(nm);
      }
    }

    return journeyEngine.evaluateProgress(
      logs: modelLogs,
      consistentWeeks: consistentWeeks,
      currentMilestones: modelMilestones,
    );
  }
}
