/// §P10-J Doctor Sharing Portal — UI Screen Widget Tests

import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:fitkarma/features/predictive/clinical_sharing_models.dart';
import 'package:fitkarma/features/predictive/doctor_sharing_notifier.dart';
import 'package:fitkarma/features/predictive/doctor_sharing_portal_screen.dart';
import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';
import 'package:fitkarma/features/predictive/monthly_report_models.dart';
import 'package:fitkarma/features/predictive/monthly_report_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MonthlyReportPayload mockReport() => MonthlyReportPayload(
        reportMonthPeriod: 'July 2026',
        generatedAt: DateTime(2026, 7, 24),
        hrvAvgMs: 58.4,
        hrvTrendPercent: 6.2,
        systolicBpAvg: 118,
        diastolicBpAvg: 76,
        fastingGlucoseAvg: 94,
        biologicalAgeResult: BiologicalAgeResult(
          chronologicalAge: 32,
          estimatedBiologicalAge: 29,
          ageDeltaYears: -3,
          primaryDrivers: const ['Optimal HRV', 'Low Blood Pressure'],
          calculationDate: DateTime(2026, 7, 24),
        ),
        detectedRisks: [
          HealthRiskFlag(
            riskCategory: HealthRiskCategory.hypertension,
            severity: RiskSeverity.low,
            triggerDescription: 'Minor evening HRV drop observed',
            inputSignals: const ['HRV drop'],
            recommendedAction: 'Ensure 7+ hours rest',
            timestamp: DateTime(2026, 7, 24),
          ),
        ],
        focusStrategyItems: const [
          'Maintain 30-min morning zone-2 cardio',
          'Increase magnesium-rich foods',
        ],
      );

  Widget buildSubject({MonthlyReportPayload? report}) {
    return ProviderScope(
      overrides: [
        latestMonthlyReportProvider.overrideWithValue(report ?? mockReport()),
      ],
      child: const MaterialApp(
        home: DoctorSharingPortalScreen(),
      ),
    );
  }

  group('DoctorSharingPortalScreen Widget Tests (§P10-J)', () {
    testWidgets('renders header, stats, and share buttons', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Doctor Sharing Portal'), findsOneWidget);
      expect(find.text('Active Shares'), findsOneWidget);
      expect(find.text('Create New Share'), findsOneWidget);
      expect(find.text('🔐 PDF + Passcode'), findsOneWidget);
      expect(find.text('🏥 FHIR-lite'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(find.textContaining('Revoke All Clinical Access'), findsOneWidget);
    });

    testWidgets('triggers passcode-protected PDF share sheet when button tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Enter recipient name
      await tester.enterText(find.byType(TextField), 'Dr. Sharma');
      await tester.tap(find.text('🔐 PDF + Passcode'));
      await tester.pumpAndSettle();

      // Verify PDF share sheet opens
      expect(find.text('🔐 Passcode-Protected Report'), findsOneWidget);
      expect(find.text('Access Passcode'), findsOneWidget);
      expect(find.text('Share Report'), findsOneWidget);
    });

    testWidgets('triggers FHIR-lite export bottom sheet when button tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('🏥 FHIR-lite'));
      await tester.pumpAndSettle();

      // Verify FHIR preview sheet opens
      expect(find.textContaining('FHIR-lite Export'), findsOneWidget);
      expect(find.text('Export FHIR JSON'), findsOneWidget);
    });

    testWidgets('token history and revocation lifecycle work correctly', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Create a token
      await tester.enterText(find.byType(TextField), 'Dr. Mehta');
      await tester.tap(find.text('🔐 PDF + Passcode'));
      await tester.pumpAndSettle();

      // Close bottom sheet
      await tester.tap(find.text('Share Report'));
      await tester.pumpAndSettle();

      // Scroll down to reveal history & revoke section
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Check token in history
      expect(find.textContaining('Sharing History'), findsOneWidget);
      expect(find.text('Dr. Mehta'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);

      // Tap Revoke All button on screen
      await tester.tap(find.widgetWithText(TextButton, 'Revoke All').first);
      await tester.pumpAndSettle();

      // Confirm in dialog (second 'Revoke All' button)
      expect(find.text('Revoke All Clinical Access?'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Revoke All').last);
      await tester.pumpAndSettle();

      // Verify active tokens updated to 0 and token badge is REVOKED
      expect(find.text('REVOKED'), findsOneWidget);
    });
  });
}
