import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/monthly_report_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/monthly_report_models.dart';

void main() {
  group('MonthlyHealthReportEngine Tests', () {
    const engine = MonthlyHealthReportEngine();

    test('Generates optimal Grade A+ monthly report for strong adherence', () {
      final report = engine.generateMonthlyReport(
        monthTitle: 'August 2026',
        regionalMonthTitle: 'अगस्त २०२६',
        avgRestingHeartRate: 58.0,
        avgSystolicBp: 114.0,
        avgDiastolicBp: 72.0,
        avgHrvRmssd: 58.0,
        avgDailySteps: 11200.0,
        strengthWorkoutsCount: 15,
        estimatedHbA1c: 5.15,
        avgFastingGlucose: 87.0,
        shatpawaliAdherencePercent: 90.0,
        avgSleepDurationHours: 7.6,
        avgDeepSleepPercent: 21.0,
        netSleepDebtHours: 0.5,
        avgProteinGramsPerKg: 1.45,
        antiInflammatoryDietScore: 88.0,
        biologicalAge: 28.5,
        chronologicalAge: 32.0,
        monthlyBioAgeImprovement: -0.6,
        agingPace: 0.82,
      );

      expect(report.compositeScore, greaterThanOrEqualTo(90.0));
      expect(report.grade, equals(MonthlyHealthGrade.aPlus));
      expect(report.pillarSummaries.length, equals(5));
      expect(report.topWins.isNotEmpty, isTrue);
      expect(report.nextMonthPriorities.isNotEmpty, isTrue);
      expect(report.doctorSummaryParagraph,
          contains('PATIENT 30-DAY BIOMETRIC SUMMARY'));
    });

    test('Correctly identifies areas needing focus for compromised telemetry',
        () {
      final report = engine.generateMonthlyReport(
        monthTitle: 'July 2026',
        regionalMonthTitle: 'जुलाई २०२६',
        avgRestingHeartRate: 78.0,
        avgSystolicBp: 138.0,
        avgDiastolicBp: 89.0,
        avgHrvRmssd: 28.0,
        avgDailySteps: 4200.0,
        strengthWorkoutsCount: 2,
        estimatedHbA1c: 6.5,
        avgFastingGlucose: 122.0,
        shatpawaliAdherencePercent: 35.0,
        avgSleepDurationHours: 5.8,
        avgDeepSleepPercent: 9.5,
        netSleepDebtHours: 5.5,
        avgProteinGramsPerKg: 0.75,
        antiInflammatoryDietScore: 42.0,
        biologicalAge: 36.2,
        chronologicalAge: 32.0,
        monthlyBioAgeImprovement: 0.8,
        agingPace: 1.18,
      );

      expect(report.compositeScore, lessThan(70.0));
      expect(report.grade, equals(MonthlyHealthGrade.c));
      expect(report.pillarSummaries.length, equals(5));
    });
  });
}
