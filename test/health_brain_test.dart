import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSyncWorker implements SyncWorker {
  @override
  bool get isSyncing => false;

  @override
  Future<void> triggerSync() async {}
}

void main() {
  late AppDatabase db;
  late MockSyncWorker syncWorker;
  late HealthOSBrain brain;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    
    // Construct real services backed by our in-memory database
    syncWorker = MockSyncWorker();
    brain = HealthOSBrain(db, syncWorker);
    
    // Seed default user
    await db.into(db.users).insert(
      UsersCompanion.insert(
        id: 'user_001',
        name: const Value('Test User'),
        email: const Value('test@fitkarma.com'),
        age: const Value(30),
        weight: const Value(70.0),  // 70.0 kg
        height: const Value(175.0), // 175.0 cm (BMI = 22.8)
        goals: const Value('["lose_weight"]'),
      ),
    );

    // Seed 7 days of healthy water logs (6 cups per day) to avoid dehydration warnings
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      await db.into(db.waterLogs).insert(
        WaterLogsCompanion.insert(
          cups: 6,
          syncBatchId: 'water_seed_$i',
          loggedAt: now.subtract(Duration(days: i)),
          hlcPhysicalTime: now.subtract(Duration(days: i)),
          hlcLogicalCounter: 0,
          hlcNodeId: 'node_test',
        ),
      );
    }
  });

  tearDown(() async {
    await db.close();
  });

  test('computeHealthSnapshot calculates correct BMI, TDEE, goals, and steps', () async {
    final snapshot = await brain.computeHealthSnapshot('user_001');

    // BMI = 70.0 / (1.75 * 1.75) = 22.857
    expect(snapshot.bmi, closeTo(22.85, 0.05));

    // Male Mifflin-St Jeor = (10 * 70) + (6.25 * 175) - (5 * 30) + 5 = 700 + 1093.75 - 150 + 5 = 1648.75
    // TDEE = 1648.75 * 1.375 = 2267.0
    expect(snapshot.tdee, closeTo(2267.0, 1.0));

    // Goal 'lose_weight' offsets calories by -500.0 => 1767.0
    expect(snapshot.dailyCalorieTarget, closeTo(1767.0, 1.0));

    // Normal BMI => 10000 steps target
    expect(snapshot.dailyStepTarget, 10000);
  });

  test('computeHealthSnapshot lowers steps for obese BMI target', () async {
    // Update user weight to obese status
    await db.update(db.users).write(
      const UsersCompanion(
        weight: Value(100.0), // 100 kg / 1.75^2 => BMI = 32.65
      ),
    );

    final snapshot = await brain.computeHealthSnapshot('user_001');
    expect(snapshot.bmi, greaterThan(30.0));
    // Obese BMI => step target reduced to 7000 to avoid joint stress
    expect(snapshot.dailyStepTarget, 7000);
  });

  test('checkAITrigger works based on risks or low readiness', () async {
    final normalSnapshot = await brain.computeHealthSnapshot('user_001');
    
    // Default seeded averages are healthy -> no triggers
    expect(brain.checkAITrigger(normalSnapshot), isFalse);

    // Let's create a snapshot with active risks
    final riskySnapshot = await brain.computeHealthSnapshot('user_001');
    riskySnapshot.localRisks.add('Test Hydration Warning');
    expect(brain.checkAITrigger(riskySnapshot), isTrue);
  });

  test('getOrGenerateDIP handles new, reuse, and sync queue insertions', () async {
    // 1. Initial generation (Must generate because no previous package exists)
    final dip1 = await brain.getOrGenerateDIP('user_001');
    expect(dip1.aiCallsUsed, 1);
    expect(dip1.adjustedCalories, 1767); // Derived target calculation

    // Verify a sync queue entry was written
    final queueItems = await db.select(db.syncQueueItems).get();
    expect(queueItems.length, 1);
    expect(queueItems.first.entityType, 'daily_intelligence_package');
    expect(queueItems.first.entityId, dip1.localId);

    // 2. Subsequent call same day (Must reuse existing row directly)
    final dip2 = await brain.getOrGenerateDIP('user_001');
    expect(dip2.localId, dip1.localId);

    // 3. Force regenerate (Must trigger new build, but reuse text if readiness is optimal)
    // Clear today's database package to simulate a new day
    await db.delete(db.dailyIntelligencePackages).go();

    // Build yesterday's package entry
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await db.into(db.dailyIntelligencePackages).insert(
      DailyIntelligencePackagesCompanion.insert(
        localId: 'dip_yesterday',
        userId: 'user_001',
        packageDate: yesterday,
        primaryInsight: 'Yesterday\'s core insight',
        todaysMission: 'Yesterday\'s mission',
        nutritionFocus: 'Focus on eating',
        recoveryFocus: 'Sleep well',
        motivationMessage: 'Keep going!',
        adjustedCalories: 1800,
        adjustedProtein: 120,
        adjustedHydrationL: 2.5,
        recommendedIntensity: 'medium',
        createdAt: yesterday,
        activeRisks: '[]',
      ),
    );

    // Fetch today's DIP. Since no risks exist, it should reuse yesterday's text but recalculate today's numbers
    final dipToday = await brain.getOrGenerateDIP('user_001');
    expect(dipToday.aiCallsUsed, 0); // Reused text!
    expect(dipToday.primaryInsight, 'Yesterday\'s core insight');
    expect(dipToday.adjustedCalories, 1767); // Today's computed target
  });
}
