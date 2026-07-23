import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/bp/bp_screen.dart';
import 'package:fitkarma/features/bp/bp_controller.dart';

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
      child: const MaterialApp(home: BpScreen()),
    );
  }

  testWidgets(
    'BpScreen lock screen, unlock via PIN, manual entry, and rising warning check',
    (tester) async {
      // 1. Pump BpScreen
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 2. Verify security locked state initially
      expect(find.text('Sensitive Vitals Locked'), findsOneWidget);
      expect(find.byIcon(Icons.shield_rounded), findsOneWidget);

      // 3. Enter wrong PIN digits (e.g. 111111)
      for (int i = 0; i < 6; i++) {
        final key = find.byKey(const Key('bp_pin_key_1'));
        expect(key, findsOneWidget);
        await tester.tap(key);
        await tester.pumpAndSettle();
      }

      // Verify invalid PIN error text is displayed
      expect(find.byKey(const Key('bp_pin_error_text')), findsOneWidget);
      expect(
        find.text('Sensitive Vitals Locked'),
        findsOneWidget,
      ); // still locked

      // 4. Enter correct PIN (123456)
      final digits = ['1', '2', '3', '4', '5', '6'];
      for (final d in digits) {
        final key = find.byKey(Key('bp_pin_key_$d'));
        expect(key, findsOneWidget);
        await tester.tap(key);
        await tester.pumpAndSettle();
      }

      // Screen should unlock now
      expect(find.text('Blood Pressure'), findsOneWidget);
      expect(find.text('Latest Reading'), findsOneWidget);

      // 5. Open record bottom sheet and save manual reading (115 / 75 mmHg)
      final recordButton = find.byKey(const Key('bp_log_manual_button'));
      expect(recordButton, findsOneWidget);
      await tester.tap(recordButton);
      await tester.pumpAndSettle();

      // Enter systolic/diastolic values using index-based TextField finders
      await tester.enterText(find.byType(TextField).at(0), '115');
      await tester.enterText(find.byType(TextField).at(1), '75');

      // Save
      await tester.tap(find.byKey(const Key('bp_save_log_button')));

      // Settle database operation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify latest reading displays 115 / 75
      expect(find.text('115 / 75 mmHg'), findsOneWidget);
      expect(find.text('Normal'), findsNWidgets(2));

      // 6. Record second consecutive higher reading (120 / 78 mmHg)
      await tester.ensureVisible(find.byKey(const Key('bp_log_manual_button')));
      await tester.tap(find.byKey(const Key('bp_log_manual_button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '120');
      await tester.enterText(find.byType(TextField).at(1), '78');

      await tester.ensureVisible(find.byKey(const Key('bp_save_log_button')));
      await tester.tap(find.byKey(const Key('bp_save_log_button')));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      final tempLogs = await db.select(db.bpReadings).get();
      print(
        'DB LOGS IN TEST: ${tempLogs.map((e) => "${e.systolic}/${e.diastolic}").toList()}',
      );

      // 120 / 78 is Elevated
      expect(find.text('120 / 78 mmHg'), findsOneWidget);
      expect(find.text('Elevated'), findsNWidgets(2));

      // Verify no warning is displayed yet (need 3 rising consecutive readings)
      expect(find.byKey(const Key('bp_warning_card')), findsNothing);

      // 7. Record third consecutive higher reading (125 / 85 mmHg)
      await tester.ensureVisible(find.byKey(const Key('bp_log_manual_button')));
      await tester.tap(find.byKey(const Key('bp_log_manual_button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '125');
      await tester.enterText(find.byType(TextField).at(1), '85');

      await tester.ensureVisible(find.byKey(const Key('bp_save_log_button')));
      await tester.tap(find.byKey(const Key('bp_save_log_button')));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // 125 / 85 is Stage 1
      expect(find.text('125 / 85 mmHg'), findsOneWidget);

      // Verify that the warning card is now rendered because of 3 rising readings
      expect(find.byKey(const Key('bp_warning_card')), findsOneWidget);
      expect(
        find.text(
          'Warning: 3 rising BP readings recorded. Limit caffeine and record again tonight.',
        ),
        findsOneWidget,
      );
    },
  );
}
