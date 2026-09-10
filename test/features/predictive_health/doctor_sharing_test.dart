import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/doctor_sharing_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/doctor_sharing_models.dart';

void main() {
  group('DoctorSharingEngine Tests', () {
    const engine = DoctorSharingEngine();

    test('Creates secure time-bound doctor access grant and compiles dossier',
        () {
      final grant = engine.createAccessGrant(
        doctorName: 'Dr. Vikram Sethi',
        specialization: 'Cardiologist',
        clinicOrHospital: 'Fortis Escorts',
        medicalRegistrationNumber: 'MCI-19482',
        permittedScopes: [
          ClinicalDataScope.cardiometabolicBp,
          ClinicalDataScope.glycemicCgm,
        ],
        durationWindow: SharingDurationWindow.days7,
      );

      expect(grant.isActive, isTrue);
      expect(grant.isExpired, isFalse);
      expect(grant.secureAccessToken.length, equals(6));
      expect(grant.permittedScopes.length, equals(2));

      final dossier = engine.compileClinicalDossier(
        patientId: 'PAT_84920',
        patientAge: 30,
        patientSex: 'Female',
        restingHeartRate: 62.0,
        systolicBp: 118.0,
        diastolicBp: 76.0,
        rmssdHeartRateVariability: 58.0,
        estimatedHbA1c: 5.15,
        meanGlucose: 91.0,
        timeInRangePercent: 98.0,
        waistToHeightRatio: 0.45,
        activeMedicationNames: ['Vitamin D3 2000IU'],
      );

      expect(dossier.patientDemographics, contains('PAT_84920'));
      expect(dossier.cardiometabolicSection, contains('WHtR 0.45'));
      expect(dossier.glycemicSection,
          contains('Time-In-Range (70-140 mg/dL): 98%'));
      expect(dossier.fullFormattedTextForPdf,
          contains('FITKARMA CLINICAL HEALTH'));
    });

    test('Instantly revokes active grant', () {
      final grant = engine.createAccessGrant(
        doctorName: 'Dr. Ananya Roy',
        specialization: 'Endocrinologist',
        clinicOrHospital: 'AIIMS',
        medicalRegistrationNumber: 'MCI-99482',
        permittedScopes: [ClinicalDataScope.glycemicCgm],
        durationWindow: SharingDurationWindow.hours24,
      );

      expect(grant.isActive, isTrue);

      final revoked = engine.revokeGrant(grant);
      expect(revoked.isActive, isFalse);
      expect(revoked.isExpired, isTrue);
    });
  });
}
