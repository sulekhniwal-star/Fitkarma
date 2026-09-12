import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'readiness_input.dart';

enum ReadinessState { prime, steady, recovery }

/// ReadinessResult — Synthesized Daily Readiness Output
class ReadinessResult {
  final int score; // 0 to 100
  final ConfidenceTier confidenceTier;
  final ReadinessState state;
  final Color stateColor;
  final String stateTitle;
  final String stateTitleHindi;
  final String narrative;
  final String narrativeHindi;
  final double strainCapacityBudget; // 0 - 21 (Bannister/Whoop scale equivalent)
  final int recoveryAgeYears; // Inferred biological recovery velocity
  final double sleepDebtHours;
  final double sleepEfficiencyScore; // 0 - 100
  final List<String> recoveryPrescriptions;
  final List<String> recoveryPrescriptionsHindi;

  const ReadinessResult({
    required this.score,
    required this.confidenceTier,
    required this.state,
    required this.stateColor,
    required this.stateTitle,
    required this.stateTitleHindi,
    required this.narrative,
    required this.narrativeHindi,
    required this.strainCapacityBudget,
    required this.recoveryAgeYears,
    required this.sleepDebtHours,
    required this.sleepEfficiencyScore,
    required this.recoveryPrescriptions,
    required this.recoveryPrescriptionsHindi,
  });

  factory ReadinessResult.fromScore({
    required int score,
    required ConfidenceTier tier,
    required int chronologicalAge,
    required double sleepDebt,
    required double sleepEfficiency,
    required List<String> prescriptions,
    required List<String> prescriptionsHindi,
  }) {
    final clampedScore = score.clamp(0, 100);

    ReadinessState state;
    Color color;
    String title;
    String titleHindi;
    String narrative;
    String narrativeHindi;
    double strainBudget;
    int recoveryAge;

    if (clampedScore >= 80) {
      state = ReadinessState.prime;
      color = AppColors.primaryEmerald;
      title = 'Prime Readiness';
      titleHindi = 'सर्वोत्तम फिटनेस तत्परता';
      narrative = 'Autonomic nervous system is fully restored. Optimal day for heavy compound lifts or high-volume sessions.';
      narrativeHindi = 'शरीर पूर्णतः ऊर्जावान है। आज भारी वजन और तीव्र वर्कआउट के लिए सबसे उपयुक्त दिन है।';
      strainBudget = 14.0 + ((clampedScore - 80) / 20.0 * 5.0); // 14.0 - 19.0
      recoveryAge = chronologicalAge - 3;
    } else if (clampedScore >= 60) {
      state = ReadinessState.steady;
      color = AppColors.accentAmber;
      title = 'Steady Recovery';
      titleHindi = 'स्थिर रिकवरी';
      narrative = 'Moderate capacity available. Maintain structured workout load with standard rest intervals.';
      narrativeHindi = 'संतुलित शारीरिक क्षमता। नियमित व्यायाम करें और सेट के बीच पर्याप्त विश्राम लें।';
      strainBudget = 9.0 + ((clampedScore - 60) / 20.0 * 4.5); // 9.0 - 13.5
      recoveryAge = chronologicalAge;
    } else {
      state = ReadinessState.recovery;
      color = AppColors.accentCoral;
      title = 'Recovery Protocol Required';
      titleHindi = 'सक्रिय विश्राम आवश्यक';
      narrative = 'Systemic strain or elevated muscle soreness detected. Prioritize active recovery, mobility, and sleep.';
      narrativeHindi = 'थकान के संकेत मिले हैं। आज भारी व्यायाम से बचें; हल्की स्ट्रेचिंग, योग और पर्याप्त नींद लें।';
      strainBudget = (clampedScore / 60.0 * 8.5).clamp(4.0, 8.5);
      recoveryAge = chronologicalAge + 4;
    }

    return ReadinessResult(
      score: clampedScore,
      confidenceTier: tier,
      state: state,
      stateColor: color,
      stateTitle: title,
      stateTitleHindi: titleHindi,
      narrative: narrative,
      narrativeHindi: narrativeHindi,
      strainCapacityBudget: double.parse(strainBudget.toStringAsFixed(1)),
      recoveryAgeYears: recoveryAge,
      sleepDebtHours: double.parse(sleepDebt.toStringAsFixed(1)),
      sleepEfficiencyScore: double.parse(sleepEfficiency.toStringAsFixed(1)),
      recoveryPrescriptions: prescriptions,
      recoveryPrescriptionsHindi: prescriptionsHindi,
    );
  }
}
