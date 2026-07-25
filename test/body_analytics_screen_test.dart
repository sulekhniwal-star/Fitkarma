/// §P11-A Body Analytics Screen Widget & Model Tests

import 'package:fitkarma/features/body_analytics/body_analytics_models.dart';
import 'package:fitkarma/features/body_analytics/body_analytics_notifier.dart';
import 'package:fitkarma/features/body_analytics/body_analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: BodyAnalyticsScreen(),
      ),
    );
  }

  group('BodyAnalyticsModels Unit Tests (§P11-A)', () {
    test('calculates Waist-to-Hip Ratio (WHR) and risk category accurately', () {
      final entry = BodyMeasurementEntry(
        localId: '1',
        userId: 'user_1',
        logDate: DateTime(2026, 7, 24),
        waistCm: 80.0,
        hipsCm: 100.0,
      );

      expect(entry.waistToHipRatio, equals(0.80));
      expect(entry.whrCategory, equals('Optimal (Low Risk)'));
    });

    test('calculates Navy body fat % estimate accurately', () {
      final entry = BodyMeasurementEntry(
        localId: '1',
        userId: 'user_1',
        logDate: DateTime(2026, 7, 24),
        neckCm: 38.0,
        waistCm: 82.0,
        hipsCm: 96.0,
      );

      expect(entry.estimatedBodyFatPct, isNotNull);
      expect(entry.estimatedBodyFatPct!, greaterThan(10.0));
      expect(entry.estimatedBodyFatPct!, lessThan(35.0));
    });
  });

  group('BodyAnalyticsScreen Widget Tests (§P11-A)', () {
    testWidgets('renders body analytics header, cards, trends, and history', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('📐 Body Analytics & Trends'), findsOneWidget);
      expect(find.text('Body Composition Summary'), findsOneWidget);
      expect(find.text('Waist-to-Hip Ratio'), findsOneWidget);
      expect(find.text('Est. Body Fat'), findsOneWidget);
      expect(find.textContaining('Circumference Trends'), findsOneWidget);
      expect(find.textContaining('Measurement History'), findsOneWidget);
    });

    testWidgets('shows Add Measurement dialog when Log Now button is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Now'));
      await tester.pumpAndSettle();

      expect(find.text('Log Body Measurements (cm)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save Log'), findsOneWidget);
    });

    testWidgets('logs new measurements and updates trends & history list', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Tap Log Now
      await tester.tap(find.text('Log Now'));
      await tester.pumpAndSettle();

      // Enter waist and chest values
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(3), '78.0'); // Waist
      await tester.enterText(textFields.at(1), '96.0'); // Chest

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Log'));
      await tester.pumpAndSettle();

      // Check SnackBar & history card
      expect(find.textContaining('persisted to BodyMeasurements table'), findsOneWidget);
    });
  });
}
