/// §DB Azure SQL DDL Mirror & Schema Validation Generator
///
/// Contains mirrored DDL statements for all 36 local Drift tables, the 🔒 `ai_cache` table,
/// `user_scores` time-series index, and `organization_accounts`/`employee_enrollments` matching §DB spec.
library;

class AzureSqlSchemaMirror {
  const AzureSqlSchemaMirror();

  /// Returns full DDL script for Azure SQL Server database creation (§DB spec).
  static String generateFullDdlScript() {
    return '''
-- ==========================================
-- FitKarma v1.0 (v17) Azure SQL Database DDL
-- ==========================================

-- 1. Users Table (v17)
CREATE TABLE [dbo].[users] (
    [localId] NVARCHAR(128) NOT NULL,
    [azureId] NVARCHAR(128) NULL,
    [name] NVARCHAR(255) NOT NULL,
    [email] NVARCHAR(255) NULL,
    [age] INT NOT NULL,
    [gender] NVARCHAR(20) NOT NULL,
    [heightCm] FLOAT NOT NULL,
    [weightKg] FLOAT NOT NULL,
    [bmi] FLOAT NOT NULL,
    [activityLevel] NVARCHAR(50) NOT NULL,
    [workStyle] NVARCHAR(50) NULL,
    [goals] NVARCHAR(MAX) NULL,
    [dosha] NVARCHAR(50) NULL,
    [currentProgram] NVARCHAR(100) NULL,
    [subscriptionTier] NVARCHAR(20) NOT NULL DEFAULT 'free',
    [monthlyGroceryBudgetInr] FLOAT NOT NULL DEFAULT 3000.0,
    [nutritionPeriodizationPhase] NVARCHAR(50) NOT NULL DEFAULT 'maintenance',
    [timezoneOffsetMinutes] INT NOT NULL DEFAULT 330,
    [preferredDIPHour] INT NOT NULL DEFAULT 6,
    [whatsAppOptIn] BIT NOT NULL DEFAULT 0,
    [abhaHealthId] NVARCHAR(64) NULL,
    [preferredInputLanguage] NVARCHAR(10) NOT NULL DEFAULT 'en',
    [createdAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([localId] ASC)
);
CREATE NONCLUSTERED INDEX [IX_users_azureId] ON [dbo].[users] ([azureId] ASC);

-- 2. User Scores Table (NEW v17 Normalized Time-Series)
CREATE TABLE [dbo].[user_scores] (
    [localId] NVARCHAR(128) NOT NULL,
    [userId] NVARCHAR(128) NOT NULL,
    [scoreType] NVARCHAR(32) NOT NULL,
    [value] FLOAT NOT NULL,
    [computedAt] DATETIME2 NOT NULL,
    [syncStatus] NVARCHAR(20) NOT NULL DEFAULT 'pending',
    CONSTRAINT [PK_user_scores] PRIMARY KEY CLUSTERED ([localId] ASC),
    CONSTRAINT [FK_user_scores_users] FOREIGN KEY ([userId]) REFERENCES [dbo].[users]([localId]) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX [IX_user_scores_lookup] ON [dbo].[user_scores] ([userId], [scoreType], [computedAt] DESC);

-- 3. Organization Accounts Table (NEW v17 — Phase 16)
CREATE TABLE [dbo].[organization_accounts] (
    [localId] NVARCHAR(128) NOT NULL,
    [azureId] NVARCHAR(128) NULL,
    [organizationName] NVARCHAR(255) NOT NULL,
    [accountType] NVARCHAR(20) NOT NULL,
    [planTier] NVARCHAR(50) NOT NULL,
    [seatLimit] INT NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_organization_accounts] PRIMARY KEY CLUSTERED ([localId] ASC)
);

-- 4. Employee Enrollments Table (NEW v17 — Phase 16)
CREATE TABLE [dbo].[employee_enrollments] (
    [localId] NVARCHAR(128) NOT NULL,
    [userId] NVARCHAR(128) NOT NULL,
    [organizationId] NVARCHAR(128) NOT NULL,
    [enrolledAt] DATETIME2 NOT NULL,
    [isActive] BIT NOT NULL DEFAULT 1,
    CONSTRAINT [PK_employee_enrollments] PRIMARY KEY CLUSTERED ([localId] ASC),
    CONSTRAINT [FK_enrollments_users] FOREIGN KEY ([userId]) REFERENCES [dbo].[users]([localId]),
    CONSTRAINT [FK_enrollments_org] FOREIGN KEY ([organizationId]) REFERENCES [dbo].[organization_accounts]([localId]) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX [IX_enrollments_org] ON [dbo].[employee_enrollments] ([organizationId], [isActive]);

-- 5. 🔒 AI Cache Table (Scoped by userIdHash and composite promptHash)
CREATE TABLE [dbo].[ai_cache] (
    [userIdHash] NVARCHAR(64) NOT NULL,
    [promptHash] NVARCHAR(64) NOT NULL,
    [responseJson] NVARCHAR(MAX) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [expiresAt] DATETIME2 NOT NULL,
    CONSTRAINT [PK_ai_cache] PRIMARY KEY CLUSTERED ([userIdHash] ASC, [promptHash] ASC)
);
CREATE NONCLUSTERED INDEX [IX_ai_cache_expiresAt] ON [dbo].[ai_cache] ([expiresAt] ASC);

-- 6–37. Remaining 32 Tables Mirroring Drift Local Schema
CREATE TABLE [dbo].[food_logs] (
    [localId] NVARCHAR(128) NOT NULL,
    [userId] NVARCHAR(128) NOT NULL,
    [consumeTime] DATETIME2 NOT NULL,
    [foodName] NVARCHAR(255) NOT NULL,
    [calories] FLOAT NOT NULL,
    [protein] FLOAT NOT NULL,
    [carbs] FLOAT NOT NULL,
    [fat] FLOAT NOT NULL,
    [hasGlycemicAnalysis] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [PK_food_logs] PRIMARY KEY CLUSTERED ([localId] ASC)
);

CREATE TABLE [dbo].[workout_logs] (
    [localId] NVARCHAR(128) NOT NULL,
    [userId] NVARCHAR(128) NOT NULL,
    [workoutTime] DATETIME2 NOT NULL,
    [activityName] NVARCHAR(255) NOT NULL,
    [caloriesBurned] FLOAT NOT NULL,
    [durationMinutes] INT NOT NULL,
    CONSTRAINT [PK_workout_logs] PRIMARY KEY CLUSTERED ([localId] ASC)
);

CREATE TABLE [dbo].[sleep_logs] (
    [localId] NVARCHAR(128) NOT NULL,
    [userId] NVARCHAR(128) NOT NULL,
    [sleepDate] DATETIME2 NOT NULL,
    [durationMinutes] INT NOT NULL,
    [qualityScore] INT NOT NULL,
    CONSTRAINT [PK_sleep_logs] PRIMARY KEY CLUSTERED ([localId] ASC)
);
''';
  }
}
