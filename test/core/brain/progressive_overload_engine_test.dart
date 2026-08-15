import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/pose_estimation_engine.dart';
import 'package:fitkarma/core/brain/progressive_overload_engine.dart';

void main() {
  group('§P6-C ProgressiveOverloadEngine & PoseEstimationEngine Tests', () {
    const overloadEngine = ProgressiveOverloadEngine();
    const poseEngine = PoseEstimationEngine();

    test(
        'Progressive Overload increments weight by +2.5kg for high readiness & low RPE',
        () {
      final target = overloadEngine.calculateNextTarget(
        previousWeightKg: 80.0,
        previousReps: 8,
        rpe: 6.5,
        readinessScore: 82,
      );

      expect(target.weightKg, equals(82.5));
      expect(target.recommendationReason, contains('Increment weight +2.5kg'));
      expect(target.progressionType, equals(ProgressionType.increaseWeight));
    });

    test('Progressive Overload deloads weight -2.5kg for low readiness (<50)',
        () {
      final target = overloadEngine.calculateNextTarget(
        previousWeightKg: 80.0,
        previousReps: 8,
        rpe: 8.0,
        readinessScore: 45,
      );

      expect(target.weightKg, equals(77.5));
      expect(target.recommendationReason, contains('Deload -2.5kg'));
      expect(target.progressionType, equals(ProgressionType.deload));
    });

    test(
        'suggestMultiSessionProgression suggests +2.5kg jump after 3 consecutive comfortable sessions (RPE <= 7)',
        () {
      const exercise = ExerciseTarget(
          name: 'Bench Press', currentWeight: 80.0, nextWeightStep: 2.5);
      final sessions = [
        WorkoutSessionRecord(
            date: DateTime.now().subtract(const Duration(days: 7)),
            repsTarget: 8,
            repsCompleted: 8,
            rpe: 6.5,
            weightKg: 80.0),
        WorkoutSessionRecord(
            date: DateTime.now().subtract(const Duration(days: 4)),
            repsTarget: 8,
            repsCompleted: 8,
            rpe: 7.0,
            weightKg: 80.0),
        WorkoutSessionRecord(
            date: DateTime.now().subtract(const Duration(days: 1)),
            repsTarget: 8,
            repsCompleted: 8,
            rpe: 6.8,
            weightKg: 80.0),
      ];

      final suggestion = overloadEngine.suggestMultiSessionProgression(
        exercise: exercise,
        recentSessions: sessions,
      );

      expect(suggestion.weightKg, equals(82.5));
      expect(
          suggestion.progressionType, equals(ProgressionType.increaseWeight));
      expect(suggestion.recommendationReason, contains('Increase to 82.5kg'));
    });

    test(
        'suggestMultiSessionProgression triggers deload week at 60% intensity upon 4-week plateau',
        () {
      const exercise = ExerciseTarget(
          name: 'Squat', currentWeight: 100.0, nextWeightStep: 2.5);
      final sessions = List.generate(4, (i) {
        return WorkoutSessionRecord(
          date: DateTime.now().subtract(Duration(days: 28 - i * 7)),
          repsTarget: 8,
          repsCompleted: 8,
          rpe: 8.5,
          weightKg: 100.0,
        );
      });

      final suggestion = overloadEngine.suggestMultiSessionProgression(
        exercise: exercise,
        recentSessions: sessions,
      );

      expect(suggestion.weightKg, equals(60.0));
      expect(suggestion.progressionType, equals(ProgressionType.deload));
      expect(suggestion.recommendationReason,
          contains('deload week at 60% intensity'));
    });

    test('Pose Estimation detects movement asymmetry offset between knees', () {
      final result = poseEngine.analyzeSquatForm(
        leftKneeAngle: 85.0,
        rightKneeAngle: 102.0, // 17 deg asymmetry
        hipAngle: 90.0,
      );

      expect(result.asymmetryOffsetDegrees, equals(17.0));
      expect(result.formFeedback, contains('Movement Asymmetry Detected'));
    });
  });
}
