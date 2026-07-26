import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/security/security_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// 1. Users Table
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get azureId => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()(); // 'male' | 'female'
  RealColumn get weight => real().nullable()();
  RealColumn get height => real().nullable()();
  TextColumn get activityLevel => text().nullable()();
  TextColumn get goals => text().nullable()(); // JSON list
  RealColumn get targetWeight => real().nullable()();
  IntColumn get dailyCalorieTarget => integer().nullable()();
  TextColumn get dosha => text().nullable()();
  TextColumn get currentProgram => text().nullable()();
  BoolColumn get isCycleTrackingEnabled => boolean().nullable()();
  IntColumn get averageCycleLength => integer().nullable()();
  DateTimeColumn get lastPeriodDate => dateTime().nullable()();
  TextColumn get subscriptionTier => text().withDefault(const Constant('free'))();
  RealColumn get monthlyGroceryBudgetInr => real().withDefault(const Constant(3000.0))();
  TextColumn get nutritionPeriodizationPhase => text().withDefault(const Constant('maintenance'))();
  DateTimeColumn get periodizationPhaseStartedAt => dateTime().nullable()();
  IntColumn get timezoneOffsetMinutes => integer().withDefault(const Constant(330))();
  IntColumn get preferredDIPHour => integer().withDefault(const Constant(6))();
  BoolColumn get whatsAppOptIn => boolean().withDefault(const Constant(false))();
  TextColumn get abhaHealthId => text().nullable()();
  TextColumn get preferredInputLanguage => text().withDefault(const Constant('en'))();
  IntColumn get streak => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class FoodLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get consumeTime => dateTime()();
  TextColumn get foodName => text()();
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  RealColumn get processingTier => real().withDefault(const Constant(1.0))();
  BoolColumn get hasGlycemicAnalysis => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

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
  RealColumn get hrvMs => real().withDefault(const Constant(0.0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class BodyMeasurements extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get weightKg => real()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get bicepsCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
  RealColumn get calvesCm => real().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

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
  DateTimeColumn get createdAt => dateTime()();

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
  DateTimeColumn get createdAt => dateTime()();

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
  DateTimeColumn get createdAt => dateTime()();

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
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

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
  DateTimeColumn get createdAt => dateTime()();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class Followers extends Table {
  TextColumn get localId => text()();
  TextColumn get followerUserId => text()();
  TextColumn get followedUserId => text()();
  DateTimeColumn get followedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {clubId};
}

class CgmReadings extends Table {
  TextColumn get readingId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get glucoseMgDl => real()();
  TextColumn get trend => text()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {readingId};
}

class CreatorProfiles extends Table {
  TextColumn get creatorId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get bio => text()();
  TextColumn get specialties => text()();
  RealColumn get rating => real()();
  RealColumn get rateInr => real()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {creatorId};
}

class MealNutritionDetails extends Table {
  TextColumn get localId => text()();
  TextColumn get mealLogId => text()();
  RealColumn get mealQualityScore => real()();
  RealColumn get glycemicSpikeMgDl => real()();
  RealColumn get proteinTimingScore => real()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

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
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

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

// 1. Users Table

// 1.5 Menstrual Symptom Logs Table
class MenstrualSymptomLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  BoolColumn get hasMenstrualFlow => boolean()();
  RealColumn get basalBodyTemperature => real().nullable()();
  BoolColumn get positiveLhTest => boolean().nullable()();
  TextColumn get physicalSymptoms => text()(); // comma separated list
  IntColumn get restingHeartRate => integer().nullable()();
  RealColumn get hrvMs => real().nullable()();
}

// 2. Cumulative Water logs
class WaterLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cups => integer()();
  TextColumn get syncBatchId => text()();
  DateTimeColumn get loggedAt => dateTime()();

  // HLC logical components
  DateTimeColumn get hlcPhysicalTime => dateTime()();
  IntColumn get hlcLogicalCounter => integer()();
  TextColumn get hlcNodeId => text()();
}

// 3. Priority Sync Queue
class SyncQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get serializedPayload => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncBatchId => text()();
}

