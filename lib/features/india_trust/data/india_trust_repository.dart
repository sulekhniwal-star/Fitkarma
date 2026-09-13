import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/india_trust_models.dart';
import '../domain/services/abha_integration_engine.dart';
import '../domain/services/vernacular_voice_engine.dart';
import '../domain/services/whatsapp_logging_engine.dart';
import '../domain/services/corporate_wellness_engine.dart';
import '../domain/services/quick_commerce_engine.dart';

class IndiaTrustRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final AbhaIntegrationEngine abhaEngine;
  final VernacularVoiceEngine voiceEngine;
  final WhatsAppLoggingEngine whatsappEngine;
  final CorporateWellnessEngine corporateEngine;
  final QuickCommerceEngine quickCommerceEngine;

  IndiaTrustRepository({
    required this.db,
    required this.syncWorker,
    this.abhaEngine = const AbhaIntegrationEngine(),
    this.voiceEngine = const VernacularVoiceEngine(),
    this.whatsappEngine = const WhatsAppLoggingEngine(),
    this.corporateEngine = const CorporateWellnessEngine(),
    this.quickCommerceEngine = const QuickCommerceEngine(),
  });

  // ==========================================
  // 1. ABHA RECORDS
  // ==========================================

  Future<void> saveAbhaRecord(AbhaRecord record) async {
    await db.into(db.localAbhaRecords).insertOnConflictUpdate(
      LocalAbhaRecordsCompanion(
        id: Value(record.id),
        userId: Value(record.userId),
        abhaNumber: Value(record.abhaNumber),
        abhaAddress: Value(record.abhaAddress),
        isLinked: Value(record.isLinked),
        fhirSyncStatus: Value(record.fhirSyncStatus),
        createdAt: Value(record.createdAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'abha_records',
      action: 'INSERT',
      payload: record.toJson(),
    );
  }

  Future<LocalAbhaRecord?> getAbhaRecord(String userId) async {
    return (db.select(db.localAbhaRecords)
          ..where((t) => t.userId.equals(userId))
          ..limit(1))
        .getSingleOrNull();
  }

  // ==========================================
  // 2. WHATSAPP LOGS
  // ==========================================

  Future<void> saveWhatsappLog({
    required String id,
    required String userId,
    required String messageId,
    required String direction,
    required String rawText,
    String? parsedEntityType,
  }) async {
    await db.into(db.localWhatsappLogs).insertOnConflictUpdate(
      LocalWhatsappLogsCompanion(
        id: Value(id),
        userId: Value(userId),
        messageId: Value(messageId),
        direction: Value(direction),
        rawText: Value(rawText),
        parsedEntityType: Value(parsedEntityType),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<LocalWhatsappLog>> getWhatsappLogs(String userId) async {
    return (db.select(db.localWhatsappLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // ==========================================
  // 3. CORPORATE WELLNESS
  // ==========================================

  Future<void> saveCorporateTeam(CorporateTeamSummary team) async {
    await db.into(db.localCorporateTeams).insertOnConflictUpdate(
      LocalCorporateTeamsCompanion(
        id: Value(team.id),
        companyName: Value(team.companyName),
        teamName: Value(team.teamName),
        corporateCode: Value(team.corporateCode),
        wellnessScore: Value(team.teamWellnessScore),
        memberCount: Value(team.activeMembersCount),
        createdAt: Value(DateTime.now()),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'corporate_teams',
      action: 'INSERT',
      payload: team.toJson(),
    );
  }

  Future<List<LocalCorporateTeam>> getAllCorporateTeams() async {
    return (db.select(db.localCorporateTeams)
          ..orderBy([(t) => OrderingTerm.desc(t.wellnessScore)]))
        .get();
  }
}
