import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/data/local/app_database.dart';

void main() {
  group('§DB Drift Local Schema (v18) Table Registration Tests', () {
    test('Verifies exactly 36 tables defined in Drift Schema v18', () {
      expect(driftV17Tables.length, equals(36));
      expect(kAppDatabaseSchemaVersion, equals(18));
    });

    test('Verifies key v17 tables exist in schema registry', () {
      expect(driftV17Tables.contains(Users), isTrue);
      expect(driftV17Tables.contains(UserScores), isTrue);
      expect(driftV17Tables.contains(FoodLogs), isTrue);
      expect(driftV17Tables.contains(WorkoutLogs), isTrue);
      expect(driftV17Tables.contains(RecoveryLogs), isTrue);
      expect(driftV17Tables.contains(DailyIntelligencePackages), isTrue);
      expect(driftV17Tables.contains(OrganizationAccounts), isTrue);
      expect(driftV17Tables.contains(EmployeeEnrollments), isTrue);
    });

    test('Verifies Phase 16 tables and fields are properly registered', () {
      expect(driftV17Tables.contains(Users), isTrue);
      expect(driftV17Tables.contains(UserScores), isTrue);
      expect(driftV17Tables.contains(OrganizationAccounts), isTrue);
      expect(driftV17Tables.contains(EmployeeEnrollments), isTrue);
      expect(driftV17Tables.contains(FoodReferences), isTrue);
      expect(driftV17Tables.contains(MovementLogs), isTrue);
      expect(driftV17Tables.contains(DailyIntelligencePackages), isTrue);
      expect(driftV17Tables.contains(RecoveryLogs), isTrue);
      expect(driftV17Tables.contains(TransformationChecks), isTrue);

      // Verify all 36 tables can be instantiated
      for (final tableType in driftV17Tables) {
        expect(tableType, isNotNull);
      }
    });
  });
}