// 4. Dead Letter Queue
class DeadLetterQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get serializedPayload => text()();
  TextColumn get syncBatchId => text()();
  TextColumn get failureReason => text()();
  DateTimeColumn get failedAt => dateTime()();
}

// 5. Daily Intelligence Packages
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
  BoolColumn get showFestivalBanner =>
      boolean().withDefault(const Constant(false))();
  TextColumn get festivalAdaptation => text().nullable()();
  BoolColumn get dietBreakActive =>
      boolean().withDefault(const Constant(false))();
  IntColumn get proteinTimingTarget =>
      integer().withDefault(const Constant(25))();
  TextColumn get loggingReliabilityStatus =>
      text().withDefault(const Constant('high'))();
  IntColumn get satietyTargetScore =>
      integer().withDefault(const Constant(70))();
  IntColumn get aiCallsUsed => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// 6. AI response Cache Table
class AICacheEntries extends Table {
  TextColumn get userId => text()();
  TextColumn get promptHash => text()();
  TextColumn get response => text()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, promptHash};
}

// 7. Transformation Memories
class TransformationMemories extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get weightHistoryJson => text()(); // JSON array
  TextColumn get majorStruggles => text()(); // JSON array
  TextColumn get injuriesJson => text()(); // JSON array
  TextColumn get successPatterns => text()(); // JSON array
  TextColumn get motivationTriggers => text()(); // JSON array
  TextColumn get primaryPersonality => text()();
  TextColumn get conversationSummary => text()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}

// 8. Diet Plans — 7-day AI / deterministic plan cache (§P1-E)
class CachedDietPlans extends Table {
  TextColumn get userId => text()();

  /// Full plan serialized as JSON ({"days":[...]}).
  TextColumn get planJson => text()();
  IntColumn get calorieTarget => integer()();
  IntColumn get proteinTargetG => integer()();
  BoolColumn get isAiGenerated => boolean().withDefault(const Constant(true))();
  DateTimeColumn get generatedAt => dateTime()();

  /// Plan is valid for 7 days; re-generate when expired or BMI shifts > 1.0.
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

class RecoveryLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get readinessScore => integer()();
  TextColumn get confidenceTier => text()(); // basic/enhanced/premium
  IntColumn get sleepQuality => integer()();
  IntColumn get sorenessLevel => integer()();
  IntColumn get stressLevel => integer()();
  IntColumn get energyLevel => integer()();
  RealColumn get restingHR => real().nullable()();
  RealColumn get hrv => real().nullable()();
  TextColumn get sorenessRegions => text()();
  IntColumn get sleepNeedMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get sleepPerformanceScore =>
      integer().withDefault(const Constant(100))();
  RealColumn get dailyStrainScore => real().withDefault(const Constant(0.0))();
  TextColumn get illnessRiskStatus =>
      text().withDefault(const Constant('low'))();
  TextColumn get prescribedActionsJson => text()();
  TextColumn get recoveryDriversJson => text()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId => text().withLength(min: 1, max: 50)();
  TextColumn get senderType => text()(); // 'user' or 'ai'
  TextColumn get messageContent => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get sourcesJson => text().nullable()();
  TextColumn get localAttachmentPath => text().nullable()();
}

class EscalationEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get reason => text()();
  TextColumn get briefing => text()();
  DateTimeColumn get escalatedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
}

class StepLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get steps => integer()();
  TextColumn get syncBatchId => text()();
  DateTimeColumn get loggedAt => dateTime()();

  // HLC logical components
  DateTimeColumn get hlcPhysicalTime => dateTime()();
  IntColumn get hlcLogicalCounter => integer()();
  TextColumn get hlcNodeId => text()();
}


class BpReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  DateTimeColumn get measuredAt => dateTime()();
  TextColumn get recordingMethod => text()(); // 'manual' or 'wearable'
  DateTimeColumn get createdAt => dateTime()();
}

class GlucoseReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  RealColumn get valueMgDl => real()();
  TextColumn get mealTag =>
      text()(); // 'Fasting', 'Pre-Meal', 'Post-Meal (1-hour)', 'Post-Meal (2-hour)'
  DateTimeColumn get measuredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

