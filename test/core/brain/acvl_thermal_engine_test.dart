import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/pose_landmark_adapter.dart';
import 'package:fitkarma/features/workout/training_os/thermal_frame_processor.dart';
import 'package:fitkarma/features/workout/training_os/thermal_safeguard_banner.dart';

void main() {
  group('§P6-F Adaptive Computer Vision Loop (ACVL) Tests', () {
    test('PoseLandmarkAdapter downsamples 33 joint landmarks to 11 core joints in downsampled mode', () {
      final adapter = PoseLandmarkAdapter();
      final raw33 = List.generate(
        33,
        (i) => PoseKeypoint(index: i, x: (i + 1) * 10.0, y: (i + 1) * 12.0, z: 0.0, score: 0.9),
      );

      final normalized = adapter.filterAndNormalizeLandmarks(
        rawLandmarks: raw33,
        isDownsampledMode: true,
      );

      expect(normalized.length, equals(33));

      // Core joints (e.g. Nose 0, Left Shoulder 11, Left Hip 23) retain coordinates
      expect(normalized[0].x, equals(10.0));
      expect(normalized[11].x, equals(120.0));
      expect(normalized[23].x, equals(240.0));

      // Non-core joint (e.g. Index finger 19, Pinky 17, Face mesh 5) must be zeroed out
      expect(normalized[19].isEmpty, isTrue);
      expect(normalized[17].isEmpty, isTrue);
      expect(normalized[5].isEmpty, isTrue);
    });

    test('PoseLandmarkAdapter calibrates tilt angle and torso scale accurately', () {
      final adapter = PoseLandmarkAdapter();

      final pose = List.generate(
        33,
        (i) => PoseKeypoint.empty(i),
      );

      // Set shoulder & hip landmarks
      pose[11] = PoseKeypoint(index: 11, x: 100, y: 100, z: 0, score: 0.9); // Left Shoulder
      pose[12] = PoseKeypoint(index: 12, x: 200, y: 100, z: 0, score: 0.9); // Right Shoulder
      pose[23] = PoseKeypoint(index: 23, x: 100, y: 300, z: 0, score: 0.9); // Left Hip
      pose[24] = PoseKeypoint(index: 24, x: 200, y: 300, z: 0, score: 0.9); // Right Hip

      adapter.calibrateCamera(pose);
      expect(adapter.isCalibrated, isTrue);
    });

    test('ThermalFrameProcessor transitions state based on thermal headroom thresholds per §P6-F matrix', () {
      final processor = ThermalFrameProcessor();

      // Normal state (< 0.75)
      processor.updateHeadroomDirectly(0.50);
      expect(processor.state, equals(ThermalWorkloadState.normal));
      expect(processor.shouldProcessNextFrame(), isTrue);

      // Moderate state (0.75 <= H < 0.85) -> Skip 1:2
      processor.updateHeadroomDirectly(0.80);
      expect(processor.state, equals(ThermalWorkloadState.moderate));

      // Severe state (0.85 <= H < 0.95) -> Skip 1:3
      processor.updateHeadroomDirectly(0.90);
      expect(processor.state, equals(ThermalWorkloadState.severe));

      // Critical state (H >= 0.95) -> Skip 1:6
      processor.updateHeadroomDirectly(0.98);
      expect(processor.state, equals(ThermalWorkloadState.critical));

      processor.dispose();
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('ThermalSafeguardBanner renders optimization banner when thermal state is non-normal', (tester) async {
      final processor = ThermalFrameProcessor();
      final container = ProviderContainer(
        overrides: [
          thermalProcessorProvider.overrideWith((ref) => processor),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: ThermalSafeguardBanner()),
          ),
        ),
      );

      // Normal mode -> Invisible banner
      expect(find.byType(ThermalSafeguardBanner), findsOneWidget);
      expect(find.textContaining('Optimization Active'), findsNothing);

      // Moderate mode -> Warning banner
      processor.updateHeadroomDirectly(0.80);
      await tester.pumpAndSettle();
      expect(find.textContaining('Optimization Active'), findsOneWidget);

      // Severe mode -> Safeguard banner
      processor.updateHeadroomDirectly(0.90);
      await tester.pumpAndSettle();
      expect(find.textContaining('Thermal Safeguard Active'), findsOneWidget);

      container.dispose();
    });
  });
}
