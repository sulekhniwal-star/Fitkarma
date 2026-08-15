import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/predictive_health/providers/monthly_report_provider.dart';
import 'package:fitkarma/features/predictive_health/screens/monthly_report_screen.dart';

void main() {
  group('§P10-C Monthly Health Report & MonthlyReportNotifier Tests', () {
    test(
        'MonthlyReportNotifier initializes with report period and biological age results',
        () {
      final notifier = MonthlyReportNotifier();
      final state = notifier.state;

      expect(state.reportMonth, equals(DateTime(2026, 5, 1)));
      expect(state.biologicalAgeResult.biologicalAge, equals(29.0));
      expect(state.averageSystolicBp, equals(118.0));
      expect(state.detectedRisks.length, equals(1));
    });

    testWidgets(
        'MonthlyReportScreen renders report month, biological age, biomarkers, and export buttons',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: MonthlyReportScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Monthly Health Report'), findsOneWidget);
      expect(find.text('Report Period: May 2026'), findsOneWidget);
      expect(find.text('Biological Age vs. Chronological Age'), findsOneWidget);
      expect(find.text('Biomarkers & Vitals Averages'), findsOneWidget);
      expect(find.text('⚠️ Detected Health Risks'), findsOneWidget);
      expect(find.text('Shoulder Strain Risk'), findsOneWidget);
      expect(find.text('Next Month\'s Focus Strategy'), findsOneWidget);

      // Tap PDF export icon
      await tester.tap(find.byIcon(Icons.picture_as_pdf));
      await tester.pump();

      expect(
          find.text('Exporting Monthly Health Report PDF...'), findsOneWidget);
    });
  });
}
