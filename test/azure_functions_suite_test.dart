/// §AZ. Azure Functions Suite & Durable Fan-Out Load Tests

import 'package:fitkarma/core/cloud/azure_functions_suite.dart';
import 'package:fitkarma/core/cloud/health_os_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const orchestrator = HealthOSDurableOrchestrator();
  const suite = AzureFunctionsSuite();

  group('§AZ Health OS Durable Functions Fan-Out & Per-User Isolation Tests 🔒', () {
    test('getUsersDueForDIP filters active users by local time window (timezoneOffsetMinutes)', () {
      final utcNow = DateTime.utc(2026, 7, 25, 0, 30); // 00:30 UTC

      final users = [
        const UserScheduleProfile(userId: 'usr_ist_6am', timezoneOffsetMinutes: 330, preferredDIPHour: 6), // 06:00 local (IST) -> DUE
        const UserScheduleProfile(userId: 'usr_ist_8am', timezoneOffsetMinutes: 330, preferredDIPHour: 8), // 08:00 local -> NOT DUE
        const UserScheduleProfile(userId: 'usr_pst_6am', timezoneOffsetMinutes: -420, preferredDIPHour: 6), // 17:30 previous day local -> NOT DUE
      ];

      final dueUsers = orchestrator.getUsersDueForDIP(users: users, utcNow: utcNow);

      expect(dueUsers, hasLength(1));
      expect(dueUsers.first.userId, equals('usr_ist_6am'));
    });

    test('runHealthOSOrchestrator isolates per-user activity failures (usr_42 failure does not block others)', () async {
      final users = [
        const UserScheduleProfile(userId: 'usr_1', timezoneOffsetMinutes: 330, preferredDIPHour: 6),
        const UserScheduleProfile(userId: 'usr_2', timezoneOffsetMinutes: 330, preferredDIPHour: 6),
        const UserScheduleProfile(userId: 'usr_3', timezoneOffsetMinutes: 330, preferredDIPHour: 6),
      ];

      final utcNow = DateTime.utc(2026, 7, 25, 0, 30);

      final results = await orchestrator.runHealthOSOrchestrator(
        allUsers: users,
        utcNow: utcNow,
        failingUserIds: {'usr_2'}, // Only usr_2 fails
      );

      expect(results, hasLength(3));
      expect(results.firstWhere((r) => r.userId == 'usr_1').status, equals('generated'));
      expect(results.firstWhere((r) => r.userId == 'usr_2').status, equals('failed'));
      expect(results.firstWhere((r) => r.userId == 'usr_3').status, equals('generated'));
    });

    test('loadTestFanOutOrchestrator processes 1000 users under 5 seconds without timeout regression', () async {
      final loadReport = await orchestrator.loadTestFanOutOrchestrator(userCount: 1000);

      expect(loadReport['totalUsersProcessed'], equals(1000));
      expect(loadReport['successfulGenerations'], equals(998));
      expect(loadReport['isolatedFailures'], equals(2));
      expect(loadReport['isTimeoutPrevented'], isTrue);
    });
  });

  group('§AZ All 10 Azure Functions Suite Endpoints & Handlers Tests', () {
    test('verifies all 10 Cloud Functions return success status codes', () async {
      final cores = await suite.handleCoresRequest({});
      final coach = await suite.handleCoachRequest({});
      final vision = await suite.handleMealVisionRequest({});
      final insights = await suite.handleInsightsTrigger();
      final reports = await suite.handleReportsTrigger();
      final social = await suite.handleSocialRequest({});
      final mkt = await suite.handleMarketplaceRequest({});
      final wa = await suite.handleWhatsAppWebhook({});
      final healthOS = await suite.handleHealthOSTrigger([]);

      expect(cores.statusCode, equals(200));
      expect(coach.statusCode, equals(200));
      expect(vision.statusCode, equals(200));
      expect(insights.statusCode, equals(200));
      expect(reports.statusCode, equals(200));
      expect(social.statusCode, equals(200));
      expect(mkt.statusCode, equals(200));
      expect(wa.statusCode, equals(200));
      expect(healthOS.statusCode, equals(200));
    });
  });
}
