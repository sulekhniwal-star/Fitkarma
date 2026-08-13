enum InteractionSeverity { low, moderate, high }

class MedicationSchedule {
  final String localId;
  final String medicationName;
  final String dosage;
  final List<String> scheduledTimes; // e.g. ['08:00', '20:00']
  final List<int> daysOfWeek; // 1-7 (Mon-Sun)
  final DateTime startDate;
  final DateTime? endDate;
  final bool requiresFood;
  final String? rxcui;

  const MedicationSchedule({
    required this.localId,
    required this.medicationName,
    required this.dosage,
    required this.scheduledTimes,
    required this.daysOfWeek,
    required this.startDate,
    this.endDate,
    this.requiresFood = false,
    this.rxcui,
  });
}

class MealSnapshot {
  final String mealName;
  final double carbsGrams;
  final List<String> foodItems;

  const MealSnapshot({
    required this.mealName,
    required this.carbsGrams,
    required this.foodItems,
  });
}

enum WorkoutIntensityLevel { low, moderate, high }

class InteractionWarning {
  final InteractionSeverity severity;
  final String message;
  final String sourceMedication;

  const InteractionWarning({
    required this.severity,
    required this.message,
    required this.sourceMedication,
  });
}

/// Pure-Dart Drug & Medication Interaction Engine per §P10-I spec
/// Evaluates drug-nutrient (dietary) and drug-workout (training) conflicts locally.
class DrugInteractionEngine {
  const DrugInteractionEngine();

  List<InteractionWarning> checkSchedule(
    MedicationSchedule med,
    MealSnapshot currentMeal,
    WorkoutIntensityLevel proposedWorkout,
  ) {
    final warnings = <InteractionWarning>[];
    final medLower = med.medicationName.toLowerCase();

    // Case 1: Metformin + high simple carbs (>80g)
    if ((medLower.contains('metformin') || medLower.contains('glycomet') || medLower.contains('glucophage')) &&
        currentMeal.carbsGrams > 80.0) {
      warnings.add(InteractionWarning(
        severity: InteractionSeverity.moderate,
        sourceMedication: med.medicationName,
        message: 'Metformin combined with high simple carbs (>80g) can trigger rapid glucose swings and GI discomfort. Balance your plate with protein.',
      ));
    }

    // Case 2: Statins (Atorvastatin/Atorva/Lipitor) + Citrus / Grapefruit
    if ((medLower.contains('statin') || medLower.contains('atorva') || medLower.contains('lipitor')) &&
        currentMeal.foodItems.any((item) => item.toLowerCase().contains('grapefruit') || item.toLowerCase().contains('citrus'))) {
      warnings.add(InteractionWarning(
        severity: InteractionSeverity.high,
        sourceMedication: med.medicationName,
        message: 'Grapefruit compounds inhibit metabolic enzymes, raising statin concentration in blood. Avoid grapefruit while on statins.',
      ));
    }

    // Case 3: Beta-blockers (Metoprolol/Ciplar/Propranolol) + High intensity exercise
    if ((medLower.contains('metoprolol') || medLower.contains('ciplar') || medLower.contains('propranolol')) &&
        proposedWorkout == WorkoutIntensityLevel.high) {
      warnings.add(InteractionWarning(
        severity: InteractionSeverity.moderate,
        sourceMedication: med.medicationName,
        message: 'Beta-blockers blunt heart rate response. Do not rely on target HR zones today; use RPE (Rate of Perceived Exertion) to gauge intensity.',
      ));
    }

    return warnings;
  }
}

/// External NIH RxNav API Service & Offline Mapping Dictionary per §P10-I spec (Pure Dart)
class RxNavInteractionService {
  static const Map<String, String> indianBrandToRxcuiSeed = {
    'glycomet': '22501',   // Metformin
    'atorva': '83367',     // Atorvastatin
    'thyronorm': '10582',   // Levothyroxine
    'pan': '1364230',      // Pantoprazole
    'pantocid': '1364230',  // Pantoprazole
    'ciplar': '8745',       // Propranolol
    'glucophage': '22501',  // Metformin
    'lipitor': '83367',     // Atorvastatin
    'augmentin': '313988',  // Amoxicillin + Clavulanate
  };

  const RxNavInteractionService();

  String? resolveOfflineRxcui(String brandName) {
    final lower = brandName.trim().toLowerCase();
    for (final entry in indianBrandToRxcuiSeed.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  List<InteractionWarning> fetchInteractionsOffline(List<MedicationSchedule> medications, MealSnapshot meal, WorkoutIntensityLevel workout) {
    const engine = DrugInteractionEngine();
    final allWarnings = <InteractionWarning>[];

    for (final med in medications) {
      final warnings = engine.checkSchedule(med, meal, workout);
      allWarnings.addAll(warnings);
    }

    return allWarnings;
  }
}
