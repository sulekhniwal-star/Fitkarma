import '../models/workout_models.dart';

class MovementIntelligenceEngine {
  const MovementIntelligenceEngine();

  /// Evaluate Squat depth and posture from joint angles
  FormCheckResult evaluateSquat({
    required double hipKneeAngleDeg, // ~80-90 degrees at parallel
    required double torsoInclinationDeg, // < 45 degrees upright
    required bool isHeelGrounded,
  }) {
    final List<String> cues = [];
    double score = 100.0;

    if (!isHeelGrounded) {
      score -= 25.0;
      cues.add('Heels lifting off ground: Shift weight back towards midfoot/heels.');
    }

    if (hipKneeAngleDeg > 95.0) {
      score -= 20.0;
      cues.add('Squat depth above parallel: Sink hips lower to recruit full glutes and hamstrings.');
    }

    if (torsoInclinationDeg > 50.0) {
      score -= 25.0;
      cues.add('Excessive forward torso lean (Good-morning squat): Chest up, engage lats.');
    }

    final isValid = score >= 70.0;
    String feedback = isValid
        ? 'Excellent squat biomechanics! Clean hip crease depth and vertical torso.'
        : 'Form breakdown detected. Review biomechanical cues below.';
    String feedbackHindi = isValid
        ? 'उत्कृष्ट स्क्वैट तकनीक! रीढ़ सीधी और पर्याप्त गहराई।'
        : 'तकनीक में सुधार की आवश्यकता है।';

    return FormCheckResult(
      isValid: isValid,
      scorePercent: score.clamp(0.0, 100.0),
      feedback: feedback,
      feedbackHindi: feedbackHindi,
      correctionCues: cues,
    );
  }

  /// Evaluate Bench Press elbow angle
  FormCheckResult evaluateBenchPress({
    required double elbowFlareAngleDeg, // 45-60 deg is optimal, 90 deg damages rotators
    required bool isScapulaRetracted,
  }) {
    final List<String> cues = [];
    double score = 100.0;

    if (!isScapulaRetracted) {
      score -= 30.0;
      cues.add('Shoulders not packed: Retract and depress shoulder blades into the bench.');
    }

    if (elbowFlareAngleDeg > 75.0) {
      score -= 35.0;
      cues.add('Elbows flared too wide (90°): Tuck elbows to ~45° to protect glenohumeral joint.');
    }

    final isValid = score >= 70.0;
    return FormCheckResult(
      isValid: isValid,
      scorePercent: score.clamp(0.0, 100.0),
      feedback: isValid ? 'Optimal pressing path with joint protection.' : 'Shoulder impingement risk detected.',
      feedbackHindi: isValid ? 'कंधों की सुरक्षा के साथ सही प्रेसिंग फॉर्म।' : 'कोहनियों को थोड़ा अंदर की ओर दबाएं।',
      correctionCues: cues,
    );
  }
}
