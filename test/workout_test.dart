import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/workout/data/workout_repository.dart';
import 'package:fitkarma/features/workout/domain/models/workout_models.dart';
import 'package:fitkarma/features/workout/domain/services/exercise_database.dart';
import 'package:fitkarma/features/workout/domain/services/movement_intelligence_engine.dart';
import 'package:fitkarma/features/workout/domain/services/progressive_overload_engine.dart';

void main() {
  group('ExerciseDatabase Tests', () {
    test('Database contains core compound, isolation, and Desi exercises', () {
      expect(ExerciseDatabase.seededExercises.isNotEmpty, isTrue);
      expect(ExerciseDatabase.seededExercises.any((e) => e.name.contains('Squat')), isTrue);
      expect(ExerciseDatabase.seededExercises.any((e) => e.name.contains('Bench Press')), isTrue);
      expect(ExerciseDatabase.seededExercises.any((e) => e.name.contains('Desi Dand')), isTrue);
      expect(ExerciseDatabase.seededExercises.any((e) => e.name.contains('Surya Namaskar')), isTrue);
    });

    test('Filter by muscle group returns targeted exercises', () {
      final chestExercises = ExerciseDatabase.getByMuscleGroup(MuscleGroup.chest);
      expect(chestExercises.isNotEmpty, isTrue);
      expect(chestExercises.any((e) => e.name.contains('Bench Press') || e.name.contains('Desi Dand')), isTrue);
    });
  });

  group('ProgressiveOverloadEngine Tests', () {
    const engine = ProgressiveOverloadEngine();
    final benchPress = ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_barbell_bench_press');

    test('Increases load (+2.5kg) when max reps are achieved at moderate RPE', () {
      final recommendation = engine.calculateNextTarget(
        exercise: benchPress,
        lastWeightKg: 70.0,
        lastRepsAchieved: [10, 10, 10, 10],
        lastRpeScores: [8, 8, 8, 8],
      );

      expect(recommendation.action, 'increase_weight');
      expect(recommendation.suggestedWeightKg, 72.5);
      expect(recommendation.reasoning, contains('+2.5kg'));
    });

    test('Maintains weight and targets rep addition when lower rep bound is satisfied', () {
      final recommendation = engine.calculateNextTarget(
        exercise: benchPress,
        lastWeightKg: 70.0,
        lastRepsAchieved: [9, 8, 8, 8],
        lastRpeScores: [8, 8, 9, 9],
      );

      expect(recommendation.action, 'increase_reps');
      expect(recommendation.suggestedWeightKg, 70.0);
    });

    test('Triggers micro-deload (-10%) after 2 consecutive failed sessions', () {
      final recommendation = engine.calculateNextTarget(
        exercise: benchPress,
        lastWeightKg: 80.0,
        lastRepsAchieved: [5, 4, 4, 3],
        lastRpeScores: [10, 10, 10, 10],
        consecutiveFailures: 2,
      );

      expect(recommendation.action, 'micro_deload');
      expect(recommendation.suggestedWeightKg, 72.0);
      expect(recommendation.reasoning, contains('Micro-deload'));
    });
  });

  group('MovementIntelligenceEngine Tests', () {
    const engine = MovementIntelligenceEngine();

    test('Validates optimal Squat depth and upright torso', () {
      final result = engine.evaluateSquat(
        hipKneeAngleDeg: 85.0,
        torsoInclinationDeg: 35.0,
        isHeelGrounded: true,
      );

      expect(result.isValid, isTrue);
      expect(result.scorePercent, greaterThanOrEqualTo(90.0));
      expect(result.feedback, contains('Excellent squat'));
    });

    test('Flags faulty squat with lifted heels and excessive torso lean', () {
      final result = engine.evaluateSquat(
        hipKneeAngleDeg: 110.0,
        torsoInclinationDeg: 60.0,
        isHeelGrounded: false,
      );

      expect(result.isValid, isFalse);
      expect(result.scorePercent, lessThan(70.0));
      expect(result.correctionCues.isNotEmpty, isTrue);
    });

    test('Validates Bench Press elbow angle and flags wide flare', () {
      final goodPress = engine.evaluateBenchPress(
        elbowFlareAngleDeg: 48.0,
        isScapulaRetracted: true,
      );
      expect(goodPress.isValid, isTrue);

      final flaredPress = engine.evaluateBenchPress(
        elbowFlareAngleDeg: 88.0,
        isScapulaRetracted: false,
      );
      expect(flaredPress.isValid, isFalse);
      expect(flaredPress.feedback, contains('impingement'));
    });
  });

  group('WorkoutRepository Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late WorkoutRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repository = WorkoutRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveWorkoutSession persists session and sets to Drift and queues Outbox mutations', () async {
      final benchPress = ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_barbell_bench_press');
      final sessionId = await repository.saveWorkoutSession(
        userId: 'user_athlete_1',
        name: 'Upper Body Push',
        durationSeconds: 2700,
        exercises: [
          SessionExercise(
            exercise: benchPress,
            sets: [
              const WorkoutSet(setNumber: 1, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
              const WorkoutSet(setNumber: 2, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
            ],
          ),
        ],
      );

      expect(sessionId.isNotEmpty, isTrue);

      final sessions = await repository.getRecentSessions('user_athlete_1');
      expect(sessions.length, 1);
      expect(sessions.first.name, 'Upper Body Push');
      expect(sessions.first.totalVolumeKg, 1400.0);

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'workout_sessions'), isTrue);
      expect(pending.any((p) => p.targetTable == 'workout_sets'), isTrue);
    });

    test('getOverloadRecommendationForExercise derives next weight target from logged sets', () async {
      final benchPress = ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_barbell_bench_press');

      await repository.saveWorkoutSession(
        userId: 'user_athlete_2',
        name: 'Bench Session',
        durationSeconds: 1800,
        exercises: [
          SessionExercise(
            exercise: benchPress,
            sets: [
              const WorkoutSet(setNumber: 1, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
              const WorkoutSet(setNumber: 2, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
              const WorkoutSet(setNumber: 3, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
              const WorkoutSet(setNumber: 4, weightKg: 70, reps: 10, rpe: 8, isCompleted: true),
            ],
          ),
        ],
      );

      final recommendation = await repository.getOverloadRecommendationForExercise(exercise: benchPress);
      expect(recommendation.action, 'increase_weight');
      expect(recommendation.suggestedWeightKg, 72.5);
    });
  });
}
