import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';

/// MedicalRecordsRepository — offline-first repository for Phase 10.
///
/// All writes go to Drift first (works offline), then enqueue a
/// [pending_mutations] outbox entry for background Supabase sync via
/// [OutboxSyncWorker]. Mirrors the pattern in HealthTrackingRepository.
///
/// Supabase tables (RLS: auth.uid() = user_id on all):
///   • clinical_lab_reports
///   • medications
///   • abha_records
///   • doctor_access_grants
///
/// Storage: clinical-dossiers bucket (private, signed URLs only).
class MedicalRecordsRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final SupabaseClient supabase;
  final _uuid = const Uuid();

  MedicalRecordsRepository({
    required this.db,
    required this.syncWorker,
    required this.supabase,
  });

  // ═══════════════════════════════════════════════════════════════════
  // Lab Reports
  // ═══════════════════════════════════════════════════════════════════

  Future<String> saveLabReport({
    required String userId,
    required String labName,
    required DateTime testDate,
    required List<Map<String, dynamic>> resultsJson,
    required String executiveSummary,
    required String executiveSummaryHindi,
  }) async {
    final id = _uuid.v4();

    await db.into(db.localClinicalLabReports).insertOnConflictUpdate(
          LocalClinicalLabReportsCompanion.insert(
            id: id,
            userId: userId,
            labName: labName,
            testDate: testDate,
            resultsJson: jsonEncode(resultsJson),
            executiveSummary: executiveSummary,
            executiveSummaryHindi: executiveSummaryHindi,
            uploadedAt: DateTime.now(),
          ),
        );

    await syncWorker.enqueueMutation(
      tableName: 'clinical_lab_reports',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'lab_name': labName,
        'test_date': testDate.toIso8601String(),
        'results': resultsJson,
        'executive_summary': executiveSummary,
        'executive_summary_hindi': executiveSummaryHindi,
        'uploaded_at': DateTime.now().toIso8601String(),
      },
    );

    return id;
  }

  /// Upload PDF to the private [clinical-dossiers] Storage bucket.
  /// Returns a 1-hour signed URL, or null on failure (network-required).
  Future<String?> uploadReportPdf({
    required String userId,
    required String reportId,
    required File pdfFile,
  }) async {
    final storagePath = '$userId/lab_$reportId.pdf';
    try {
      await supabase.storage.from('clinical-dossiers').upload(
            storagePath,
            pdfFile,
            fileOptions: const FileOptions(
                contentType: 'application/pdf', upsert: true),
          );

      final signedUrl = await supabase.storage
          .from('clinical-dossiers')
          .createSignedUrl(storagePath, 3600);

      // Best-effort: update the remote row with the storage path
      await supabase
          .from('clinical_lab_reports')
          .update({'pdf_storage_path': storagePath}).eq('id', reportId);

      return signedUrl;
    } catch (e) {
      debugPrint('[MedicalRecordsRepository] PDF upload error: $e');
      return null;
    }
  }

  /// Call the [parse-lab-report] Edge Function (Groq Llama-3.2-11b vision)
  /// to extract structured test values from an uploaded PDF.
  Future<LabReportParseResult?> parseReportWithAI({
    required String storagePath,
    required String userId,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'parse-lab-report',
        body: {'storagePath': storagePath, 'userId': userId},
      );
      if (response.data == null) return null;
      final data = Map<String, dynamic>.from(response.data as Map);
      return LabReportParseResult(
        resultsJson: List<Map<String, dynamic>>.from(
            (data['resultsJson'] as List? ?? [])
                .map((e) => Map<String, dynamic>.from(e as Map))),
        executiveSummary: data['executiveSummary'] as String? ?? '',
        executiveSummaryHindi: data['executiveSummaryHindi'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('[MedicalRecordsRepository] AI parse error: $e');
      return null;
    }
  }

  Future<List<LocalClinicalLabReport>> getLabReports(String userId) {
    return (db.select(db.localClinicalLabReports)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) =>
              OrderingTerm(expression: t.testDate, mode: OrderingMode.desc)]))
        .get();
  }

  // ═══════════════════════════════════════════════════════════════════
  // Medications
  // ═══════════════════════════════════════════════════════════════════

  Future<String> saveMedication({
    required String userId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required String timingCategory,
    String? foodInteractionWarning,
    String? foodInteractionWarningHindi,
  }) async {
    final id = _uuid.v4();
    await db.into(db.localMedications).insertOnConflictUpdate(
          LocalMedicationsCompanion.insert(
            id: id,
            userId: userId,
            medicationName: medicationName,
            dosage: dosage,
            frequency: frequency,
            timingCategory: timingCategory,
            foodInteractionWarning: Value(foodInteractionWarning),
            foodInteractionWarningHindi: Value(foodInteractionWarningHindi),
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
        'food_interaction_warning': foodInteractionWarning,
        'food_interaction_warning_hindi': foodInteractionWarningHindi,
      },
    );
    return id;
  }

  Future<void> toggleMedicationTakenToday({
    required String medicationId,
    required bool isTaken,
  }) async {
    await (db.update(db.localMedications)
          ..where((t) => t.id.equals(medicationId)))
        .write(LocalMedicationsCompanion(isTakenToday: Value(isTaken)));
    await syncWorker.enqueueMutation(
      tableName: 'medications',
      action: 'UPDATE',
      payload: {'id': medicationId, 'is_taken_today': isTaken},
    );
  }

  Future<List<LocalMedication>> getMedications(String userId) {
    return (db.select(db.localMedications)
          ..where((t) => t.userId.equals(userId)))
        .get();
  }

  // ═══════════════════════════════════════════════════════════════════
  // ABHA Records
  // ═══════════════════════════════════════════════════════════════════

  /// Link ABHA number: client-side 14-digit format check → Edge Function
  /// validation → local Drift persist → outbox sync.
  Future<AbhaLinkResult> linkAbhaNumber({
    required String userId,
    required String abhaNumber,
    required String abhaAddress,
  }) async {
    final digits = abhaNumber.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^\d{14}$').hasMatch(digits)) {
      return AbhaLinkResult(
        success: false,
        message: 'Invalid ABHA number. Must be 14 digits.',
        messageHindi: 'गलत ABHA नंबर। 14 अंक होने चाहिए।',
      );
    }

    try {
      final response = await supabase.functions.invoke(
        'validate-abha',
        body: {
          'abhaNumber': digits,
          'abhaAddress': abhaAddress,
          'userId': userId,
        },
      );
      if (response.data?['status'] != 'linked') {
        return AbhaLinkResult(
          success: false,
          message: response.data?['message'] ?? 'ABHA linking failed.',
          messageHindi: 'ABHA लिंक करने में विफल।',
        );
      }
    } catch (e) {
      debugPrint('[MedicalRecordsRepository] ABHA edge function error: $e');
      // Proceed with local save even if network call fails
    }

    final id = _uuid.v4();
    await db.into(db.localAbhaRecords).insertOnConflictUpdate(
          LocalAbhaRecordsCompanion.insert(
            id: id,
            userId: userId,
            abhaNumber: digits,
            abhaAddress: abhaAddress,
          ),
        );
    await syncWorker.enqueueMutation(
      tableName: 'abha_records',
      action: 'UPSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'abha_number': digits,
        'abha_address': abhaAddress,
        'fhir_sync_status': 'pending',
      },
    );

    return AbhaLinkResult(
      success: true,
      message: 'ABHA linked. Records will sync once ABDM integration is live.',
      messageHindi:
          'ABHA लिंक हो गया। ABDM एकीकरण सक्रिय होने के बाद रिकॉर्ड सिंक होंगे।',
    );
  }

  Future<LocalAbhaRecord?> getAbhaRecord(String userId) {
    return (db.select(db.localAbhaRecords)
          ..where((t) => t.userId.equals(userId))
          ..limit(1))
        .getSingleOrNull();
  }

  // ═══════════════════════════════════════════════════════════════════
  // Doctor Access Grants
  // ═══════════════════════════════════════════════════════════════════

  Future<String> createDoctorGrant({
    required String userId,
    required String doctorName,
    required String clinicHospital,
    required String accessPin,
    required DateTime expiresAt,
  }) async {
    final id = _uuid.v4();
    await db.into(db.localDoctorGrants).insertOnConflictUpdate(
          LocalDoctorGrantsCompanion.insert(
            id: id,
            userId: userId,
            doctorName: doctorName,
            clinicHospital: clinicHospital,
            accessPin: accessPin,
            expiresAt: expiresAt,
          ),
        );
    await syncWorker.enqueueMutation(
      tableName: 'doctor_access_grants',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'doctor_name': doctorName,
        'clinic_hospital': clinicHospital,
        'access_pin': accessPin,
        'expires_at': expiresAt.toIso8601String(),
      },
    );
    return id;
  }

  Future<void> revokeGrant(String grantId) async {
    await (db.update(db.localDoctorGrants)
          ..where((t) => t.id.equals(grantId)))
        .write(const LocalDoctorGrantsCompanion(isActive: Value(false)));
    await syncWorker.enqueueMutation(
      tableName: 'doctor_access_grants',
      action: 'UPDATE',
      payload: {'id': grantId, 'is_active': false},
    );
  }

  Future<List<LocalDoctorGrant>> getActiveGrants(String userId) {
    return (db.select(db.localDoctorGrants)
          ..where((t) => t.userId.equals(userId) & t.isActive.equals(true))
          ..orderBy([(t) =>
              OrderingTerm(expression: t.expiresAt, mode: OrderingMode.asc)]))
        .get();
  }
}

// ═══════════════════════════════════════════════════════════════════
// Value Objects
// ═══════════════════════════════════════════════════════════════════

class LabReportParseResult {
  final List<Map<String, dynamic>> resultsJson;
  final String executiveSummary;
  final String executiveSummaryHindi;

  const LabReportParseResult({
    required this.resultsJson,
    required this.executiveSummary,
    required this.executiveSummaryHindi,
  });
}

class AbhaLinkResult {
  final bool success;
  final String message;
  final String messageHindi;

  const AbhaLinkResult({
    required this.success,
    required this.message,
    required this.messageHindi,
  });
}
