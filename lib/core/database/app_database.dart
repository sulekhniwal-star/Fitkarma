import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// 1. Users Table
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()(); // 'male' | 'female'
  RealColumn get weight => real().nullable()();
  RealColumn get height => real().nullable()();
  TextColumn get activityLevel => text().nullable()(); // ActivityLevel.name
  TextColumn get goals => text().nullable()(); // JSON list e.g. '["weight_loss","heart_health"]'
  RealColumn get targetWeight => real().nullable()(); // kg
  IntColumn get dailyCalorieTarget => integer().nullable()();
  TextColumn get dosha => text().nullable()(); // Added for §P1-F Dosha Quiz
  TextColumn get currentProgram => text().nullable()(); // Added for §P1-G Program Blueprint Selection Screen
  BoolColumn get isCycleTrackingEnabled => boolean().nullable()();
  IntColumn get averageCycleLength => integer().nullable()();
  DateTimeColumn get lastPeriodDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

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
  BoolColumn get showFestivalBanner => boolean().withDefault(const Constant(false))();
  TextColumn get festivalAdaptation => text().nullable()();
  BoolColumn get dietBreakActive => boolean().withDefault(const Constant(false))();
  IntColumn get proteinTimingTarget => integer().withDefault(const Constant(25))();
  TextColumn get loggingReliabilityStatus => text().withDefault(const Constant('high'))();
  IntColumn get satietyTargetScore => integer().withDefault(const Constant(70))();
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
  BoolColumn get isAiGenerated =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get generatedAt => dateTime()();
  /// Plan is valid for 7 days; re-generate when expired or BMI shifts > 1.0.
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DriftDatabase(tables: [Users, WaterLogs, SyncQueueItems, DeadLetterQueueItems, DailyIntelligencePackages, AICacheEntries, TransformationMemories, CachedDietPlans, MenstrualSymptomLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.executor(super.e);

  @override
  int get schemaVersion => 23;

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
      },
    );
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
  }) async {
    await (update(users)
      ..where((t) => t.id.equals(userId)))
      .write(UsersCompanion(
        goals: goalsJson != null ? Value(goalsJson) : const Value.absent(),
        targetWeight: targetWeight != null ? Value(targetWeight) : const Value.absent(),
        dailyCalorieTarget: dailyCalorieTarget != null ? Value(dailyCalorieTarget) : const Value.absent(),
        dosha: dosha != null ? Value(dosha) : const Value.absent(),
        currentProgram: currentProgram != null ? Value(currentProgram) : const Value.absent(),
        isCycleTrackingEnabled: isCycleTrackingEnabled != null ? Value(isCycleTrackingEnabled) : const Value.absent(),
        averageCycleLength: averageCycleLength != null ? Value(averageCycleLength) : const Value.absent(),
        lastPeriodDate: lastPeriodDate != null ? Value(lastPeriodDate) : const Value.absent(),
      ));
  }

  // ── Women's Health helpers ──────────────────────────────────────────────

  Future<void> saveMenstrualSymptomLog(MenstrualSymptomLogsCompanion log) async {
    await into(menstrualSymptomLogs).insertOnConflictUpdate(log);
  }

  Future<List<MenstrualSymptomLog>> getMenstrualSymptomLogs(String userId) async {
    return (select(menstrualSymptomLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.asc)]))
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
        age:                Value(age),
        gender:             Value(gender),
        height:             Value(heightCm),
        weight:             Value(weightKg),
        activityLevel:      Value(activityLevel),
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
    final now       = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));
    await into(cachedDietPlans).insertOnConflictUpdate(
      CachedDietPlansCompanion.insert(
        userId:         userId,
        planJson:       planJson,
        calorieTarget:  calorieTarget,
        proteinTargetG: proteinTargetG,
        isAiGenerated:  Value(isAiGenerated),
        generatedAt:    now,
        expiresAt:      expiresAt,
      ),
    );
  }

  /// Returns the cached plan if it exists and has not expired; otherwise null.
  Future<CachedDietPlan?> getCachedDietPlan(String userId) async {
    return (select(cachedDietPlans)
          ..where(
            (t) => t.userId.equals(userId) &
                t.expiresAt.isBiggerThanValue(DateTime.now()),
          ))
        .getSingleOrNull();
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
  
  // Generate secure key bytes using OS-level entropy source
  final random = Random.secure();
  final bytes = List<int>.generate(32, (i) => random.nextInt(256));
  final key = base64Url.encode(bytes);
  
  await keyFile.writeAsString(key);
  return key;
}
