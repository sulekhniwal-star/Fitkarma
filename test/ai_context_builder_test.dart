import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/ai/ai_context_builder.dart';
import 'package:fitkarma/core/brain/health_snapshot.dart';

class MockSyncWorker implements SyncWorker {
  @override
  bool get isSyncing => false;

  @override
  Future<void> triggerSync() async {}
}

void main() {
  late AppDatabase db;
  late HealthOSBrain healthBrain;
  late AIContextBuilder contextBuilder;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
    healthBrain = HealthOSBrain(db, MockSyncWorker());
    contextBuilder = AIContextBuilder(db, healthBrain);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'buildCompressed queries database and constructs valid AIContext',
    () async {
      // 1. Seed user profile
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              id: 'user_123',
              name: const Value('Arjun'),
              age: const Value(30),
              weight: const Value(70.0),
              height: const Value(175.0),
              goals: const Value('["lose_weight"]'),
              currentProgram: const Value('Strength foundations'),
            ),
          );

      // 2. Seed water logs to compute health snapshot
      final now = DateTime.now();
      await db
          .into(db.waterLogs)
          .insert(
            WaterLogsCompanion.insert(
              cups: 4,
              syncBatchId: 'batch1',
              loggedAt: now,
              hlcPhysicalTime: now,
              hlcLogicalCounter: 0,
              hlcNodeId: 'node1',
            ),
          );

      // 3. Build context
      final aiContext = await contextBuilder.buildCompressed(
        'user_123',
        weather: 'Hot and humid',
        festival: 'Diwali',
      );

      expect(aiContext.name, 'Arjun');
      expect(aiContext.program, 'Strength foundations');
      expect(aiContext.weather, 'Hot and humid');
      expect(aiContext.festival, 'Diwali');
      expect(aiContext.snapshot.bmi, closeTo(22.85, 0.1));
      expect(aiContext.primaryConcern, contains('Low hydration'));
    },
  );

  group('Token Budget Compliance Tests', () {
    final mockSnapshot = HealthSnapshot(
      bmi: 22.8,
      tdee: 2100.0,
      dailyCalorieTarget: 1800.0,
      dailyProteinTargetG: 120.0,
      dailyHydrationTargetL: 3.0,
      dailyStepTarget: 10000,
      avgSteps7Days: 8500.0,
      avgSleepMinutes7Days: 450.0,
      avgWaterCups7Days: 4.5,
      avgReadinessScore7Days: 78.0,
      avgHeartRate7Days: 62.0,
      localRisks: [
        'Low hydration warning: averaging only 4.5 cups daily.',
        'High stress warning: heart rate variability is depressed.',
        'Poor sleep warning: average sleep duration is below threshold.',
      ],
    );

    test(
      'Standard prompt payload contains full details when budget is high',
      () {
        final context = AIContext(
          name: 'Arjun',
          goals: '["lose_weight"]',
          program: 'Strength foundations',
          dietType: 'Veg/Indian',
          tone: 'roast',
          injuries: 'Knee pain',
          snapshot: mockSnapshot,
          readinessScore: 78,
          primaryConcern: 'Low hydration warning',
          weather: 'Sunny and warm',
          festival: 'Holi',
        );

        final payload = context.toPromptPayload(tokenBudget: 500);

        // Verify full details are retained
        expect(payload, contains('Program: Strength foundations'));
        expect(payload, contains('Diet: Veg/Indian'));
        expect(payload, contains('Injuries: Knee pain'));
        expect(payload, contains('Weather: Sunny and warm'));
        expect(payload, contains('Festival: Holi'));
        expect(payload, contains('High stress warning'));

        final tokenCount = (payload.length / 4).round();
        expect(tokenCount, lessThanOrEqualTo(500));
      },
    );

    test('Compresses payload when token budget is restricted', () {
      final context = AIContext(
        name: 'Arjun',
        goals: '["lose_weight"]',
        program: 'Strength foundations',
        dietType: 'Veg/Indian',
        tone: 'roast',
        injuries: 'Knee pain',
        snapshot: mockSnapshot,
        readinessScore: 78,
        primaryConcern: 'Low hydration warning',
        weather: 'Sunny and warm',
        festival: 'Holi',
      );

      // Low budget of 110 tokens (approx 440 characters)
      final payload = context.toPromptPayload(tokenBudget: 110);

      // Should omit optional parameters to compress size
      expect(payload, isNot(contains('Program:')));
      expect(payload, isNot(contains('Diet:')));
      expect(payload, isNot(contains('Injuries:')));
      expect(payload, isNot(contains('Weather:')));
      expect(payload, isNot(contains('Festival:')));

      // Should limit local risks list
      expect(payload, contains('Low hydration warning'));
      expect(payload, isNot(contains('High stress warning')));

      final tokenCount = (payload.length / 4).round();
      expect(tokenCount, lessThanOrEqualTo(110));
    });

    test(
      'Aggressively truncates payload when token budget is extremely low',
      () {
        final context = AIContext(
          name: 'Arjun',
          goals: '["lose_weight"]',
          program: 'Strength foundations',
          dietType: 'Veg/Indian',
          tone: 'roast',
          injuries: 'Knee pain',
          snapshot: mockSnapshot,
          readinessScore: 78,
          primaryConcern: 'Low hydration warning',
          weather: 'Sunny and warm',
          festival: 'Holi',
        );

        // Extremely restricted budget of 30 tokens (approx 120 characters)
        final payload = context.toPromptPayload(tokenBudget: 30);

        expect(payload, contains('... [truncated]'));
        final tokenCount = (payload.length / 4).round();
        expect(
          tokenCount,
          lessThanOrEqualTo(31),
        ); // Allow 1 token margin for truncated string
      },
    );
  });
}
