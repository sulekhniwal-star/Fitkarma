import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/monthly_report_engine.dart';
import '../../domain/monthly_report_models.dart';

final monthlyReportProvider =
    StateNotifierProvider<MonthlyReportNotifier, MonthlyHealthReport>((ref) {
  return MonthlyReportNotifier();
});

class MonthlyReportNotifier extends StateNotifier<MonthlyHealthReport> {
  MonthlyReportNotifier() : super(_buildInitialReport());

  static final MonthlyHealthReportEngine _engine = const MonthlyHealthReportEngine();

  static MonthlyHealthReport _buildInitialReport() {
    return _engine.generateMonthlyReport(
      monthTitle: 'August 2026',
      regionalMonthTitle: 'अगस्त २०२६',
      avgRestingHeartRate: 59.5,
      avgSystolicBp: 116.0,
      avgDiastolicBp: 74.0,
      avgHrvRmssd: 54.0,
      avgDailySteps: 10850.0,
      strengthWorkoutsCount: 14,
      estimatedHbA1c: 5.22,
      avgFastingGlucose: 89.0,
      shatpawaliAdherencePercent: 88.0,
      avgSleepDurationHours: 7.5,
      avgDeepSleepPercent: 20.2,
      netSleepDebtHours: 0.8,
      avgProteinGramsPerKg: 1.42,
      antiInflammatoryDietScore: 86.0,
      biologicalAge: 28.8,
      chronologicalAge: 32.0,
      monthlyBioAgeImprovement: -0.5,
      agingPace: 0.84,
    );
  }

  void recalculateWithMonthlyMetrics({
    required String monthTitle,
    required String regionalMonthTitle,
    required double avgRestingHeartRate,
    required double avgSystolicBp,
    required double avgDiastolicBp,
    required double avgHrvRmssd,
    required double avgDailySteps,
    required int strengthWorkoutsCount,
    required double estimatedHbA1c,
    required double avgFastingGlucose,
    required double shatpawaliAdherencePercent,
    required double avgSleepDurationHours,
    required double avgDeepSleepPercent,
    required double netSleepDebtHours,
    required double avgProteinGramsPerKg,
    required double antiInflammatoryDietScore,
    required double biologicalAge,
    required double chronologicalAge,
    required double monthlyBioAgeImprovement,
    required double agingPace,
  }) {
    state = _engine.generateMonthlyReport(
      monthTitle: monthTitle,
      regionalMonthTitle: regionalMonthTitle,
      avgRestingHeartRate: avgRestingHeartRate,
      avgSystolicBp: avgSystolicBp,
      avgDiastolicBp: avgDiastolicBp,
      avgHrvRmssd: avgHrvRmssd,
      avgDailySteps: avgDailySteps,
      strengthWorkoutsCount: strengthWorkoutsCount,
      estimatedHbA1c: estimatedHbA1c,
      avgFastingGlucose: avgFastingGlucose,
      shatpawaliAdherencePercent: shatpawaliAdherencePercent,
      avgSleepDurationHours: avgSleepDurationHours,
      avgDeepSleepPercent: avgDeepSleepPercent,
      netSleepDebtHours: netSleepDebtHours,
      avgProteinGramsPerKg: avgProteinGramsPerKg,
      antiInflammatoryDietScore: antiInflammatoryDietScore,
      biologicalAge: biologicalAge,
      chronologicalAge: chronologicalAge,
      monthlyBioAgeImprovement: monthlyBioAgeImprovement,
      agingPace: agingPace,
    );
  }
}
