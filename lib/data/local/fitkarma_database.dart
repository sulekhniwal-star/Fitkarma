// §DB FitKarma App Database (Drift v18)
// Cross-reference: §DB in Fitkarma_documentation.md
//
// This file declares the @DriftDatabase-annotated AppDatabase class.
// The generated code lives in app_database.g.dart (run build_runner to generate).
//
// The table definitions (class bodies) live in app_database.dart,
// which this file imports and references.

import 'package:drift/drift.dart';

import 'app_database.dart';
import '../../core/security/encrypted_database_connection.dart';

export 'app_database.dart';

part 'fitkarma_database.g.dart';

@DriftDatabase(tables: [
  Users,
  UserScores,
  FoodLogs,
  DietPlans,
  MicronutrientLogs,
  MealNutritionDetails,
  FamilyMealPlans,
  FoodSubstitutions,
  FoodReferences,
  WorkoutLogs,
  MovementLogs,
  MovementWeaknessProfiles,
  RecoveryLogs,
  SleepLogs,
  BpReadings,
  GlucoseReadings,
  CgmReadings,
  MedicationLogs,
  DailyIntelligencePackages,
  HealthSnapshots,
  TransformationMemories,
  LifeEvents,
  WaterLogs,
  HabitLogs,
  MoodLogs,
  KarmaEvents,
  AiInsights,
  TransformationChecks,
  BodyMeasurements,
  SquadGroups,
  SquadMembers,
  Followers,
  Clubs,
  CreatorProfiles,
  OrganizationAccounts,
  EmployeeEnrollments,
])
class FitKarmaDatabase extends _$FitKarmaDatabase {
  FitKarmaDatabase() : super(EncryptedDatabaseConnection.getDatabaseConnection());

  /// Testing constructor — allows passing any QueryExecutor (e.g. in-memory).
  FitKarmaDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => kAppDatabaseSchemaVersion; // 18

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Create food_references FTS5 virtual table for full-text search
          await customStatement(
            '''CREATE VIRTUAL TABLE IF NOT EXISTS food_fts
               USING fts5(foodId UNINDEXED, foodName, category,
                          content='food_references', content_rowid='rowid');''',
          );
        },
        onUpgrade: (m, from, to) async {
          // v17 → v18: Add extended food_references columns
          if (from < 18) {
            await m.addColumn(foodReferences, foodReferences.category);
            await m.addColumn(foodReferences, foodReferences.region);
            await m.addColumn(foodReferences, foodReferences.servingGrams);
            await m.addColumn(foodReferences, foodReferences.sourceTag);
          }
        },
      );
}
