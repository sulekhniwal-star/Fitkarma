import 'package:drift/drift.dart';

/// Table storing Daily Intelligence Packages (DIP)
class DailyIntelligencePackagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get readinessScore => integer()();
  TextColumn get readinessTier => text()();
  TextColumn get primaryFocus => text()();
  TextColumn get dailyMissionsJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table storing Health Snapshots
class HealthSnapshotsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  RealColumn get sleepHours => real().withDefault(const Constant(0.0))();
  RealColumn get hrvMs => real().nullable()();
  IntColumn get restingHeartRate => integer().nullable()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table storing Transformation Memories
class TransformationMemoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get weightKg => real()();
  RealColumn get bodyFatPercentage => real().nullable()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table storing Life Events
class LifeEventsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get eventType => text()(); // e.g. festival, travel, illness
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Normalized User Scores Time-Series Table
class UserScoresTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get healthScore => integer()();
  IntColumn get adherenceScore => integer()();
  IntColumn get longevityScore => integer()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
