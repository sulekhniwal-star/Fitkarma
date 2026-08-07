import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/training_operating_system_engine.dart';
import 'package:fitkarma/features/workout/screens/training_os_screen.dart';

void main() {
  group('§P6-E Training Operating System Tests', () {
    const engine = TrainingOperatingSystemEngine();

    test('diagnoseSquatPattern identifies dorsiflexion and valgus faults and prescribes correctives per §P6-E spec', () {
      final report = engine.diagnoseSquatPattern(setLogs: const [
        FormAnalysisResult(kneeValgusDetected: false, heelLiftDetected: true, squatDepthAngle: 75.0),
        FormAnalysisResult(kneeValgusDetected: true, heelLiftDetected: true, squatDepthAngle: 85.0),
        FormAnalysisResult(kneeValgusDetected: true, heelLiftDetected: false, squatDepthAngle: 72.0),
      ]);

      expect(report.identifiedIssues, contains('Limited Ankle Dorsiflexion'));
      expect(report.identifiedIssues, contains('Glute Medius Instability'));
      expect(report.prescribedDrills.any((d) => d.contains('ankle rocker')), isTrue);
      expect(report.prescribedDrills.any((d) => d.contains('resistance band')), isTrue);
      expect(report.mobilityIndex, lessThan(100));
    });

    test('calculateExerciseConfidenceScore (ECS) computes confidence index strictly clamped to 0-100', () {
      final score = engine.calculateExerciseConfidenceScore(
        tempoVariancePct: 15.0, // 6 pts penalty
        asymmetryRatePct: 10.0, // 3 pts penalty
        jointJitterIndex: 10.0, // 3 pts penalty -> Total penalty = 12
      );

      expect(score, equals(88.0));
    });

    test('calculateMovementAge calculates younger Movement Age for high MHS score', () {
      final profile = engine.calculateMovementAge(actualAge: 30, mhsScore: 88.0);

      expect(profile.movementAge, equals(25)); // 30 - 5
      expect(profile.athleticTier, equals('Advanced'));
    });

    test('selectAlternativeExercise performs smart swaps for joint mobility limitations', () {
      final squatSwap = engine.selectAlternativeExercise(
        primaryExerciseId: 'barbell_back_squat',
        identifiedLimitations: const ['Limited Ankle Dorsiflexion'],
      );
      expect(squatSwap, equals('goblet_box_squat'));

      final ohpSwap = engine.selectAlternativeExercise(
        primaryExerciseId: 'barbell_overhead_press',
        identifiedLimitations: const ['Poor Shoulder Mobility'],
      );
      expect(ohpSwap, equals('landmine_press'));
    });

    test('calculateLocalSegmentReadiness flags leg recovery needed when lower readiness is low', () {
      final seg = engine.calculateLocalSegmentReadiness(
        overallReadiness: 85.0,
        upperSoreness: 1.0, // 85 - 4 = 81
        lowerSoreness: 8.0, // 85 - 32 = 53
      );

      expect(seg.upperBodyReadiness, equals(81.0));
      expect(seg.lowerBodyReadiness, equals(53.0));
      expect(seg.recommendation, contains('legs need recovery'));
    });

    test('analyzeUnilateralRep detects asymmetry imbalance when delta exceeds 10%', () {
      final rep = engine.analyzeUnilateralRep(
        leftAngleDeg: 80.0,
        rightAngleDeg: 95.0,
        exerciseKey: 'single_leg_squat',
      );

      expect(rep.isImbalanced, isTrue);
      expect(rep.asymmetryDeltaPct, equals(15.8));
      expect(rep.recommendedAdjustment, contains('left side is compensating'));
    });

    test('forecastStrength projects 8-week and 12-week load progression based on training reliability', () {
      final forecast = engine.forecastStrength(
        historicWeights: const [75.0, 77.5, 80.0],
        reliabilityScore: 90.0,
      );

      expect(forecast.projected8WeekWeight, equals(82.0));
      expect(forecast.projected12WeekWeight, equals(85.2));
      expect(forecast.forecastSummary, contains('progress your load to 82.0 kg'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('TrainingOsScreen renders MHS score, Local Readiness card, Mobility card, and Forecasting card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TrainingOsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Training OS — TOS 5.0'), findsOneWidget);
      expect(find.text('Movement Health Score (MHS)'), findsOneWidget);
      expect(find.text('Segmented Local Muscle Readiness'), findsOneWidget);
      expect(find.text('Mobility Diagnosis & Correctives'), findsOneWidget);
      expect(find.text('Biomechanical Asymmetry & Forecasting'), findsOneWidget);
    });
  });
}
