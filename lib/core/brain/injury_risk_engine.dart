enum InjuryRiskLevel { low, moderate, high }

class InjuryRiskAlert {
  final String region; // 'Shoulder', 'Knee', 'Lower Back'
  final InjuryRiskLevel risk;
  final String message;
  final List<String> actions;

  const InjuryRiskAlert({
    required this.region,
    required this.risk,
    required this.message,
    required this.actions,
  });
}

class FormHistoryData {
  final int kneeValgusIncidents;
  final int shoulderImpactionIncidents;
  final int spinalFlexionIncidents;

  const FormHistoryData({
    this.kneeValgusIncidents = 0,
    this.shoulderImpactionIncidents = 0,
    this.spinalFlexionIncidents = 0,
  });
}

class RecoveryLogSnapshot {
  final String region;
  final double sorenessLevel; // 0.0 to 5.0
  final bool isHrvDeclining;

  const RecoveryLogSnapshot({
    required this.region,
    required this.sorenessLevel,
    this.isHrvDeclining = false,
  });
}

class WorkoutLogSnapshot {
  final String exerciseCategory; // 'pressing', 'lower_body', 'deadlift_row'
  final double volumeKg;

  const WorkoutLogSnapshot({
    required this.exerciseCategory,
    required this.volumeKg,
  });
}

/// Pure-Dart Rule-Based + Heuristics Injury Risk Engine per §P10-D spec
class InjuryRiskEngine {
  const InjuryRiskEngine();

  List<InjuryRiskAlert> analyze({
    required List<RecoveryLogSnapshot> recoveryLogs,
    required List<WorkoutLogSnapshot> workoutLogs,
    required FormHistoryData formHistory,
  }) {
    final risks = <InjuryRiskAlert>[];

    // 1. Shoulder Injury Risk: High pressing volume (>12,000 kg) + elevated shoulder soreness (>3.0)
    final pressingVolume = workoutLogs
        .where((w) => w.exerciseCategory == 'pressing')
        .fold(0.0, (sum, item) => sum + item.volumeKg);

    final shoulderSorenessLogs = recoveryLogs.where((r) => r.region.toLowerCase() == 'shoulder').toList();
    final avgShoulderSoreness = shoulderSorenessLogs.isNotEmpty
        ? shoulderSorenessLogs.map((r) => r.sorenessLevel).reduce((a, b) => a + b) / shoulderSorenessLogs.length
        : 0.0;

    if (pressingVolume > 12000 && avgShoulderSoreness > 3.0) {
      risks.add(InjuryRiskAlert(
        region: 'Shoulder',
        risk: InjuryRiskLevel.moderate,
        message: 'High pressing volume (${pressingVolume.round()} kg this week) + elevated shoulder soreness (${avgShoulderSoreness.toStringAsFixed(1)}/5). Risk of rotator cuff strain.',
        actions: const [
          'Reduce pressing volume by 20% this week',
          'Add 2 sets of face pulls or band pull-aparts',
          'Stretch thoracic spine daily',
        ],
      ));
    }

    // 2. Knee Injury Risk: High lower body volume (>15,000 kg) + knee valgus form incidents (>2)
    final lowerBodyVolume = workoutLogs
        .where((w) => w.exerciseCategory == 'lower_body')
        .fold(0.0, (sum, item) => sum + item.volumeKg);

    if (formHistory.kneeValgusIncidents > 2 && lowerBodyVolume > 15000) {
      risks.add(InjuryRiskAlert(
        region: 'Knee',
        risk: InjuryRiskLevel.moderate,
        message: 'Knee valgus detected in recent squat sessions + high volume. Patellar tendon stress building.',
        actions: const [
          'Add glute activation (clamshells, band walks)',
          'Reduce squat depth temporarily',
          'Check knee tracking during all lower body work',
        ],
      ));
    }

    // 3. Lower Back Injury Risk: Elevated lower back soreness (>3.5) + HRV decline
    final lbSorenessLogs = recoveryLogs.where((r) => r.region.toLowerCase() == 'lower_back').toList();
    final avgLbSoreness = lbSorenessLogs.isNotEmpty
        ? lbSorenessLogs.map((r) => r.sorenessLevel).reduce((a, b) => a + b) / lbSorenessLogs.length
        : 0.0;
    final isHrvDeclining = recoveryLogs.any((r) => r.isHrvDeclining);

    if (avgLbSoreness > 3.5 && isHrvDeclining) {
      risks.add(InjuryRiskAlert(
        region: 'Lower Back',
        risk: InjuryRiskLevel.high,
        message: 'Persistent lower back soreness (${avgLbSoreness.toStringAsFixed(1)}/5) with HRV decline. High risk of muscle strain or disc irritation.',
        actions: const [
          'Skip deadlifts and heavy rows this week',
          'Focus on core stability (bird-dog, dead bug)',
          'Ice + rest if pain >4/10',
        ],
      ));
    }

    return risks;
  }
}
