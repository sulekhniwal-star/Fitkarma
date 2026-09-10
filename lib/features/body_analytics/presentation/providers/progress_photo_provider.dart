import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/progress_photo_engine.dart';
import '../../domain/progress_photo_models.dart';

final progressPhotoProvider =
    StateNotifierProvider<ProgressPhotoNotifier, ProgressPhotoTimelineReport>(
        (ref) {
  return ProgressPhotoNotifier();
});

class ProgressPhotoNotifier extends StateNotifier<ProgressPhotoTimelineReport> {
  ProgressPhotoNotifier() : super(_buildInitialReport());

  static final ProgressPhotoEngine _engine = const ProgressPhotoEngine();

  static ProgressPhotoTimelineReport _buildInitialReport() {
    final now = DateTime.now();

    final day1 = ProgressPhotoEntry(
      photoId: 'photo_01_day1',
      capturedAt: now.subtract(const Duration(days: 90)),
      poseAngle: PhotoPoseAngle.front,
      localFilePath: 'vault://photos/day1_front.enc',
      weightKgAtCapture: 81.2,
      bodyFatPercentAtCapture: 21.4,
      waistCmAtCapture: 88.0,
      milestoneTag: MilestonePhaseTag.baseline,
      userNotes: 'Day 1 starting transformation baseline.',
    );

    final day30 = ProgressPhotoEntry(
      photoId: 'photo_02_day30',
      capturedAt: now.subtract(const Duration(days: 60)),
      poseAngle: PhotoPoseAngle.front,
      localFilePath: 'vault://photos/day30_front.enc',
      weightKgAtCapture: 78.6,
      bodyFatPercentAtCapture: 19.0,
      waistCmAtCapture: 85.0,
      milestoneTag: MilestonePhaseTag.cuttingPhase,
      userNotes: 'Month 1 checkpoint after initial shred block.',
    );

    final day60 = ProgressPhotoEntry(
      photoId: 'photo_03_day60',
      capturedAt: now.subtract(const Duration(days: 30)),
      poseAngle: PhotoPoseAngle.front,
      localFilePath: 'vault://photos/day60_front.enc',
      weightKgAtCapture: 76.2,
      bodyFatPercentAtCapture: 16.8,
      waistCmAtCapture: 82.5,
      milestoneTag: MilestonePhaseTag.recomposition,
      userNotes: 'Noticeable abdominal and shoulder definition.',
    );

    final day90 = ProgressPhotoEntry(
      photoId: 'photo_04_day90',
      capturedAt: now,
      poseAngle: PhotoPoseAngle.front,
      localFilePath: 'vault://photos/day90_front.enc',
      weightKgAtCapture: 74.5,
      bodyFatPercentAtCapture: 14.8,
      waistCmAtCapture: 80.5,
      milestoneTag: MilestonePhaseTag.muscleBuilding,
      userNotes: '90-day peak conditioning milestone.',
    );

    return _engine.generateTimelineReport(
      entries: [day1, day30, day60, day90],
      selectedBefore: day1,
      selectedAfter: day90,
      executionTime: now,
    );
  }

  void selectComparison(ProgressPhotoEntry before, ProgressPhotoEntry after) {
    state = _engine.generateTimelineReport(
      entries: state.entries,
      selectedBefore: before,
      selectedAfter: after,
      executionTime: DateTime.now(),
    );
  }

  void addPhotoEntry({
    required PhotoPoseAngle poseAngle,
    required double weightKg,
    required double bodyFatPercent,
    double? waistCm,
    required MilestonePhaseTag milestoneTag,
    String? userNotes,
  }) {
    final newEntry = ProgressPhotoEntry(
      photoId: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      capturedAt: DateTime.now(),
      poseAngle: poseAngle,
      localFilePath:
          'vault://photos/new_${DateTime.now().millisecondsSinceEpoch}.enc',
      weightKgAtCapture: weightKg,
      bodyFatPercentAtCapture: bodyFatPercent,
      waistCmAtCapture: waistCm,
      milestoneTag: milestoneTag,
      userNotes: userNotes,
    );

    final updatedEntries = [...state.entries, newEntry];
    state = _engine.generateTimelineReport(
      entries: updatedEntries,
      selectedBefore:
          state.activeComparison?.beforePhoto ?? updatedEntries.first,
      selectedAfter: newEntry,
      executionTime: DateTime.now(),
    );
  }
}
