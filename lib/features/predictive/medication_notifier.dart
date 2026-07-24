/// §P10-I Medication Tracker & Interaction Warning Engine — Riverpod Notifier
///
/// Riverpod state management for holding scheduled medications and active warnings matching §P10-I spec.
library;

import 'package:fitkarma/features/predictive/medication_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicationState {
  const MedicationState({
    required this.scheduledMedications,
    required this.activeWarnings,
  });

  final List<MedicationSchedule> scheduledMedications;
  final List<InteractionWarning> activeWarnings;
}

class MedicationNotifier extends Notifier<MedicationState> {
  final DrugInteractionEngine _engine = DrugInteractionEngine();

  @override
  MedicationState build() {
    final now = DateTime.now();

    final initialMeds = [
      MedicationSchedule(
        medicationId: 'm1',
        medicationName: 'Glycomet SR 500 (Metformin)',
        rxcui: '22501',
        dosage: '500 mg',
        scheduledTimes: ['08:30 AM', '08:30 PM'],
        requiresFood: true,
        startDate: now,
      ),
      MedicationSchedule(
        medicationId: 'm2',
        medicationName: 'Atorva 10 (Atorvastatin)',
        rxcui: '83367',
        dosage: '10 mg',
        scheduledTimes: ['10:00 PM'],
        requiresFood: false,
        startDate: now,
      ),
    ];

    final warnings = _engine.checkInteractions(
      medications: initialMeds,
      recentMealCarbsGrams: 95.0, // High carbs trigger
      recentMealFoods: ['Grapefruit Juice'], // Grapefruit trigger
      workoutIntensity: 'high',
    );

    return MedicationState(
      scheduledMedications: initialMeds,
      activeWarnings: warnings,
    );
  }

  void addMedication(MedicationSchedule schedule) {
    final updatedList = [...state.scheduledMedications, schedule];
    final warnings = _engine.checkInteractions(
      medications: updatedList,
      recentMealCarbsGrams: 95.0,
      recentMealFoods: ['Grapefruit Juice'],
      workoutIntensity: 'high',
    );

    state = MedicationState(
      scheduledMedications: updatedList,
      activeWarnings: warnings,
    );
  }
}

final medicationProvider =
    NotifierProvider<MedicationNotifier, MedicationState>(MedicationNotifier.new);
