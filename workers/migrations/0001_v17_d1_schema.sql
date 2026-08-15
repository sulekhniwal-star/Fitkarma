-- §DB-C Cloudflare D1 Cloud Database Schema (SQLite Dialect)
-- Migration 0001: Initial Schema v17

-- 1. Users Table (Normalized v17, no legacy score columns, includes Phase 16 fields)
CREATE TABLE IF NOT EXISTS users (
    localId TEXT NOT NULL,
    authProviderId TEXT NULL,
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    heightCm REAL NOT NULL,
    weightKg REAL NOT NULL,
    bmi REAL NOT NULL,
    activityLevel TEXT NOT NULL,
    workStyle TEXT NOT NULL,
    goals TEXT NOT NULL, -- JSON array
    dosha TEXT NULL,
    currentProgram TEXT NULL,
    dietType TEXT NOT NULL,
    region TEXT NULL,
    tdee REAL NOT NULL,
    dailyStepsTarget INTEGER NOT NULL,
    dailyCalorieTarget INTEGER NOT NULL,
    dailyWaterTargetL REAL NOT NULL,
    dailyProteinTargetG INTEGER NOT NULL,
    tone TEXT NOT NULL DEFAULT 'motivational',
    nutritionPeriodizationPhase TEXT NOT NULL DEFAULT 'maintenance',
    monthlyGroceryBudgetInr REAL NOT NULL DEFAULT 3000.0,
    familyUnitId TEXT NULL,
    averageReliabilityPct REAL NOT NULL DEFAULT 100.0,
    athleticProfileJson TEXT NOT NULL,
    athleticTestBatteryJson TEXT NOT NULL,
    skillMasteryLevelsJson TEXT NOT NULL,
    projectedPerformanceJson TEXT NOT NULL,
    timezoneOffsetMinutes INTEGER NOT NULL DEFAULT 330,
    preferredDIPHour INTEGER NOT NULL DEFAULT 6,
    whatsAppOptIn INTEGER NOT NULL DEFAULT 0,
    abhaHealthId TEXT NULL,
    preferredInputLanguage TEXT NOT NULL DEFAULT 'en',
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    updatedAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_users PRIMARY KEY (localId)
);

CREATE INDEX IF NOT EXISTS IX_users_authProviderId ON users (authProviderId);

