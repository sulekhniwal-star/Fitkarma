import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/injury_risk_engine.dart';
import '../../domain/injury_risk_models.dart';

final injuryRiskProvider =
    StateNotifierProvider<InjuryRiskNotifier, InjuryRiskReport>((ref) {
  return InjuryRiskNotifier();
});

class InjuryRiskNotifier extends StateNotifier<InjuryRiskReport> {
  InjuryRiskNotifier() : super(_buildInitialReport());

  static final InjuryRiskEngine _engine = const InjuryRiskEngine();

  static InjuryRiskReport _buildInitialReport() {
    return _engine.evaluateInjuryRisk(
      acuteLoad7Days: 3750.0,
      chronicLoad28Days: 3450.0,
      sleepDebtHours: 1.1,
      hrvSuppressionPercent: 4.5,
      formBreakdownRatePercent: 6.0,
      jointSorenessScores: {
        AnatomicalJointArea.lumbarSpine: 2,
        AnatomicalJointArea.knees: 3,
        AnatomicalJointArea.shoulders: 1,
        AnatomicalJointArea.hips: 2,
        AnatomicalJointArea.anklesAchilles: 1,
      },
      jointLoadTonnages: {
        AnatomicalJointArea.lumbarSpine: 3800.0,
        AnatomicalJointArea.knees: 4200.0,
        AnatomicalJointArea.shoulders: 2900.0,
        AnatomicalJointArea.hips: 3100.0,
        AnatomicalJointArea.anklesAchilles: 1800.0,
      },
    );
  }

  void recalculateWithWorkload({
    required double acuteLoad7Days,
    required double chronicLoad28Days,
    required double sleepDebtHours,
    required double hrvSuppressionPercent,
    required double formBreakdownRatePercent,
    required Map<AnatomicalJointArea, int> jointSorenessScores,
    required Map<AnatomicalJointArea, double> jointLoadTonnages,
  }) {
    state = _engine.evaluateInjuryRisk(
      acuteLoad7Days: acuteLoad7Days,
      chronicLoad28Days: chronicLoad28Days,
      sleepDebtHours: sleepDebtHours,
      hrvSuppressionPercent: hrvSuppressionPercent,
      formBreakdownRatePercent: formBreakdownRatePercent,
      jointSorenessScores: jointSorenessScores,
      jointLoadTonnages: jointLoadTonnages,
    );
  }
}
