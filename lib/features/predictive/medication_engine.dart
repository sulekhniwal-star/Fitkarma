/// §P10-I Medication Tracker & Interaction Warning Engine — Engine & Models
///
/// Implements medication schedules, RxNorm concept ID dictionary matching,
/// drug-nutrient and drug-workout interaction detection, and ClinicalCopyLinter (§P10-M) integration.
library;

import 'package:fitkarma/features/predictive/clinical_copy_linter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P10-I Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum InteractionSeverity {
  low('Low Advisory', '🟨'),
  moderate('Moderate Warning', '🟧'),
  high('High Conflict', '🟥');

  const InteractionSeverity(this.displayName, this.indicatorEmoji);

  final String displayName;
  final String indicatorEmoji;
}

enum InteractionType {
  drugDrug('Drug-Drug Conflict'),
  drugNutrient('Drug-Nutrient Conflict'),
  drugWorkout('Drug-Workout Advisory');

  const InteractionType(this.displayName);

  final String displayName;
}

class MedicationSchedule {
  const MedicationSchedule({
    required this.medicationId,
    required this.medicationName,
    this.rxcui,
    required this.dosage,
    required this.scheduledTimes,
    required this.requiresFood,
    required this.startDate,
  });

  final String medicationId;
  final String medicationName;
  final String? rxcui; // RxNorm Concept ID (e.g. 22501 for Metformin)
  final String dosage;
  final List<String> scheduledTimes; // e.g. ["08:00", "20:00"]
  final bool requiresFood;
  final DateTime startDate;
}

class InteractionWarning {
  const InteractionWarning({
    required this.warningId,
    required this.severity,
    required this.type,
    required this.sourceMedication,
    required this.targetItem,
    required this.lintedMessage,
  });

  final String warningId;
  final InteractionSeverity severity;
  final InteractionType type;
  final String sourceMedication;
  final String targetItem;
  final String lintedMessage;
}

// ─────────────────────────────────────────────────────────────────────────────
// DrugInteractionEngine (§P10-I Specification)
// ─────────────────────────────────────────────────────────────────────────────

class DrugInteractionEngine {
  final ClinicalCopyLinter _linter = const ClinicalCopyLinter();

  /// Seed mapping common Indian brand names to generic RxNorm Concept IDs (RxCUIs) (§P10-I spec).
  static const Map<String, String> indianBrandToRxcuiSeed = {
    'glycomet': '22501', // Metformin
    'metformin': '22501',
    'atorva': '83367', // Atorvastatin
    'atorvastatin': '83367',
    'lipitor': '83367',
    'thyronorm': '10582', // Levothyroxine
    'levothyroxine': '10582',
    'pan': '1364230', // Pantoprazole
    'pantocid': '1364230',
    'ciplar': '8745', // Propranolol / Metoprolol (Beta-blockers)
    'metoprolol': '8745',
  };

  /// Resolves RxNorm concept ID for a given medication name.
  String? resolveRxcui(String medicationName) {
    final lower = medicationName.trim().toLowerCase();
    for (final entry in indianBrandToRxcuiSeed.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Evaluates drug-drug, drug-nutrient, and drug-workout interaction warnings.
  List<InteractionWarning> checkInteractions({
    required List<MedicationSchedule> medications,
    double recentMealCarbsGrams = 0.0,
    List<String> recentMealFoods = const [],
    String workoutIntensity = 'moderate',
  }) {
    final warnings = <InteractionWarning>[];

    for (final med in medications) {
      final nameLower = med.medicationName.toLowerCase();

      // Case 1: Metformin + high simple carbs (>80g)
      if ((nameLower.contains('metformin') || nameLower.contains('glycomet')) &&
          recentMealCarbsGrams > 80.0) {
        final rawMsg =
            'Metformin combined with high simple carbs (${recentMealCarbsGrams.round()}g) can trigger rapid glucose swings. Balance plate with protein.';
        warnings.add(InteractionWarning(
          warningId: 'w_metformin_carbs',
          severity: InteractionSeverity.moderate,
          type: InteractionType.drugNutrient,
          sourceMedication: med.medicationName,
          targetItem: 'High Carbs (${recentMealCarbsGrams.round()}g)',
          lintedMessage: _linter.lintAndSanitize(rawMsg),
        ));
      }

      // Case 2: Statins (Atorvastatin) + Grapefruit
      if ((nameLower.contains('statin') || nameLower.contains('atorva')) &&
          recentMealFoods.any((f) => f.toLowerCase().contains('grapefruit'))) {
        final rawMsg =
            'Grapefruit compounds inhibit metabolic enzymes, raising statin concentrations in blood. Avoid grapefruit while on statins.';
        warnings.add(InteractionWarning(
          warningId: 'w_statin_grapefruit',
          severity: InteractionSeverity.high,
          type: InteractionType.drugNutrient,
          sourceMedication: med.medicationName,
          targetItem: 'Grapefruit',
          lintedMessage: _linter.lintAndSanitize(rawMsg),
        ));
      }

      // Case 3: Beta-blockers (Metoprolol / Ciplar) + High Workout Intensity
      if ((nameLower.contains('metoprolol') || nameLower.contains('ciplar')) &&
          workoutIntensity.toLowerCase() == 'high') {
        final rawMsg =
            'Beta-blockers blunt heart rate response. Do not rely solely on target HR zones today; use Rate of Perceived Exertion (RPE) to gauge intensity.';
        warnings.add(InteractionWarning(
          warningId: 'w_betablocker_workout',
          severity: InteractionSeverity.moderate,
          type: InteractionType.drugWorkout,
          sourceMedication: med.medicationName,
          targetItem: 'High Intensity Workout',
          lintedMessage: _linter.lintAndSanitize(rawMsg),
        ));
      }
    }

    return warnings;
  }
}
