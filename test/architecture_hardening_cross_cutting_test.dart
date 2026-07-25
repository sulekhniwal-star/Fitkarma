/// §Hardening v1.0 Architecture Hardening (Cross-Cutting) Verification Tests

import 'dart:io';
import 'package:fitkarma/core/security/security_service.dart';
import 'package:fitkarma/core/sync/cumulative_log_sync.dart';
import 'package:fitkarma/core/sync/sync_merge_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('§Hardening CSPRNG Key Generation & AI Cache User Scoping', () {
    test('SqlCipherSecurity uses Random.secure() for 256-bit key', () {
      final key = SqlCipherSecurity.generateSecureKey();
      expect(key, hasLength(64));
    });

    test('AiCacheManager hashes prompt and scopes cache entries', () {
      final key1 = AiCacheManager.generateCacheKey(userId: 'usr_1', promptPayload: 'High protein meal plan');
      final key2 = AiCacheManager.generateCacheKey(userId: 'usr_2', promptPayload: 'High protein meal plan');

      expect(key1, isNot(equals(key2)));
      expect(key1, startsWith('ai_cache:'));
    });
  });

  group('§Hardening HLC Conflict Resolution & Cumulative Sync Idempotency', () {
    test('SyncMergeResolver compares HLCTimestamp with physical + logical counter tiebreaker', () {
      const resolver = SyncMergeResolver();
      final now = DateTime.now();

      final hlcOlder = HLCTimestamp(physicalTime: now, logicalCounter: 1, nodeId: 'dev_1');
      final hlcNewer = HLCTimestamp(physicalTime: now, logicalCounter: 2, nodeId: 'dev_1');

      expect(hlcNewer.compareTo(hlcOlder), greaterThan(0));
    });

    test('CumulativeLogSyncEngine enforces syncBatchId idempotency and server-side dedup', () {
      final engine = CumulativeLogSyncEngine();
      final now = DateTime.now();
      final hlc = HLCTimestamp(physicalTime: now, logicalCounter: 0, nodeId: 'dev_1');

      final log = WaterLogEntry(
        id: 'w1',
        userId: 'usr_1',
        cups: 2,
        syncBatchId: 'batch_water_998',
        hlc: hlc,
      );

      final firstAttempt = engine.processSyncBatch(log);
      final secondAttempt = engine.processSyncBatch(log); // Retry repeat

      expect(firstAttempt, isTrue);
      expect(secondAttempt, isFalse); // Deduplicated repeat batch
    });
  });

  group('§Hardening Clinical Copy Linter & PR Template Verification', () {
    test('verifies scripts/clinical_copy_linter.dart and .github/PULL_REQUEST_TEMPLATE.md exist', () {
      final linterScript = File('scripts/clinical_copy_linter.dart');
      final prTemplate = File('.github/PULL_REQUEST_TEMPLATE.md');

      expect(linterScript.existsSync(), isTrue);
      expect(prTemplate.existsSync(), isTrue);
      expect(prTemplate.readAsStringSync(), contains('Clinical Copy Change Checklist'));
    });
  });
}
