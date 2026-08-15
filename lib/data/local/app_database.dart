// §DB Drift Local Schema (v17)
// Cross-reference: §DB in Fitkarma_documentation.md

import 'package:drift/drift.dart';

// ── 1. Core User & Scores Tables ─────────────────────────────────────────────

class Users extends Table {
  TextColumn get localId => text()();
  TextColumn get authProviderId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  RealColumn get bmi => real()();
  TextColumn get activityLevel => text()();
  TextColumn get workStyle => text()();
  TextColumn get goals => text()(); // JSON array
  TextColumn get dosha => text().nullable()();
  TextColumn get currentProgram => text().nullable()();
  TextColumn get dietType => text()();
  TextColumn get region => text().nullable()();
  RealColumn get tdee => real()();
  IntColumn get dailyStepsTarget => integer()();
  IntColumn get dailyCalorieTarget => integer()();
  RealColumn get dailyWaterTargetL => real()();
  IntColumn get dailyProteinTargetG => integer()();
  TextColumn get tone => text().withDefault(const Constant('motivational'))();
  TextColumn get nutritionPeriodizationPhase => text().withDefault(const Constant('maintenance'))(); // NEW v8
  RealColumn get monthlyGroceryBudgetInr => real().withDefault(const Constant(3000.0))(); // NEW v8
  TextColumn get familyUnitId => text().nullable()(); // NEW v9
  RealColumn get averageReliabilityPct => real().withDefault(const Constant(100.0))(); // NEW v9
  TextColumn get athleticProfileJson => text()(); // NEW v12
  TextColumn get athleticTestBatteryJson => text()(); // NEW v13
  TextColumn get skillMasteryLevelsJson => text()(); // NEW v13
  TextColumn get projectedPerformanceJson => text()(); // NEW v13
  IntColumn get timezoneOffsetMinutes => integer().withDefault(const Constant(330))(); // NEW v17 — 330 = IST
  IntColumn get preferredDIPHour => integer().withDefault(const Constant(6))(); // NEW v17
  BoolColumn get whatsAppOptIn => boolean().withDefault(const Constant(false))(); // NEW v17 — Phase 16
  TextColumn get abhaHealthId => text().nullable()(); // NEW v17 — Phase 16, encrypted at rest
  TextColumn get preferredInputLanguage => text().withDefault(const Constant('en'))(); // NEW v17 — Phase 16
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class UserScores extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get scoreType => text()(); // 'health', 'movement', 'circadian', etc.
  RealColumn get value => real()();
  DateTimeColumn get computedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── 2. Nutrition & Dietary Tables ────────────────────────────────────────────

class FoodLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get consumeTime => dateTime()();
  TextColumn get foodName => text()();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  RealColumn get processingTier => real().withDefault(const Constant(1.0))();
  BoolColumn get hasGlycemicAnalysis => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class DietPlans extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get dailyCalories => integer()();
  IntColumn get dailyProteinG => integer()();
  IntColumn get dailyCarbsG => integer()();
  IntColumn get dailyFatG => integer()();
  TextColumn get mealStructuresJson => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class MicronutrientLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get ironMg => real()();
  RealColumn get calciumMg => real()();
  RealColumn get magnesiumMg => real()();
  RealColumn get zincMg => real()();
  RealColumn get vitD3Iu => real()();
  RealColumn get vitB12Mcg => real()();
  RealColumn get omega3G => real()();
  RealColumn get folateMcg => real()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class MealNutritionDetails extends Table {
  TextColumn get localId => text()();
  TextColumn get mealLogId => text()();
  RealColumn get mealQualityScore => real()();
  RealColumn get glycemicSpikeMgDl => real()();
  RealColumn get proteinTimingScore => real()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class FamilyMealPlans extends Table {
  TextColumn get localId => text()();
  TextColumn get familyUnitId => text()();
  DateTimeColumn get planDate => dateTime()();
  TextColumn get recipeId => text()();
  TextColumn get recipeName => text()();
  TextColumn get portionGuidesJson => text()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class FoodSubstitutions extends Table {
  TextColumn get localId => text()();
  TextColumn get cavedFoodKey => text()();
  TextColumn get alternativeName => text()();
  IntColumn get calories => integer()();
  RealColumn get proteinG => real()();
  TextColumn get swapInstructions => text()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class FoodReferences extends Table {
  TextColumn get foodId => text()();
  TextColumn get foodName => text()();
  TextColumn get defaultServing => text()();
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  IntColumn get glycemicIndex => integer()();
  RealColumn get fiberG => real()();
  IntColumn get satietyIndex => integer()();

  @override
  Set<Column> get primaryKey => {foodId};
}

// ── 3. Movement & Workout Tables ─────────────────────────────────────────────

class WorkoutLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get workoutDate => dateTime()();
  TextColumn get programId => text().nullable()();
  TextColumn get workoutName => text()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  RealColumn get intensityFactor => real().withDefault(const Constant(1.0))();
  IntColumn get durationMinutes => integer()();
  RealColumn get totalVolumeKg => real().withDefault(const Constant(0.0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class MovementLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get workoutLogId => text()();
  TextColumn get exerciseKey => text()();
  IntColumn get repCount => integer()();
  RealColumn get averageFormScore => real()();
  RealColumn get exerciseConfidenceScore => real()();
  RealColumn get tempoVariance => real().withDefault(const Constant(0.0))();
  RealColumn get jointPathJitter => real().withDefault(const Constant(0.0))();
  TextColumn get diagnosedLimiter => text().nullable()();
  TextColumn get prescribedCorrectivesJson => text()();
  RealColumn get leftVsRightAsymmetryRatio => real().withDefault(const Constant(0.0))();
  IntColumn get repDurationMs => integer().withDefault(const Constant(0))();
  TextColumn get jointAnglesJson => text()();
  TextColumn get repTemposJson => text()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class MovementWeaknessProfiles extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get exerciseKey => text()();
  TextColumn get activeFaultsJson => text()();
  TextColumn get remedialDrillsJson => text()();
  DateTimeColumn get lastCalculatedAt => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── 4. Recovery, Sleep & Biomarker Tables ────────────────────────────────────

class RecoveryLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get readinessScore => integer()();
  TextColumn get confidenceTier => text()();
  IntColumn get sleepQuality => integer()();
  IntColumn get sorenessLevel => integer()();
  IntColumn get stressLevel => integer()();
  IntColumn get energyLevel => integer()();
  RealColumn get restingHR => real().nullable()();
  RealColumn get hrv => real().nullable()();
  TextColumn get sorenessRegions => text()();
  IntColumn get sleepNeedMinutes => integer().withDefault(const Constant(480))();
  IntColumn get sleepPerformanceScore => integer().withDefault(const Constant(100))();
  RealColumn get dailyStrainScore => real().withDefault(const Constant(0.0))();
  TextColumn get illnessRiskStatus => text().withDefault(const Constant('low'))();
  TextColumn get prescribedActionsJson => text()();
  TextColumn get recoveryDriversJson => text()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class SleepLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get sleepDate => dateTime()();
  IntColumn get durationMinutes => integer()();
  IntColumn get deepSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get remSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get lightSleepMinutes => integer().withDefault(const Constant(0))();
  IntColumn get awakeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get qualityScore => integer().withDefault(const Constant(70))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class BpReadings extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkTime => dateTime()();
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  IntColumn get pulse => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class GlucoseReadings extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkTime => dateTime()();
  RealColumn get glucoseMgDl => real()();
  TextColumn get mealContext => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class CgmReadings extends Table {
  TextColumn get readingId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get glucoseMgDl => real()();
  TextColumn get trend => text()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {readingId};
}

class MedicationLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  DateTimeColumn get scheduledTime => dateTime()();
  DateTimeColumn get takenTime => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── 5. Intelligence, Habits & Daily Briefing Tables ──────────────────────────

class DailyIntelligencePackages extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get packageDate => dateTime()();
  TextColumn get primaryInsight => text()();
  TextColumn get todaysMission => text()();
  TextColumn get nutritionFocus => text()();
  TextColumn get recoveryFocus => text()();
  TextColumn get motivationMessage => text()();
  IntColumn get adjustedCalories => integer()();
  IntColumn get adjustedProtein => integer()();
  RealColumn get adjustedHydrationL => real()();
  TextColumn get recommendedIntensity => text()();
  BoolColumn get isRestDay => boolean().withDefault(const Constant(false))();
  TextColumn get activeRisks => text()(); // JSON array
  BoolColumn get showFestivalBanner => boolean().withDefault(const Constant(false))();
  TextColumn get festivalAdaptation => text().nullable()();
  BoolColumn get dietBreakActive => boolean().withDefault(const Constant(false))();
  IntColumn get proteinTimingTarget => integer().withDefault(const Constant(25))();
  TextColumn get loggingReliabilityStatus => text().withDefault(const Constant('high'))();
  IntColumn get satietyTargetScore => integer().withDefault(const Constant(70))();
  IntColumn get aiCallsUsed => integer()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class HealthSnapshots extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get snapshotDate => dateTime()();
  TextColumn get proteinTrend => text()();
  TextColumn get sleepTrend => text()();
  RealColumn get weightChange4w => real()();
  IntColumn get currentStreak => integer()();
  IntColumn get readinessScore => integer()();
  IntColumn get healthScore => integer()();
  BoolColumn get activeRisk => boolean()();
  TextColumn get primaryConcern => text()();
  TextColumn get programPhase => text()();
  IntColumn get daysToGoal => integer()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class TransformationMemories extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get weightHistoryJson => text()();
  TextColumn get majorStruggles => text()();
  TextColumn get injuriesJson => text()();
  TextColumn get successPatterns => text()();
  TextColumn get motivationTriggers => text()();
  TextColumn get primaryPersonality => text()();
  TextColumn get conversationSummary => text()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class LifeEvents extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get eventType => text()();
  TextColumn get eventData => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class WaterLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logTime => dateTime()();
  RealColumn get amountMl => real()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class HabitLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  TextColumn get habitId => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class MoodLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logTime => dateTime()();
  IntColumn get moodScore => integer()();
  IntColumn get energyScore => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class KarmaEvents extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get eventTime => dateTime()();
  IntColumn get xpAwarded => integer()();
  TextColumn get eventType => text()();
  TextColumn get description => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class AiInsights extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get category => text()();
  TextColumn get content => text()();
  BoolColumn get actionTaken => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── 6. Transformation & Measurements Tables ──────────────────────────────────

class TransformationChecks extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkDate => dateTime()();
  RealColumn get weightKg => real()();
  RealColumn get bodyFatPct => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get hipCm => real().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get measurementsJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class BodyMeasurements extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get bicepsCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
  RealColumn get calvesCm => real().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── 7. Social, Marketplace & B2B2C Tables ────────────────────────────────────

class SquadGroups extends Table {
  TextColumn get squadId => text()();
  TextColumn get name => text()();
  TextColumn get inviteCode => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {squadId};
}

class SquadMembers extends Table {
  TextColumn get localId => text()();
  TextColumn get squadId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

class Followers extends Table {
  TextColumn get localId => text()();
  TextColumn get followerUserId => text()();
  TextColumn get followedUserId => text()();
  DateTimeColumn get followedAt => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

class Clubs extends Table {
  TextColumn get clubId => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get city => text()();
  TextColumn get type => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {clubId};
}

class CreatorProfiles extends Table {
  TextColumn get creatorId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get bio => text()();
  TextColumn get specialties => text()();
  RealColumn get rating => real()();
  RealColumn get rateInr => real()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {creatorId};
}

class OrganizationAccounts extends Table {
  TextColumn get localId => text()();
  TextColumn get authProviderId => text().nullable()();
  TextColumn get organizationName => text()();
  TextColumn get accountType => text()(); // 'employer' | 'insurer'
  TextColumn get planTier => text()(); // 'corporate_basic' | 'corporate_plus'
  IntColumn get seatLimit => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class EmployeeEnrollments extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get organizationId => text()();
  DateTimeColumn get enrolledAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── App Database Definition ──────────────────────────────────────────────────

/// Complete List of all 36 Drift tables in Schema v17
final driftV17Tables = <Type>[
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
];

const int kAppDatabaseSchemaVersion = 17;
