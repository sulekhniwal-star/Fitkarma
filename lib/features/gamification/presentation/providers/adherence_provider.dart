import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/adherence_engine.dart';
import '../../domain/adherence_models.dart';

final adherenceProvider = StateNotifierProvider<AdherenceNotifier, AdherenceReport>((ref) {
  return AdherenceNotifier();
});

class AdherenceNotifier extends StateNotifier<AdherenceReport> {
  AdherenceNotifier() : super(_getInitialReport());

  static AdherenceReport _getInitialReport() {
    final now = DateTime.now();
    final List<DailyAdherenceSnapshot> history = [
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 6)),
        compositeScore: 82.5,
        tier: AdherenceTier.disciplined,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 85, weight: 0.3, keyMetricLabel: 'Macro Target Met', statusSummary: '140g Protein'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 80, weight: 0.3, keyMetricLabel: 'Push Day Completed', statusSummary: 'Overload Met'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 84, weight: 0.25, keyMetricLabel: '7.5h Sleep', statusSummary: 'High HRV'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 80, weight: 0.15, keyMetricLabel: '2 Shatpawali', statusSummary: 'Curfew Met'),
      ),
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 5)),
        compositeScore: 88.0,
        tier: AdherenceTier.elite,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 90, weight: 0.3, keyMetricLabel: 'Clean Indian Food', statusSummary: 'MQS 92'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 90, weight: 0.3, keyMetricLabel: 'Pull Day Completed', statusSummary: 'Form 94%'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 86, weight: 0.25, keyMetricLabel: '8.0h Sleep', statusSummary: 'Optimal Recovery'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 85, weight: 0.15, keyMetricLabel: '3 Shatpawali', statusSummary: 'Pranayama Done'),
      ),
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 4)),
        compositeScore: 76.0,
        tier: AdherenceTier.disciplined,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 72, weight: 0.3, keyMetricLabel: 'Minor Over-carb', statusSummary: 'Festive Sweet'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 80, weight: 0.3, keyMetricLabel: 'Leg Day Completed', statusSummary: 'Baithak Done'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 75, weight: 0.25, keyMetricLabel: '6.8h Sleep', statusSummary: 'Mild Sleep Debt'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 80, weight: 0.15, keyMetricLabel: 'Shatpawali Done', statusSummary: 'Curfew Met'),
      ),
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 3)),
        compositeScore: 91.5,
        tier: AdherenceTier.elite,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 95, weight: 0.3, keyMetricLabel: 'Pristine Macro Split', statusSummary: '145g Protein'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 90, weight: 0.3, keyMetricLabel: 'Shoulders & Arms', statusSummary: 'Overload 105%'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 90, weight: 0.25, keyMetricLabel: '8.2h Restorative', statusSummary: 'Readiness 94'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 90, weight: 0.15, keyMetricLabel: 'Full Routine', statusSummary: 'Curfew Met'),
      ),
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 2)),
        compositeScore: 85.0,
        tier: AdherenceTier.elite,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 85, weight: 0.3, keyMetricLabel: 'Macro Balance', statusSummary: '140g Protein'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 85, weight: 0.3, keyMetricLabel: 'Active Recovery Flow', statusSummary: 'Mobility Done'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 85, weight: 0.25, keyMetricLabel: '7.8h Sleep', statusSummary: 'Optimal HRV'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 85, weight: 0.15, keyMetricLabel: '2 Shatpawali', statusSummary: 'Curfew Met'),
      ),
      DailyAdherenceSnapshot(
        date: now.subtract(const Duration(days: 1)),
        compositeScore: 87.5,
        tier: AdherenceTier.elite,
        nutrition: const PillarAdherenceScore(name: 'Nutrition', regionalName: 'पोषण', score: 88, weight: 0.3, keyMetricLabel: 'Target Hit', statusSummary: 'Clean Diet'),
        training: const PillarAdherenceScore(name: 'Training', regionalName: 'व्यायाम', score: 90, weight: 0.3, keyMetricLabel: 'Upper Body Power', statusSummary: 'Bench PR Hit'),
        recovery: const PillarAdherenceScore(name: 'Recovery', regionalName: 'रिकवरी', score: 85, weight: 0.25, keyMetricLabel: '7.6h Sleep', statusSummary: 'Low Debt'),
        circadianHabits: const PillarAdherenceScore(name: 'Circadian', regionalName: 'सर्केडियन', score: 85, weight: 0.15, keyMetricLabel: 'Shatpawali Logged', statusSummary: 'Curfew Met'),
      ),
    ];

    return AdherenceEngine.generateReport(
      nutritionScore: 88.0,
      trainingScore: 92.0,
      recoveryScore: 84.0,
      circadianScore: 86.0,
      weeklySnapshots: history,
    );
  }

  /// Refreshes scores when new telemetry data arrives
  void updatePillarScores({
    required double nutritionScore,
    required double trainingScore,
    required double recoveryScore,
    required double circadianScore,
  }) {
    state = AdherenceEngine.generateReport(
      nutritionScore: nutritionScore,
      trainingScore: trainingScore,
      recoveryScore: recoveryScore,
      circadianScore: circadianScore,
      weeklySnapshots: state.weeklyHistory,
    );
  }
}
