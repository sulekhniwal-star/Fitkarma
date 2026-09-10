import 'dart:math';
import 'workout_models.dart';

enum RepPhase {
  setup(label: 'Setup & Ready', regionalLabel: 'तैयारी'),
  eccentric(
      label: 'Eccentric (Descent)', regionalLabel: 'नीचे जाना (नियंत्रित)'),
  peakContraction(label: 'Peak Depth / Stretch', regionalLabel: 'अधिकतम गहराई'),
  concentric(
      label: 'Concentric (Ascent)', regionalLabel: 'ऊपर उठना (विस्फोटक)'),
  lockout(label: 'Lockout & Rep Complete', regionalLabel: 'पूर्ण रेप संपन्न');

  final String label;
  final String regionalLabel;

  const RepPhase({
    required this.label,
    required this.regionalLabel,
  });
}

enum FormFeedbackTier {
  optimal(
      label: 'Optimal Technique',
      regionalLabel: 'उत्कृष्ट मुद्रा',
      colorCode: 0xff22C55E),
  warning(
      label: 'Form Alert / Minor Deviation',
      regionalLabel: 'चेतावनी / मामूली विचलन',
      colorCode: 0xffFF9100),
  fault(
      label: 'Form Fault / Safety Risk',
      regionalLabel: 'त्रुटि / सुरक्षा जोखिम',
      colorCode: 0xffEF4444);

  final String label;
  final String regionalLabel;
  final int colorCode;

  const FormFeedbackTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
  });
}

class PoseKeypoint {
  final String name;
  final double x; // 0.0 to 1.0 normalized screen coordinate
  final double y; // 0.0 to 1.0 normalized screen coordinate
  final double confidence; // 0.0 to 1.0

  const PoseKeypoint({
    required this.name,
    required this.x,
    required this.y,
    this.confidence = 0.95,
  });
}

class FormRepSummary {
  final int repNumber;
  final double eccentricSeconds;
  final double concentricSeconds;
  final double peakAngleDegrees;
  final FormFeedbackTier qualityTier;
  final String primaryFeedback;

  const FormRepSummary({
    required this.repNumber,
    required this.eccentricSeconds,
    required this.concentricSeconds,
    required this.peakAngleDegrees,
    required this.qualityTier,
    required this.primaryFeedback,
  });
}

class VisionFormAnalysisFrame {
  final Exercise exercise;
  final RepPhase currentPhase;
  final int completedReps;
  final double primaryJointAngleDegrees;
  final double secondaryJointAngleDegrees;
  final FormFeedbackTier feedbackTier;
  final String liveCue;
  final String regionalLiveCue;
  final List<FormRepSummary> loggedRepSummaries;

  const VisionFormAnalysisFrame({
    required this.exercise,
    required this.currentPhase,
    required this.completedReps,
    required this.primaryJointAngleDegrees,
    required this.secondaryJointAngleDegrees,
    required this.feedbackTier,
    required this.liveCue,
    required this.regionalLiveCue,
    required this.loggedRepSummaries,
  });
}

class ComputerVisionFormEngine {
  /// Pure Dart deterministic joint angle calculation from 3 2D keypoints (A-B-C with B as vertex)
  static double calculateJointAngle(
      PoseKeypoint a, PoseKeypoint b, PoseKeypoint c) {
    final double radians =
        atan2(c.y - b.y, c.x - b.x) - atan2(a.y - b.y, a.x - b.x);
    double angle = (radians * 180.0 / pi).abs();
    if (angle > 180.0) {
      angle = 360.0 - angle;
    }
    return double.parse(angle.toStringAsFixed(1));
  }

  /// Pure Dart deterministic evaluation of exercise biomechanical form frame
  static VisionFormAnalysisFrame analyzeExerciseFrame({
    required Exercise exercise,
    required double kneeAngle, // e.g. 180 standing -> 85 deep squat
    required double hipAngle, // e.g. 175 standing -> 60 bent over
    required int completedRepsCount,
    required List<FormRepSummary> history,
  }) {
    final name = exercise.name.toLowerCase();

    // 1. Squats / Desi Baithak Evaluation
    if (name.contains('squat') || name.contains('baithak')) {
      return _evaluateSquatFrame(
          exercise, kneeAngle, hipAngle, completedRepsCount, history);
    }

    // 2. Bench Press / Desi Dand / Pushups Evaluation
    if (name.contains('bench') ||
        name.contains('dand') ||
        name.contains('pushup')) {
      return _evaluatePushFrame(
          exercise, kneeAngle, hipAngle, completedRepsCount, history);
    }

    // Default Fallback Evaluation (RDL / Hinge)
    return _evaluateHingeFrame(
        exercise, kneeAngle, hipAngle, completedRepsCount, history);
  }

