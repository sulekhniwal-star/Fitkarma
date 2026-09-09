import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/injury_risk_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/injury_risk_models.dart';

void main() {
  group('InjuryRiskEngine Tests', () {
    const engine = InjuryRiskEngine();

    test('Identifies optimal ACWR and low injury risk for balanced load', () {
      final report = engine.evaluateInjuryRisk(
        acuteLoad7Days: 3500.0,
        chronicLoad28Days: 3400.0,
        sleepDebtHours: 0.8,
        hrvSuppressionPercent: 3.0,
        formBreakdownRatePercent: 5.0,
        jointSorenessScores: {
          AnatomicalJointArea.lumbarSpine: 2,
          AnatomicalJointArea.knees: 2,
          AnatomicalJointArea.shoulders: 1,
          AnatomicalJointArea.hips: 1,
          AnatomicalJointArea.anklesAchilles: 1,
        },
        jointLoadTonnages: {
          AnatomicalJointArea.lumbarSpine: 3200.0,
          AnatomicalJointArea.knees: 3400.0,
          AnatomicalJointArea.shoulders: 2200.0,
          AnatomicalJointArea.hips: 2800.0,
          AnatomicalJointArea.anklesAchilles: 1400.0,
        },
      );

      expect(report.acuteChronicWorkloadRatio, inInclusiveRange(0.85, 1.25));
      expect(report.overallRiskTier, equals(InjuryRiskTier.optimal));
      expect(report.shouldDeload, isFalse);
      expect(report.jointAssessments.length, equals(5));
      expect(report.activeProtocols.isNotEmpty, isTrue);
    });

    test('Triggers high-risk tier and deload recommendation on severe training spike', () {
      final report = engine.evaluateInjuryRisk(
        acuteLoad7Days: 5800.0,
        chronicLoad28Days: 3200.0,
        sleepDebtHours: 5.5,
        hrvSuppressionPercent: 28.0,
        formBreakdownRatePercent: 18.0,
        jointSorenessScores: {
          AnatomicalJointArea.lumbarSpine: 8,
          AnatomicalJointArea.knees: 7,
          AnatomicalJointArea.shoulders: 6,
          AnatomicalJointArea.hips: 5,
          AnatomicalJointArea.anklesAchilles: 4,
        },
        jointLoadTonnages: {
          AnatomicalJointArea.lumbarSpine: 7200.0,
          AnatomicalJointArea.knees: 6800.0,
          AnatomicalJointArea.shoulders: 4900.0,
          AnatomicalJointArea.hips: 5100.0,
          AnatomicalJointArea.anklesAchilles: 2400.0,
        },
      );

      expect(report.acuteChronicWorkloadRatio, greaterThan(1.50));
      expect(report.overallRiskTier, equals(InjuryRiskTier.high));
      expect(report.shouldDeload, isTrue);
      expect(report.activeProtocols.any((p) => p.id.contains('deload')), isTrue);
    });
  });
}
