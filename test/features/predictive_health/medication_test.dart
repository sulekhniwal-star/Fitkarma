import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/medication_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/medication_models.dart';

void main() {
  group('MedicationSafetyEngine Tests', () {
    const engine = MedicationSafetyEngine();

    test('Identifies safe schedule with no cross-interactions', () {
      final meds = [
        const TrackedMedication(
          id: 'med_1',
          name: 'Vitamin D3',
          regionalName: 'विटामिन D3',
          genericOrHerbName: 'vitamin d3 cholecalciferol',
          type: MedicationType.supplementVitamin,
          dosage: '2000 IU',
          timing: DoseTiming.afternoonPostLunch,
          isTakenToday: true,
          totalPillsRemaining: 30,
          clinicalPurpose: 'Bone density and immunity',
          regionalClinicalPurpose: 'अस्थि स्वास्थ्य व प्रतिरक्षा',
        ),
        const TrackedMedication(
          id: 'med_2',
          name: 'Ashwagandha Extract',
          regionalName: 'अश्वगंधा अर्क',
          genericOrHerbName: 'withania somnifera ashwagandha',
          type: MedicationType.ayurvedicHerb,
          dosage: '500 mg',
          timing: DoseTiming.nightBeforeBed,
          isTakenToday: true,
          totalPillsRemaining: 60,
          clinicalPurpose: 'Vagal stress down-regulation',
          regionalClinicalPurpose: 'तनाव शांति व मानसिक संतुलन',
        ),
      ];

      final report = engine.evaluateSchedule(medications: meds);

      expect(report.adherenceScorePercent, equals(100.0));
      expect(report.hasCriticalContraindication, isFalse);
      expect(report.detectedInteractions.isEmpty, isTrue);
    });

    test(
        'Screens and flags synergistic Herb-Drug interaction between Curcumin and Aspirin',
        () {
      final meds = [
        const TrackedMedication(
          id: 'med_aspirin',
          name: 'Ecosprin 75mg',
          regionalName: 'इकोस्प्रिन ७५mg',
          genericOrHerbName: 'aspirin',
          type: MedicationType.allopathicPrescription,
          dosage: '1 tablet daily',
          timing: DoseTiming.morningAfterBreakfast,
          isTakenToday: true,
          totalPillsRemaining: 20,
          clinicalPurpose: 'Antiplatelet arterial prophylaxis',
          regionalClinicalPurpose: 'रक्त पतला रखने की दवा',
        ),
        const TrackedMedication(
          id: 'med_curcumin',
          name: 'Curcumin 95%',
          regionalName: 'करक्यूमिन ९५%',
          genericOrHerbName: 'curcumin turmeric',
          type: MedicationType.ayurvedicHerb,
          dosage: '1000 mg',
          timing: DoseTiming.nightBeforeBed,
          isTakenToday: false,
          totalPillsRemaining: 40,
          clinicalPurpose: 'Anti-inflammatory joint recovery',
          regionalClinicalPurpose: 'सूजन-रोधी व जोड़ों की रिकवरी',
        ),
      ];

      final report = engine.evaluateSchedule(medications: meds);

      expect(report.detectedInteractions.isNotEmpty, isTrue);
      expect(report.detectedInteractions.first.id,
          equals('inter_curcumin_aspirin'));
      expect(report.detectedInteractions.first.severity,
          equals(InteractionSeverity.moderate));
      expect(report.adherenceScorePercent, equals(50.0));
    });
  });
}