  static VisionFormAnalysisFrame _evaluateSquatFrame(
    Exercise exercise,
    double kneeAngle,
    double hipAngle,
    int completedReps,
    List<FormRepSummary> history,
  ) {
    RepPhase phase;
    FormFeedbackTier tier = FormFeedbackTier.optimal;
    String cue = 'Solid standing alignment. Initiate descent with hips.';
    String regCue = 'प्रारंभिक मुद्रा सही है। नीचे जाना शुरू करें।';

    if (kneeAngle > 160) {
      phase = RepPhase.setup;
      cue = 'Full lockout. Ready for next repetition.';
      regCue = 'पूर्ण विस्तार। अगले रेप के लिए तैयार।';
    } else if (kneeAngle > 105) {
      phase = RepPhase.eccentric;
      cue = 'Controlled descent (Keep knees tracking over toes).';
      regCue = 'नियंत्रित गति (घुटनों को पंजों की सीध में रखें)।';
    } else if (kneeAngle <= 95) {
      phase = RepPhase.peakContraction;
      if (kneeAngle <= 90) {
        cue = 'Excellent depth below parallel! Drive through midfoot.';
        regCue = 'सटीक गहराई (समानांतर से नीचे)! ऊपर उठें।';
      } else {
        tier = FormFeedbackTier.warning;
        cue = 'Near parallel depth. Descend 1 inch deeper if mobility allows.';
        regCue = 'गहराई थोड़ी कम है। १ इंच और नीचे जाएं।';
      }
    } else {
      phase = RepPhase.concentric;
      cue = 'Powerful drive! Squeeze glutes at top.';
      regCue = 'ऊपर उठें! शीर्ष पर ग्लूट्स टाइट करें।';
    }

    // Spine rounding fault check
    if (hipAngle < 45) {
      tier = FormFeedbackTier.fault;
      cue = 'Excessive forward chest pitch! Keep chest proud and brace core.';
      regCue = 'छाती अत्यधिक आगे झुक रही है! सीना तानें।';
    }

    return VisionFormAnalysisFrame(
      exercise: exercise,
      currentPhase: phase,
      completedReps: completedReps,
      primaryJointAngleDegrees: kneeAngle,
      secondaryJointAngleDegrees: hipAngle,
      feedbackTier: tier,
      liveCue: cue,
      regionalLiveCue: regCue,
      loggedRepSummaries: history,
    );
  }

  static VisionFormAnalysisFrame _evaluatePushFrame(
    Exercise exercise,
    double elbowAngle,
    double shoulderAngle,
    int completedReps,
    List<FormRepSummary> history,
  ) {
    RepPhase phase;
    FormFeedbackTier tier = FormFeedbackTier.optimal;
    String cue = 'Arms extended. Retract scapulae.';
    String regCue = 'हाथ सीधे। कंधों को पीछे खींचें।';

    if (elbowAngle > 155) {
      phase = RepPhase.lockout;
      cue = 'Top lockout. Control 2-second eccentric descent.';
      regCue = 'शीर्ष स्थिति। २-सेकंड नियंत्रित गति से नीचे आएं।';
    } else if (elbowAngle > 90) {
      phase = RepPhase.eccentric;
      cue = 'Good tuck (Keep elbows at 45–60 degrees from torso).';
      regCue = 'कोहनी ४५-६० डिग्री के कोण पर रखें।';
    } else {
      phase = RepPhase.peakContraction;
      cue = 'Full pectoral stretch achieved! Drive upward forcefully.';
      regCue = 'पूर्ण चेस्ट खिंचाव! ताकत से ऊपर धक्का दें।';
    }

    if (shoulderAngle > 85) {
      tier = FormFeedbackTier.warning;
      cue = 'Elbows flaring too wide! Tuck elbows to protect rotator cuffs.';
      regCue = 'कोहनी ज्यादा चौड़ी फैल रही है! थोड़ा अंदर समेटें।';
    }

    return VisionFormAnalysisFrame(
      exercise: exercise,
      currentPhase: phase,
      completedReps: completedReps,
      primaryJointAngleDegrees: elbowAngle,
      secondaryJointAngleDegrees: shoulderAngle,
      feedbackTier: tier,
      liveCue: cue,
      regionalLiveCue: regCue,
      loggedRepSummaries: history,
    );
  }

  static VisionFormAnalysisFrame _evaluateHingeFrame(
    Exercise exercise,
    double kneeAngle,
    double hipHingeAngle,
    int completedReps,
    List<FormRepSummary> history,
  ) {
    final RepPhase phase;
    const tier = FormFeedbackTier.optimal;
    const cue =
        'Hips hinged backward with soft knees. Feel deep hamstring stretch.';
    const regCue =
        'कूल्हों को पीछे धकेलें, हैमस्ट्रिंग्स में खिंचाव महसूस करें।';

    if (hipHingeAngle > 150) {
      phase = RepPhase.lockout;
    } else {
      phase = RepPhase.peakContraction;
    }

    return VisionFormAnalysisFrame(
      exercise: exercise,
      currentPhase: phase,
      completedReps: completedReps,
      primaryJointAngleDegrees: hipHingeAngle,
      secondaryJointAngleDegrees: kneeAngle,
      feedbackTier: tier,
      liveCue: cue,
      regionalLiveCue: regCue,
      loggedRepSummaries: history,
    );
  }
}
