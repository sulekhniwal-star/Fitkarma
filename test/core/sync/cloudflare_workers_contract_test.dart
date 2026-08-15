import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§CF Cloudflare Workers Verification & Contract Tests', () {
    test('Verifies wrangler.toml defines cron schedule and D1 database bindings', () {
      final wranglerFile = File('workers/wrangler.toml');
      expect(wranglerFile.existsSync(), isTrue);

      final content = wranglerFile.readAsStringSync();
      expect(content, contains('binding = "DB"'));
      expect(content, contains('crons = ["*/15 * * * *"]'));
      expect(content, contains('main = "src/index.ts"'));
    });

    test('Verifies all 9 Cloudflare Worker microservices exist in workers/src', () {
      final requiredWorkers = [
        'fitkarma-health-os',
        'fitkarma-social',
        'fitkarma-marketplace',
        'fitkarma-cores',
        'fitkarma-coach',
        'fitkarma-meal-vision',
        'fitkarma-insights',
        'fitkarma-reports',
        'fitkarma-whatsapp',
      ];

      for (final workerName in requiredWorkers) {
        final workerFile = File('workers/src/$workerName/index.ts');
        expect(workerFile.existsSync(), isTrue, reason: '$workerName/index.ts should exist');
      }
    });

    test('Verifies shared AI cache implementation includes DPDP user-scoped purge', () {
      final aiCacheFile = File('workers/src/shared/aiCache.ts');
      expect(aiCacheFile.existsSync(), isTrue);

      final code = aiCacheFile.readAsStringSync();
      expect(code, contains('purgeCacheForUser'));
      expect(code, contains('getCached'));
      expect(code, contains('setCached'));
      expect(code, contains('hashPrompt'));
    });

    test('Verifies master index.ts routes all 9 microservices and scheduled crons', () {
      final indexFile = File('workers/src/index.ts');
      expect(indexFile.existsSync(), isTrue);

      final code = indexFile.readAsStringSync();
      expect(code, contains('/health-os'));
      expect(code, contains('/social'));
      expect(code, contains('/marketplace'));
      expect(code, contains('/cores'));
      expect(code, contains('/coach'));
      expect(code, contains('/meal-vision'));
      expect(code, contains('/insights'));
      expect(code, contains('/reports'));
      expect(code, contains('/whatsapp'));
      expect(code, contains('healthOsWorker.scheduled'));
    });
  });
}
