import 'dart:math';

class PoseKeypoint {
  final int index;
  final double x;
  final double y;
  final double z;
  final double score;
  final double vx; // Velocity X
  final double vy; // Velocity Y
  final bool isTracked;

  PoseKeypoint({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.score,
    this.vx = 0.0,
    this.vy = 0.0,
    this.isTracked = true,
  });

  factory PoseKeypoint.empty(int index) =>
      PoseKeypoint(index: index, x: 0, y: 0, z: 0, score: 0, isTracked: false);

  bool get isEmpty => !isTracked && x == 0 && y == 0;

  PoseKeypoint copyWith({double? vx, double? vy}) {
    return PoseKeypoint(
      index: index,
      x: x,
      y: y,
      z: z,
      score: score,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      isTracked: isTracked,
    );
  }
}

/// Pure-Dart Pose Landmark Adapter per §P6-F spec
class PoseLandmarkAdapter {
  /// Standard MediaPipe landmarks retained in downsampled modes:
  /// Nose (0), Shoulders (11, 12), Elbows (13, 14), Wrists (15, 16),
  /// Hips (23, 24), Knees (25, 26), Ankles (27, 28).
  static const Set<int> coreIndices = {
    0,
    11,
    12,
    13,
    14,
    15,
    16,
    23,
    24,
    25,
    26,
    27,
    28
  };

  double _cameraTiltAngleRad = 0.0;
  double _torsoScaleFactor = 1.0;
  bool _isCalibrated = false;

  bool get isCalibrated => _isCalibrated;

  /// Calibrates the camera roll and height/distance scale factor using shoulder/hip coordinates
  void calibrateCamera(List<PoseKeypoint> calibrationPose) {
    if (calibrationPose.length < 33) return;

    final leftShoulder = calibrationPose[11];
    final rightShoulder = calibrationPose[12];
    final leftHip = calibrationPose[23];
    final rightHip = calibrationPose[24];

    if (leftShoulder.isEmpty ||
        rightShoulder.isEmpty ||
        leftHip.isEmpty ||
        rightHip.isEmpty) {
      return; // Cannot calibrate with missing reference landmarks
    }

    // Calculate shoulder tilt angle
    final dx = rightShoulder.x - leftShoulder.x;
    final dy = rightShoulder.y - leftShoulder.y;
    _cameraTiltAngleRad = atan2(dy, dx);

    // Calculate torso height scale
    final midShoulderY = (leftShoulder.y + rightShoulder.y) / 2.0;
    final midHipY = (leftHip.y + rightHip.y) / 2.0;
    final torsoLen = (midHipY - midShoulderY).abs();

    _torsoScaleFactor = torsoLen > 0 ? 100.0 / torsoLen : 1.0;
    _isCalibrated = true;
  }

  /// Downsamples raw 33 MediaPipe landmarks to 11 core joints or applies downsampling matrix
  List<PoseKeypoint> filterAndNormalizeLandmarks({
    required List<PoseKeypoint> rawLandmarks,
    required bool isDownsampledMode,
  }) {
    if (rawLandmarks.isEmpty) return [];

    final normalized = <PoseKeypoint>[];

    for (int i = 0; i < rawLandmarks.length; i++) {
      final keypoint = rawLandmarks[i];

      // If in downsampled mode and keypoint is non-core, zero it out safely
      if (isDownsampledMode && !coreIndices.contains(i)) {
        normalized.add(PoseKeypoint.empty(i));
        continue;
      }

      if (!_isCalibrated || keypoint.isEmpty) {
        normalized.add(keypoint);
        continue;
      }

      // Apply camera tilt compensation
      final cosT = cos(-_cameraTiltAngleRad);
      final sinT = sin(-_cameraTiltAngleRad);

      final rx = (keypoint.x * cosT) - (keypoint.y * sinT);
      final ry = (keypoint.x * sinT) + (keypoint.y * cosT);

      normalized.add(PoseKeypoint(
        index: keypoint.index,
        x: rx * _torsoScaleFactor,
        y: ry * _torsoScaleFactor,
        z: keypoint.z,
        score: keypoint.score,
        vx: keypoint.vx,
        vy: keypoint.vy,
        isTracked: keypoint.isTracked,
      ));
    }

    return normalized;
  }
}
