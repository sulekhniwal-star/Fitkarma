import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/data/sync/d1_schema_definitions.dart';

void main() {
  group('§DB-C Cloudflare D1 Cloud Database Schema Parity Tests', () {
    test('D1SchemaRegistry contains all 12 documented table families', () {
      final names = D1SchemaRegistry.tables.map((t) => t.tableName).toList();

      expect(names, contains('users'));
      expect(names, contains('user_scores'));
      expect(names, contains('organization_accounts'));
      expect(names, contains('employee_enrollments'));
      expect(names, contains('food_logs'));
      expect(names, contains('daily_intelligence_packages'));
      expect(names, contains('ai_cache'));
      expect(names, contains('cgm_readings'));
      expect(names, contains('recovery_logs'));
      expect(names, contains('transformation_checks'));
      expect(names, contains('sync_audit_trail'));
      expect(names, contains('sync_dead_letter_queue'));
      expect(names, contains('marketplace_wallets'));
      expect(names, contains('marketplace_ledger_entries'));
    });

    test('Validates users table excludes legacy score columns and contains Phase 16 fields', () {
      final userTable = D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'users');

      // No legacy scalar score columns
      expect(userTable.requiredColumns.contains('healthScore'), isFalse);
      expect(userTable.requiredColumns.contains('movementHealthScore'), isFalse);
      expect(userTable.requiredColumns.contains('circadianScore'), isFalse);

      // Contains Phase 16 fields
      expect(userTable.requiredColumns.contains('timezoneOffsetMinutes'), isTrue);
      expect(userTable.requiredColumns.contains('preferredDIPHour'), isTrue);
      expect(userTable.requiredColumns.contains('whatsAppOptIn'), isTrue);
      expect(userTable.requiredColumns.contains('preferredInputLanguage'), isTrue);
    });

    test('Validates double-entry ledger flag on marketplace_ledger_entries', () {
      final ledgerTable =
          D1SchemaRegistry.tables.firstWhere((t) => t.tableName == 'marketplace_ledger_entries');

      expect(ledgerTable.isDoubleEntryLedger, isTrue);
      expect(ledgerTable.requiredColumns, contains('debit'));
      expect(ledgerTable.requiredColumns, contains('credit'));
      expect(ledgerTable.requiredColumns, contains('accountType'));
    });

    test('Validates physical migration script file existence and syntax matching', () {
      final file = File('workers/migrations/0001_v17_d1_schema.sql');
      expect(file.existsSync(), isTrue);

      final ddl = file.readAsStringSync();
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS users'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS user_scores'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS organization_accounts'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS employee_enrollments'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS food_logs'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS daily_intelligence_packages'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS ai_cache'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS cgm_readings'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS recovery_logs'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS transformation_checks'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS sync_audit_trail'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS sync_dead_letter_queue'));
      expect(ddl, contains('CREATE TABLE IF NOT EXISTS marketplace_ledger_entries'));
      expect(ddl, contains('IX_user_scores_lookup'));
      expect(ddl, contains('IX_enrollments_org'));
      expect(ddl, contains('UQ_ai_cache_user_prompt'));
    });

    test('D1SchemaRegistry validates a compliant record successfully', () {
      final validUserScoresRecord = {
        'localId': 'score_101',
        'userId': 'user_1',
        'scoreType': 'health',
        'value': 88.5,
        'computedAt': '2026-08-15T10:00:00Z',
      };

      expect(D1SchemaRegistry.validateRecord('user_scores', validUserScoresRecord), isTrue);

      final invalidRecord = {
        'localId': 'score_102',
        // missing userId
        'scoreType': 'health',
      };

      expect(D1SchemaRegistry.validateRecord('user_scores', invalidRecord), isFalse);
    });
  });
}
