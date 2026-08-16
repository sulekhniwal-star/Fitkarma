// §DB-B Drift Migration Strategy Engine (Pure Dart)
// Cross-reference: §DB-B in Fitkarma_documentation.md

/// Score Record to insert into normalized UserScores table during v16 -> v17 migration
class MigratedScoreRecord {
  final String localId;
  final String userId;
  final String scoreType;
  final double value;
  final DateTime computedAt;

  const MigratedScoreRecord({
    required this.localId,
    required this.userId,
    required this.scoreType,
    required this.value,
    required this.computedAt,
  });
}

/// Migration Step Metadata
class MigrationStepInfo {
  final int targetVersion;
  final String description;
  final List<String> createdTables;
  final List<String> addedColumns;

  const MigrationStepInfo({
    required this.targetVersion,
    required this.description,
    required this.createdTables,
    required this.addedColumns,
  });
}

/// Pure Dart Drift Migration & Data Preservation Engine
class DriftMigrationEngine {
  const DriftMigrationEngine();

  /// Mapping of legacy score columns on Users to new normalized scoreType keys
  static const Map<String, String> legacyScoreColumnsMap = {
    'health': 'healthScore',
    'movement': 'movementHealthScore',
    'movementAge': 'estimatedMovementAge',
    'recoveryAge': 'estimatedRecoveryAge',
    'circadian': 'circadianScore',
    'trainingReliability': 'trainingReliabilityScore',
    'upperBodyReadiness': 'upperBodyReadiness',
    'lowerBodyReadiness': 'lowerBodyReadiness',
  };

