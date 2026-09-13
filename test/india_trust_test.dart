import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/india_trust/domain/models/india_trust_models.dart';
import 'package:fitkarma/features/india_trust/domain/services/abha_integration_engine.dart';
import 'package:fitkarma/features/india_trust/domain/services/vernacular_voice_engine.dart';
import 'package:fitkarma/features/india_trust/domain/services/whatsapp_logging_engine.dart';
import 'package:fitkarma/features/india_trust/domain/services/corporate_wellness_engine.dart';
import 'package:fitkarma/features/india_trust/domain/services/quick_commerce_engine.dart';
import 'package:fitkarma/features/india_trust/data/india_trust_repository.dart';

void main() {
  group('India Trust - AbhaIntegrationEngine Tests', () {
    const engine = AbhaIntegrationEngine();

    test('Validates 14-digit ABHA ID format', () {
      expect(engine.validateAbhaNumber('14-8842-1940-5521'), isTrue);
      expect(engine.validateAbhaNumber('14884219405521'), isTrue);
      expect(engine.validateAbhaNumber('12345'), isFalse);
      expect(engine.validateAbhaNumber('14-8842-1940-552A'), isFalse);
    });

    test('Formats raw digits to XX-XXXX-XXXX-XXXX', () {
      expect(engine.formatAbhaNumber('14884219405521'), equals('14-8842-1940-5521'));
    });

    test('Validates ABHA Address format', () {
      expect(engine.validateAbhaAddress('rahul.sharma@abdm'), isTrue);
      expect(engine.validateAbhaAddress('user123@sbx'), isTrue);
      expect(engine.validateAbhaAddress('invalid@gmail.com'), isFalse);
    });

    test('Generates valid FHIR DiagnosticReport bundle', () {
      final fhir = engine.generateFhirDiagnosticReport(
        abhaNumber: '14-8842-1940-5521',
        patientName: 'Rahul Sharma',
        fastingGlucose: 94.0,
        systolicBp: 120.0,
        diastolicBp: 80.0,
        biologicalAge: 27,
      );

      expect(fhir['resourceType'], equals('DiagnosticReport'));
      expect(fhir['subject']['display'], equals('Rahul Sharma'));
      expect((fhir['result'] as List).length, equals(3));
    });
  });

  group('India Trust - VernacularVoiceEngine Tests', () {
    const engine = VernacularVoiceEngine();

    test('Parses Hinglish meal transcript correctly', () {
      final parsed = engine.parseTranscript('Maine lunch me 3 roti aur 1 katori dal khaya');
      expect(parsed.entryType, equals('meal'));
      expect(parsed.extractedEntities['roti_count'], equals(3));
      expect(parsed.extractedEntities['dal_katori'], equals(1));
    });

    test('Parses Desi workout transcript correctly', () {
      final parsed = engine.parseTranscript('Subah 50 dand aur 40 baithak lagaye');
      expect(parsed.entryType, equals('workout'));
      expect(parsed.extractedEntities['reps'], equals(50));
    });
  });

  group('India Trust - WhatsAppLoggingEngine Tests', () {
    const engine = WhatsAppLoggingEngine();

    test('Processes inbound meal message and returns structured confirmation reply', () {
      final result = engine.processInboundMessage(
        fromPhoneNumber: '+919876543210',
        textMessage: '2 roti paneer sabzi khaya',
      );

      expect(result['reply_message'], contains('FitKarma Meal Logged'));
      expect(result['reply_message'], contains('Karma: +50 pts'));
    });
  });

  group('India Trust - CorporateWellnessEngine Tests', () {
    const engine = CorporateWellnessEngine();

    test('Calculates high team wellness and maximum 15% insurer discount', () {
      final summary = engine.evaluateTeamWellness(
        id: 'team-1',
        companyName: 'Tata Consultancy',
        teamName: 'Cloud Infrastructure',
        corporateCode: 'TCS-FIT-2026',
        memberAdherencePercentages: [0.85, 0.90, 0.82, 0.88, 0.94],
      );

      expect(summary.teamWellnessScore, greaterThanOrEqualTo(80.0));
      expect(summary.insurerDiscountPct, equals(15.0));
      expect(summary.activeMembersCount, equals(5));
    });
  });

  group('India Trust - QuickCommerceEngine Tests', () {
    const engine = QuickCommerceEngine();

    test('Returns price comparative basket across 3 platforms', () {
      final items = engine.getComparativeBasket(['paneer', 'makhana']);
      expect(items.length, greaterThanOrEqualTo(2));
      expect(items.first.blinkitPriceInr, greaterThan(0));
      expect(items.first.zeptoPriceInr, greaterThan(0));

      final cheapest = engine.findCheapestPlatform(items);
      expect(cheapest, isNotNull);
    });

    test('Generates platform deep link URI', () {
      final items = engine.getComparativeBasket(['paneer']);
      final link = engine.generateDeepLink(platform: GroceryPlatform.zepto, items: items);
      expect(link, contains('zepto://'));
    });
  });

  group('India Trust - IndiaTrustRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker outbox;
    late IndiaTrustRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = IndiaTrustRepository(
        db: db,
        syncWorker: outbox,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Saves and retrieves ABHA record from Drift', () async {
      final record = AbhaRecord(
        id: 'abha-1',
        userId: 'user-1',
        abhaNumber: '14-8842-1940-5521',
        abhaAddress: 'rahul@abdm',
        isLinked: true,
        createdAt: DateTime.now(),
      );

      await repo.saveAbhaRecord(record);
      final retrieved = await repo.getAbhaRecord('user-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.abhaNumber, equals('14-8842-1940-5521'));
      expect(retrieved.isLinked, isTrue);
    });

    test('Saves and retrieves WhatsApp chat logs from Drift', () async {
      await repo.saveWhatsappLog(
        id: 'msg-1',
        userId: 'user-1',
        messageId: 'wa_101',
        direction: 'inbound',
        rawText: '2 roti 1 dal khaya',
        parsedEntityType: 'meal',
      );

      final logs = await repo.getWhatsappLogs('user-1');
      expect(logs.length, equals(1));
      expect(logs.first.rawText, contains('2 roti'));
      expect(logs.first.parsedEntityType, equals('meal'));
    });

    test('Saves and retrieves Corporate Teams from Drift', () async {
      const team = CorporateTeamSummary(
        id: 'corp-1',
        companyName: 'Wipro',
        teamName: 'AI Core',
        corporateCode: 'WIPRO-AI',
        teamWellnessScore: 86.5,
        activeMembersCount: 14,
        insurerDiscountPct: 15.0,
      );

      await repo.saveCorporateTeam(team);
      final teams = await repo.getAllCorporateTeams();
      expect(teams.length, equals(1));
      expect(teams.first.corporateCode, equals('WIPRO-AI'));
      expect(teams.first.wellnessScore, equals(86.5));
    });
  });
}
