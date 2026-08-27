enum BlueprintLevel { beginner, intermediate, advanced, allLevels }
enum BlueprintLocation { gym, home, hybrid }

class WorkoutBlueprint {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final int daysPerWeek;
  final int durationWeeks;
  final BlueprintLevel level;
  final BlueprintLocation location;
  final String targetGoal;
  final List<String> focusAreas;
  final String equipmentRequired;

  const WorkoutBlueprint({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.daysPerWeek,
    required this.durationWeeks,
    required this.level,
    required this.location,
    required this.targetGoal,
    required this.focusAreas,
    required this.equipmentRequired,
  });

  static const List<WorkoutBlueprint> catalog = [
    WorkoutBlueprint(
      id: 'desi_iron_4day',
      title: 'Desi Iron 4-Day Split',
      regionalTitle: 'भारतीय जिम 4-दिवसीय विभाजन',
      description: 'Classic hypertrophy & strength progression. Push / Pull / Legs / Upper split built for progressive overload.',
      daysPerWeek: 4,
      durationWeeks: 8,
      level: BlueprintLevel.intermediate,
      location: BlueprintLocation.gym,
      targetGoal: 'build_muscle',
      focusAreas: ['Chest & Triceps', 'Back & Biceps', 'Legs & Glutes', 'Shoulders & Core'],
      equipmentRequired: 'Barbell, Dumbbells, Cables, Squat Rack',
    ),
    WorkoutBlueprint(
      id: 'ghar_calisthenics_3day',
      title: 'Ghar Par Calisthenics & Dumbbell',
      regionalTitle: 'घरेलू कसरत एवं डंबल स्टार्टर',
      description: 'Zero-excuses home training. High-density fat burn paired with bodyweight and dumbbell progressive movements.',
      daysPerWeek: 3,
      durationWeeks: 6,
      level: BlueprintLevel.beginner,
      location: BlueprintLocation.home,
      targetGoal: 'fat_loss',
      focusAreas: ['Full Body Compound', 'Core & Stability', 'HIIT Finisher'],
      equipmentRequired: 'Bodyweight, Pair of Dumbbells, Yoga Mat',
    ),
    WorkoutBlueprint(
      id: 'athletic_hybrid_5day',
      title: 'Athletic Hybrid PPL & Zone 2',
      regionalTitle: 'एथलेटिक सहनशक्ति एवं दीर्घायु',
      description: 'Peak conditioning hybrid combining heavy resistance training with aerobic Zone 2 endurance base building.',
      daysPerWeek: 5,
      durationWeeks: 12,
      level: BlueprintLevel.advanced,
      location: BlueprintLocation.hybrid,
      targetGoal: 'boost_energy',
      focusAreas: ['Push Strength', 'Pull & Grip', 'Legs & Power', 'Zone 2 Running', 'Mobility'],
      equipmentRequired: 'Full Gym or Barbell + Outdoor Track',
    ),
    WorkoutBlueprint(
      id: 'desk_posture_recovery_3day',
      title: 'Desk Worker Posture & Core',
      regionalTitle: 'आसन सुधार एवं कोर मजबूती',
      description: 'Reverses forward-head posture, tight hip flexors, and lower back stiffness with restorative strength & somatic mobility.',
      daysPerWeek: 3,
      durationWeeks: 6,
      level: BlueprintLevel.allLevels,
      location: BlueprintLocation.home,
      targetGoal: 'stress_recovery',
      focusAreas: ['Thoracic Spine', 'Glute Activation', 'Deep Core', 'Neck & Scapula'],
      equipmentRequired: 'Resistance Band, Foam Roller, Bodyweight',
    ),
  ];
}