  /// Returns all migration steps needed to upgrade from [fromVersion] to [toVersion]
  List<MigrationStepInfo> getMigrationSteps(int fromVersion, int toVersion) {
    final steps = <MigrationStepInfo>[];

    if (fromVersion < 6 && toVersion >= 6) {
      steps.add(const MigrationStepInfo(
        targetVersion: 6,
        description: 'Added daily_intelligence_packages, health_snapshots, transformation_memories, life_events',
        createdTables: ['daily_intelligence_packages', 'health_snapshots', 'transformation_memories', 'life_events'],
        addedColumns: ['users.healthScore', 'recovery_logs.confidenceTier'],
      ));
    }

    if (fromVersion < 7 && toVersion >= 7) {
      steps.add(const MigrationStepInfo(
        targetVersion: 7,
        description: 'Added followers, clubs, cgm_readings, medication_logs, creator_profiles',
        createdTables: ['followers', 'clubs', 'cgm_readings', 'medication_logs', 'creator_profiles'],
        addedColumns: [],
      ));
    }

    if (fromVersion < 8 && toVersion >= 8) {
      steps.add(const MigrationStepInfo(
        targetVersion: 8,
        description: 'Added micronutrient_logs, meal_nutrition_details and periodization fields',
        createdTables: ['micronutrient_logs', 'meal_nutrition_details'],
        addedColumns: ['users.nutritionPeriodizationPhase', 'users.monthlyGroceryBudgetInr', 'daily_intelligence_packages.dietBreakActive', 'daily_intelligence_packages.proteinTimingTarget'],
      ));
    }

    if (fromVersion < 9 && toVersion >= 9) {
      steps.add(const MigrationStepInfo(
        targetVersion: 9,
        description: 'Added family_meal_plans, food_substitutions and familyUnitId',
        createdTables: ['family_meal_plans', 'food_substitutions'],
        addedColumns: ['users.familyUnitId', 'users.averageReliabilityPct', 'daily_intelligence_packages.loggingReliabilityStatus', 'daily_intelligence_packages.satietyTargetScore'],
      ));
    }

    if (fromVersion < 10 && toVersion >= 10) {
      steps.add(const MigrationStepInfo(
        targetVersion: 10,
        description: 'Added movement_weakness_profiles, movement_logs',
        createdTables: ['movement_weakness_profiles', 'movement_logs'],
        addedColumns: ['users.movementHealthScore', 'users.estimatedMovementAge'],
      ));
    }

    if (fromVersion < 11 && toVersion >= 11) {
      steps.add(const MigrationStepInfo(
        targetVersion: 11,
        description: 'Added sleep fields and recovery logs enhancements',
        createdTables: [],
        addedColumns: ['users.estimatedRecoveryAge', 'users.circadianScore', 'recovery_logs.sleepNeedMinutes', 'recovery_logs.sleepPerformanceScore', 'recovery_logs.dailyStrainScore', 'recovery_logs.illnessRiskStatus'],
      ));
    }

    if (fromVersion < 12 && toVersion >= 12) {
      steps.add(const MigrationStepInfo(
        targetVersion: 12,
        description: 'Added training reliability, local readiness and athletic profile',
        createdTables: [],
        addedColumns: ['users.trainingReliabilityScore', 'users.upperBodyReadiness', 'users.lowerBodyReadiness', 'users.athleticProfileJson', 'movement_logs.tempoVariance', 'movement_logs.jointPathJitter'],
      ));
    }

    if (fromVersion < 13 && toVersion >= 13) {
      steps.add(const MigrationStepInfo(
        targetVersion: 13,
        description: 'Added athletic test battery and skill mastery levels',
        createdTables: [],
        addedColumns: ['users.athleticTestBatteryJson', 'users.skillMasteryLevelsJson', 'users.projectedPerformanceJson', 'movement_logs.leftVsRightAsymmetryRatio', 'movement_logs.repDurationMs'],
      ));
    }

    if (fromVersion < 14 && toVersion >= 14) {
      steps.add(const MigrationStepInfo(
        targetVersion: 14,
        description: 'Added glycemic analysis flag to food_logs',
        createdTables: [],
        addedColumns: ['food_logs.hasGlycemicAnalysis'],
      ));
    }

    if (fromVersion < 15 && toVersion >= 15) {
      steps.add(const MigrationStepInfo(
        targetVersion: 15,
        description: 'Added food_references lookup table',
        createdTables: ['food_references'],
        addedColumns: [],
      ));
    }

    if (fromVersion < 16 && toVersion >= 16) {
      steps.add(const MigrationStepInfo(
        targetVersion: 16,
        description: 'Added waistCm, neckCm, hipCm columns to transformation_checks table',
        createdTables: [],
        addedColumns: ['transformation_checks.waistCm', 'transformation_checks.neckCm', 'transformation_checks.hipCm'],
      ));
    }

    if (fromVersion < 17 && toVersion >= 17) {
      steps.add(const MigrationStepInfo(
        targetVersion: 17,
        description: 'v1.0 Hardening: Normalized UserScores time-series table, Phase 16 columns and B2B2C tables',
        createdTables: ['user_scores', 'organization_accounts', 'employee_enrollments'],
        addedColumns: ['users.timezoneOffsetMinutes', 'users.preferredDIPHour', 'users.whatsAppOptIn', 'users.abhaHealthId', 'users.preferredInputLanguage'],
      ));
    }

    if (fromVersion < 18 && toVersion >= 18) {
      steps.add(const MigrationStepInfo(
        targetVersion: 18,
        description: 'v18: Extended food_references with category, region, servingGrams, sourceTag for real food DB seed',
        createdTables: [],
        addedColumns: [
          'food_references.category',
          'food_references.region',
          'food_references.servingGrams',
          'food_references.sourceTag',
        ],
      ));
    }

    return steps;
  }

  /// Extracts legacy scalar score columns from a Users row and generates normalized UserScores entries (§DB-B)
  List<MigratedScoreRecord> migrateLegacyScores({
    required Map<String, dynamic> legacyUserRow,
    DateTime? migrationTimestamp,
  }) {
    final userId = legacyUserRow['localId'] as String? ?? 'user_unknown';
    final now = migrationTimestamp ?? DateTime.now();
    final records = <MigratedScoreRecord>[];

    legacyScoreColumnsMap.forEach((scoreTypeKey, legacyColumnName) {
      if (legacyUserRow.containsKey(legacyColumnName)) {
        final rawValue = legacyUserRow[legacyColumnName];
        if (rawValue != null) {
          final numericValue = (rawValue is num)
              ? rawValue.toDouble()
              : double.tryParse(rawValue.toString());

          if (numericValue != null) {
            records.add(MigratedScoreRecord(
              localId: 'score_${userId}_${scoreTypeKey}_${now.millisecondsSinceEpoch}',
              userId: userId,
              scoreType: scoreTypeKey,
              value: numericValue,
              computedAt: now,
            ));
          }
        }
      }
    });

    return records;
  }
}
