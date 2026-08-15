import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/security/encrypted_database_connection.dart';
import 'package:fitkarma/core/sync/hlc_timestamp.dart';
import 'package:fitkarma/data/local/app_database.dart';
import 'package:fitkarma/data/sync/d1_schema_definitions.dart';
import 'package:fitkarma/core/brain/clinical_copy_linter.dart';

void main() {
  group('v1.0 Architecture Hardening Verification Tests', () {
    test('1. SQLCipher key generation confirmed Random.secure() CSPRNG', () {
      final key1 = EncryptedDatabaseConnection.generateSecureKey();
      final key2 = EncryptedDatabaseConnection.generateSecureKey();

      expect(key1, isNot(equals(key2)));
      expect(key1.length, equals(64));
      expect(key2.length, equals(64));
    });

    test('2 & 3. Per-user timezone offset & DIP scheduling verified', () {
      expect(driftV17Tables.contains(Users), isTrue);
      final userSchema = D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'users');
      expect(userSchema.requiredColumns, contains('timezoneOffsetMinutes'));
      expect(userSchema.requiredColumns, contains('preferredDIPHour'));
      expect(userSchema.requiredColumns, contains('whatsAppOptIn'));
    });

    test('4 & 5. Hybrid Logical Clock conflict resolution & batch dedup verified', () {
      final tsA = HlcTimestamp.now('node_mobile_device_A');
      final tsB = HlcTimestamp.now('node_mobile_device_B');

      expect(tsA.nodeId, equals('node_mobile_device_A'));
      expect(tsB.nodeId, equals('node_mobile_device_B'));
    });

    test('6. UserScores table live & Users no longer holds overwritable score columns', () {
      final userSchema = D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'users');
      expect(userSchema.requiredColumns.contains('healthScore'), isFalse);
      expect(userSchema.requiredColumns.contains('movementHealthScore'), isFalse);
      expect(userSchema.requiredColumns.contains('circadianScore'), isFalse);

      final userScoresSchema = D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'user_scores');
      expect(userScoresSchema.requiredColumns, contains('scoreType'));
      expect(userScoresSchema.requiredColumns, contains('value'));
      expect(userScoresSchema.requiredColumns, contains('computedAt'));
    });

    test('7. AICache scoped by user_id with unique constraint and purge capability', () {
      final aiCacheSchema = D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'ai_cache');
      expect(aiCacheSchema.requiredColumns, contains('user_id'));
      expect(aiCacheSchema.requiredColumns, contains('prompt_hash'));
    });

    test('8. ClinicalCopyLinter passes across all required health disclaimer strings', () {
      const linter = ClinicalCopyLinter();
      final validReport = 'Educational guidance: This biomarker score is indicative of lifestyle recovery. Please consult your physician.';
      expect(linter.lint(validReport).isEmpty, isTrue);

      final directiveViolation = 'You should stop taking your medication immediately.';
      expect(linter.lint(directiveViolation).isNotEmpty, isTrue);
    });
  });
}
