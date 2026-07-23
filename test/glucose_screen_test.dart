import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/glucose/glucose_screen.dart';
import 'package:fitkarma/features/glucose/glucose_controller.dart';

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
      child: const MaterialApp(home: GlucoseScreen()),
    );
  }

  testWidgets(
    'GlucoseScreen lock screen, unlock via PIN, manual entry, and HbA1c estimation check',
    (tester) async {
      // 1. Pump GlucoseScreen
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 2. Verify security locked state initially
      expect(find.text('Sensitive Vitals Locked'), findsOneWidget);
      expect(find.byIcon(Icons.shield_rounded), findsOneWidget);

      // 3. Enter wrong PIN digits (e.g. 111111)
      for (int i = 0; i < 6; i++) {
        final key = find.byKey(const Key('glucose_pin_key_1'));
        expect(key, findsOneWidget);
        await tester.tap(key);
        await tester.pumpAndSettle();
      }

      // Verify invalid PIN error text is displayed
      expect(find.byKey(const Key('glucose_pin_error_text')), findsOneWidget);
      expect(
        find.text('Sensitive Vitals Locked'),
        findsOneWidget,
      ); // still locked

      // 4. Enter correct PIN (123456)
      final digits = ['1', '2', '3', '4', '5', '6'];
      for (final d in digits) {
        final key = find.byKey(Key('glucose_pin_key_$d'));
        expect(key, findsOneWidget);
        await tester.tap(key);
        await tester.pumpAndSettle();
      }

      // Screen should unlock now
      expect(find.text('Blood Glucose'), findsOneWidget);
      expect(find.text('Estimated HbA1c'), findsOneWidget);

      // 5. Open record bottom sheet and save manual fasting reading (110 mg/dL)
      final recordButton = find.byKey(const Key('glucose_log_manual_button'));
      expect(recordButton, findsOneWidget);
      await tester.tap(recordButton);
      await tester.pumpAndSettle();

      // Enter glucose value
      final valField = find.byType(TextField);
      expect(valField, findsOneWidget);
      await tester.enterText(valField, '110.0');

      // Save (meal tag dropdown defaults to 'Fasting')
      final saveButton = find.byKey(const Key('glucose_save_log_button'));
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);

      // Settle database operation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify latest fasting reading displays 110 mg/dL (Prediabetes)
      expect(find.text('110 mg/dL'), findsNWidgets(2));
      expect(
        find.text('Prediabetes'),
        findsNWidgets(2),
      ); // Under latest fasting & history list

      // Verify estimated HbA1c is updated: (110 + 46.7) / 28.7 = 5.459 -> 5.5%
      expect(find.text('5.5%'), findsOneWidget);

      // 6. Record post-meal reading (150 mg/dL)
      await tester.ensureVisible(recordButton);
      await tester.tap(recordButton);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '150.0');

      // We can select another dropdown item or just type in (for this test let's open dropdown and select Post-Meal)
      // To make it simple: let's select DropdownButton, find the third item (Post-Meal (1-hour)) and click it
      final dropdownFinder = find.byType(DropdownButton<String>);
      expect(dropdownFinder, findsOneWidget);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      final dropdownItemFinder = find.text('Post-Meal (1-hour)').last;
      await tester.tap(dropdownItemFinder);
      await tester.pumpAndSettle();

      final saveButton2 = find.byKey(const Key('glucose_save_log_button'));
      await tester.ensureVisible(saveButton2);
      await tester.tap(saveButton2);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify post-meal updated to 150 mg/dL (Elevated)
      expect(find.text('150 mg/dL'), findsNWidgets(2));
      expect(
        find.text('Elevated'),
        findsNWidgets(2),
      ); // latest post-meal & history list

      // Verify updated estimated HbA1c: Avg = (110 + 150) / 2 = 130.
      // HbA1c = (130 + 46.7) / 28.7 = 6.156 -> 6.2%
      expect(find.text('6.2%'), findsOneWidget);
    },
  );
}
