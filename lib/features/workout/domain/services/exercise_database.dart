import '../models/workout_models.dart';

class ExerciseDatabase {
  const ExerciseDatabase();

  static const List<Exercise> seededExercises = [
    // 1. Squat / Quad Dominant
    Exercise(
      id: 'ex_barbell_squat',
      name: 'Barbell Back Squat',
      nameHindi: 'बारबेल बैक स्क्वैट',
      pattern: MovementPattern.squat,
      primaryMuscle: MuscleGroup.quadriceps,
      secondaryMuscles: [MuscleGroup.hamstrings, MuscleGroup.core],
      equipment: EquipmentType.barbell,
      defaultSets: 4,
      defaultMinReps: 6,
      defaultMaxReps: 8,
      defaultRestSeconds: 120,
      formCues: [
        'Brace core using Valsalva maneuver before descent.',
        'Keep knees tracking in line with toes.',
        'Hit parallel or below depth without lumbar rounding.',
      ],
      formCuesHindi: [
        'नीचे जाने से पहले कोर को कसें।',
        'घुटनों को पंजों की सीध में रखें।',
        'पीठ को सीधा रखते हुए पर्याप्त गहराई तक जाएं।',
      ],
    ),
    Exercise(
      id: 'ex_desi_baithak',
      name: 'Desi Baithak (Hindu Squat)',
      nameHindi: 'देसी बैठक (पहलवानी स्क्वैट)',
      pattern: MovementPattern.squat,
      primaryMuscle: MuscleGroup.quadriceps,
      secondaryMuscles: [MuscleGroup.core, MuscleGroup.hamstrings],
      equipment: EquipmentType.bodyweight,
      defaultSets: 3,
      defaultMinReps: 15,
      defaultMaxReps: 25,
      defaultRestSeconds: 60,
      formCues: [
        'Inhale on the way down swinging hands back.',
        'Exhale standing up on balls of feet.',
        'Maintains incredible knee tendon resilience.',
      ],
      formCuesHindi: [
        'नीचे जाते हुए सांस लें और हाथ पीछे ले जाएं।',
        'ऊपर आते हुए सांस छोड़ें और पंजों पर खड़े हों।',
      ],
    ),

    // 2. Hinge / Posterior Chain
    Exercise(
      id: 'ex_barbell_deadlift',
      name: 'Conventional Barbell Deadlift',
      nameHindi: 'बारबेल डेडलिफ्ट',
      pattern: MovementPattern.hinge,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.hamstrings, MuscleGroup.core],
      equipment: EquipmentType.barbell,
      defaultSets: 3,
      defaultMinReps: 5,
      defaultMaxReps: 5,
      defaultRestSeconds: 180,
      formCues: [
        'Barbell touches shins at start position.',
        'Lats engaged with chest proudly upright.',
        'Push the floor away through midfoot.',
      ],
      formCuesHindi: [
        'शुरुआत में रॉड पिंडलियों से छूती रहे।',
        'छाती सीधी और रीढ़ की हड्डी न्यूट्रल रखें।',
        'पैरों से ज़मीन को धकेलते हुए वजन उठाएं।',
      ],
    ),
    Exercise(
      id: 'ex_romanian_deadlift',
      name: 'Romanian Deadlift (Dumbbell/Barbell)',
      nameHindi: 'रोमानियन डेडलिफ्ट',
      pattern: MovementPattern.hinge,
      primaryMuscle: MuscleGroup.hamstrings,
      secondaryMuscles: [MuscleGroup.back],
      equipment: EquipmentType.dumbbell,
      defaultSets: 3,
      defaultMinReps: 8,
      defaultMaxReps: 12,
      defaultRestSeconds: 90,
      formCues: [
        'Soft bend in knees, push hips back to the wall.',
        'Feel deep stretch in hamstrings before reversing.',
      ],
      formCuesHindi: [
        'घुटने थोड़े मोड़ें और कूल्हों को पीछे धकेलें।',
        'हैमस्ट्रिंग में खिंचाव महसूस करें।',
      ],
    ),

