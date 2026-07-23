import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/steps/steps_screen.dart';
import 'package:fitkarma/features/steps/steps_controller.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: StepsScreen()),
    );
  }

  testWidgets(
    'StepsScreen renders initial values and updates on sync simulation',
    (tester) async {
      // Seed initial steps log
      final now = DateTime.now();
      await db
          .into(db.stepLogs)
          .insert(
            StepLogsCompanion.insert(
              steps: 8420,
              syncBatchId: 'initial_batch',
              loggedAt: now,
              hlcPhysicalTime: now,
              hlcLogicalCounter: 0,
              hlcNodeId: 'device_sensor',
            ),
          );

      // 1. Pump screen
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 2. Verify progress and metrics render with initial default values
      expect(find.text('Steps Tracker'), findsOneWidget);
      expect(find.text('8420 / 10000 steps'), findsOneWidget);
      expect(find.text('6.3 km'), findsOneWidget);
      expect(find.text('52 min'), findsOneWidget);
      expect(
        find.text('337 kcal'),
        findsOneWidget,
      ); // 8420 * 0.04 = 336.8, rounded is 337
      expect(find.text('Sync: Synced'), findsOneWidget);

      // 3. Verify bar chart labels
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('18:00'), findsOneWidget);

      // 4. Tap the sync simulation button
      final syncButton = find.byKey(const Key('steps_sync_button'));
      expect(syncButton, findsOneWidget);
      await tester.ensureVisible(syncButton);
      await tester.tap(syncButton);

      // Re-pump to let microtasks and DB writes complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // 5. Verify steps count and metrics updated
      // 8420 + 1500 = 9920 steps.
      // 9920 * 0.04 = 396.8, rounded is 397.
      // 9920 * 0.00075 = 7.44 km -> 7.4 km.
      // 9920 ~/ 160 = 62 min.
      expect(find.text('9920 / 10000 steps'), findsOneWidget);
      expect(find.text('7.4 km'), findsOneWidget);
      expect(find.text('62 min'), findsOneWidget);
      expect(find.text('397 kcal'), findsOneWidget);
      expect(find.text('Sync: Synced'), findsOneWidget);

      // 6. Verify that it was persisted in the SQLite StepLogs table
      final logs = await db.select(db.stepLogs).get();
      expect(logs.length, 2);
      expect(logs[0].steps, 8420);
      expect(logs[1].steps, 1500);
    },
  );
}