-- 2. User Scores Table (Normalized v17 time-series score storage)
CREATE TABLE IF NOT EXISTS user_scores (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    scoreType TEXT NOT NULL,
    value REAL NOT NULL,
    computedAt TEXT NOT NULL,
    CONSTRAINT PK_user_scores PRIMARY KEY (localId),
    CONSTRAINT FK_user_scores_users FOREIGN KEY (userId) REFERENCES users(localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_user_scores_lookup ON user_scores (userId, scoreType, computedAt DESC);

-- 3. Organization Accounts & Employee Enrollments (Phase 16 B2B2C)
CREATE TABLE IF NOT EXISTS organization_accounts (
    localId TEXT NOT NULL,
    authProviderId TEXT NULL,
    organizationName TEXT NOT NULL,
    accountType TEXT NOT NULL, -- 'employer' | 'insurer'
    planTier TEXT NOT NULL,
    seatLimit INTEGER NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_organization_accounts PRIMARY KEY (localId)
);

CREATE TABLE IF NOT EXISTS employee_enrollments (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    organizationId TEXT NOT NULL,
    enrolledAt TEXT NOT NULL,
    isActive INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT PK_employee_enrollments PRIMARY KEY (localId),
    CONSTRAINT FK_enrollments_users FOREIGN KEY (userId) REFERENCES users(localId),
    CONSTRAINT FK_enrollments_org FOREIGN KEY (organizationId) REFERENCES organization_accounts(localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_enrollments_org ON employee_enrollments (organizationId, isActive);

-- 4. Food Logs Table
CREATE TABLE IF NOT EXISTS food_logs (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    consumeTime TEXT NOT NULL,
    foodName TEXT NOT NULL,
    calories REAL NOT NULL,
    protein REAL NOT NULL,
    carbs REAL NOT NULL,
    fat REAL NOT NULL,
    processingTier REAL NOT NULL DEFAULT 1.0,
    hasGlycemicAnalysis INTEGER NOT NULL DEFAULT 0,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_food_logs PRIMARY KEY (localId),
    CONSTRAINT FK_food_logs_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_food_logs_userId_consumeTime ON food_logs (userId ASC, consumeTime DESC);

-- 5. Daily Intelligence Packages Table
CREATE TABLE IF NOT EXISTS daily_intelligence_packages (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    packageDate TEXT NOT NULL,
    primaryInsight TEXT NOT NULL,
    todaysMission TEXT NOT NULL,
    nutritionFocus TEXT NOT NULL,
    recoveryFocus TEXT NOT NULL,
    motivationMessage TEXT NOT NULL,
    adjustedCalories INTEGER NOT NULL,
    adjustedProtein INTEGER NOT NULL,
    adjustedHydrationL REAL NOT NULL,
    recommendedIntensity TEXT NOT NULL,
    isRestDay INTEGER NOT NULL DEFAULT 0,
    activeRisks TEXT NOT NULL, -- JSON array
    showFestivalBanner INTEGER NOT NULL DEFAULT 0,
    festivalAdaptation TEXT NULL,
    dietBreakActive INTEGER NOT NULL DEFAULT 0,
    proteinTimingTarget INTEGER NOT NULL DEFAULT 25,
    loggingReliabilityStatus TEXT NOT NULL DEFAULT 'high',
    satietyTargetScore INTEGER NOT NULL DEFAULT 70,
    aiCallsUsed INTEGER NOT NULL DEFAULT 0,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_daily_intelligence_packages PRIMARY KEY (localId),
    CONSTRAINT FK_daily_intelligence_packages_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_dip_userId_date ON daily_intelligence_packages (userId ASC, packageDate DESC);

-- 6. AI Cache Table (Scoped by user_id, purged on account deletion)
CREATE TABLE IF NOT EXISTS ai_cache (
    localId TEXT NOT NULL,
    user_id TEXT NOT NULL,
    prompt_hash TEXT NOT NULL,
    response TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_ai_cache PRIMARY KEY (localId),
    CONSTRAINT UQ_ai_cache_user_prompt UNIQUE (user_id, prompt_hash),
    CONSTRAINT FK_ai_cache_users FOREIGN KEY (user_id) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_ai_cache_user ON ai_cache (user_id);

-- 7. CGM Readings Table
CREATE TABLE IF NOT EXISTS cgm_readings (
    readingId TEXT NOT NULL,
    userId TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    glucoseMgDl REAL NOT NULL,
    trend TEXT NOT NULL,
    status TEXT NOT NULL,
    CONSTRAINT PK_cgm_readings PRIMARY KEY (readingId),
    CONSTRAINT FK_cgm_readings_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_cgm_readings_userId_timestamp ON cgm_readings (userId ASC, timestamp DESC);

-- 8. Recovery Logs Table
CREATE TABLE IF NOT EXISTS recovery_logs (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    logDate TEXT NOT NULL,
    readinessScore INTEGER NOT NULL,
    confidenceTier TEXT NOT NULL DEFAULT 'basic',
    sleepQuality INTEGER NOT NULL,
    sorenessLevel INTEGER NOT NULL,
    stressLevel INTEGER NOT NULL,
    energyLevel INTEGER NOT NULL,
    restingHR REAL NULL,
    hrv REAL NULL,
    sorenessRegions TEXT NOT NULL,
    sleepNeedMinutes INTEGER NOT NULL DEFAULT 480,
    sleepPerformanceScore INTEGER NOT NULL DEFAULT 100,
    dailyStrainScore REAL NOT NULL DEFAULT 0.0,
    illnessRiskStatus TEXT NOT NULL DEFAULT 'low',
    prescribedActionsJson TEXT NOT NULL,
    recoveryDriversJson TEXT NOT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_recovery_logs PRIMARY KEY (localId),
    CONSTRAINT FK_recovery_logs_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

-- 9. Transformation Checks Table
CREATE TABLE IF NOT EXISTS transformation_checks (
    localId TEXT NOT NULL,
    userId TEXT NOT NULL,
    checkDate TEXT NOT NULL,
    weightKg REAL NOT NULL,
    bodyFatPct REAL NULL,
    waistCm REAL NULL,
    neckCm REAL NULL,
    hipCm REAL NULL,
    photoPath TEXT NULL,
    measurementsJson TEXT NULL,
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_transformation_checks PRIMARY KEY (localId),
    CONSTRAINT FK_transformation_checks_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

-- 10. Sync Audit Trail Table
CREATE TABLE IF NOT EXISTS sync_audit_trail (
    auditId TEXT NOT NULL,
    userId TEXT NOT NULL,
    syncDirection TEXT NOT NULL, -- 'PUSH' or 'PULL'
    tableName TEXT NOT NULL,
    recordsProcessed INTEGER NOT NULL,
    syncStatus TEXT NOT NULL, -- 'SUCCESS', 'FAILED', 'PARTIAL'
    errorMessage TEXT NULL,
    durationMs INTEGER NOT NULL,
    processedAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_sync_audit_trail PRIMARY KEY (auditId),
    CONSTRAINT FK_sync_audit_trail_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_sync_audit_trail_userId ON sync_audit_trail (userId);

-- 11. Sync Dead Letter Queue Table
CREATE TABLE IF NOT EXISTS sync_dead_letter_queue (
    dlqId TEXT NOT NULL,
    userId TEXT NOT NULL,
    tableName TEXT NOT NULL,
    recordLocalId TEXT NOT NULL,
    payloadJson TEXT NOT NULL,
    failureReason TEXT NOT NULL,
    retryCount INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'RETRIED', 'ABANDONED'
    queuedAt TEXT NOT NULL DEFAULT (datetime('now')),
    lastAttemptAt TEXT NULL,
    CONSTRAINT PK_sync_dead_letter_queue PRIMARY KEY (dlqId),
    CONSTRAINT FK_sync_dlq_users FOREIGN KEY (userId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_sync_dlq_status ON sync_dead_letter_queue (status);

-- 12. Marketplace Wallet & Double-Entry Ledger Tables
CREATE TABLE IF NOT EXISTS marketplace_wallets (
    walletId TEXT NOT NULL,
    creatorId TEXT NOT NULL,
    currency TEXT NOT NULL DEFAULT 'INR',
    status TEXT NOT NULL DEFAULT 'ACTIVE', -- 'ACTIVE', 'SUSPENDED'
    createdAt TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT PK_marketplace_wallets PRIMARY KEY (walletId),
    CONSTRAINT FK_marketplace_wallets_users FOREIGN KEY (creatorId) REFERENCES users (localId) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS marketplace_ledger_entries (
    entryId TEXT NOT NULL,
    transactionId TEXT NOT NULL,
    walletId TEXT NULL,
    accountType TEXT NOT NULL, -- 'escrowLiability', 'creatorPayable', 'platformRevenue', 'tcsLiability', 'tdsLiability', 'gstExpense', 'cashAsset'
    debit REAL NOT NULL DEFAULT 0.0000,
    credit REAL NOT NULL DEFAULT 0.0000,
    timestamp TEXT NOT NULL DEFAULT (datetime('now')),
    memo TEXT NULL,
    CONSTRAINT PK_marketplace_ledger_entries PRIMARY KEY (entryId),
    CONSTRAINT FK_marketplace_ledger_wallets FOREIGN KEY (walletId) REFERENCES marketplace_wallets (walletId) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS IX_ledger_entries_wallet ON marketplace_ledger_entries (walletId);
CREATE INDEX IF NOT EXISTS IX_ledger_entries_tx ON marketplace_ledger_entries (transactionId);
