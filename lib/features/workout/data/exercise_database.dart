import '../domain/workout_models.dart';

class ExerciseDatabase {
  static const List<Exercise> exercises = [
    // Chest
    Exercise(
      id: 'ex_barbell_bench_press',
      name: 'Flat Barbell Bench Press',
      regionalName: 'फ्लैट बारबेल बेंच प्रेस',
      targetMuscle: MuscleGroup.chest,
      equipment: EquipmentType.barbell,
      instructions: 'Retract scapulae, touch lower sternum with controlled tempo, drive upward without flaring elbows.',
    ),
    Exercise(
      id: 'ex_incline_dumbbell_press',
      name: 'Incline Dumbbell Press',
      regionalName: 'इनक्लाइन डंबल प्रेस',
      targetMuscle: MuscleGroup.chest,
      equipment: EquipmentType.dumbbell,
      instructions: 'Set bench at 30 degrees, press upward convergent path, focus on clavicular pec fibers.',
    ),
    Exercise(
      id: 'ex_hindu_pushups',
      name: 'Desi Dand (Hindu Pushups)',
      regionalName: 'देसी दंड (पारंपरिक व्यायाम)',
      targetMuscle: MuscleGroup.chest,
      equipment: EquipmentType.traditionalIndian,
      instructions: 'Start in downward dog, swoop chest close to floor into upward cobra, return in reverse wave.',
    ),

    // Back
    Exercise(
      id: 'ex_lat_pulldown',
      name: 'Lat Pulldown (Neutral Grip)',
      regionalName: 'लैट पुलडाउन',
      targetMuscle: MuscleGroup.back,
      equipment: EquipmentType.cable,
      instructions: 'Pull with elbows down to ribcage, squeeze lats for 1 second at bottom, control 2s eccentric.',
    ),
    Exercise(
      id: 'ex_barbell_bent_row',
      name: 'Barbell Bent-Over Row',
      regionalName: 'बारबेल बेंट ओवर रो',
      targetMuscle: MuscleGroup.back,
      equipment: EquipmentType.barbell,
      instructions: 'Hinge at hips at 45 degrees, pull bar to upper navel, engaging middle trapezius and rhomboids.',
    ),

    // Legs
    Exercise(
      id: 'ex_barbell_back_squat',
      name: 'Barbell Back Squat',
      regionalName: 'बारबेल बैक स्क्वैट',
      targetMuscle: MuscleGroup.quads,
      equipment: EquipmentType.barbell,
      instructions: 'Brace core with intra-abdominal pressure, break at hips and knees, descend below parallel.',
    ),
    Exercise(
      id: 'ex_desi_baithak',
      name: 'Desi Baithak (Deep Indian Squats)',
      regionalName: 'देसी बैठक (पहलवानी स्क्वैट्स)',
      targetMuscle: MuscleGroup.quads,
      equipment: EquipmentType.traditionalIndian,
      instructions: 'Full range deep squat with heel raise at bottom and arm swing rhythm as in traditional Akharas.',
    ),
    Exercise(
      id: 'ex_romanian_deadlift',
      name: 'Romanian Deadlift (RDL)',
      regionalName: 'रोमानियन डेडलिफ्ट',
      targetMuscle: MuscleGroup.hamstrings,
      equipment: EquipmentType.barbell,
      instructions: 'Push hips backward with soft knees, feel deep hamstring stretch below knees, drive hips forward.',
    ),

    // Shoulders
    Exercise(
      id: 'ex_overhead_press',
      name: 'Standing Overhead Barbell Press',
      regionalName: 'ओवरहेड बारबेल प्रेस',
      targetMuscle: MuscleGroup.shoulders,
      equipment: EquipmentType.barbell,
      instructions: 'Squeeze glutes and core, press vertically in tight line around face, lock out overhead.',
    ),
    Exercise(
      id: 'ex_cable_lateral_raise',
      name: 'Cable Lateral Raise',
      regionalName: 'केबल लेटरल रेज़',
      targetMuscle: MuscleGroup.shoulders,
      equipment: EquipmentType.cable,
      instructions: 'Set pulley at wrist height, lead with elbows to shoulder height for isolated lateral delt stimulus.',
    ),
    Exercise(
      id: 'ex_mudgar_swing',
      name: 'Mudgar / Karlakattai Swing (Indian Club)',
      regionalName: 'मुद्गर / गदा घुमाना',
      targetMuscle: MuscleGroup.shoulders,
      equipment: EquipmentType.traditionalIndian,
      instructions: 'Rotate heavy wooden club around shoulders in 360 circular arch for rotational shoulder stability.',
    ),

    // Arms
    Exercise(
      id: 'ex_incline_dumbbell_curl',
      name: 'Incline Dumbbell Bicep Curl',
      regionalName: 'इनक्लाइन डंबल कर्ल',
      targetMuscle: MuscleGroup.arms,
      equipment: EquipmentType.dumbbell,
      instructions: 'Sit on incline bench to place bicep long head in full stretch, curl without moving elbows.',
    ),
    Exercise(
      id: 'ex_tricep_rope_pushdown',
      name: 'Tricep Rope Pushdown',
      regionalName: 'ट्राइसेप रोप पुशडाउन',
      targetMuscle: MuscleGroup.arms,
      equipment: EquipmentType.cable,
      instructions: 'Keep elbows pinned to sides, push rope down and spread handles apart at peak contraction.',
    ),

    // Core
    Exercise(
      id: 'ex_hanging_leg_raise',
      name: 'Hanging Leg / Knee Raise',
      regionalName: 'हैंगिंग लेग रेज़',
      targetMuscle: MuscleGroup.core,
      equipment: EquipmentType.bodyweight,
      instructions: 'Hang from pull-up bar, posterior pelvic tilt, curl knees up to chest without swinging.',
    ),
  ];

  static Exercise getById(String id) {
    return exercises.firstWhere(
      (e) => e.id == id,
      orElse: () => exercises.first,
    );
  }

  static List<Exercise> search(String query) {
    if (query.isEmpty) return exercises;
    final q = query.toLowerCase();
    return exercises.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.regionalName.contains(q) ||
          e.targetMuscle.name.toLowerCase().contains(q);
    }).toList();
  }
}
