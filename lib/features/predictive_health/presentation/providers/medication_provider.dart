import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/medication_engine.dart';
import '../../domain/medication_models.dart';

final medicationProvider =
    StateNotifierProvider<MedicationNotifier, MedicationScheduleReport>((ref) {
  return MedicationNotifier();
});

class MedicationNotifier extends StateNotifier<MedicationScheduleReport> {
  MedicationNotifier() : super(_buildInitialReport());

  static final MedicationSafetyEngine _engine = const MedicationSafetyEngine();

  static MedicationScheduleReport _buildInitialReport() {
    final initialList = [
      const TrackedMedication(
        id: 'med_telmisartan',
        name: 'Telmisartan 40mg',
        regionalName: 'टेल्मीसार्टन ४०mg',
        genericOrHerbName: 'telmisartan',
        type: MedicationType.allopathicPrescription,
        dosage: '1 tablet daily',
        timing: DoseTiming.morningAfterBreakfast,
        isTakenToday: true,
        totalPillsRemaining: 24,
        clinicalPurpose: 'Blood pressure stabilization and arterial endothelial protection.',
        regionalClinicalPurpose: 'रक्तचाप नियंत्रण व धमनी सुरक्षा।',
      ),
      const TrackedMedication(
        id: 'med_curcumin',
        name: 'Pure Curcumin 500mg (with Piperine)',
        regionalName: 'शुद्ध करक्यूमिन ५००mg (हल्दी अर्क)',
        genericOrHerbName: 'curcumin',
        type: MedicationType.ayurvedicHerb,
        dosage: '1 capsule daily',
        timing: DoseTiming.nightBeforeBed,
        isTakenToday: false,
        totalPillsRemaining: 45,
        clinicalPurpose: 'Systemic anti-inflammatory and joint cartilage support.',
        regionalClinicalPurpose: 'सूजन-रोधी व जोड़ों की सुरक्षा।',
      ),
      const TrackedMedication(
        id: 'med_triphala',
        name: 'Triphala Churna / Extract',
        regionalName: 'त्रिफला चूर्ण / अर्क',
        genericOrHerbName: 'triphala',
        type: MedicationType.ayurvedicHerb,
        dosage: '1 tsp with warm water',
        timing: DoseTiming.nightBeforeBed,
        isTakenToday: false,
        totalPillsRemaining: 60,
        clinicalPurpose: 'Digestive colon cleansing and gut microbiome modulation.',
        regionalClinicalPurpose: 'पाचन तंत्र की शुद्धि व आंत स्वास्थ्य।',
      ),
      const TrackedMedication(
        id: 'med_vit_d3',
        name: 'Vitamin D3 + K2 (2000 IU)',
        regionalName: 'विटामिन D3 + K2',
        genericOrHerbName: 'vitamin d3 cholecalciferol',
        type: MedicationType.supplementVitamin,
        dosage: '1 softgel daily with healthy fats',
        timing: DoseTiming.afternoonPostLunch,
        isTakenToday: true,
        totalPillsRemaining: 30,
        clinicalPurpose: 'Immune resilience and bone mineral density support.',
        regionalClinicalPurpose: 'रोग प्रतिरोधक क्षमता व अस्थि घनत्व।',
      ),
    ];

    return _engine.evaluateSchedule(medications: initialList);
  }

  void toggleDoseTaken(String medicationId) {
    final updatedList = state.activeMedications.map((m) {
      if (m.id == medicationId) {
        final newStatus = !m.isTakenToday;
        final newPills = newStatus ? (m.totalPillsRemaining - 1).clamp(0, 999) : (m.totalPillsRemaining + 1);
        return m.copyWith(isTakenToday: newStatus, totalPillsRemaining: newPills);
      }
      return m;
    }).toList();

    state = _engine.evaluateSchedule(medications: updatedList);
  }

  void addMedication(TrackedMedication med) {
    final updatedList = [...state.activeMedications, med];
    state = _engine.evaluateSchedule(medications: updatedList);
  }

  void removeMedication(String medicationId) {
    final updatedList = state.activeMedications.where((m) => m.id != medicationId).toList();
    state = _engine.evaluateSchedule(medications: updatedList);
  }
}
