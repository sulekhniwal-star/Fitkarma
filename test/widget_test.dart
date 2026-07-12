// This is a basic Flutter widget test for the Fitkarma App.
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/screens/style_guide_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Fitkarma style guide screen loads correctly', (WidgetTester tester) async {
    late AppDatabase db;

    // Build our app and trigger a frame, overriding databaseProvider to use in-memory db
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) {
            db = AppDatabase.executor(NativeDatabase.memory());
            return db;
          }),
        ],
        child: const MaterialApp(
          home: StyleGuideScreen(),
        ),
      ),
    );

    // Let the initial database load stream complete
    await tester.pumpAndSettle();

    // Verify that our branding header and tabs are present.
    expect(find.text('FITKARMA'), findsOneWidget);
    expect(find.text('Health Dashboard'), findsOneWidget);

    // Explicitly close database and pump to flush any async stream timers
    await db.close();
    await tester.pumpAndSettle();
  });
}
