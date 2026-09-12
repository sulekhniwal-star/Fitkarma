import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/readiness_input.dart';
import '../domain/models/readiness_result.dart';
import '../domain/services/readiness_calculation_engine.dart';

/// ReadinessRepository — Local-First Persistence + Outbox Sync for Readiness & Recovery
class ReadinessRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final ReadinessCalculationEngine engine;
  final _uuid = const Uuid();

  ReadinessRepository({
    required this.db,
    required this.syncWorker,
    this.engine = const ReadinessCalculationEngine(),
  });

  /// Compute and save daily readiness score locally, queueing Supabase outbox write
  Future<ReadinessResult> calculateAndSaveReadiness({
    required String userId,
    required ReadinessInput input,
    required int chronologicalAge,
  }) async {
    final result = engine.computeReadiness(
      input: input,
      chronologicalAge: chronologicalAge,
    );

    final scoreId = _uuid.v4();
    final now = DateTime.now();

    // 1. Write to local Drift database
    await db.into(db.localReadinessScores).insert(
          LocalReadinessScoresCompanion.insert(
            id: scoreId,
            userId: userId,
            score: result.score,
            confidenceTier: result.confidenceTier.name,
            calculatedAt: Value(now),
          ),
        );

    // 2. Queue Outbox Mutation for Supabase
    await syncWorker.enqueueMutation(
      tableName: 'readiness_scores',
      action: 'INSERT',
      payload: {
        'id': scoreId,
        'user_id': userId,
        'score': result.score,
        'confidence_tier': result.confidenceTier.name,
        'hrv_rmssd': input.hrvRmssdMs,
        'resting_hr': input.restingHeartRateBpm,
        'sleep_quality_score': result.sleepEfficiencyScore,
        'muscle_soreness_index': input.sorenessList.length,
        'calculated_at': now.toIso8601String(),
      },
    );

    // 3. Persist muscle soreness logs
    for (final s in input.sorenessList) {
      final sorenessId = _uuid.v4();
      await db.into(db.localSorenessLogs).insert(
            LocalSorenessLogsCompanion.insert(
              id: sorenessId,
              userId: userId,
              muscleGroup: s.muscleGroup,
              severity: s.severity,
              loggedAt: Value(now),
            ),
          );
    }

    return result;
  }

  /// Query latest readiness score from local database
  Future<LocalReadinessScore?> getLatestLocalReadiness(String userId) async {
    return (db.select(db.localReadinessScores)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.calculatedAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get active muscle soreness entries
  Future<List<LocalSorenessLog>> getRecentSorenessLogs(String userId) async {
    final yesterday = DateTime.now().subtract(const Duration(hours: 36));
    return (db.select(db.localSorenessLogs)
          ..where((t) => t.userId.equals(userId) & t.loggedAt.isBiggerThanValue(yesterday)))
        .get();
  }
}
