import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/daily_mission/recovery_log_screen.dart';
import 'package:fitkarma/features/daily_mission/recovery_log_controller.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';

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
      child: const MaterialApp(home: RecoveryLogScreen()),
    );
  }

  testWidgets(
    'RecoveryLogScreen renders form widgets, handles inputs, and commits log to database',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 1. Assert initial state UIs exist
      expect(find.text('Recovery Log'), findsOneWidget);
      expect(find.text('Computed Readiness Score'), findsOneWidget);
      expect(
        find.text('100'),
        findsOneWidget,
      ); // Default starting readiness score is 100

      // 2. Change sliders (Simulate dragging or call state methods directly for reliability)
      final context = tester.element(find.byType(RecoveryLogScreen));
      final container = ProviderScope.containerOf(context);

      // Update sleep duration to 350 minutes (<6h => should reduce score)
      // Update soreness map to shoulders: mild
      container
          .read(recoveryLogProvider.notifier)
          .setCheckInResponses(
            sleepQuality: 4,
            sleepDurationMin: 350,
            stressLevel: 2,
            energyLevel: 4,
          );

      container
          .read(recoveryLogProvider.notifier)
          .updateSoreness(MuscleGroup.shoulders, SorenessSeverity.mild);

      // Let the screen update and check score recalculation
      await tester.pumpAndSettle();

      // Readiness recalculation:
      // Perfect: 100
      // Sleep quality 4: -7.0 => 93
      // Sleep duration 350 (< 360, but >= 300): -10 => 83
      // Soreness shoulders mild => totalPoints 1 => compositeSorenessValue 2 => soreness Level 2 => (2 - 1) * 5.0 = -5.0 => 78
      // Stress level 2: (2 - 1) * 5.0 = -5.0 => 73
      // Total: 73
      expect(find.text('73'), findsOneWidget);

      // 3. Fill in Biometrics Form
      final hrField = find.widgetWithText(TextFormField, 'Resting HR (BPM)');
      expect(hrField, findsOneWidget);
      await tester.enterText(hrField, '72');

      final hrvField = find.widgetWithText(TextFormField, 'HRV (ms)');
      expect(hrvField, findsOneWidget);
      await tester.enterText(hrvField, '50');

      // Trigger form submit or update logic via controller
      container
          .read(recoveryLogProvider.notifier)
          .updateBiometrics(
            restingHR: 72,
            hrv: 50,
            baselineHR: 70,
            baselineHRV: 50,
          );
      await tester.pumpAndSettle();

      // 4. Tap Soreness Map
      // Tap the body painter area. Since we defined exact hitboxes, let's tap on the chest coordinates.
      // Chest bounding box relative to width/height: width * 0.4, height * 0.25, width * 0.2, height * 0.12
      // Let's find the GestureDetector inside the screen
      final gestureDetectorFinder = find.byKey(const Key('body_soreness_map'));
      expect(gestureDetectorFinder, findsOneWidget);

      await tester.ensureVisible(gestureDetectorFinder);
      await tester.pumpAndSettle();

      final RenderBox renderBox = tester.renderObject(gestureDetectorFinder);
      final globalTapOffset = renderBox.localToGlobal(const Offset(90, 85));
      await tester.tapAt(globalTapOffset);
      await tester.pumpAndSettle();

      // Verify chest soreness is registered and shown in list
      expect(find.text('CHEST: MILD'), findsOneWidget);

      // 5. Commit Log
      final commitButton = find.widgetWithText(
        FitButton,
        'Commit Recovery Log',
      );
      expect(commitButton, findsOneWidget);
      await tester.tap(commitButton);
      await tester.pumpAndSettle();

      // 6. Assert row is inserted in database
      final logs = await db.getRecoveryLogs('onboarding_user');
      expect(logs.length, 1);

      final insertedLog = logs.first;
      expect(insertedLog.sleepQuality, 4);
      expect(insertedLog.stressLevel, 2);
      expect(insertedLog.energyLevel, 4);
      expect(insertedLog.restingHR, 72.0);
      expect(insertedLog.hrv, 50.0);
      expect(insertedLog.confidenceTier, 'premium');
    },
  );
}
