import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';

void main() {
  late AppDatabase db;
  late OutboxSyncWorker syncWorker;

  setUp(() {
    // In-memory Drift database for tests
    db = AppDatabase(NativeDatabase.memory());
    syncWorker = OutboxSyncWorker(db: db);
  });

  tearDown(() async {
    syncWorker.dispose();
    await db.close();
  });

  test('Enqueue mutation writes to pending_mutations outbox table', () async {
    final mutationId = await syncWorker.enqueueMutation(
      tableName: 'profiles',
      action: 'UPSERT',
      payload: {
        'user_id': 'user-123',
        'full_name': 'Aarav Sharma',
        'age': 29,
      },
    );

    expect(mutationId, isNotEmpty);

    final pending = await db.select(db.pendingMutations).get();
    expect(pending.length, equals(1));
    expect(pending.first.id, equals(mutationId));
    expect(pending.first.targetTable, equals('profiles'));
    expect(pending.first.action, equals('UPSERT'));
    expect(pending.first.payload, contains('Aarav Sharma'));
  });

  test('LocalProfile can be saved and retrieved from Drift', () async {
    await db.into(db.localProfiles).insert(
          LocalProfilesCompanion.insert(
            userId: 'user-abc',
            name: const Value('Priya Patel'),
            age: const Value(26),
            gender: const Value('female'),
            heightCm: const Value(162.5),
            weightKg: const Value(58.0),
            primaryGoal: const Value('muscle_gain'),
          ),
        );

    final profile = await (db.select(db.localProfiles)..where((t) => t.userId.equals('user-abc'))).getSingle();
    expect(profile.name, equals('Priya Patel'));
    expect(profile.weightKg, equals(58.0));
    expect(profile.primaryGoal, equals('muscle_gain'));
  });
}
