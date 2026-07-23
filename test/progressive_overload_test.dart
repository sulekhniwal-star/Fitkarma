import 'package:fitkarma/features/workout/progressive_overload_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = ProgressiveOverloadEngine();

  const benchPress = OverloadExercise(
    name: 'Barbell Bench Press',
    currentWeightKg: 80.0,
    weightStepKg: 2.5,
  );

  ExerciseSessionRecord comfortable(DateTime date) => ExerciseSessionRecord(
        exerciseName: 'Barbell Bench Press',
        weightKg: 80.0,
        repsCompleted: 8,
        repsTarget: 8,
        rpe: 7,
        sessionDate: date,
      );

  ExerciseSessionRecord hard(DateTime date) => ExerciseSessionRecord(
        exerciseName: 'Barbell Bench Press',
        weightKg: 80.0,
        repsCompleted: 6,
        repsTarget: 8,
        rpe: 9,
        sessionDate: date,
      );

  group('ProgressiveOverloadEngine Unit Tests', () {
    test('returns null when no records exist for exercise', () {
      final result = engine.suggest(exercise: benchPress, recentRecords: const []);
      expect(result, isNull);
    });

    test('Rule 1: 3 comfortable sessions → increaseWeight suggestion at nextWeightStep', () {
      final records = [
        comfortable(DateTime(2026, 7, 20)),
        comfortable(DateTime(2026, 7, 17)),
        comfortable(DateTime(2026, 7, 14)),
      ];

      final result = engine.suggest(exercise: benchPress, recentRecords: records);

      expect(result, isNotNull);
      expect(result!.type, ProgressionType.increaseWeight);
      expect(result.suggestedWeightKg, 82.5); // 80.0 + 2.5
      expect(result.message, contains('80.0kg'));
      expect(result.message, contains('82.5kg'));
    });

    test('Rule 1: mixed comfortable / hard sessions → no weight increase', () {
      final records = [
        comfortable(DateTime(2026, 7, 20)),
        hard(DateTime(2026, 7, 17)),      // RPE 9, reps short
        comfortable(DateTime(2026, 7, 14)),
      ];

      final result = engine.suggest(exercise: benchPress, recentRecords: records);

      expect(result, isNotNull);
      expect(result!.type, isNot(ProgressionType.increaseWeight));
    });

    test('Rule 2: 4 sessions at same weight with no reps improvement → deload at 60%', () {
      final records = [
        hard(DateTime(2026, 7, 20)),
        hard(DateTime(2026, 7, 17)),
        hard(DateTime(2026, 7, 14)),
        hard(DateTime(2026, 7, 11)),
      ];

      final result = engine.suggest(exercise: benchPress, recentRecords: records);

      expect(result, isNotNull);
      expect(result!.type, ProgressionType.deload);
      expect(result.suggestedWeightKg, closeTo(48.0, 1.0)); // 80 * 0.6 = 48 kg
      expect(result.message, contains('deload'));
    });

    test('Rule 3: fewer than 3 records, not plateau → maintain', () {
      final records = [
        comfortable(DateTime(2026, 7, 20)),
        hard(DateTime(2026, 7, 17)),
      ];

      final result = engine.suggest(exercise: benchPress, recentRecords: records);

      expect(result, isNotNull);
      expect(result!.type, ProgressionType.maintain);
      expect(result.suggestedWeightKg, 80.0);
    });

    test('Plateau check: fewer than 4 sessions → no deload triggered', () {
      final records = [
        hard(DateTime(2026, 7, 20)),
        hard(DateTime(2026, 7, 17)),
        hard(DateTime(2026, 7, 14)),
      ];

      final result = engine.suggest(exercise: benchPress, recentRecords: records);

      // Only 3 hard (not comfortable) sessions → no increaseWeight, no deload (needs 4 for plateau)
      expect(result, isNotNull);
      expect(result!.type, ProgressionType.maintain);
    });

    test('ExerciseSessionRecord isComfortable returns true only when reps >= target AND rpe <= 7', () {
      final good = comfortable(DateTime(2026, 7, 20));
      final bad = hard(DateTime(2026, 7, 20));

      expect(good.isComfortable, isTrue);
      expect(bad.isComfortable, isFalse);
    });
  });
}