    // 3. Push / Upper Body
    Exercise(
      id: 'ex_barbell_bench_press',
      name: 'Flat Barbell Bench Press',
      nameHindi: 'बेंच प्रेस (छाती)',
      pattern: MovementPattern.push,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipment: EquipmentType.barbell,
      defaultSets: 4,
      defaultMinReps: 8,
      defaultMaxReps: 10,
      defaultRestSeconds: 90,
      formCues: [
        'Scapulae retracted and depressed into bench.',
        'Elbows tucked at approximately 45 degrees.',
        'Lower bar with control to lower sternum.',
      ],
      formCuesHindi: [
        'कंधों को पीछे खींचकर बेंच पर टिकाएं।',
        'कोहनियों को ४५ डिग्री के कोण पर रखें।',
        'रॉड को छाती के निचले हिस्से पर धीरे से लाएं।',
      ],
    ),
    Exercise(
      id: 'ex_desi_dand',
      name: 'Desi Dand (Hindu Pushup)',
      nameHindi: 'देसी दंड (पहलावान पुशअप)',
      pattern: MovementPattern.push,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.triceps, MuscleGroup.core],
      equipment: EquipmentType.bodyweight,
      defaultSets: 3,
      defaultMinReps: 10,
      defaultMaxReps: 20,
      defaultRestSeconds: 60,
      formCues: [
        'Start in downward dog position.',
        'Swoop chest low between hands and arc up to cobra.',
        'Fluid dynamic spinal mobility and shoulder strength.',
      ],
      formCuesHindi: [
        'अधोमुख श्वानासन से शुरू करें।',
        'छाती को हाथों के बीच से निकालते हुए भुजंगासन में आएं।',
      ],
    ),
    Exercise(
      id: 'ex_overhead_press',
      name: 'Standing Overhead Barbell Press',
      nameHindi: 'शोल्डर प्रेस (खड़े होकर)',
      pattern: MovementPattern.push,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.core],
      equipment: EquipmentType.barbell,
      defaultSets: 3,
      defaultMinReps: 6,
      defaultMaxReps: 8,
      defaultRestSeconds: 120,
      formCues: [
        'Squeeze glutes and brace core to prevent hyperextension.',
        'Press bar in a straight vertical path.',
      ],
      formCuesHindi: [
        'कोर और हिप्स को कसें ताकि कमर मुड़े नहीं।',
        'रॉड को सीधे ऊपर की ओर धकेलें।',
      ],
    ),

    // 4. Pull / Upper Back
    Exercise(
      id: 'ex_pull_ups',
      name: 'Overhand Pull-ups',
      nameHindi: 'पुल-अप्स',
      pattern: MovementPattern.pull,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps],
      equipment: EquipmentType.bodyweight,
      defaultSets: 3,
      defaultMinReps: 6,
      defaultMaxReps: 10,
      defaultRestSeconds: 90,
      formCues: [
        'Initiate pull by depressing scapulae.',
        'Drive elbows down towards hips until chin clears bar.',
      ],
      formCuesHindi: [
        'कंधों को नीचे दबाते हुए खींचना शुरू करें।',
        'ठोड़ी रॉड के ऊपर जाने तक कोहनियों को नीचे खींचें।',
      ],
    ),
    Exercise(
      id: 'ex_barbell_bent_row',
      name: 'Bent-Over Barbell Row',
      nameHindi: 'बेंट-ओवर बारबेल रोइंग',
      pattern: MovementPattern.pull,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.core],
      equipment: EquipmentType.barbell,
      defaultSets: 4,
      defaultMinReps: 8,
      defaultMaxReps: 12,
      defaultRestSeconds: 90,
      formCues: [
        'Maintain 45-degree torso angle with flat spine.',
        'Pull bar towards navel squeezing back at the top.',
      ],
      formCuesHindi: [
        'धड़ को ४५ डिग्री पर झुकाएं और पीठ सीधी रखें।',
        'रॉड को नाभि की तरफ खींचें और पीठ को सिकोड़ें।',
      ],
    ),

    // 5. Functional & Core
    Exercise(
      id: 'ex_surya_namaskar',
      name: 'Dynamic Surya Namaskar (Sun Salutation Flow)',
      nameHindi: 'सूर्य नमस्कार (१२ आसन प्रवाह)',
      pattern: MovementPattern.carry,
      primaryMuscle: MuscleGroup.fullBody,
      secondaryMuscles: [MuscleGroup.core, MuscleGroup.shoulders, MuscleGroup.hamstrings],
      equipment: EquipmentType.bodyweight,
      defaultSets: 3,
      defaultMinReps: 6,
      defaultMaxReps: 12,
      defaultRestSeconds: 45,
      formCues: [
        'Synchronize breath with each of the 12 transitions.',
        'Optimal for full-body cardiovascular mobility and activation.',
      ],
      formCuesHindi: [
        '१२ आसनों के साथ श्वास का समन्वय रखें।',
        'शरीर के लचीलेपन और ऊर्जा संचार के लिए सर्वोत्तम।',
      ],
    ),
  ];

  static List<Exercise> getByMuscleGroup(MuscleGroup group) {
    return seededExercises.where((e) => e.primaryMuscle == group || e.secondaryMuscles.contains(group)).toList();
  }

  static List<Exercise> getByEquipment(EquipmentType equipment) {
    return seededExercises.where((e) => e.equipment == equipment).toList();
  }
}
