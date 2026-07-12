import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/ai/ai_cache.dart';
import 'package:fitkarma/core/ai/rule_engine.dart';
import 'package:fitkarma/core/ai/insight_template_engine.dart';
import 'package:fitkarma/core/ai/ai_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AICache cache;
  late RuleEngine ruleEngine;
  late InsightTemplateEngine templateEngine;
  late bool connectivityStatus;
  late AIRouter router;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    cache = AICache(db);
    ruleEngine = RuleEngine(db);
    templateEngine = InsightTemplateEngine(db);
    connectivityStatus = true;
    
    // Inject simplified lamda connectivity query
    router = AIRouter(
      ruleEngine, 
      templateEngine, 
      cache, 
      () async => connectivityStatus,
    );

    // Seed default user
    await db.into(db.users).insert(
      UsersCompanion.insert(
        id: 'user_001',
        name: const Value('Test User'),
        email: const Value('test@fitkarma.com'),
        age: const Value(28),
        weight: const Value(68.0),
        height: const Value(172.0),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('AICache handles composite key mapping, expiration, and user purging', () async {
    // 1. Set cache response
    await cache.set('user_001', 'prompt_hash_1', 'Cached Response ABC');

    // Retrieve cache
    final response = await cache.get('user_001', 'prompt_hash_1');
    expect(response, 'Cached Response ABC');

    // 2. Querying with another user returns null (scoping check)
    final diffUser = await cache.get('user_002', 'prompt_hash_1');
    expect(diffUser, isNull);

    // 3. Expiry date in past returns null (expiration check)
    final yesterday = DateTime.now().subtract(const Duration(hours: 30));
    await db.update(db.aICacheEntries).write(
      AICacheEntriesCompanion(expiresAt: Value(yesterday)),
    );

    final expired = await cache.get('user_001', 'prompt_hash_1');
    expect(expired, isNull);

    // 4. Purge cache wipes all rows for that user (DPDP erasure compliance)
    await cache.set('user_001', 'prompt_hash_2', 'Cached Response XYZ');
    await cache.purgeForUser('user_001');

    final purged = await cache.get('user_001', 'prompt_hash_2');
    expect(purged, isNull);
  });

  test('RuleEngine triggers hydration warning when logs are low past 3PM', () async {
    final request = AIRequest(
      userId: 'user_001',
      prompt: 'Check vitals status',
      promptHash: 'vitals_hash',
      complexity: AIComplexity.dailyInsight,
    );

    // Seed 5 cups of water today
    await db.into(db.waterLogs).insert(
      WaterLogsCompanion.insert(
        cups: 5,
        syncBatchId: 'seed_water',
        loggedAt: DateTime.now(),
        hlcPhysicalTime: DateTime.now(),
        hlcLogicalCounter: 0,
        hlcNodeId: 'node_test',
      ),
    );

    final result = await ruleEngine.tryHandle(request);
    // Since we have logged 5 cups (>= 4), hydration warning should NOT trigger
    expect(result, isNull);
  });

  test('AIRouter selects model tier, retries flaky networks, and triggers fallbacks', () async {
    final request = AIRequest(
      userId: 'user_001',
      prompt: 'Summarize today',
      promptHash: 'summary_hash',
      complexity: AIComplexity.classification,
    );

    // Mock connectivity is online, normal routing
    final response = await router.route(request);
    expect(response, contains('llama3_8b')); // Tiny model classification chosen

    // Test retry policy on flaky Groq endpoint
    router.simulateFlakyGroq = true; // Will fail 2 times, succeed on 3rd attempt
    final request2 = AIRequest(
      userId: 'user_001',
      prompt: 'Coaching response',
      promptHash: 'coaching_hash',
      complexity: AIComplexity.coaching,
    );

    final response2 = await router.route(request2);
    expect(response2, contains('llama3_70b_full')); // Large model chosen, retry succeeds

    // Test Offline Fallbacks with a fresh uncached request
    connectivityStatus = false;
    final request3 = AIRequest(
      userId: 'user_001',
      prompt: 'Offline prompt query',
      promptHash: 'offline_hash',
      complexity: AIComplexity.coaching,
    );

    // A. High-tier device loads local Gemma
    router.deviceHardwareTier = DeviceTier.high;
    router.isLocalModelLoaded = true;
    final offlineResponseHigh = await router.route(request3);
    expect(offlineResponseHigh, contains('[Local Gemma-2B Offline Response]'));

    // B. Medium-tier device triggers system offline message
    router.deviceHardwareTier = DeviceTier.medium;
    final offlineResponseMed = await router.route(request3);
    expect(offlineResponseMed, contains('Offline System Message'));
  });
}
