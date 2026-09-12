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

@DriftDatabase(tables: [
  PendingMutations,
  LocalProfiles,
  LocalReadinessScores,
  LocalDipCache,
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
