import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Pending Mutations Outbox Table
class PendingMutations extends Table {
  TextColumn get id => text()();
  TextColumn get targetTable => text()();
  TextColumn get action => text()(); // 'INSERT', 'UPDATE', 'DELETE', 'UPSERT'
  TextColumn get payload => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Local Profiles Table
class LocalProfiles extends Table {
  TextColumn get userId => text()();
  TextColumn get name => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get primaryGoal => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

// 3. Local Readiness Scores Table
class LocalReadinessScores extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get score => integer()();
  TextColumn get confidenceTier => text()(); // 'high', 'moderate', 'low'
  DateTimeColumn get calculatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Local Daily Intelligence Package (DIP) Cache Table
class LocalDipCache extends Table {
  TextColumn get userId => text()();
  TextColumn get date => text()(); // 'YYYY-MM-DD'
  TextColumn get payloadJson => text()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, date};
}

// 5. Local Dosha Scores Table
class LocalDoshaScores extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get vataScore => integer()();
  IntColumn get pittaScore => integer()();
  IntColumn get kaphaScore => integer()();
  TextColumn get dominantDosha => text()();
  DateTimeColumn get assessedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Local Women's Health & Cycle Tracking Table
class LocalCycleTracking extends Table {
  TextColumn get userId => text()();
  IntColumn get cycleLengthDays => integer()();
  IntColumn get currentCycleDay => integer()();
  TextColumn get currentPhase => text()();
  BoolColumn get hasPcos => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

// 7. Local Body Soreness Logs Table
class LocalSorenessLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get muscleGroup => text()();
  IntColumn get severity => integer()(); // 1 to 5
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. Local Coach Sessions Table
class LocalCoachSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text().withDefault(const Constant('Daily Coaching Session'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 9. Local Coach Messages Table
class LocalCoachMessages extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get sender => text()(); // 'user', 'coach', 'system'
  TextColumn get content => text()();
  TextColumn get modelUsed => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 10. Local Wearable Samples Table
class LocalWearableSamples extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get source => text()();
  TextColumn get metric => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 11. Local Biomarkers Table
class LocalBiomarkers extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get source => text()();
  TextColumn get type => text()();
  RealColumn get primaryValue => real()();
  RealColumn get secondaryValue => real().nullable()();
  TextColumn get unit => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get measuredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 12. Local CGM Telemetry Table
class LocalCgmTelemetry extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get glucoseMgDl => real()();
  TextColumn get trendArrow => text()();
  TextColumn get associatedMealId => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 13. Local Recipes Table (Seeded Indian Foods)
class LocalRecipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameHindi => text()();
  TextColumn get region => text()();
  TextColumn get dietaryType => text()();
  RealColumn get caloriesKcal => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  RealColumn get fiberGrams => real()();
  RealColumn get glycemicIndex => real()();

  @override
  Set<Column> get primaryKey => {id};
}

// 14. Local Meals Table (Logged User Meals)
class LocalMeals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get mealType => text()();
  RealColumn get caloriesKcal => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  RealColumn get fiberGrams => real()();
  IntColumn get mealQualityScore => integer()();
  RealColumn get visionConfidence => real().withDefault(const Constant(1.0))();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get loggedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 15. Local Grocery Items Table
class LocalGroceryItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get nameHindi => text()();
  TextColumn get category => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  RealColumn get estimatedCostInr => real()();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 16. Local Workout Sessions Table
class LocalWorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  IntColumn get durationSeconds => integer()();
  RealColumn get totalVolumeKg => real()();
  RealColumn get avgRpe => real()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 17. Local Workout Sets Table
class LocalWorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  IntColumn get rpe => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 18. Local Karma Points Ledger Table
class LocalKarmaPoints extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get points => integer()();
  TextColumn get actionType => text()();
  TextColumn get description => text()();
  DateTimeColumn get earnedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 19. Local Habit Streaks Table
class LocalHabitStreaks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get habitType => text()();
  IntColumn get currentStreak => integer()();
  IntColumn get longestStreak => integer()();
  DateTimeColumn get lastActiveDate => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 20. Local Transformation Milestones Table
class LocalTransformationMilestones extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get titleHindi => text()();
  TextColumn get description => text()();
  DateTimeColumn get achievedAt => dateTime()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 21. Local Body Transformation Logs Table
class LocalBodyTransformationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get weightKg => real()();
  RealColumn get waistCm => real()();
  RealColumn get hipCm => real()();
  RealColumn get bodyFatPct => real()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get loggedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 22. Local Squads Table
class LocalSquads extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get bio => text()();
  TextColumn get bannerUrl => text().nullable()();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  IntColumn get totalKarma => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 23. Local Squad Members Table
class LocalSquadMembers extends Table {
  TextColumn get id => text()();
  TextColumn get squadId => text()();
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text()();
  BoolColumn get todayLogged => boolean().withDefault(const Constant(false))();
  IntColumn get todayKarma => integer().withDefault(const Constant(0))();
  TextColumn get todayCommitment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 24. Local Community Posts Table
class LocalCommunityPosts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get activityType => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get mediaUrl => text().nullable()();
  IntColumn get karmaEarned => integer().withDefault(const Constant(0))();
  IntColumn get likesCount => integer().withDefault(const Constant(0))();
  IntColumn get cheersCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 25. Local Family Members Table
class LocalFamilyMembers extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get relativeUserId => text()();
  TextColumn get relativeName => text()();
  TextColumn get relation => text()();
  IntColumn get age => integer()();
  RealColumn get latestSystolicBp => real().nullable()();
  RealColumn get latestDiastolicBp => real().nullable()();
  RealColumn get latestFastingGlucoseMgDl => real().nullable()();
  IntColumn get todaySteps => integer().nullable()();
  TextColumn get alertLevel => text()();
  TextColumn get alertMessage => text().nullable()();
  TextColumn get alertMessageHindi => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 26. Local Clubs Table
class LocalClubs extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get city => text()();
  TextColumn get locality => text()();
  TextColumn get clubType => text()();
  IntColumn get memberCount => integer().withDefault(const Constant(1))();
  TextColumn get bannerUrl => text().nullable()();
  TextColumn get nextMeetup => text()();
  TextColumn get nextMeetupHindi => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 27. Local Biological Age Records Table
class LocalBiologicalAgeRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get chronologicalAge => integer()();
  RealColumn get biologicalAge => real()();
  RealColumn get ageDelta => real()();
  TextColumn get topAction => text()();
  TextColumn get topActionHindi => text()();
  DateTimeColumn get calculatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 28. Local Clinical Lab Reports Table
class LocalClinicalLabReports extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get labName => text()();
  DateTimeColumn get testDate => dateTime()();
  TextColumn get resultsJson => text()();
  TextColumn get executiveSummary => text()();
  TextColumn get executiveSummaryHindi => text()();
  DateTimeColumn get uploadedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 29. Local Medications Table
class LocalMedications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get medicationName => text()();
  TextColumn get dosage => text()();
  TextColumn get frequency => text()();
  TextColumn get timingCategory => text()();
  TextColumn get foodInteractionWarning => text().nullable()();
  TextColumn get foodInteractionWarningHindi => text().nullable()();
  BoolColumn get isTakenToday => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 30. Local Doctor Access Grants Table
class LocalDoctorGrants extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get doctorName => text()();
  TextColumn get clinicHospital => text()();
  TextColumn get accessPin => text()();
  DateTimeColumn get expiresAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 31. Local Progress Photos Table
class LocalProgressPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get poseType => text()();
  TextColumn get localFilePath => text()();
  RealColumn get poseConfidence => real().withDefault(const Constant(1.0))();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 32. Local Body Composition Snapshots Table
class LocalBodyCompositionSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get bodyFatPct => real()();
  RealColumn get leanMassKg => real()();
  RealColumn get fatMassKg => real()();
  RealColumn get totalWeightKg => real()();
  RealColumn get waistToHeightRatio => real()();
  RealColumn get ffmi => real()();
  TextColumn get insight => text()();
  TextColumn get insightHindi => text()();
  DateTimeColumn get calculatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 33. Local Active Life Events Table
class LocalActiveLifeEvents extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get eventType => text()();
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get configJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 34. Local Wedding Plans Table
class LocalWeddingPlans extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get weddingDate => dateTime()();
  RealColumn get targetWeightKg => real()();
  RealColumn get targetWaistCm => real()();
  TextColumn get currentPhase => text()();
  TextColumn get currentPhaseHindi => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 35. Local Entitlements Table (Server-verified only)
class LocalEntitlements extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get tier => text()(); // 'free', 'pro', 'elite', 'corporate'
  TextColumn get source => text()(); // 'revenuecat', 'razorpay', 'corporate_sso'
  DateTimeColumn get expiresAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 36. Local Coach Profiles Table
class LocalCoachProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get title => text()();
  TextColumn get specialty => text()();
  TextColumn get bio => text()();
  TextColumn get languagesJson => text()();
  RealColumn get rating => real()();
  IntColumn get reviewCount => integer()();
  IntColumn get hourlyRateInr => integer()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 37. Local Coach Bookings Table
class LocalCoachBookings extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get coachId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get status => text()(); // 'pending', 'confirmed', 'completed', 'cancelled'
  IntColumn get amountInr => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 38. Local Affiliate Referrals Table
class LocalAffiliateReferrals extends Table {
  TextColumn get id => text()();
  TextColumn get referrerId => text()();
  TextColumn get referralCode => text()();
  TextColumn get refereeUserId => text()();
  IntColumn get karmaReward => integer()();
  IntColumn get commissionInr => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  PendingMutations,
  LocalProfiles,
  LocalReadinessScores,
  LocalDipCache,
  LocalDoshaScores,
  LocalCycleTracking,
  LocalSorenessLogs,
  LocalCoachSessions,
  LocalCoachMessages,
  LocalWearableSamples,
  LocalBiomarkers,
  LocalCgmTelemetry,
  LocalRecipes,
  LocalMeals,
  LocalGroceryItems,
  LocalWorkoutSessions,
  LocalWorkoutSets,
  LocalKarmaPoints,
  LocalHabitStreaks,
  LocalTransformationMilestones,
  LocalBodyTransformationLogs,
  LocalSquads,
  LocalSquadMembers,
  LocalCommunityPosts,
  LocalFamilyMembers,
  LocalClubs,
  LocalBiologicalAgeRecords,
  LocalClinicalLabReports,
  LocalMedications,
  LocalDoctorGrants,
  LocalProgressPhotos,
  LocalBodyCompositionSnapshots,
  LocalActiveLifeEvents,
  LocalWeddingPlans,
  LocalEntitlements,
  LocalCoachProfiles,
  LocalCoachBookings,
  LocalAffiliateReferrals,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fitkarma_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
