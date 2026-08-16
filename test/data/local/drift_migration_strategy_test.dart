import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/data/local/drift_migration_strategy.dart';

void main() {
  group('§DB-B Drift Migration Strategy Tests', () {
    const engine = DriftMigrationEngine();

    test('Computes full progressive migration path from v1 to v18', () {
      final steps = engine.getMigrationSteps(1, 18);

      expect(steps.length, equals(13)); // v6-v17 (12 steps) + v18
      expect(steps.first.targetVersion, equals(6));
      expect(steps.last.targetVersion, equals(18));
    });

    test('Computes direct migration path from v16 to v17', () {
      final steps = engine.getMigrationSteps(16, 17);

      expect(steps.length, equals(1));
      final v17Step = steps.first;
      expect(v17Step.targetVersion, equals(17));
      expect(v17Step.createdTables, contains('user_scores'));
      expect(v17Step.createdTables, contains('organization_accounts'));
      expect(v17Step.createdTables, contains('employee_enrollments'));
      expect(v17Step.addedColumns, contains('users.timezoneOffsetMinutes'));
      expect(v17Step.addedColumns, contains('users.whatsAppOptIn'));
      expect(v17Step.addedColumns, contains('users.abhaHealthId'));
    });

    test('Computes v17 to v18 migration step with food_references columns', () {
      final steps = engine.getMigrationSteps(17, 18);

      expect(steps.length, equals(1));
      final v18Step = steps.first;
      expect(v18Step.targetVersion, equals(18));
      expect(v18Step.addedColumns, contains('food_references.category'));
      expect(v18Step.addedColumns, contains('food_references.region'));
      expect(v18Step.addedColumns, contains('food_references.servingGrams'));
      expect(v18Step.addedColumns, contains('food_references.sourceTag'));
    });

    test('Extracts all 8 legacy scalar scores into normalized UserScores records', () {
      final legacyUserRow = {
        'localId': 'user_arjun_101',
        'name': 'Arjun Sharma',
        'healthScore': 84.5,
        'movementHealthScore': 78.0,
        'estimatedMovementAge': 26.0,
        'estimatedRecoveryAge': 28.0,
        'circadianScore': 92.0,
        'trainingReliabilityScore': 95.0,
        'upperBodyReadiness': 82.0,
        'lowerBodyReadiness': 88.0,
      };

      final timestamp = DateTime(2026, 8, 15, 10, 30);
      final migratedRecords = engine.migrateLegacyScores(
        legacyUserRow: legacyUserRow,
        migrationTimestamp: timestamp,
      );

      expect(migratedRecords.length, equals(8));

      final healthScoreRecord =
          migratedRecords.firstWhere((r) => r.scoreType == 'health');
      expect(healthScoreRecord.userId, equals('user_arjun_101'));
      expect(healthScoreRecord.value, equals(84.5));
      expect(healthScoreRecord.computedAt, equals(timestamp));

      final circadianRecord =
          migratedRecords.firstWhere((r) => r.scoreType == 'circadian');
      expect(circadianRecord.value, equals(92.0));
    });

    test('Handles partial or missing legacy scores gracefully', () {
      final partialUserRow = {
        'localId': 'user_partial_02',
        'healthScore': 75.0,
        'circadianScore': null,
      };

      final migratedRecords = engine.migrateLegacyScores(
        legacyUserRow: partialUserRow,
      );

      expect(migratedRecords.length, equals(1));
      expect(migratedRecords.first.scoreType, equals('health'));
      expect(migratedRecords.first.value, equals(75.0));
    });
  });
}
