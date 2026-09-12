import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/predictive_health_models.dart';
import '../domain/services/biological_age_engine.dart';
import '../domain/services/cardiometabolic_risk_engine.dart';
import '../domain/services/clinical_lab_intelligence_engine.dart';
import '../domain/services/injury_risk_engine.dart';
import '../domain/services/medication_safety_engine.dart';
import '../domain/services/stress_detection_engine.dart';

class PredictiveHealthRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final BiologicalAgeEngine biologicalAgeEngine;
  final CardiometabolicRiskEngine cardioRiskEngine;
  final InjuryRiskEngine injuryRiskEngine;
  final StressDetectionEngine stressEngine;
  final ClinicalLabIntelligenceEngine labEngine;
  final MedicationSafetyEngine medicationSafetyEngine;

  PredictiveHealthRepository({
    required this.db,
    required this.syncWorker,
    this.biologicalAgeEngine = const BiologicalAgeEngine(),
    this.cardioRiskEngine = const CardiometabolicRiskEngine(),
    this.injuryRiskEngine = const InjuryRiskEngine(),
    this.stressEngine = const StressDetectionEngine(),
    this.labEngine = const ClinicalLabIntelligenceEngine(),
    this.medicationSafetyEngine = const MedicationSafetyEngine(),
  });

  // ==========================================
  // 1. BIOLOGICAL AGE
  // ==========================================

  Future<void> saveBiologicalAgeEstimate(BiologicalAgeEstimate estimate) async {
    await db.into(db.localBiologicalAgeRecords).insertOnConflictUpdate(
      LocalBiologicalAgeRecordsCompanion(
        id: Value(estimate.id),
        userId: Value(estimate.userId),
        chronologicalAge: Value(estimate.chronologicalAge),
        biologicalAge: Value(estimate.biologicalAge),
        ageDelta: Value(estimate.ageDelta),
        topAction: Value(estimate.topImprovementAction),
        topActionHindi: Value(estimate.topImprovementActionHindi),
        calculatedAt: Value(estimate.calculatedAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'biological_age_estimates',
      action: 'INSERT',
      payload: estimate.toJson(),
    );
  }

  Future<LocalBiologicalAgeRecord?> getLatestBiologicalAge(String userId) async {
    return (db.select(db.localBiologicalAgeRecords)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.calculatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  // ==========================================
  // 2. CLINICAL LAB REPORTS
  // ==========================================

  Future<void> saveClinicalLabReport(ClinicalLabReport report) async {
    final resultsJson = jsonEncode(report.results.map((r) => r.toJson()).toList());

    await db.into(db.localClinicalLabReports).insertOnConflictUpdate(
      LocalClinicalLabReportsCompanion(
        id: Value(report.id),
        userId: Value(report.userId),
        labName: Value(report.labName),
        testDate: Value(report.testDate),
        resultsJson: Value(resultsJson),
        executiveSummary: Value(report.executiveSummary),
        executiveSummaryHindi: Value(report.executiveSummaryHindi),
        uploadedAt: Value(report.uploadedAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'clinical_lab_reports',
      action: 'INSERT',
      payload: report.toJson(),
    );
  }

  Stream<List<ClinicalLabReport>> watchClinicalLabReports(String userId) {
    return (db.select(db.localClinicalLabReports)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.testDate)]))
        .watch()
        .map((rows) => rows.map((r) {
              List<LabBiomarkerResult> results = [];
              try {
                final List<dynamic> decoded = jsonDecode(r.resultsJson);
                results = decoded
                    .map((item) => LabBiomarkerResult(
                          markerKey: item['marker_key'] ?? '',
                          name: item['name'] ?? '',
                          nameHindi: item['name_hindi'] ?? '',
                          value: (item['value'] as num).toDouble(),
                          unit: item['unit'] ?? '',
                          referenceMin: (item['reference_min'] as num).toDouble(),
                          referenceMax: (item['reference_max'] as num).toDouble(),
                          status: LabMarkerStatus.values.firstWhere(
                            (s) => s.name == item['status'],
                            orElse: () => LabMarkerStatus.optimal,
                          ),
                          interpretation: item['interpretation'] ?? '',
                          interpretationHindi: item['interpretation_hindi'] ?? '',
                        ))
                    .toList();
              } catch (_) {}

              return ClinicalLabReport(
                id: r.id,
                userId: r.userId,
                labName: r.labName,
                testDate: r.testDate,
                results: results,
                executiveSummary: r.executiveSummary,
                executiveSummaryHindi: r.executiveSummaryHindi,
                uploadedAt: r.uploadedAt,
              );
            }).toList());
  }

  // ==========================================
  // 3. MEDICATIONS
  // ==========================================

  Future<void> saveMedication({
    required String id,
    required String userId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required String timingCategory,
  }) async {
    final warningEn = medicationSafetyEngine.getFoodInteractionWarning(medicationName);
    final warningHi = medicationSafetyEngine.getFoodInteractionWarningHindi(medicationName);

    await db.into(db.localMedications).insertOnConflictUpdate(
      LocalMedicationsCompanion(
        id: Value(id),
        userId: Value(userId),
        medicationName: Value(medicationName),
        dosage: Value(dosage),
        frequency: Value(frequency),
        timingCategory: Value(timingCategory),
        foodInteractionWarning: Value(warningEn),
        foodInteractionWarningHindi: Value(warningHi),
        isTakenToday: const Value(false),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'medications',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'medication_name': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'timing_category': timingCategory,
        'food_interaction_warning': warningEn,
        'food_interaction_warning_hindi': warningHi,
        'is_taken_today': false,
      },
    );
  }

  Stream<List<MedicationSchedule>> watchMedications(String userId) {
    return (db.select(db.localMedications)..where((t) => t.userId.equals(userId)))
        .watch()
        .map((rows) => rows
            .map((r) => MedicationSchedule(
                  id: r.id,
                  userId: r.userId,
                  medicationName: r.medicationName,
                  dosage: r.dosage,
                  frequency: r.frequency,
                  timingCategory: r.timingCategory,
                  foodInteractionWarning: r.foodInteractionWarning,
                  foodInteractionWarningHindi: r.foodInteractionWarningHindi,
                  isTakenToday: r.isTakenToday,
                ))
            .toList());
  }

  // ==========================================
  // 4. DOCTOR ACCESS GRANTS
  // ==========================================

  Future<void> createDoctorGrant(DoctorAccessGrant grant) async {
    await db.into(db.localDoctorGrants).insertOnConflictUpdate(
      LocalDoctorGrantsCompanion(
        id: Value(grant.id),
        userId: Value(grant.userId),
        doctorName: Value(grant.doctorName),
        clinicHospital: Value(grant.clinicHospital),
        accessPin: Value(grant.accessPin),
        expiresAt: Value(grant.expiresAt),
        isActive: Value(grant.isActive),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'doctor_access_grants',
      action: 'INSERT',
      payload: grant.toJson(),
    );
  }

  Stream<List<DoctorAccessGrant>> watchDoctorGrants(String userId) {
    return (db.select(db.localDoctorGrants)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.expiresAt)]))
        .watch()
        .map((rows) => rows
            .map((r) => DoctorAccessGrant(
                  id: r.id,
                  userId: r.userId,
                  doctorName: r.doctorName,
                  clinicHospital: r.clinicHospital,
                  accessPin: r.accessPin,
                  expiresAt: r.expiresAt,
                  isActive: r.isActive,
                ))
            .toList());
  }
}
