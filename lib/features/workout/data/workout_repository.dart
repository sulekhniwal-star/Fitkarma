import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/workout_models.dart';
import '../domain/services/movement_intelligence_engine.dart';
import '../domain/services/progressive_overload_engine.dart';

class WorkoutRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final ProgressiveOverloadEngine overloadEngine;
  final MovementIntelligenceEngine movementEngine;
  final _uuid = const Uuid();

  WorkoutRepository({
    required this.db,
    required this.syncWorker,
    this.overloadEngine = const ProgressiveOverloadEngine(),
    this.movementEngine = const MovementIntelligenceEngine(),
  });

  /// Save completed workout session and sets (offline-first Drift -> Outbox)
  Future<String> saveWorkoutSession({
    required String userId,
    required String name,
    required int durationSeconds,
    required List<SessionExercise> exercises,
    DateTime? startedAt,
    DateTime? completedAt,
  }) async {
    final sessionId = _uuid.v4();
    final start = startedAt ?? DateTime.now().subtract(Duration(seconds: durationSeconds));
    final end = completedAt ?? DateTime.now();

    double totalVolume = 0;
    int totalRpe = 0;
    int totalSets = 0;

    for (final ex in exercises) {
      totalVolume += ex.totalVolumeKg;
      for (final s in ex.sets) {
        if (s.isCompleted) {
          totalRpe += s.rpe;
          totalSets++;
        }
      }
    }

    final avgRpe = totalSets > 0 ? (totalRpe / totalSets) : 8.0;

    // 1. Write Session to Drift
    await db.into(db.localWorkoutSessions).insert(
          LocalWorkoutSessionsCompanion.insert(
            id: sessionId,
            userId: userId,
            name: name,
            durationSeconds: durationSeconds,
            totalVolumeKg: totalVolume,
            avgRpe: avgRpe,
            startedAt: start,
            completedAt: end,
          ),
        );

    // 2. Queue Outbox for Session
    await syncWorker.enqueueMutation(
      tableName: 'workout_sessions',
      action: 'INSERT',
      payload: {
        'id': sessionId,
        'user_id': userId,
        'name': name,
        'duration_seconds': durationSeconds,
        'total_volume_kg': totalVolume,
        'avg_rpe': avgRpe,
        'started_at': start.toIso8601String(),
        'completed_at': end.toIso8601String(),
      },
    );

    // 3. Write individual sets to Drift & Outbox
    for (final ex in exercises) {
      for (final s in ex.sets) {
        final setId = _uuid.v4();
        await db.into(db.localWorkoutSets).insert(
              LocalWorkoutSetsCompanion.insert(
                id: setId,
                sessionId: sessionId,
                exerciseId: ex.exercise.id,
                setNumber: s.setNumber,
                weightKg: s.weightKg,
                reps: s.reps,
                rpe: s.rpe,
                isCompleted: Value(s.isCompleted),
              ),
            );

        await syncWorker.enqueueMutation(
          tableName: 'workout_sets',
          action: 'INSERT',
          payload: {
            'id': setId,
            'session_id': sessionId,
            'exercise_id': ex.exercise.id,
            'set_number': s.setNumber,
            'weight_kg': s.weightKg,
            'reps': s.reps,
            'rpe': s.rpe,
            'is_completed': s.isCompleted,
          },
        );
      }
    }

    return sessionId;
  }

  /// Get recent workout sessions
  Future<List<LocalWorkoutSession>> getRecentSessions(String userId) async {
    return (db.select(db.localWorkoutSessions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Get past set history for an exercise to compute overload
  Future<List<LocalWorkoutSet>> getExerciseHistory(String exerciseId) async {
    return (db.select(db.localWorkoutSets)
          ..where((t) => t.exerciseId.equals(exerciseId) & t.isCompleted.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Calculate progressive overload recommendation for an exercise
  Future<OverloadRecommendation> getOverloadRecommendationForExercise({
    required Exercise exercise,
    double fallbackWeightKg = 20.0,
  }) async {
    final history = await getExerciseHistory(exercise.id);
    if (history.isEmpty) {
      return overloadEngine.calculateNextTarget(
        exercise: exercise,
        lastWeightKg: fallbackWeightKg,
        lastRepsAchieved: [],
        lastRpeScores: [],
      );
    }

    // Group sets from the most recent session
    final latestSessionId = history.first.sessionId;
    final latestSets = history.where((s) => s.sessionId == latestSessionId).toList();

    final lastWeight = latestSets.first.weightKg;
    final reps = latestSets.map((s) => s.reps).toList();
    final rpes = latestSets.map((s) => s.rpe).toList();

    return overloadEngine.calculateNextTarget(
      exercise: exercise,
      lastWeightKg: lastWeight,
      lastRepsAchieved: reps,
      lastRpeScores: rpes,
    );
  }
}
