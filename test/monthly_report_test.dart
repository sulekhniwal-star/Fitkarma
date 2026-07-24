import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';
import 'package:fitkarma/features/predictive/monthly_report_generator.dart';
import 'package:fitkarma/features/predictive/monthly_report_notifier.dart';
import 'package:fitkarma/features/predictive/monthly_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final job = MonthlyReportGeneratorJob();
  final now = DateTime.now();



  final safeSnapshot = UserMonthlyHealthSnapshot(
    chronologicalAge: 32,
    restingHrBpm: 58.0,
    hrvMs: 68.0,
    sleepHoursAvg: 7.6,
    bmi: 22.0,
    dailyStepsAvg: 9400,
    fastingGlucoseMgDl: 92.0,
    calculationDate: now,
  );

  const telemetry = UserHealthTelemetry(
    systolicBpMmHg: 118,
    diastolicBpMmHg: 78,
    isBpRising: false,
    stepsDecliningDays: 0,
    fastingGlucoseMgDl: 92,
    isGlucoseRising: false,
    bmi: 22.0,
    restingHrBpm: 58,
    isRestingHrElevated: false,
    stressScore: 28,
    sleepHoursAvg: 7.6,
    waistCircumferenceCm: 80,
    isMale: true,
    hrvMs: 68,
    isHrvDeclining: false,
    isPerformanceDropping: false,
    dailyStepsAvg: 9400,
    highFatigueDays: 0,
  );

  group('§P10-C MonthlyReportGeneratorJob Unit Tests', () {
    test('Assembles monthly report payload correctly', () {
      final payload = job.generateReport(
        monthPeriod: 'May 2026',
        snapshot: safeSnapshot,
        telemetry: telemetry,
      );

      expect(payload.reportMonthPeriod, 'May 2026');
      expect(payload.biologicalAgeResult.chronologicalAge, 32);
      expect(payload.biologicalAgeResult.isYoungerThanChronological, true);
      expect(payload.systolicBpAvg, 118);
      expect(payload.fastingGlucoseAvg, 92);
      expect(payload.focusStrategyItems, isNotEmpty);
    });

    test('Formats clean text export suitable for PDF compilation', () {
      final payload = job.generateReport(
        monthPeriod: 'May 2026',
        snapshot: safeSnapshot,
        telemetry: telemetry,
      );

      final exportedText = job.exportToTextFormat(payload);

      expect(exportedText, contains('=== FITKARMA MONTHLY HEALTH REPORT ==='));
      expect(exportedText, contains('Report Period: May 2026'));
      expect(exportedText, contains('1. BIOLOGICAL AGE ESTIMATION'));
      expect(exportedText, contains('2. BIOMARKERS & VITALS AVERAGES'));
      expect(exportedText, contains("4. NEXT MONTH'S FOCUS STRATEGY"));
    });
  });

  group('§P10-C MonthlyReportScreen Widget Tests', () {
    testWidgets('Renders biological age card, vitals card, focus strategy, and export buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monthlyReportProvider.overrideWith(MonthlyReportNotifier.new),
          ],
          child: const MaterialApp(
            home: MonthlyReportScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Export Buttons
      expect(find.text('Monthly Health Report'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);

      // 2. Period Badge
      expect(find.text('Report Period: May 2026'), findsOneWidget);

      // 3. Biological Age Card
      expect(find.text('Biological Age vs. Chronological Age'), findsOneWidget);
      expect(find.text('Chronological Age'), findsOneWidget);
      expect(find.text('Biological Age'), findsOneWidget);

      // 4. Biomarkers Card
      expect(find.text('Biomarkers & Vitals Averages'), findsOneWidget);
      expect(find.text('Systolic BP:'), findsOneWidget);

      // 5. Focus Strategy Card
      expect(find.text("Next Month's Focus Strategy"), findsOneWidget);
    });
  });
}
