import 'package:fitkarma/features/coach/coach_escalation_service.dart';

enum Trend {
  rising,
  declining,
  stable,
}

class UserHealthData {
  const UserHealthData({
    required this.bpTrend,
    required this.sleepTrend,
    required this.weightTrend,
    required this.stepsTrend,
    required this.glucoseTrend,
    required this.bmi,
    required this.stepAvg7d,
  });

  final Trend bpTrend;
  final Trend sleepTrend;
  final Trend weightTrend;
  final Trend stepsTrend;
  final Trend glucoseTrend;
  final double bmi;
  final double stepAvg7d;
}

class HealthRiskAlert {
  const HealthRiskAlert({
    required this.risk,
    required this.severity,
    required this.message,
    required this.actions,
  });

  final String risk;
  final RiskSeverity severity;
  final String message;
  final List<String> actions;
}

class PreventiveIntelligenceEngine {
  List<HealthRiskAlert> analyze(UserHealthData data) {
    final alerts = <HealthRiskAlert>[];

    // Hypertension pattern
    if (data.bpTrend == Trend.rising &&
        data.sleepTrend == Trend.declining &&
        data.weightTrend == Trend.rising &&
        data.stepsTrend == Trend.declining) {
      alerts.add(HealthRiskAlert(
        risk: 'Hypertension',
        severity: RiskSeverity.medium,
        message: 'Rising BP + declining sleep + reduced activity is '
                 'a hypertension risk pattern. Prioritize walking.',
        actions: const ['Log a 20-min walk', 'Reduce sodium', 'Check BP tomorrow'],
      ));
    }

    // Diabetes pattern
    if (data.glucoseTrend == Trend.rising &&
        data.bmi >= 27 &&
        data.stepAvg7d < 5000) {
      alerts.add(HealthRiskAlert(
        risk: 'Type 2 Diabetes',
        severity: RiskSeverity.medium,
        message: 'Elevated glucose + low activity. '
                 'A 15-min post-meal walk reduces glucose spikes significantly.',
        actions: const ['Walk after meals', 'Reduce refined carbs', 'Log fasting glucose'],
      ));
    }

    return alerts;
  }
}
