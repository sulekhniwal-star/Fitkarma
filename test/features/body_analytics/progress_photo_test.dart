import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/body_analytics/domain/progress_photo_engine.dart';
import 'package:fitkarma/features/body_analytics/domain/progress_photo_models.dart';

void main() {
  group('ProgressPhotoEngine Deterministic Offline Tests', () {
    const engine = ProgressPhotoEngine();

    test('Generates timeline report with correct multi-milestone deltas', () {
      final now = DateTime(2026, 9, 9, 10, 0);

      final photo1 = ProgressPhotoEntry(
        photoId: 'p1',
        capturedAt: now.subtract(const Duration(days: 60)),
        poseAngle: PhotoPoseAngle.front,
        localFilePath: 'vault://p1.enc',
        weightKgAtCapture: 82.0,
        bodyFatPercentAtCapture: 22.0,
        waistCmAtCapture: 90.0,
        milestoneTag: MilestonePhaseTag.baseline,
      );

      final photo2 = ProgressPhotoEntry(
        photoId: 'p2',
        capturedAt: now.subtract(const Duration(days: 30)),
        poseAngle: PhotoPoseAngle.front,
        localFilePath: 'vault://p2.enc',
        weightKgAtCapture: 78.5,
        bodyFatPercentAtCapture: 19.5,
        waistCmAtCapture: 86.0,
        milestoneTag: MilestonePhaseTag.cuttingPhase,
      );

      final photo3 = ProgressPhotoEntry(
        photoId: 'p3',
        capturedAt: now,
        poseAngle: PhotoPoseAngle.front,
        localFilePath: 'vault://p3.enc',
        weightKgAtCapture: 75.0,
        bodyFatPercentAtCapture: 16.0,
        waistCmAtCapture: 82.0,
        milestoneTag: MilestonePhaseTag.recomposition,
      );

      final report = engine.generateTimelineReport(
        entries: [photo1, photo2, photo3],
        executionTime: now,
      );

      expect(report.totalPhotosCaptured, equals(3));
      expect(report.totalDaysTracked, equals(60));
      expect(
          report.totalWeightLossKg, equals(7.0)); // 82.0 - 75.0 = 7.0 kg loss
      expect(report.totalBodyFatLossPercent,
          equals(6.0)); // 22.0 - 16.0 = 6.0% BF drop
      expect(report.isVaultEncrypted, isTrue);
      expect(report.activeComparison, isNotNull);
      expect(report.activeComparison!.weightDeltaKg, equals(-7.0));
      expect(report.activeComparison!.bodyFatDeltaPercent, equals(-6.0));
      expect(report.activeComparison!.waistDeltaCm, equals(-8.0));
      expect(report.activeComparison!.transformationSummary,
          contains('7.0 kg reduction'));
      expect(report.activeComparison!.regionalTransformationSummary,
          contains('किग्रा भार'));
    });

    test(
        'Creates accurate comparative photo pair between two specific milestones',
        () {
      final now = DateTime(2026, 9, 9);
      final before = ProgressPhotoEntry(
        photoId: 'b1',
        capturedAt: now.subtract(const Duration(days: 45)),
        poseAngle: PhotoPoseAngle.side,
        localFilePath: 'vault://b1.enc',
        weightKgAtCapture: 70.0,
        bodyFatPercentAtCapture: 15.0,
        waistCmAtCapture: 78.0,
        milestoneTag: MilestonePhaseTag.baseline,
      );

      final after = ProgressPhotoEntry(
        photoId: 'a1',
        capturedAt: now,
        poseAngle: PhotoPoseAngle.side,
        localFilePath: 'vault://a1.enc',
        weightKgAtCapture: 72.5, // Muscle gain
        bodyFatPercentAtCapture: 13.5, // Fat drop
        waistCmAtCapture: 77.0,
        milestoneTag: MilestonePhaseTag.muscleBuilding,
      );

      final comp = engine.createComparativePair(before, after);

      expect(comp.daysElapsed, equals(45));
      expect(comp.weightDeltaKg, equals(2.5));
      expect(comp.bodyFatDeltaPercent, equals(-1.5));
      expect(comp.waistDeltaCm, equals(-1.0));
      expect(comp.transformationSummary, contains('recomposition'));
    });

    test('Handles empty photo collection gracefully', () {
      final report = engine.generateTimelineReport(entries: const []);
      expect(report.totalPhotosCaptured, equals(0));
      expect(report.totalDaysTracked, equals(0));
      expect(report.activeComparison, isNull);
    });
  });
}
