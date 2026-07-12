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
  RealColumn get weight => real().nullable()();
  RealColumn get height => real().nullable()();
  TextColumn get goals => text().nullable()(); // JSON list

  @override
  Set<Column> get primaryKey => {id};
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

@DriftDatabase(tables: [Users, WaterLogs, SyncQueueItems, DeadLetterQueueItems, DailyIntelligencePackages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.executor(super.e);

  @override
  int get schemaVersion => 17; // Database Drift Schema v17 matching docs
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
