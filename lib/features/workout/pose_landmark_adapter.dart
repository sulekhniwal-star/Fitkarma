/// §P6-F Adaptive Computer Vision Loop — Pose Landmark Adapter
///
/// Implements PoseKeypoint and PoseLandmarkAdapter for §P6-F Section 6 spec:
/// normalizes variable-fidelity skeleton outputs (33 joints or 11-joint core)
/// with camera calibration, temporal fallback, confidence filtering,
/// and 2D rotation + torso-scale normalization.
library;

import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────────────────────
// PoseKeypoint
// ─────────────────────────────────────────────────────────────────────────────

/// A single joint landmark from the MediaPipe pose detection pipeline.
class PoseKeypoint {
  const PoseKeypoint({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.score,
    this.vx = 0.0,
    this.vy = 0.0,
    this.isTracked = true,
  });

  factory PoseKeypoint.empty(int index) => PoseKeypoint(
        index: index,
        x: 0.0,
        y: 0.0,
        z: 0.0,
        score: 0.0,
        isTracked: false,
      );

  /// MediaPipe landmark index (0–32).
  final int index;
  final double x;
  final double y;
  final double z;

  /// Detection confidence score 0.0–1.0.
  final double score;

  /// Optical flow velocity X (from previous frame delta).
  final double vx;

  /// Optical flow velocity Y (from previous frame delta).
  final double vy;

  final bool isTracked;

  bool get isEmpty => !isTracked && x == 0.0 && y == 0.0;

  PoseKeypoint copyWith({
    double? x,
    double? y,
    double? z,
    double? vx,
    double? vy,
  }) {
    return PoseKeypoint(
      index: index,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      score: score,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      isTracked: isTracked,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PoseLandmarkAdapter (§P6-F Section 6 Specification)
// ─────────────────────────────────────────────────────────────────────────────

class PoseLandmarkAdapter {
  /// Core 11+2 joint indices retained in downsampled thermal modes.
  /// Nose (0), Shoulders (11,12), Elbows (13,14), Wrists (15,16),
  /// Hips (23,24), Knees (25,26), Ankles (27,28).
  static const Set<int> coreIndices = {
    0, 11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28,
  };

  /// Minimum landmark confidence score to treat as tracked.
  static const double _minConfidence = 0.5;

  double _cameraTiltAngleRad = 0.0;
  double _torsoScaleFactor = 1.0;
  bool _isCalibrated = false;

  /// Calibrates the adapter using a full-fidelity reference pose.
  /// Extracts camera roll angle from shoulder slope and torso scale factor
  /// from shoulder-to-hip midpoint distance.
  void calibrateCamera(List<PoseKeypoint> calibrationPose) {
    if (calibrationPose.length < 33) return;

    final leftShoulder  = calibrationPose[11];
    final rightShoulder = calibrationPose[12];
    final leftHip       = calibrationPose[23];
    final rightHip      = calibrationPose[24];

    if (leftShoulder.isEmpty || rightShoulder.isEmpty ||
        leftHip.isEmpty || rightHip.isEmpty) {
      return;
    }

    // 1. Camera roll (tilt) from shoulder slope dy/dx
    final dx = leftShoulder.x - rightShoulder.x;
    final dy = leftShoulder.y - rightShoulder.y;
    _cameraTiltAngleRad = math.atan2(dy, dx);

    // 2. Torso scale from shoulder-midpoint to hip-midpoint distance
    final shoulderMidX = (leftShoulder.x + rightShoulder.x) / 2.0;
    final shoulderMidY = (leftShoulder.y + rightShoulder.y) / 2.0;
    final hipMidX = (leftHip.x + rightHip.x) / 2.0;
    final hipMidY = (leftHip.y + rightHip.y) / 2.0;

    final torsoHeight = math.sqrt(
      math.pow(shoulderMidX - hipMidX, 2.0) +
      math.pow(shoulderMidY - hipMidY, 2.0),
    );

    if (torsoHeight > 0.0) {
      _torsoScaleFactor = torsoHeight;
      _isCalibrated = true;
    }
  }

  /// Normalizes incoming landmarks to a stable 33-joint skeleton.
  ///
  /// Steps (§P6-F spec):
  /// 1. Confidence filter: joints < 0.5 confidence → empty.
  /// 2. Temporal fallback: carry previous-frame coordinates (freeze velocity).
  /// 3. Rotation correction: apply negative camera tilt rotation around nose origin.
  /// 4. Scale normalization: divide translated coordinates by torso height.
  List<PoseKeypoint> normalize({
    required List<PoseKeypoint> incomingLandmarks,
    List<PoseKeypoint>? lastFrameLandmarks,
  }) {
    // Build standard 33-joint skeleton
    final skeleton = List<PoseKeypoint>.generate(33, (index) {
      final currentMatch = incomingLandmarks.firstWhere(
        (kp) => kp.index == index && kp.isTracked,
        orElse: () => PoseKeypoint.empty(index),
      );

      // Keep high-confidence current detections
      if (!currentMatch.isEmpty && currentMatch.score >= _minConfidence) {
        return currentMatch;
      }

      // Temporal fallback — carry previous frame coordinates, freeze velocity
      if (lastFrameLandmarks != null && lastFrameLandmarks.length == 33) {
        final prev = lastFrameLandmarks[index];
        if (!prev.isEmpty) return prev.copyWith(vx: 0.0, vy: 0.0);
      }

      return PoseKeypoint.empty(index);
    });

    // Cannot normalize without calibration or nose reference
    if (!_isCalibrated || skeleton[0].isEmpty) return skeleton;

    // Geometric normalization: rotation + scale around nose origin
    final cosA = math.cos(-_cameraTiltAngleRad);
    final sinA = math.sin(-_cameraTiltAngleRad);
    final originX = skeleton[0].x;
    final originY = skeleton[0].y;

    return skeleton.map((kp) {
      if (kp.isEmpty) return kp;

      final tx = kp.x - originX;
      final ty = kp.y - originY;

      final rotX = tx * cosA - ty * sinA;
      final rotY = tx * sinA + ty * cosA;

      return kp.copyWith(
        x: (rotX / _torsoScaleFactor) + originX,
        y: (rotY / _torsoScaleFactor) + originY,
      );
    }).toList();
  }

  bool get isCalibrated => _isCalibrated;
}
