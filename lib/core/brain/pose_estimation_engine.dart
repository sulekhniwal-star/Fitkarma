import 'dart:math';

/// Joint Angle Analysis Result
class PoseAngleResult {
  final double kneeAngleDegrees;
  final double hipAngleDegrees;
  final double asymmetryOffsetDegrees; // Left vs Right discrepancy
  final String formFeedback;

  const PoseAngleResult({
    required this.kneeAngleDegrees,
    required this.hipAngleDegrees,
    required this.asymmetryOffsetDegrees,
    required this.formFeedback,
  });
}

/// MediaPipe On-Device Pose Estimation & Joint Angle Engine
class PoseEstimationEngine {
  const PoseEstimationEngine();

  /// Calculate 3-point joint angle in degrees (e.g. Hip -> Knee -> Ankle)
  double calculateJointAngle({
    required Point<double> p1,
    required Point<double> p2,
    required Point<double> p3,
  }) {
    final radians = atan2(p3.y - p2.y, p3.x - p2.x) - atan2(p1.y - p2.y, p1.x - p2.x);
    double degrees = (radians * 180.0 / pi).abs();
    if (degrees > 180.0) {
      degrees = 360.0 - degrees;
    }
    return degrees;
  }

  /// Analyze movement symmetry and joint angles
  PoseAngleResult analyzeSquatForm({
    required double leftKneeAngle,
    required double rightKneeAngle,
    required double hipAngle,
  }) {
    final asymmetry = (leftKneeAngle - rightKneeAngle).abs();
    String feedback;

    if (asymmetry > 12.0) {
      feedback = 'Movement Asymmetry Detected: Shift weight evenly to balance left/right knees.';
    } else if (leftKneeAngle < 90.0) {
      feedback = 'Good Depth: Parallel squat depth achieved.';
    } else {
      feedback = 'Depth Alert: Descend slightly lower to reach 90-degree knee flex.';
    }

    return PoseAngleResult(
      kneeAngleDegrees: (leftKneeAngle + rightKneeAngle) / 2,
      hipAngleDegrees: hipAngle,
      asymmetryOffsetDegrees: asymmetry,
      formFeedback: feedback,
    );
  }
}
