/// §P6-F Adaptive Computer Vision Loop — Form Deviation Detector
///
/// Computes real-time form quality scores and actionable cues from normalized
/// [PoseKeypoint] skeleton streams. Adjusts scoring confidence based on active
/// [ThermalWorkloadState].
library;

import 'dart:math' as math;

import 'package:fitkarma/features/workout/pose_landmark_adapter.dart';
import 'package:fitkarma/features/workout/thermal_frame_processor.dart';
import 'package:fitkarma/features/workout/training_os_engine.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Output Model
// ─────────────────────────────────────────────────────────────────────────────

/// Real-time form quality evaluation for the current frame/rep.
class FormQualityScore {
  const FormQualityScore({
    required this.overallScore,
    required this.kneeValgusFlag,
    required this.heelLiftFlag,
    required this.squatDepthAngle,
    required this.asymmetryDeltaPct,
    required this.feedback,
    required this.trackedJointCount,
    required this.thermalState,
  });

  /// 0–100 form score.
  final int overallScore;

  /// True if knees collapse inward beyond threshold.
  final bool kneeValgusFlag;

  /// True if heels lift off the floor during squat bottom.
  final bool heelLiftFlag;

  /// Joint angle in degrees at bottom position (≥90° parallel).
  final double squatDepthAngle;

  /// Left/right joint angle delta percentage.
  final double asymmetryDeltaPct;

  /// Short actionable coaching cue.
  final String feedback;

  /// Number of tracked joint landmarks (33 in normal/moderate, 11 in severe/critical).
  final int trackedJointCount;

  final ThermalWorkloadState thermalState;

  bool get isFormGood => overallScore >= 80;
  bool get isFormWarning => overallScore >= 60 && overallScore < 80;
  bool get isFormPoor => overallScore < 60;
}

// ─────────────────────────────────────────────────────────────────────────────
// FormDeviationDetector Engine
// ─────────────────────────────────────────────────────────────────────────────

class FormDeviationDetector {
  const FormDeviationDetector();

  /// Analyzes a normalized 33-joint skeleton stream for form deviations.
  FormQualityScore analyze({
    required List<PoseKeypoint> skeleton,
    required ThermalWorkloadState thermalState,
  }) {
    if (skeleton.length < 33) {
      return FormQualityScore(
        overallScore: 100,
        kneeValgusFlag: false,
        heelLiftFlag: false,
        squatDepthAngle: 90.0,
        asymmetryDeltaPct: 0.0,
        feedback: 'Position camera to capture full body skeleton.',
        trackedJointCount: skeleton.where((k) => k.isTracked).length,
        thermalState: thermalState,
      );
    }

    final hipLeft = skeleton[23];
    final hipRight = skeleton[24];
    final kneeLeft = skeleton[25];
    final kneeRight = skeleton[26];
    final ankleLeft = skeleton[27];
    final ankleRight = skeleton[28];

    // Count active tracked joints
    final trackedCount = skeleton.where((k) => k.isTracked).length;

    // 1. Compute Knee Angle (Left & Right)
    final leftKneeAngle = _computeJointAngle(hipLeft, kneeLeft, ankleLeft);
    final rightKneeAngle = _computeJointAngle(hipRight, kneeRight, ankleRight);
    final minKneeAngle = math.min(leftKneeAngle, rightKneeAngle);

    // 2. Compute Asymmetry Delta %
    final maxKneeAngle = math.max(leftKneeAngle, rightKneeAngle);
    final asymmetryDeltaPct = maxKneeAngle > 0.0
        ? ((leftKneeAngle - rightKneeAngle).abs() / maxKneeAngle) * 100.0
        : 0.0;

    // 3. Knee Valgus Detection (distance ratio between knees vs ankles/hips)
    bool kneeValgusFlag = false;
    if (kneeLeft.isTracked && kneeRight.isTracked && ankleLeft.isTracked && ankleRight.isTracked) {
      final kneeDistance = (kneeLeft.x - kneeRight.x).abs();
      final ankleDistance = (ankleLeft.x - ankleRight.x).abs();
      if (ankleDistance > 0.0 && kneeDistance / ankleDistance < 0.65) {
        kneeValgusFlag = true;
      }
    }

    // 4. Heel Lift Detection (vertical position of ankle relative to foot baseline)
    bool heelLiftFlag = false;
    if (ankleLeft.isTracked && ankleRight.isTracked) {
      if (ankleLeft.y < ankleRight.y - 0.08 || ankleRight.y < ankleLeft.y - 0.08) {
        heelLiftFlag = true;
      }
    }

    // 5. Score Calculation
    int penalty = 0;
    final feedbackList = <String>[];

    if (kneeValgusFlag) {
      penalty += 25;
      feedbackList.add('Push knees outward');
    }
    if (heelLiftFlag) {
      penalty += 20;
      feedbackList.add('Keep heels flat on ground');
    }
    if (minKneeAngle < 80.0) {
      penalty += 15;
      feedbackList.add('Hit parallel depth');
    }
    if (asymmetryDeltaPct > 12.0) {
      penalty += 15;
      feedbackList.add('Distribute weight evenly on both legs');
    }

    final overallScore = (100 - penalty).clamp(0, 100);

    String feedback = 'Great form! Keep going.';
    if (feedbackList.isNotEmpty) {
      feedback = feedbackList.first;
    }

    return FormQualityScore(
      overallScore: overallScore,
      kneeValgusFlag: kneeValgusFlag,
      heelLiftFlag: heelLiftFlag,
      squatDepthAngle: minKneeAngle,
      asymmetryDeltaPct: asymmetryDeltaPct,
      feedback: feedback,
      trackedJointCount: trackedCount,
      thermalState: thermalState,
    );
  }

  /// Converts a FormQualityScore into a §P6-E FormAnalysisResult.
  FormAnalysisResult toFormAnalysisResult(FormQualityScore score) {
    return FormAnalysisResult(
      kneeValgusDetected: score.kneeValgusFlag,
      heelLiftDetected: score.heelLiftFlag,
      squatDepthAngle: score.squatDepthAngle,
      leftAngleDeg: score.squatDepthAngle,
      rightAngleDeg: score.squatDepthAngle * (1.0 - (score.asymmetryDeltaPct / 100.0)),
    );
  }

  double _computeJointAngle(PoseKeypoint a, PoseKeypoint b, PoseKeypoint c) {
    if (!a.isTracked || !b.isTracked || !c.isTracked) return 90.0;

    final abX = a.x - b.x;
    final abY = a.y - b.y;
    final cbX = c.x - b.x;
    final cbY = c.y - b.y;

    final dot = abX * cbX + abY * cbY;
    final magAB = math.sqrt(abX * abX + abY * abY);
    final magCB = math.sqrt(cbX * cbX + cbY * cbY);

    if (magAB == 0.0 || magCB == 0.0) return 90.0;

    final cosTheta = (dot / (magAB * magCB)).clamp(-1.0, 1.0);
    return math.acos(cosTheta) * (180.0 / math.pi);
  }
}
