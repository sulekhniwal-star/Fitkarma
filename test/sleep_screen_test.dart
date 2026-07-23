import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/sleep/sleep_screen.dart';
import 'package:fitkarma/features/sleep/sleep_controller.dart';

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
      child: const MaterialApp(home: SleepScreen()),
    );
  }

  testWidgets(
    'SleepScreen renders default metrics, opens sheet, and saves manual entry',
    (tester) async {
      // 1. Pump SleepScreen
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 2. Verify initial default UI state
      expect(find.text('Sleep OS'), findsOneWidget);
      expect(find.text('7h 15m'), findsOneWidget);
      expect(find.text('Status: Normal'), findsOneWidget);
      expect(find.text('-30m (Low)'), findsOneWidget); // Default Sleep debt

      // 3. Verify sleep stages text legends exist
      expect(find.text('Awake'), findsOneWidget);
      expect(find.text('REM'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Deep'), findsOneWidget);

      // 4. Tap 'Log Night's Sleep' button to open manual entry bottom sheet
      final logButton = find.byKey(const Key('sleep_log_manual_button'));
      expect(logButton, findsOneWidget);
      await tester.ensureVisible(logButton);
      await tester.tap(logButton);
      await tester.pumpAndSettle();

      // Verify sheet is open
      expect(find.text('Duration (minutes)'), findsOneWidget);
      expect(find.text('Sleep Quality (1-100)'), findsOneWidget);
      expect(find.text('HRV (ms)'), findsOneWidget);

      // 5. Enter details in form
      // Enter 510 minutes sleep duration (8.5 hours)
      final durationFinder = find.widgetWithText(
        TextField,
        'Duration (minutes)',
      );
      await tester.enterText(durationFinder, '510');

      final qualityFinder = find.widgetWithText(
        TextField,
        'Sleep Quality (1-100)',
      );
      await tester.enterText(qualityFinder, '90');

      final hrvFinder = find.widgetWithText(TextField, 'HRV (ms)');
      await tester.enterText(hrvFinder, '72');

      // Tap Save
      final saveButton = find.byKey(const Key('sleep_save_log_button'));
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);

      // Let the database transaction and state updates settle
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // 6. Verify main Sleep OS page updated with the logged values
      // 510 min = 8h 30m
      expect(find.text('8h 30m'), findsOneWidget);
      // Debt calculation: 480 - 510 = -30m
      expect(find.text('-30m (Low)'), findsOneWidget);

      // 7. Verify persistence in SQLite
      final logs = await db.select(db.sleepLogs).get();
      expect(logs.length, 1);
      expect(logs.first.sleepMinutes, 510);
      expect(logs.first.sleepQuality, 90);
      expect(logs.first.hrvMs, 72.0);
    },
  );
}
