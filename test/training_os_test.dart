import 'package:fitkarma/features/workout/recovery_aware_overload_engine.dart';
import 'package:fitkarma/features/workout/training_os_controller.dart';
import 'package:fitkarma/features/workout/training_os_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mobilityEngine = MobilityDiagnosisEngine();
  const selector = AdaptiveExerciseSelector();
  const scorer = LocalReadinessScorer();
  const overloadEngine = RecoveryAwareOverloadEngine();

  // ─── MobilityDiagnosisEngine Tests ─────────────────────────────────────────

  group('MobilityDiagnosisEngine', () {
    test('empty setLogs → mobilityIndex 100, no issues', () {
      final report = mobilityEngine.diagnoseSquatPattern(setLogs: []);

      expect(report.mobilityIndex, 100);
      expect(report.identifiedIssues, isEmpty);
      expect(report.prescribedDrills, isEmpty);
    });

    test('high heel-lift ratio (>40%) → Limited Ankle Dorsiflexion diagnosed with drills', () {
      // 5 out of 8 reps have heel lift → 62.5%
      final setLogs = [
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: false, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: false, squatDepthAngle: 90.0),
        const FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: false, squatDepthAngle: 90.0),
      ];

      final report = mobilityEngine.diagnoseSquatPattern(setLogs: setLogs);

      expect(report.identifiedIssues, contains('Limited Ankle Dorsiflexion'));
      expect(report.prescribedDrills, contains('Perform 10 ankle rocker stretches per side before squatting.'));
      expect(report.mobilityIndex, lessThan(100));
    });

    test('high valgus ratio (>30%) → Glute Medius Instability diagnosed', () {
      // 4 out of 8 reps have valgus → 50%
      final setLogs = List.generate(8, (i) => FormAnalysisResult(
        kneeValgusDetected: i < 4,
        heelLiftDetected: false,
        squatDepthAngle: 90.0,
      ));

      final report = mobilityEngine.diagnoseSquatPattern(setLogs: setLogs);

      expect(report.identifiedIssues, contains('Glute Medius Instability'));
      expect(report.prescribedDrills, contains('Wrap a loop resistance band around knees during warm-up sets.'));
    });

    test('clean reps → mobilityIndex high (≥80), no issues', () {
      final setLogs = List.generate(8, (_) => const FormAnalysisResult(
        kneeValgusDetected: false,
        heelLiftDetected: false,
        squatDepthAngle: 95.0,
      ));

      final report = mobilityEngine.diagnoseSquatPattern(setLogs: setLogs);

      expect(report.identifiedIssues, isEmpty);
      expect(report.mobilityIndex, greaterThanOrEqualTo(80));
    });
  });

  // ─── AdaptiveExerciseSelector Tests ────────────────────────────────────────

  group('AdaptiveExerciseSelector', () {
    test('Poor Shoulder Mobility → landmine_press swap for overhead press', () {
      final alt = selector.selectAlternative(
        'barbell_overhead_press',
        ['Poor Shoulder Mobility'],
      );
      expect(alt, 'landmine_press');
    });

    test('Limited Ankle Dorsiflexion → goblet_box_squat swap for back squat', () {
      final alt = selector.selectAlternative(
        'barbell_back_squat',
        ['Limited Ankle Dorsiflexion'],
      );
      expect(alt, 'goblet_box_squat');
    });

    test('No limitations → returns first default substitute from registry', () {
      final alt = selector.selectAlternative('conventional_deadlift', []);
      expect(alt, 'romanian_deadlift');
    });

    test('Unknown exercise → returns primary exercise unchanged', () {
      final alt = selector.selectAlternative('unknown_exercise', []);
      expect(alt, 'unknown_exercise');
    });
  });

  // ─── RecoveryAwareOverloadEngine Tests ─────────────────────────────────────

  group('RecoveryAwareOverloadEngine', () {
    test('recoveryCapacity < 50 → 0 overload, maintenance message', () {
      final result = overloadEngine.suggest(
        exerciseId: 'bench_press',
        baseTargetWeightKg: 80.0,
        recoveryCapacity: 40.0,
        sleepDebtHours: 0.0,
      );

      expect(result.progressionFactor, 0.0);
      expect(result.overloadStepKg, 0.0);
      expect(result.targetWeightKg, 80.0);
      expect(result.message, contains('Maintain current weight'));
    });

    test('recoveryCapacity 60, sleepDebt 3h → half-step +2.5kg', () {
      final result = overloadEngine.suggest(
        exerciseId: 'bench_press',
        baseTargetWeightKg: 80.0,
        recoveryCapacity: 60.0,
        sleepDebtHours: 3.0,
      );

      expect(result.progressionFactor, 0.5);
      expect(result.overloadStepKg, 2.5);
      expect(result.targetWeightKg, 82.5);
      expect(result.message, contains('half-step'));
    });

    test('full recovery (capacity=90, sleep=0.5h) → full +5.0kg step', () {
      final result = overloadEngine.suggest(
        exerciseId: 'bench_press',
        baseTargetWeightKg: 80.0,
        recoveryCapacity: 90.0,
        sleepDebtHours: 0.5,
      );

      expect(result.progressionFactor, 1.0);
      expect(result.overloadStepKg, 5.0);
      expect(result.targetWeightKg, 85.0);
    });
  });

  // ─── LocalReadinessScorer Tests ────────────────────────────────────────────

  group('LocalReadinessScorer', () {
    test('high overall but low lower readiness → daySwapSuggestion generated', () {
      // Very fresh upper (soreness=1.0), very sore lower (soreness=5.0)
      final score = scorer.evaluate(
        upperSoreness: 1.0,
        lowerSoreness: 5.0,
        mobilityIndex: 90,
      );

      expect(score.upperBodyReadiness, greaterThan(80.0));
      expect(score.lowerBodyReadiness, lessThan(60.0));
      expect(score.daySwapSuggestion, isNotNull);
      expect(score.daySwapSuggestion, contains('Swap Leg Day with Upper Body Day'));
    });

    test('fully fresh user → near-100 readiness, no swap suggestion', () {
      final score = scorer.evaluate(
        upperSoreness: 1.0,
        lowerSoreness: 1.0,
        mobilityIndex: 100,
      );

      expect(score.upperBodyReadiness, greaterThan(90.0));
      expect(score.lowerBodyReadiness, greaterThan(90.0));
      expect(score.daySwapSuggestion, isNull);
    });
  });

  // ─── TrainingOsNotifier Integration Tests ──────────────────────────────────

  group('TrainingOsNotifier Integration', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial UserScores are all 100', () {
      final state = container.read(trainingOsProvider);

      expect(state.upperBodyReadiness, 100.0);
      expect(state.lowerBodyReadiness, 100.0);
      expect(state.mobilityIndex, 100);
    });

    test('evaluateReadiness updates UserScores correctly', () {
      final notifier = container.read(trainingOsProvider.notifier);
      const mobilityReport = MobilityReport(
        identifiedIssues: ['Limited Ankle Dorsiflexion'],
        prescribedDrills: ['Perform 10 ankle rocker stretches.'],
        mobilityIndex: 65,
      );

      notifier.evaluateReadiness(
        upperSoreness: 1.0,
        lowerSoreness: 4.5,
        mobilityReport: mobilityReport,
      );

      final state = container.read(trainingOsProvider);
      expect(state.mobilityIndex, 65);
      expect(state.lowerBodyReadiness, lessThan(60.0));
      expect(state.daySwapSuggestion, isNotNull);
    });
  });
}
