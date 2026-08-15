import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/biological_age_estimator.dart';
import '../../../core/brain/preventive_intelligence_engine.dart';

class MonthlyReportState {
  final DateTime reportMonth;
  final BiologicalAgeEstimationResult biologicalAgeResult;
  final double averageSystolicBp;
  final double averageFastingGlucoseMgDl;
  final double averageHrvMs;
  final int averageDailySteps;
  final List<HealthRiskAlert> detectedRisks;
  final String nextMonthFocusStrategy;
  final bool isExporting;

  const MonthlyReportState({
    required this.reportMonth,
    required this.biologicalAgeResult,
    required this.averageSystolicBp,
    required this.averageFastingGlucoseMgDl,
    required this.averageHrvMs,
    required this.averageDailySteps,
    required this.detectedRisks,
    required this.nextMonthFocusStrategy,
    this.isExporting = false,
  });

  MonthlyReportState copyWith({
    bool? isExporting,
  }) {
    return MonthlyReportState(
      reportMonth: reportMonth,
      biologicalAgeResult: biologicalAgeResult,
      averageSystolicBp: averageSystolicBp,
      averageFastingGlucoseMgDl: averageFastingGlucoseMgDl,
      averageHrvMs: averageHrvMs,
      averageDailySteps: averageDailySteps,
      detectedRisks: detectedRisks,
      nextMonthFocusStrategy: nextMonthFocusStrategy,
      isExporting: isExporting ?? this.isExporting,
    );
  }
}

class MonthlyReportNotifier extends StateNotifier<MonthlyReportState> {
  MonthlyReportNotifier()
      : super(
          MonthlyReportState(
            reportMonth: DateTime(2026, 5, 1),
            biologicalAgeResult: const BiologicalAgeEstimationResult(
              chronologicalAge: 32,
              biologicalAge: 29.0,
              ageDeltaYears: -3.0,
              positiveContributors: [
                'High HRV (≥65 ms)',
                'Low Resting Heart Rate (<60 bpm)'
              ],
              riskFactors: [],
            ),
            averageSystolicBp: 118.0,
            averageFastingGlucoseMgDl: 92.0,
            averageHrvMs: 68.0,
            averageDailySteps: 8400,
            detectedRisks: const [
              HealthRiskAlert(
                id: 'r_shoulder',
                patternName: 'Shoulder Strain Risk',
                description:
                    'High volume pressing + reported anterior deltoid soreness.',
                severity: RiskSeverity.moderate,
                recommendation:
                    'Swap heavy overhead presses for cable face-pulls.',
                actions: ['Incorporate face-pulls', 'Deload pressing volume'],
              ),
            ],
            nextMonthFocusStrategy:
                'Swap high volume dumbbell presses for face-pulls and maintain 8,000+ daily steps.',
          ),
        );

  void triggerExportPdf() {
    state = state.copyWith(isExporting: true);
    state = state.copyWith(isExporting: false);
  }
}

final monthlyReportProvider =
    StateNotifierProvider<MonthlyReportNotifier, MonthlyReportState>((ref) {
  return MonthlyReportNotifier();
});
