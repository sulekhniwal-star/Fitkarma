import 'package:flutter/foundation.dart';

/// Categories of major life events & lifestyle transitions
enum LifeEventCategory {
  examCrunch(
    name: 'Exam / Study Crunch Season',
    regionalName: 'परीक्षा काल एवं अध्ययन सत्र',
    description: 'High cognitive demand, sedentary study hours, mental fatigue.',
    recommendedMode: 'Brain Fuel & Cognitive Focus',
  ),
  newParenthood(
    name: 'Newborn / Early Parenthood Phase',
    regionalName: 'नवजात शिशु देखभाल चरण',
    description: 'Fragmented sleep, volatile daily schedule, time scarcity.',
    recommendedMode: 'Sleep Preservation & Micro-Workouts',
  ),
  careerShift(
    name: 'Job Transition / Startup Crunch',
    regionalName: 'नौकरी परिवर्तन / स्टार्टअप व्यस्तता',
    description: 'High workplace stress, erratic meal timings, prolonged desk hours.',
    recommendedMode: 'Stress Shield & Posture Resilience',
  ),
  relocation(
    name: 'City Relocation & Moving',
    regionalName: 'शहर स्थानांतरण व गृह प्रवेश',
    description: 'Disrupted gym access, unfamiliar local grocery sourcing, physical exertion.',
    recommendedMode: 'Minimalist Bodyweight & Sourcing Guide',
  ),
  postIllnessRecovery(
    name: 'Post-Viral / Post-Surgical Recovery',
    regionalName: 'रोगमुक्ति एवं स्वास्थ्य लाभ चरण',
    description: 'Depleted metabolic energy, elevated resting heart rate, systemic healing.',
    recommendedMode: 'Gentle Agni Rebuilding & Restorative Pranayama',
  ),
  griefRecovery(
    name: 'Bereavement & Emotional Healing',
    regionalName: 'शोक निवारण एवं भावनात्मक संतुलन',
    description: 'Suppressed appetite or emotional eating, severe autonomic strain.',
    recommendedMode: 'Compassionate Grace & Nature Grounding',
  );

  final String name;
  final String regionalName;
  final String description;
  final String recommendedMode;

  const LifeEventCategory({
    required this.name,
    required this.regionalName,
    required this.description,
    required this.recommendedMode,
  });
}

/// Life event timeline progression stage
enum TransitionPhase {
  acuteDisruption(name: 'Acute Transition (Days 1–7)', regionalName: 'प्रारंभिक उथल-पुथल चरण'),
  stabilization(name: 'Routine Stabilization (Days 8–21)', regionalName: 'संतुलन स्थापना चरण'),
  progressiveReEntry(name: 'Progressive Baseline Re-entry (Days 22+)', regionalName: 'पुनः सक्रियता चरण');

  final String name;
  final String regionalName;

  const TransitionPhase({
    required this.name,
    required this.regionalName,
  });
}

/// Pillar adjustment during life event
@immutable
class LifeEventPillarAdjustment {
  final String pillarTitle;
  final String originalTarget;
  final String adaptedTarget;
  final String rationale;
  final String regionalRationale;

  const LifeEventPillarAdjustment({
    required this.pillarTitle,
    required this.originalTarget,
    required this.adaptedTarget,
    required this.rationale,
    required this.regionalRationale,
  });
}

/// Comprehensive Life Event Adaptive Strategy Report
@immutable
class LifeEventAdaptiveReport {
  final LifeEventCategory activeEvent;
  final TransitionPhase currentPhase;
  final int daysElapsedInEvent;
  final bool isGraceStreakFreezeActive;
  final int stepGoalAdjustment; // e.g. 5,000 steps instead of 10,000
  final int workoutDurationMinutes; // e.g. 15 min instead of 60 min
  final String nutritionMode; // e.g. "Survival Maintenance & Brain Nutrition"
  final List<LifeEventPillarAdjustment> pillarAdjustments;
  final String ayurvedicNervineTonic; // e.g. Brahmi / Shankhpushpi / Ashwagandha
  final String regionalAyurvedicTonic;
  final String supportiveCoachMessage;
  final String regionalSupportiveCoachMessage;
  final DateTime generatedAt;

  const LifeEventAdaptiveReport({
    required this.activeEvent,
    required this.currentPhase,
    required this.daysElapsedInEvent,
    required this.isGraceStreakFreezeActive,
    required this.stepGoalAdjustment,
    required this.workoutDurationMinutes,
    required this.nutritionMode,
    required this.pillarAdjustments,
    required this.ayurvedicNervineTonic,
    required this.regionalAyurvedicTonic,
    required this.supportiveCoachMessage,
    required this.regionalSupportiveCoachMessage,
    required this.generatedAt,
  });
}
