import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/medical_records_repository.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';

// ─────────────────────────────────────────────
// Repository provider
// ─────────────────────────────────────────────

final medicalRecordsRepositoryProvider = Provider<MedicalRecordsRepository>((ref) {
  return MedicalRecordsRepository(
    db: ref.watch(appDatabaseProvider),
    syncWorker: ref.watch(outboxSyncWorkerProvider),
    supabase: ref.watch(supabaseClientProvider),
  );
});

// ─────────────────────────────────────────────
// Lab Reports
// ─────────────────────────────────────────────

/// Reactive stream of all lab reports for the current user (newest first).
final labReportsStreamProvider = StreamProvider<List<LocalClinicalLabReport>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  return (db.select(db.localClinicalLabReports)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm(expression: t.testDate, mode: OrderingMode.desc)]))
      .watch();
});

// ─────────────────────────────────────────────
// Medications
// ─────────────────────────────────────────────

/// Reactive stream of all medications for the current user.
final medicationsStreamProvider = StreamProvider<List<LocalMedication>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  return (db.select(db.localMedications)
        ..where((t) => t.userId.equals(userId)))
      .watch();
});

// ─────────────────────────────────────────────
// ABHA Record
// ─────────────────────────────────────────────

/// Reactive stream of the user's ABHA record (nullable — null = not linked yet).
final abhaRecordStreamProvider = StreamProvider<LocalAbhaRecord?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  return (db.select(db.localAbhaRecords)
        ..where((t) => t.userId.equals(userId))
        ..limit(1))
      .watchSingleOrNull();
});

// ─────────────────────────────────────────────
// Doctor Access Grants
// ─────────────────────────────────────────────

/// Reactive stream of active (non-expired) doctor access grants.
final activeDoctorGrantsStreamProvider = StreamProvider<List<LocalDoctorGrant>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  final now = DateTime.now();
  return (db.select(db.localDoctorGrants)
        ..where((t) => t.userId.equals(userId) & t.isActive.equals(true) & t.expiresAt.isBiggerThanValue(now))
        ..orderBy([(t) => OrderingTerm(expression: t.expiresAt, mode: OrderingMode.asc)]))
      .watch();
});

// ─────────────────────────────────────────────
// Async Actions (StateNotifier)
// ─────────────────────────────────────────────

enum MedicalRecordsStatus { idle, loading, success, error }

class MedicalRecordsState {
  final MedicalRecordsStatus status;
  final String? message;
  final String? messageHindi;

  const MedicalRecordsState({
    this.status = MedicalRecordsStatus.idle,
    this.message,
    this.messageHindi,
  });

  MedicalRecordsState copyWith({
    MedicalRecordsStatus? status,
    String? message,
    String? messageHindi,
  }) => MedicalRecordsState(
    status: status ?? this.status,
    message: message,
    messageHindi: messageHindi,
  );
}

class MedicalRecordsController extends Notifier<MedicalRecordsState> {
  @override
  MedicalRecordsState build() => const MedicalRecordsState();

  MedicalRecordsRepository get _repo => ref.read(medicalRecordsRepositoryProvider);
  String get _userId => ref.read(activeUserIdProvider);

  Future<void> saveMedication({
    required String medicationName,
    required String dosage,
    required String frequency,
    required String timingCategory,
    String? foodInteractionWarning,
    String? foodInteractionWarningHindi,
  }) async {
    state = state.copyWith(status: MedicalRecordsStatus.loading);
    try {
      await _repo.saveMedication(
        userId: _userId,
        medicationName: medicationName,
        dosage: dosage,
        frequency: frequency,
        timingCategory: timingCategory,
        foodInteractionWarning: foodInteractionWarning,
        foodInteractionWarningHindi: foodInteractionWarningHindi,
      );
      state = state.copyWith(status: MedicalRecordsStatus.success, message: 'Medication saved.');
    } catch (e) {
      state = state.copyWith(status: MedicalRecordsStatus.error, message: 'Could not save medication.');
    }
  }

  Future<void> toggleMedication(String medicationId, bool isTaken) async {
    try {
      await _repo.toggleMedicationTakenToday(medicationId: medicationId, isTaken: isTaken);
    } catch (_) {}
  }

  Future<void> linkAbha({required String abhaNumber, required String abhaAddress}) async {
    state = state.copyWith(status: MedicalRecordsStatus.loading);
    final result = await _repo.linkAbhaNumber(
      userId: _userId,
      abhaNumber: abhaNumber,
      abhaAddress: abhaAddress,
    );
    state = state.copyWith(
      status: result.success ? MedicalRecordsStatus.success : MedicalRecordsStatus.error,
      message: result.message,
      messageHindi: result.messageHindi,
    );
  }

  Future<void> createDoctorGrant({
    required String doctorName,
    required String clinicHospital,
    required String accessPin,
    required DateTime expiresAt,
  }) async {
    state = state.copyWith(status: MedicalRecordsStatus.loading);
    try {
      await _repo.createDoctorGrant(
        userId: _userId,
        doctorName: doctorName,
        clinicHospital: clinicHospital,
        accessPin: accessPin,
        expiresAt: expiresAt,
      );
      state = state.copyWith(
        status: MedicalRecordsStatus.success,
        message: 'Doctor access granted.',
        messageHindi: 'डॉक्टर को एक्सेस दी गई।',
      );
    } catch (e) {
      state = state.copyWith(status: MedicalRecordsStatus.error, message: 'Could not create grant.');
    }
  }

  Future<void> revokeGrant(String grantId) async {
    try {
      await _repo.revokeGrant(grantId);
    } catch (_) {}
  }

  void clearStatus() => state = state.copyWith(status: MedicalRecordsStatus.idle);
}

final medicalRecordsControllerProvider =
    NotifierProvider<MedicalRecordsController, MedicalRecordsState>(MedicalRecordsController.new);
