enum LifeEventType {
  wedding,
  examSeason,
  travelAbroad,
  travelDomestic,
  ramadan,
  shiftWork,
  nightShift,
  injury,
  newBaby,
  officeDeadline,
  relocation,
  grief,
  illness,
}

class LifeEvent {
  final String id;
  final String title;
  final LifeEventType type;
  final DateTime startDate;
  final DateTime? endDate;
  final String? injuredRegion;
  final String? timezone;

  const LifeEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    this.endDate,
    this.injuredRegion,
    this.timezone,
  });
}

class LifeEventAdaptation {
  final int workoutDurationMins;
  final String workoutFocus;
  final bool isRecoveryFirst;
  final int calorieBuffer;
  final bool simplifyNutrition;
  final double hydrationMultiplier;
  final String sleepStrategy;
  final String coachTone;
  final String DIPPriority;

  const LifeEventAdaptation({
    required this.workoutDurationMins,
    required this.workoutFocus,
    required this.isRecoveryFirst,
    required this.calorieBuffer,
    required this.simplifyNutrition,
    required this.hydrationMultiplier,
    required this.sleepStrategy,
    required this.coachTone,
    required this.DIPPriority,
  });

  factory LifeEventAdaptation.standard() {
    return const LifeEventAdaptation(
      workoutDurationMins: 45,
      workoutFocus: 'Full program',
      isRecoveryFirst: false,
      calorieBuffer: 0,
      simplifyNutrition: false,
      hydrationMultiplier: 1.0,
      sleepStrategy: 'Standard 7-8h bedtime',
      coachTone: 'Balanced',
      DIPPriority: 'Balanced progression',
    );
  }

  factory LifeEventAdaptation.injury({String? region}) {
    return LifeEventAdaptation(
      workoutDurationMins: 20,
      workoutFocus: region != null ? 'Uninjured limbs only ($region isolated)' : 'Rehab & gentle mobility',
      isRecoveryFirst: true,
      calorieBuffer: 100, // Healing maintenance buffer
      simplifyNutrition: true,
      hydrationMultiplier: 1.2,
      sleepStrategy: 'Extended tissue repair sleep (8-9h)',
      coachTone: 'Empathetic & safety-first',
      DIPPriority: 'Injury isolation & recovery',
    );
  }

  factory LifeEventAdaptation.travel({String? timezone}) {
    return LifeEventAdaptation(
      workoutDurationMins: 20,
      workoutFocus: 'Bodyweight hotel circuit & mobility',
      isRecoveryFirst: true,
      calorieBuffer: 200,
      simplifyNutrition: true,
      hydrationMultiplier: 1.4, // Jet lag hydration
      sleepStrategy: 'Circadian anchor timing ${timezone ?? 'local time'}',
      coachTone: 'Adaptable & encouraging',
      DIPPriority: 'Jet lag & circadian alignment',
    );
  }

  factory LifeEventAdaptation.deadline() {
    return const LifeEventAdaptation(
      workoutDurationMins: 15,
      workoutFocus: 'Quick 15-min high-efficiency HIIT',
      isRecoveryFirst: false,
      calorieBuffer: 100,
      simplifyNutrition: true,
      hydrationMultiplier: 1.1,
      sleepStrategy: 'Power naps & deep sleep optimization',
      coachTone: 'Focused & efficient',
      DIPPriority: 'Time-compressed consistency',
    );
  }

  factory LifeEventAdaptation.newBaby() {
    return const LifeEventAdaptation(
      workoutDurationMins: 15,
      workoutFocus: 'Low-friction home movement when baby sleeps',
      isRecoveryFirst: true,
      calorieBuffer: 150,
      simplifyNutrition: true,
      hydrationMultiplier: 1.2,
      sleepStrategy: 'Polyphasic sleep logging & recovery priority',
      coachTone: 'Supportive & non-judgmental',
      DIPPriority: 'Parental stress & fatigue mitigation',
    );
  }

  factory LifeEventAdaptation.examSeason() {
    return const LifeEventAdaptation(
      workoutDurationMins: 20,
      workoutFocus: 'Mental refresh walk & quick circuit',
      isRecoveryFirst: true,
      calorieBuffer: 100,
      simplifyNutrition: true,
      hydrationMultiplier: 1.1,
      sleepStrategy: 'Strict 7h memory consolidation cutoff',
      coachTone: 'Calming & encouraging',
      DIPPriority: 'Cognitive energy maintenance',
    );
  }

  factory LifeEventAdaptation.shiftWork() {
    return const LifeEventAdaptation(
      workoutDurationMins: 30,
      workoutFocus: 'Shift-aligned strength maintenance',
      isRecoveryFirst: true,
      calorieBuffer: 0,
      simplifyNutrition: true,
      hydrationMultiplier: 1.2,
      sleepStrategy: 'Dark room circadian shift protocol',
      coachTone: 'Adaptive',
      DIPPriority: 'Circadian shift realignment',
    );
  }
}

/// Pure-Dart Life Events Engine per §P12-B spec
class LifeEventsEngine {
  const LifeEventsEngine();

  LifeEventAdaptation adapt(LifeEvent event) {
    switch (event.type) {
      case LifeEventType.injury:
        return LifeEventAdaptation.injury(region: event.injuredRegion);

      case LifeEventType.travelAbroad:
      case LifeEventType.travelDomestic:
        return LifeEventAdaptation.travel(timezone: event.timezone);

      case LifeEventType.officeDeadline:
        return LifeEventAdaptation.deadline();

      case LifeEventType.newBaby:
        return LifeEventAdaptation.newBaby();

      case LifeEventType.examSeason:
        return LifeEventAdaptation.examSeason();

      case LifeEventType.shiftWork:
      case LifeEventType.nightShift:
        return LifeEventAdaptation.shiftWork();

      case LifeEventType.wedding:
        return const LifeEventAdaptation(
          workoutDurationMins: 30,
          workoutFocus: 'Tone & skin glow cardio/HIIT',
          isRecoveryFirst: false,
          calorieBuffer: 0,
          simplifyNutrition: false,
          hydrationMultiplier: 1.3,
          sleepStrategy: 'Beauty sleep & stress management',
          coachTone: 'Festive & high-accountability',
          DIPPriority: 'Wedding prep transformation',
        );

      case LifeEventType.ramadan:
        return const LifeEventAdaptation(
          workoutDurationMins: 25,
          workoutFocus: 'Light pre-Sehri / post-Iftar movement',
          isRecoveryFirst: true,
          calorieBuffer: 0,
          simplifyNutrition: true,
          hydrationMultiplier: 1.5,
          sleepStrategy: 'Split night sleep schedule',
          coachTone: 'Mindful',
          DIPPriority: 'Fasting energy preservation',
        );

      case LifeEventType.relocation:
      case LifeEventType.grief:
      case LifeEventType.illness:
        return const LifeEventAdaptation(
          workoutDurationMins: 15,
          workoutFocus: 'Gentle restorative movement & walks',
          isRecoveryFirst: true,
          calorieBuffer: 200,
          simplifyNutrition: true,
          hydrationMultiplier: 1.2,
          sleepStrategy: 'Maximum rest & stress recovery',
          coachTone: 'Gentle & compassionate',
          DIPPriority: 'Emotional & physical recovery',
        );
    }
  }
}
