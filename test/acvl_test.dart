import 'package:fitkarma/features/workout/form_deviation_detector.dart';
import 'package:fitkarma/features/workout/form_feedback_overlay.dart';
import 'package:fitkarma/features/workout/movement_log_repository.dart';
import 'package:fitkarma/features/workout/pose_landmark_adapter.dart';
import 'package:fitkarma/features/workout/thermal_frame_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§P6-F ACVL — ThermalFrameProcessor Unit & Performance Tests', () {
    late ProviderContainer container;
    late ThermalFrameProcessor processor;

    setUp(() {
      container = ProviderContainer();
      processor = container.read(thermalProcessorProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Evaluate headroom maps correctly across all 4 thermal states', () {
      processor.evaluateHeadroom(0.50);
      expect(processor.debugState, ThermalWorkloadState.normal);
      expect(processor.debugState.targetFps, 30);

      processor.evaluateHeadroom(0.80);
      expect(processor.debugState, ThermalWorkloadState.moderate);
      expect(processor.debugState.targetFps, 15);

      processor.evaluateHeadroom(0.90);
      expect(processor.debugState, ThermalWorkloadState.severe);
      expect(processor.debugState.targetFps, 10);

      processor.evaluateHeadroom(0.96);
      expect(processor.debugState, ThermalWorkloadState.critical);
      expect(processor.debugState.targetFps, 5);
    });

    test('shouldProcessNextFrame respects exact downsampling ratios', () {
      // 1. Normal state -> 100% of frames (1:1)
      processor.evaluateHeadroom(0.50);
      processor.resetFrameCount();
      final normalResults = List.generate(6, (_) => processor.shouldProcessNextFrame());
      expect(normalResults, [true, true, true, true, true, true]);

      // 2. Moderate state -> 15 fps target (1:2 skip)
      processor.evaluateHeadroom(0.80);
      processor.resetFrameCount();
      final moderateResults = List.generate(6, (_) => processor.shouldProcessNextFrame());
      expect(moderateResults, [false, true, false, true, false, true]);

      // 3. Severe state -> 10 fps target (1:3 skip)
      processor.evaluateHeadroom(0.90);
      processor.resetFrameCount();
      final severeResults = List.generate(6, (_) => processor.shouldProcessNextFrame());
      expect(severeResults, [false, false, true, false, false, true]);

      // 4. Critical state -> 5 fps target (1:6 skip)
      processor.evaluateHeadroom(0.96);
      processor.resetFrameCount();
      final criticalResults = List.generate(6, (_) => processor.shouldProcessNextFrame());
      expect(criticalResults, [false, false, false, false, false, true]);
    });
  });

  group('§P6-F ACVL — PoseLandmarkAdapter Tests', () {
    late PoseLandmarkAdapter adapter;

    setUp(() {
      adapter = PoseLandmarkAdapter();
    });

    test('Normalize handles temporal fallback on low confidence joints', () {
      final lastFrame = List.generate(33, (i) => PoseKeypoint(
        index: i,
        x: 0.5,
        y: 0.5,
        z: 0.0,
        score: 0.9,
      ));

      final lowConfidenceIncoming = List.generate(33, (i) => PoseKeypoint(
        index: i,
        x: 0.9,
        y: 0.9,
        z: 0.0,
        score: 0.2, // Below 0.5 threshold
      ));

      final normalized = adapter.normalize(
        incomingLandmarks: lowConfidenceIncoming,
        lastFrameLandmarks: lastFrame,
      );

      // Low confidence points should fall back to previous frame coordinates
      expect(normalized[25].x, 0.5);
      expect(normalized[25].y, 0.5);
    });
  });

  group('§P6-F ACVL — FormDeviationDetector & MovementLogRepository', () {
    const detector = FormDeviationDetector();
    late MovementLogRepository repository;

    setUp(() {
      repository = MovementLogRepository();
    });

    test('Detects clean form with high score', () {
      final skeleton = List.generate(33, (i) => PoseKeypoint(
        index: i,
        x: 0.5,
        y: 0.5,
        z: 0.0,
        score: 0.9,
      ));

      final score = detector.analyze(
        skeleton: skeleton,
        thermalState: ThermalWorkloadState.normal,
      );

      expect(score.overallScore, 100);
      expect(score.feedback, contains('Great form'));
    });

    test('Persists form metrics to MovementLogRepository', () {
      final skeleton = List.generate(33, (i) => PoseKeypoint(
        index: i,
        x: 0.5,
        y: 0.5,
        z: 0.0,
        score: 0.9,
      ));

      final score = detector.analyze(
        skeleton: skeleton,
        thermalState: ThermalWorkloadState.normal,
      );

      repository.addEntry(
        sessionId: 'session_123',
        exerciseName: 'Squat',
        score: score,
      );

      final logs = repository.getSessionLogs('session_123');
      expect(logs.length, 1);
      expect(logs.first.exerciseName, 'Squat');
      expect(repository.getAverageFormScore('session_123'), 100.0);
    });
  });

  group('§P6-F ACVL — FormFeedbackOverlay Widget Tests', () {
    testWidgets('Renders thermal optimization badge when in severe thermal state', (tester) async {
      const score = FormQualityScore(
        overallScore: 85,
        kneeValgusFlag: false,
        heelLiftFlag: false,
        squatDepthAngle: 90.0,
        asymmetryDeltaPct: 0.0,
        feedback: 'Good form',
        trackedJointCount: 11,
        thermalState: ThermalWorkloadState.severe,
      );

      final container = ProviderContainer();
      container.read(thermalProcessorProvider.notifier).evaluateHeadroom(0.90);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: FormFeedbackOverlay(
                formScore: score,
                skeleton: [],
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('Optimization Mode Active'), findsOneWidget);
      expect(find.text('Good form'), findsOneWidget);

      container.dispose();
    });
  });
}

extension on ThermalFrameProcessor {
  ThermalWorkloadState get debugState => state;
}