// FoodReferences — offline seeded Indian food nutrition database (§P5-D)
class FoodReferences extends Table {
  TextColumn get id => text()(); // e.g. 'roti_1', 'dal_1'
  TextColumn get foodName => text()();
  RealColumn get defaultServingG => real()();
  TextColumn get servingDescription => text()(); // e.g. '1 Roti (40g)'
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  IntColumn get glycemicIndex => integer()();
  RealColumn get fiberG => real()();
  IntColumn get satietyIndex => integer()(); // 0–100
  TextColumn get searchTerms => text()(); // comma-separated aliases

  @override
  Set<Column> get primaryKey => {id};
}

class MicronutrientLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get ironMg => real().withDefault(const Constant(0.0))();
  RealColumn get vitaminB12Mcg => real().withDefault(const Constant(0.0))();
  RealColumn get vitaminD3Iu => real().withDefault(const Constant(0.0))();
  RealColumn get calciumMg => real().withDefault(const Constant(0.0))();
  RealColumn get magnesiumMg => real().withDefault(const Constant(0.0))();
  RealColumn get zincMg => real().withDefault(const Constant(0.0))();
  RealColumn get folateMcg => real().withDefault(const Constant(0.0))();
  RealColumn get omega3G => real().withDefault(const Constant(0.0))();
}

// 🆕 v17 Normalized UserScores Time-Series Table (§DB)
class UserScores extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get scoreType => text()(); // 'health' | 'movement' | 'circadian' | 'trainingReliability' | etc.
  RealColumn get value => real()();
  DateTimeColumn get computedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {localId};
}

