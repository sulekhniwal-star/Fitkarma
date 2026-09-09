import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/doctor_sharing_engine.dart';
import '../../domain/doctor_sharing_models.dart';

final doctorSharingProvider =
    StateNotifierProvider<DoctorSharingNotifier, DoctorSharingPortalReport>((ref) {
  return DoctorSharingNotifier();
});

class DoctorSharingNotifier extends StateNotifier<DoctorSharingPortalReport> {
  DoctorSharingNotifier() : super(_buildInitialReport());

  static final DoctorSharingEngine _engine = const DoctorSharingEngine();

  static DoctorSharingPortalReport _buildInitialReport() {
    final now = DateTime.now();

    final initialGrant = _engine.createAccessGrant(
      doctorName: 'Dr. Rajiv Sharma, MD',
      specialization: 'Cardiologist & Preventive Diabetologist',
      clinicOrHospital: 'Max Super Speciality Hospital, New Delhi',
      medicalRegistrationNumber: 'MCI-38291',
      permittedScopes: [
        ClinicalDataScope.cardiometabolicBp,
        ClinicalDataScope.glycemicCgm,
        ClinicalDataScope.labBiomarkers,
        ClinicalDataScope.medicationRegimens,
      ],
      durationWindow: SharingDurationWindow.days7,
      grantTime: now.subtract(const Duration(hours: 12)),
    );

    final initialDossier = _engine.compileClinicalDossier(
      patientId: 'ABHA-9821-4829-1048',
      patientAge: 32,
      patientSex: 'Male',
      restingHeartRate: 59.0,
      systolicBp: 116.0,
      diastolicBp: 74.0,
      rmssdHeartRateVariability: 54.0,
      estimatedHbA1c: 5.22,
      meanGlucose: 94.0,
      timeInRangePercent: 96.0,
      waistToHeightRatio: 0.46,
      activeMedicationNames: [
        'Telmisartan 40mg (Morning)',
        'Pure Curcumin 500mg (Night)',
        'Vitamin D3+K2 (Post-lunch)',
      ],
      compileTime: now,
    );

    final auditLogs = [
      ClinicalAuditLogEntry(
        id: 'audit_01',
        doctorName: 'Dr. Rajiv Sharma, MD',
        accessedAt: now.subtract(const Duration(hours: 2)),
        scopesViewed: const [
          ClinicalDataScope.cardiometabolicBp,
          ClinicalDataScope.glycemicCgm,
        ],
        ipAddressOrDevice: 'Hospital Workstation (103.24.18.9)',
      ),
    ];

    return DoctorSharingPortalReport(
      activeGrants: [initialGrant],
      auditLogs: auditLogs,
      currentDossier: initialDossier,
      totalActiveGrantsCount: 1,
      hasActiveSharingLinks: true,
      lastRefreshed: now,
    );
  }

  void createNewGrant({
    required String doctorName,
    required String specialization,
    required String clinicOrHospital,
    required String medicalRegistrationNumber,
    required List<ClinicalDataScope> permittedScopes,
    required SharingDurationWindow durationWindow,
  }) {
    final newGrant = _engine.createAccessGrant(
      doctorName: doctorName,
      specialization: specialization,
      clinicOrHospital: clinicOrHospital,
      medicalRegistrationNumber: medicalRegistrationNumber,
      permittedScopes: permittedScopes,
      durationWindow: durationWindow,
    );

    final updatedGrants = [...state.activeGrants, newGrant];
    final activeCount = updatedGrants.where((g) => g.isActive && !g.isExpired).length;

    state = DoctorSharingPortalReport(
      activeGrants: updatedGrants,
      auditLogs: state.auditLogs,
      currentDossier: state.currentDossier,
      totalActiveGrantsCount: activeCount,
      hasActiveSharingLinks: activeCount > 0,
      lastRefreshed: DateTime.now(),
    );
  }

  void revokeGrant(String grantId) {
    final updatedGrants = state.activeGrants.map((g) {
      if (g.grantId == grantId) {
        return _engine.revokeGrant(g);
      }
      return g;
    }).toList();

    final activeCount = updatedGrants.where((g) => g.isActive && !g.isExpired).length;

    state = DoctorSharingPortalReport(
      activeGrants: updatedGrants,
      auditLogs: state.auditLogs,
      currentDossier: state.currentDossier,
      totalActiveGrantsCount: activeCount,
      hasActiveSharingLinks: activeCount > 0,
      lastRefreshed: DateTime.now(),
    );
  }

  void revokeAllGrants() {
    final updatedGrants = state.activeGrants.map((g) => _engine.revokeGrant(g)).toList();

    state = DoctorSharingPortalReport(
      activeGrants: updatedGrants,
      auditLogs: state.auditLogs,
      currentDossier: state.currentDossier,
      totalActiveGrantsCount: 0,
      hasActiveSharingLinks: false,
      lastRefreshed: DateTime.now(),
    );
  }
}
