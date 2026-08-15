// §DB-C Cloudflare D1 Cloud Database Schema Contracts & Sync Validator
// Cross-reference: §DB-C in Fitkarma_documentation.md

class D1TableMetadata {
  final String tableName;
  final String primaryKey;
  final List<String> requiredColumns;
  final List<String> foreignKeys;
  final List<String> indexNames;
  final bool isDoubleEntryLedger;
  final bool isUserScoped;

  const D1TableMetadata({
    required this.tableName,
    required this.primaryKey,
    required this.requiredColumns,
    this.foreignKeys = const [],
    this.indexNames = const [],
    this.isDoubleEntryLedger = false,
    this.isUserScoped = true,
  });
}

/// Pure Dart Catalog & Contract Validator for §DB-C Cloudflare D1 Tables
class D1SchemaRegistry {
  static const List<D1TableMetadata> tables = [
    // 1. Users
    D1TableMetadata(
      tableName: 'users',
      primaryKey: 'localId',
      requiredColumns: [
        'localId', 'name', 'age', 'gender', 'heightCm', 'weightKg', 'bmi',
        'activityLevel', 'workStyle', 'goals', 'dietType', 'tdee',
        'dailyStepsTarget', 'dailyCalorieTarget', 'dailyWaterTargetL',
        'dailyProteinTargetG', 'tone', 'nutritionPeriodizationPhase',
        'monthlyGroceryBudgetInr', 'averageReliabilityPct',
        'athleticProfileJson', 'athleticTestBatteryJson',
        'skillMasteryLevelsJson', 'projectedPerformanceJson',
        'timezoneOffsetMinutes', 'preferredDIPHour', 'whatsAppOptIn',
        'preferredInputLanguage', 'createdAt', 'updatedAt'
      ],
      indexNames: ['IX_users_authProviderId'],
    ),

    // 2. UserScores
    D1TableMetadata(
      tableName: 'user_scores',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'scoreType', 'value', 'computedAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_user_scores_lookup'],
    ),

    // 3. OrganizationAccounts
    D1TableMetadata(
      tableName: 'organization_accounts',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'organizationName', 'accountType', 'planTier', 'seatLimit', 'createdAt'],
      isUserScoped: false,
    ),

    // 4. EmployeeEnrollments
    D1TableMetadata(
      tableName: 'employee_enrollments',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'organizationId', 'enrolledAt', 'isActive'],
      foreignKeys: ['users.localId', 'organization_accounts.localId'],
      indexNames: ['IX_enrollments_org'],
    ),

    // 5. FoodLogs
    D1TableMetadata(
      tableName: 'food_logs',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'consumeTime', 'foodName', 'calories', 'protein', 'carbs', 'fat', 'processingTier', 'hasGlycemicAnalysis', 'createdAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_food_logs_userId_consumeTime'],
    ),

    // 6. DailyIntelligencePackages
    D1TableMetadata(
      tableName: 'daily_intelligence_packages',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'packageDate', 'primaryInsight', 'todaysMission', 'nutritionFocus', 'recoveryFocus', 'motivationMessage', 'adjustedCalories', 'adjustedProtein', 'adjustedHydrationL', 'recommendedIntensity', 'isRestDay', 'activeRisks', 'showFestivalBanner', 'dietBreakActive', 'proteinTimingTarget', 'loggingReliabilityStatus', 'satietyTargetScore', 'aiCallsUsed', 'createdAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_dip_userId_date'],
    ),

    // 7. AICache
    D1TableMetadata(
      tableName: 'ai_cache',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'user_id', 'prompt_hash', 'response', 'expires_at', 'createdAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_ai_cache_user'],
    ),

    // 8. CGMReadings
    D1TableMetadata(
      tableName: 'cgm_readings',
      primaryKey: 'readingId',
      requiredColumns: ['readingId', 'userId', 'timestamp', 'glucoseMgDl', 'trend', 'status'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_cgm_readings_userId_timestamp'],
    ),

    // 9. RecoveryLogs
    D1TableMetadata(
      tableName: 'recovery_logs',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'logDate', 'readinessScore', 'confidenceTier', 'sleepQuality', 'sorenessLevel', 'stressLevel', 'energyLevel', 'sorenessRegions', 'sleepNeedMinutes', 'sleepPerformanceScore', 'dailyStrainScore', 'illnessRiskStatus', 'prescribedActionsJson', 'recoveryDriversJson', 'createdAt'],
      foreignKeys: ['users.localId'],
    ),

    // 10. TransformationChecks
    D1TableMetadata(
      tableName: 'transformation_checks',
      primaryKey: 'localId',
      requiredColumns: ['localId', 'userId', 'checkDate', 'weightKg', 'createdAt'],
      foreignKeys: ['users.localId'],
    ),

    // 11. SyncAuditTrail
    D1TableMetadata(
      tableName: 'sync_audit_trail',
      primaryKey: 'auditId',
      requiredColumns: ['auditId', 'userId', 'syncDirection', 'tableName', 'recordsProcessed', 'syncStatus', 'durationMs', 'processedAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_sync_audit_trail_userId'],
    ),

    // 12. SyncDeadLetterQueue
    D1TableMetadata(
      tableName: 'sync_dead_letter_queue',
      primaryKey: 'dlqId',
      requiredColumns: ['dlqId', 'userId', 'tableName', 'recordLocalId', 'payloadJson', 'failureReason', 'retryCount', 'status', 'queuedAt'],
      foreignKeys: ['users.localId'],
      indexNames: ['IX_sync_dlq_status'],
    ),

    // 13. MarketplaceWallets & MarketplaceLedgerEntries
    D1TableMetadata(
      tableName: 'marketplace_wallets',
      primaryKey: 'walletId',
      requiredColumns: ['walletId', 'creatorId', 'currency', 'status', 'createdAt'],
      foreignKeys: ['users.localId'],
    ),
    D1TableMetadata(
      tableName: 'marketplace_ledger_entries',
      primaryKey: 'entryId',
      requiredColumns: ['entryId', 'transactionId', 'accountType', 'debit', 'credit', 'timestamp'],
      foreignKeys: ['marketplace_wallets.walletId'],
      indexNames: ['IX_ledger_entries_wallet', 'IX_ledger_entries_tx'],
      isDoubleEntryLedger: true,
    ),
  ];

  /// Verifies a cloud record against table contract
  static bool validateRecord(String tableName, Map<String, dynamic> record) {
    final meta = tables.firstWhere(
      (t) => t.tableName == tableName,
      orElse: () => throw ArgumentError('Unknown table $tableName'),
    );

    if (!record.containsKey(meta.primaryKey)) return false;
    for (final col in meta.requiredColumns) {
      if (!record.containsKey(col)) return false;
    }
    return true;
  }
}
