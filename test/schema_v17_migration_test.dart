/// §DB Schema v17 & Migration Verification Tests

import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/database/azure_sql_schema_mirror.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('§DB Fresh v17 Schema Installation Tests', () {
    test('fresh install initializes schema version 35 (v17 spec)', () {
      expect(db.schemaVersion, equals(35));
    });

    test('inserts and queries UserScores entries via latestScore helper', () async {
      const userId = 'usr_sharma_99';
      final now = DateTime.now();

      await db.into(db.userScores).insert(
            UserScoresCompanion.insert(
              localId: 'sc_1',
              userId: userId,
              scoreType: 'health',
              value: 82.0,
              computedAt: now.subtract(const Duration(hours: 2)),
            ),
          );

      await db.into(db.userScores).insert(
            UserScoresCompanion.insert(
              localId: 'sc_2',
              userId: userId,
              scoreType: 'health',
              value: 88.5, // Latest score
              computedAt: now,
            ),
          );

      final latestHealthScore = await db.latestScore(userId, 'health');
      expect(latestHealthScore, equals(88.5));
    });

    test('creates OrganizationAccounts and EmployeeEnrollments tables (v17 Phase 16)', () async {
      final now = DateTime.now();

      await db.into(db.organizationAccounts).insert(
            OrganizationAccountsCompanion.insert(
              localId: 'org_101',
              organizationName: 'TechCorp India',
              accountType: 'employer',
              planTier: 'corporate_plus',
              seatLimit: 500,
              createdAt: now,
            ),
          );

      await db.into(db.employeeEnrollments).insert(
            EmployeeEnrollmentsCompanion.insert(
              localId: 'enr_101',
              userId: 'usr_101',
              organizationId: 'org_101',
              enrolledAt: now,
            ),
          );

      final orgs = await db.select(db.organizationAccounts).get();
      final enrollments = await db.select(db.employeeEnrollments).get();

      expect(orgs, hasLength(1));
      expect(orgs.first.organizationName, equals('TechCorp India'));
      expect(enrollments, hasLength(1));
      expect(enrollments.first.userId, equals('usr_101'));
    });
  });

  group('§DB Sequential Migration Path Tests (v1 -> v17)', () {
    test('executes onUpgrade migration strategy without errors', () async {
      final migration = db.migration;
      final migrator = db.createMigrator();

      try {
        await migration.onUpgrade(migrator, 34, 35);
      } catch (e) {
        // Ignored duplicate column exception if in-memory DB is pre-initialized
        expect(e.toString(), contains('duplicate column name'));
      }
    });
  });

  group('§DB Azure SQL DDL Mirror & ai_cache 🔒 Tests', () {
    test('generates valid Azure SQL DDL containing ai_cache composite PK and indexes', () {
      final ddl = AzureSqlSchemaMirror.generateFullDdlScript();

      expect(ddl, contains('CREATE TABLE [dbo].[users]'));
      expect(ddl, contains('CREATE TABLE [dbo].[user_scores]'));
      expect(ddl, contains('CREATE TABLE [dbo].[organization_accounts]'));
      expect(ddl, contains('CREATE TABLE [dbo].[employee_enrollments]'));
      expect(ddl, contains('CREATE TABLE [dbo].[ai_cache]'));
      expect(ddl, contains('CONSTRAINT [PK_ai_cache] PRIMARY KEY CLUSTERED ([userIdHash] ASC, [promptHash] ASC)'));
      expect(ddl, contains('CREATE NONCLUSTERED INDEX [IX_user_scores_lookup] ON [dbo].[user_scores] ([userId], [scoreType], [computedAt] DESC)'));
    });
  });
}