// 🆕 v17 Organization Accounts Table (§P16-D)
class OrganizationAccounts extends Table {
  TextColumn get localId => text()();
  TextColumn get azureId => text().nullable()();
  TextColumn get organizationName => text()();
  TextColumn get accountType => text()(); // 'employer' | 'insurer'
  TextColumn get planTier => text()(); // 'corporate_basic' | 'corporate_plus'
  IntColumn get seatLimit => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// 🆕 v17 Employee Enrollments Table (§P16-D)
class EmployeeEnrollments extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  TextColumn get organizationId => text()();
  DateTimeColumn get enrolledAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DriftDatabase(
  tables: [
    Users,
    UserScores,
    OrganizationAccounts,
    EmployeeEnrollments,
    WaterLogs,
    SyncQueueItems,
    DeadLetterQueueItems,
    DailyIntelligencePackages,
    AICacheEntries,
    TransformationMemories,
    CachedDietPlans,
    MenstrualSymptomLogs,
    RecoveryLogs,
    ChatMessages,
    EscalationEvents,
    StepLogs,
    SleepLogs,
    BpReadings,
    GlucoseReadings,
    FoodReferences,
    MicronutrientLogs,
    FoodLogs,
    WorkoutLogs,
    BodyMeasurements,
    HealthSnapshots,
    HabitLogs,
    MoodLogs,
    KarmaEvents,
    AiInsights,
    TransformationChecks,
    LifeEvents,
    Followers,
    Clubs,
    CgmReadings,
    CreatorProfiles,
    MealNutritionDetails,
    FamilyMealPlans,
    FoodSubstitutions,
    MovementWeaknessProfiles,
    MovementLogs,
    SquadGroups,
    SquadMembers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.executor(super.e);

  @override
  int get schemaVersion => 35;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 21) {
          await migrator.addColumn(users, users.dosha);
        }
        if (from < 22) {
          await migrator.addColumn(users, users.currentProgram);
        }
        if (from < 23) {
          await migrator.addColumn(users, users.isCycleTrackingEnabled);
          await migrator.addColumn(users, users.averageCycleLength);
          await migrator.addColumn(users, users.lastPeriodDate);
          await migrator.createTable(menstrualSymptomLogs);
        }
        if (from < 24) {
          await migrator.createTable(recoveryLogs);
        }
        if (from < 25) {
          await migrator.createTable(chatMessages);
        }
        if (from < 26) {
          await migrator.addColumn(users, users.subscriptionTier);
          await migrator.createTable(escalationEvents);
        }
        if (from < 27) {
          await migrator.createTable(stepLogs);
        }
        if (from < 28) {
          await migrator.createTable(sleepLogs);
        }
        if (from < 29) {
          await migrator.createTable(bpReadings);
        }
        if (from < 30) {
          await migrator.createTable(glucoseReadings);
        }
        if (from < 31) {
          await migrator.createTable(foodReferences);
        }
        if (from < 32) {
          await migrator.addColumn(users, users.monthlyGroceryBudgetInr);
        }
        if (from < 33) {
          await migrator.addColumn(users, users.nutritionPeriodizationPhase);
          await migrator.addColumn(users, users.periodizationPhaseStartedAt);
        }
        if (from < 34) {
          await migrator.createTable(micronutrientLogs);
        }
        if (from < 35) {
          // v17 (v1.0 hardening): create UserScores, OrganizationAccounts, EmployeeEnrollments
          await migrator.createTable(userScores);
          await migrator.createTable(organizationAccounts);
          await migrator.createTable(employeeEnrollments);

          // Add v17 Users columns
          await migrator.addColumn(users, users.timezoneOffsetMinutes);
          await migrator.addColumn(users, users.preferredDIPHour);
          await migrator.addColumn(users, users.whatsAppOptIn);
          await migrator.addColumn(users, users.abhaHealthId);
          await migrator.addColumn(users, users.preferredInputLanguage);
        }
      },
    );
  }

  /// Hot-path query: Returns latest score value of type [scoreType] for user [userId] (§DB spec).
  /// Uses index `(userId, scoreType, computedAt DESC)`.
  Future<double?> latestScore(String userId, String scoreType) async {
    final row = await (select(userScores)
          ..where((t) => t.userId.equals(userId) & t.scoreType.equals(scoreType))
          ..orderBy([(t) => OrderingTerm(expression: t.computedAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return row?.value;
  }

  /// Upserts the onboarding goals + target weight for a given user.
  Future<void> updateUserProfile({
    required String userId,
    String? goalsJson,
    double? targetWeight,
    int? dailyCalorieTarget,
    String? dosha,
    String? currentProgram,
    bool? isCycleTrackingEnabled,
    int? averageCycleLength,
    DateTime? lastPeriodDate,
    String? subscriptionTier,
    double? monthlyGroceryBudgetInr,
    String? nutritionPeriodizationPhase,
    DateTime? periodizationPhaseStartedAt,
  }) async {
    await (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        goals: goalsJson != null ? Value(goalsJson) : const Value.absent(),
        targetWeight: targetWeight != null
            ? Value(targetWeight)
            : const Value.absent(),
        dailyCalorieTarget: dailyCalorieTarget != null
            ? Value(dailyCalorieTarget)
            : const Value.absent(),
        dosha: dosha != null ? Value(dosha) : const Value.absent(),
        currentProgram: currentProgram != null
            ? Value(currentProgram)
            : const Value.absent(),
        isCycleTrackingEnabled: isCycleTrackingEnabled != null
            ? Value(isCycleTrackingEnabled)
            : const Value.absent(),
        averageCycleLength: averageCycleLength != null
            ? Value(averageCycleLength)
            : const Value.absent(),
        lastPeriodDate: lastPeriodDate != null
            ? Value(lastPeriodDate)
            : const Value.absent(),
        subscriptionTier: subscriptionTier != null
            ? Value(subscriptionTier)
            : const Value.absent(),
        monthlyGroceryBudgetInr: monthlyGroceryBudgetInr != null
            ? Value(monthlyGroceryBudgetInr)
            : const Value.absent(),
        nutritionPeriodizationPhase: nutritionPeriodizationPhase != null
            ? Value(nutritionPeriodizationPhase)
            : const Value.absent(),
        periodizationPhaseStartedAt: periodizationPhaseStartedAt != null
            ? Value(periodizationPhaseStartedAt)
            : const Value.absent(),
      ),
    );
  }

  // ── Women's Health helpers ──────────────────────────────────────────────

  Future<void> saveMenstrualSymptomLog(
    MenstrualSymptomLogsCompanion log,
  ) async {
    await into(menstrualSymptomLogs).insertOnConflictUpdate(log);
  }

  Future<List<MenstrualSymptomLog>> getMenstrualSymptomLogs(
    String userId,
  ) async {
    return (select(menstrualSymptomLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // ── Recovery Logs helpers ──────────────────────────────────────────────────

  Future<void> saveRecoveryLog(RecoveryLogsCompanion log) async {
    await into(recoveryLogs).insertOnConflictUpdate(log);
  }

  Future<List<RecoveryLog>> getRecoveryLogs(String userId) async {
    return (select(recoveryLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // ── Chat Messages helpers ──────────────────────────────────────────────────

  Future<void> saveChatMessage(ChatMessagesCompanion message) async {
    await into(chatMessages).insertOnConflictUpdate(message);
  }

  Future<List<ChatMessage>> getChatMessages(String conversationId) async {
    return (select(chatMessages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Upserts age, gender, height, weight, activityLevel, and computed
  /// dailyCalorieTarget for the Demographics Screen (§P1-D).
  Future<void> updateUserDemographics({
    required String userId,
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String activityLevel,
    required int dailyCalorieTarget,
  }) async {
    await (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        age: Value(age),
        gender: Value(gender),
        height: Value(heightCm),
        weight: Value(weightKg),
        activityLevel: Value(activityLevel),
        dailyCalorieTarget: Value(dailyCalorieTarget),
      ),
    );
  }

  // ── Diet Plan Cache helpers (§P1-E) ────────────────────────────────────────

  /// Writes (or replaces) the cached 7-day diet plan for a user.
  Future<void> saveDietPlan({
    required String userId,
    required String planJson,
    required int calorieTarget,
    required int proteinTargetG,
    required bool isAiGenerated,
  }) async {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));
    await into(cachedDietPlans).insertOnConflictUpdate(
      CachedDietPlansCompanion.insert(
        userId: userId,
        planJson: planJson,
        calorieTarget: calorieTarget,
        proteinTargetG: proteinTargetG,
        isAiGenerated: Value(isAiGenerated),
        generatedAt: now,
        expiresAt: expiresAt,
      ),
    );
  }

  /// Returns the cached plan if it exists and has not expired; otherwise null.
  Future<CachedDietPlan?> getCachedDietPlan(String userId) async {
    return (select(cachedDietPlans)..where(
          (t) =>
              t.userId.equals(userId) &
              t.expiresAt.isBiggerThanValue(DateTime.now()),
        ))
        .getSingleOrNull();
  }

  // ── Escalation Events helpers ──────────────────────────────────────────────

  Future<void> saveEscalationEvent(EscalationEventsCompanion event) async {
    await into(escalationEvents).insertOnConflictUpdate(event);
  }

  Future<List<EscalationEvent>> getEscalationEvents(String userId) async {
    return (select(escalationEvents)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.escalatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // ── FoodReferences helpers (§P5-B) ────────────────────────────────────────

  /// Idempotent seed for the 15 pre-seeded Indian foods from §P5-D.
  Future<void> seedFoodReferences() async {
    const seeds = [
      FoodReferencesCompanion(
        id: Value('roti_1'),
        foodName: Value('Whole Wheat Roti'),
        defaultServingG: Value(40),
        servingDescription: Value('1 Roti (40g)'),
        calories: Value(85),
        proteinG: Value(3.0),
        carbsG: Value(18),
        fatG: Value(0.5),
        glycemicIndex: Value(62),
        fiberG: Value(2.5),
        satietyIndex: Value(65),
        searchTerms: Value('roti,chapati,wheat roti,fulka,phulka'),
      ),
      FoodReferencesCompanion(
        id: Value('rice_1'),
        foodName: Value('Steamed Basmati Rice'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Cup (150g)'),
        calories: Value(200),
        proteinG: Value(4.2),
        carbsG: Value(44),
        fatG: Value(0.4),
        glycemicIndex: Value(72),
        fiberG: Value(1.0),
        satietyIndex: Value(50),
        searchTerms: Value('rice,basmati,steamed rice,white rice,chawal'),
      ),
      FoodReferencesCompanion(
        id: Value('dal_1'),
        foodName: Value('Dal Tadka (Yellow)'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Bowl (150g)'),
        calories: Value(150),
        proteinG: Value(8.5),
        carbsG: Value(22),
        fatG: Value(3.5),
        glycemicIndex: Value(45),
        fiberG: Value(6.0),
        satietyIndex: Value(75),
        searchTerms: Value('dal,dal tadka,tadka dal,yellow dal,lentil,dhal'),
      ),
      FoodReferencesCompanion(
        id: Value('paneer_1'),
        foodName: Value('Paneer Bhurji'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Plate (150g)'),
        calories: Value(280),
        proteinG: Value(18.0),
        carbsG: Value(8),
        fatG: Value(20),
        glycemicIndex: Value(30),
        fiberG: Value(2.0),
        satietyIndex: Value(85),
        searchTerms: Value('paneer,paneer bhurji,bhurji,cottage cheese'),
      ),
      FoodReferencesCompanion(
        id: Value('chick_1'),
        foodName: Value('Tandoori Chicken'),
        defaultServingG: Value(180),
        servingDescription: Value('1 Plate (180g)'),
        calories: Value(260),
        proteinG: Value(32.0),
        carbsG: Value(3),
        fatG: Value(12),
        glycemicIndex: Value(15),
        fiberG: Value(0.5),
        satietyIndex: Value(90),
        searchTerms: Value(
          'chicken,tandoori chicken,grilled chicken,chicken tikka,murgh',
        ),
      ),
      FoodReferencesCompanion(
        id: Value('poha_1'),
        foodName: Value('Onion Poha'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Plate (150g)'),
        calories: Value(220),
        proteinG: Value(3.5),
        carbsG: Value(42),
        fatG: Value(4.0),
        glycemicIndex: Value(68),
        fiberG: Value(2.8),
        satietyIndex: Value(60),
        searchTerms: Value('poha,onion poha,beaten rice,chivda'),
      ),
      FoodReferencesCompanion(
        id: Value('idli_1'),
        foodName: Value('Steamed Idli'),
        defaultServingG: Value(90),
        servingDescription: Value('2 Pieces (90g)'),
        calories: Value(120),
        proteinG: Value(3.0),
        carbsG: Value(26),
        fatG: Value(0.2),
        glycemicIndex: Value(70),
        fiberG: Value(1.5),
        satietyIndex: Value(58),
        searchTerms: Value('idli,steamed idli,idly,idlis'),
      ),
      FoodReferencesCompanion(
        id: Value('dosa_1'),
        foodName: Value('Plain Dosa'),
        defaultServingG: Value(80),
        servingDescription: Value('1 Piece (80g)'),
        calories: Value(165),
        proteinG: Value(3.2),
        carbsG: Value(32),
        fatG: Value(2.5),
        glycemicIndex: Value(75),
        fiberG: Value(1.2),
        satietyIndex: Value(55),
        searchTerms: Value('dosa,plain dosa,dosai,crispy dosa,masala dosa'),
      ),
      FoodReferencesCompanion(
        id: Value('sambar_1'),
        foodName: Value('Mixed Veg Sambar'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Bowl (150g)'),
        calories: Value(110),
        proteinG: Value(4.0),
        carbsG: Value(18),
        fatG: Value(2.0),
        glycemicIndex: Value(48),
        fiberG: Value(4.5),
        satietyIndex: Value(70),
        searchTerms: Value('sambar,sambhar,veg sambar,south indian curry'),
      ),
      FoodReferencesCompanion(
        id: Value('chole_1'),
        foodName: Value('Punjabi Chole Masala'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Bowl (150g)'),
        calories: Value(240),
        proteinG: Value(10.2),
        carbsG: Value(34),
        fatG: Value(7.0),
        glycemicIndex: Value(38),
        fiberG: Value(8.5),
        satietyIndex: Value(80),
        searchTerms: Value('chole,chana,chole masala,chickpea curry,chick pea'),
      ),
      FoodReferencesCompanion(
        id: Value('rajma_1'),
        foodName: Value('Rajma Masala'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Bowl (150g)'),
        calories: Value(220),
        proteinG: Value(9.8),
        carbsG: Value(32),
        fatG: Value(5.5),
        glycemicIndex: Value(35),
        fiberG: Value(9.0),
        satietyIndex: Value(80),
        searchTerms: Value('rajma,kidney bean,rajma masala,rajma chawal'),
      ),
      FoodReferencesCompanion(
        id: Value('curd_1'),
        foodName: Value('Whole Milk Curd'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Cup (150g)'),
        calories: Value(98),
        proteinG: Value(5.2),
        carbsG: Value(6),
        fatG: Value(6.0),
        glycemicIndex: Value(28),
        fiberG: Value(0.0),
        satietyIndex: Value(72),
        searchTerms: Value('curd,dahi,yogurt,yoghurt,raita'),
      ),
      FoodReferencesCompanion(
        id: Value('khich_1'),
        foodName: Value('Moong Dal Khichdi'),
        defaultServingG: Value(200),
        servingDescription: Value('1 Bowl (200g)'),
        calories: Value(210),
        proteinG: Value(7.2),
        carbsG: Value(38),
        fatG: Value(3.0),
        glycemicIndex: Value(55),
        fiberG: Value(4.0),
        satietyIndex: Value(72),
        searchTerms: Value('khichdi,khichri,moong dal khichdi,dal khichdi'),
      ),
      FoodReferencesCompanion(
        id: Value('upma_1'),
        foodName: Value('Semolina Upma'),
        defaultServingG: Value(150),
        servingDescription: Value('1 Plate (150g)'),
        calories: Value(190),
        proteinG: Value(4.0),
        carbsG: Value(34),
        fatG: Value(3.5),
        glycemicIndex: Value(65),
        fiberG: Value(2.0),
        satietyIndex: Value(62),
        searchTerms: Value('upma,rava upma,semolina upma,sooji upma'),
      ),
      FoodReferencesCompanion(
        id: Value('egg_1'),
        foodName: Value('Boiled Egg'),
        defaultServingG: Value(50),
        servingDescription: Value('1 Large (50g)'),
        calories: Value(78),
        proteinG: Value(6.3),
        carbsG: Value(0.6),
        fatG: Value(5.3),
        glycemicIndex: Value(0),
        fiberG: Value(0.0),
        satietyIndex: Value(85),
        searchTerms: Value('egg,boiled egg,hard boiled egg,anda,ande'),
      ),
    ];
    for (final seed in seeds) {
      await into(foodReferences).insertOnConflictUpdate(seed);
    }
  }

  /// Returns all FoodReferences whose foodName or searchTerms contain [query].
  Future<List<FoodReference>> searchFoodReferences(String query) async {
    final lower = query.toLowerCase();
    return (select(foodReferences)
          ..where(
            (t) =>
                t.foodName.lower().contains(lower) |
                t.searchTerms.lower().contains(lower),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.foodName)]))
        .get();
  }

  // ── Micronutrient Logs ──────────────────────────────────────────────────

  Future<void> saveMicronutrientLog(MicronutrientLogsCompanion log) async {
    await into(micronutrientLogs).insertOnConflictUpdate(log);
  }

  Future<List<MicronutrientLog>> getMicronutrientLogs(
    String userId, {
    int days = 7,
  }) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(micronutrientLogs)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.logDate.isBiggerOrEqualValue(cutoff),
          )
          ..orderBy([
            (t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.desc),
          ]))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fitkarma.db'));

    // Load or generate secure encryption key
    final key = await _getOrGenerateEncryptionKey(dbFolder);

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        // Enforce SQLCipher page-level encryption
        database.execute("PRAGMA key = '$key';");
      },
    );
  });
}

/// Cryptographically secure key generator using Random.secure() (CSPRNG)
Future<String> _getOrGenerateEncryptionKey(Directory directory) async {
  final keyFile = File(p.join(directory.path, '.db_secure_key'));

  if (await keyFile.exists()) {
    return await keyFile.readAsString();
  }

  // Generate secure key using OS CSPRNG (Random.secure)
  final key = SqlCipherSecurity.generateSecureKey();

  await keyFile.writeAsString(key);
  return key;
}
