import 'package:fitkarma/features/predictive/injury_risk_engine.dart';
import 'package:fitkarma/features/workout/training_os_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = InjuryRiskEngine();
  const selector = AdaptiveExerciseSelector();

  group('§P10-D InjuryRiskEngine Unit Tests', () {
    test('Optimal training inputs produce Low Risk level', () {
      const optimalInput = InjuryRiskInput(
        weeklyVolumeLoadKg: 12000,
        acuteToChronicWorkloadRatio: 1.1, // Optimal sweet spot 0.8–1.3
        jointSorenessScores: {
          JointArea.shoulders: 1,
          JointArea.knees: 2,
        },
        formDeviationCount: 0,
        recoveryReadinessScore: 85.0,
      );

      final assessment = engine.assessInjuryRisk(optimalInput);

      expect(assessment.overallRiskLevel, InjuryRiskLevel.low);
      expect(assessment.riskScorePct, lessThan(25.0));
      expect(assessment.acwrStatus, contains('ACWR Optimal'));
      expect(assessment.isDeloadRecommended, false);
    });

    test('ACWR spike > 1.5 triggers High/Critical Risk level and volume load adjustment', () {
      const spikeInput = InjuryRiskInput(
        weeklyVolumeLoadKg: 25000,
        acuteToChronicWorkloadRatio: 1.65, // ACWR Spike > 1.5
        jointSorenessScores: {
          JointArea.shoulders: 3,
          JointArea.knees: 2,
        },
        formDeviationCount: 1,
        recoveryReadinessScore: 70.0,
      );

      final assessment = engine.assessInjuryRisk(spikeInput);

      expect(assessment.overallRiskLevel.priorityLevel, greaterThanOrEqualTo(2));
      expect(assessment.acwrStatus, contains('ACWR Spike'));
      expect(assessment.recommendedTrainingOsAdjustments.first, contains('Reduce weekly volume load by 30%'));
    });

    test('Joint soreness >= 7/10 identifies primary vulnerable joint and prescribes joint-sparing exercise', () {
      const shoulderSorenessInput = InjuryRiskInput(
        weeklyVolumeLoadKg: 15000,
        acuteToChronicWorkloadRatio: 1.2,
        jointSorenessScores: {
          JointArea.shoulders: 8, // High soreness
          JointArea.knees: 2,
        },
        formDeviationCount: 6, // Form errors
        recoveryReadinessScore: 55.0, // Low readiness
      );

      final assessment = engine.assessInjuryRisk(shoulderSorenessInput);

      expect(assessment.overallRiskLevel, InjuryRiskLevel.high);
      expect(assessment.primaryVulnerableJoint, JointArea.shoulders);
      expect(assessment.isDeloadRecommended, true);
      expect(assessment.recommendedTrainingOsAdjustments, contains(contains('Swap heavy loading on Shoulders')));
    });

    test('Wires InjuryRiskAssessment into Training OS AdaptiveExerciseSelector', () {
      const shoulderRiskInput = InjuryRiskInput(
        weeklyVolumeLoadKg: 20000,
        acuteToChronicWorkloadRatio: 1.6,
        jointSorenessScores: {
          JointArea.shoulders: 8,
        },
        formDeviationCount: 5,
        recoveryReadinessScore: 50.0,
      );

      final assessment = engine.assessInjuryRisk(shoulderRiskInput);

      // Verify Training OS selector overrides overhead press to joint-sparing landmine press
      final alt = selector.selectAlternative(
        'barbell_overhead_press',
        const [],
        injuryRisk: assessment,
      );

      expect(alt, 'landmine_press');
    });
  });
}
