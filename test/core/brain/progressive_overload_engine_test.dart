import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/pose_estimation_engine.dart';
import 'package:fitkarma/core/brain/progressive_overload_engine.dart';

void main() {
  group('ProgressiveOverloadEngine & PoseEstimationEngine Tests', () {
    const overloadEngine = ProgressiveOverloadEngine();
    const poseEngine = PoseEstimationEngine();

    test('Progressive Overload increments weight by +2.5kg for high readiness & low RPE', () {
      final target = overloadEngine.calculateNextTarget(
        previousWeightKg: 80.0,
        previousReps: 8,
        rpe: 6.5,
        readinessScore: 82,
      );

      expect(target.weightKg, equals(82.5));
      expect(target.recommendationReason, contains('Increment weight +2.5kg'));
    });

    test('Progressive Overload deloads weight -2.5kg for low readiness (<50)', () {
      final target = overloadEngine.calculateNextTarget(
        previousWeightKg: 80.0,
        previousReps: 8,
        rpe: 8.0,
        readinessScore: 45,
      );

      expect(target.weightKg, equals(77.5));
      expect(target.recommendationReason, contains('Deload -2.5kg'));
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
