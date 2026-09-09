import 'package:flutter/foundation.dart';

/// Photo angle / pose orientation
enum PhotoPoseAngle {
  front(name: 'Front View', regionalName: 'सम्मुख दृश्य'),
  side(name: 'Side Profile', regionalName: 'पार्श्व दृश्य'),
  back(name: 'Back View', regionalName: 'पृष्ठ दृश्य');

  final String name;
  final String regionalName;

  const PhotoPoseAngle({
    required this.name,
    required this.regionalName,
  });
}

/// Transformation Milestone Phase Tag
enum MilestonePhaseTag {
  baseline(name: 'Baseline Day 1', regionalName: 'प्रारंभिक दिवस'),
  cuttingPhase(name: 'Fat Loss & Shred', regionalName: 'मेद क्षय व कसावट'),
  muscleBuilding(name: 'Lean Muscle Gain', regionalName: 'मांसपेशी संवर्धन'),
  recomposition(name: 'Body Recomposition', regionalName: 'शारीरिक पुनर्गठन'),
  maintenance(name: 'Peak Maintenance', regionalName: 'संतुलन व स्थिरीकरण');

  final String name;
  final String regionalName;

  const MilestonePhaseTag({
    required this.name,
    required this.regionalName,
  });
}

/// A progress photo capture entry
@immutable
class ProgressPhotoEntry {
  final String photoId;
  final DateTime capturedAt;
  final PhotoPoseAngle poseAngle;
  final String localFilePath;
  final double weightKgAtCapture;
  final double bodyFatPercentAtCapture;
  final double? waistCmAtCapture;
  final MilestonePhaseTag milestoneTag;
  final String? userNotes;
  final bool isEncryptedInVault;

  const ProgressPhotoEntry({
    required this.photoId,
    required this.capturedAt,
    required this.poseAngle,
    required this.localFilePath,
    required this.weightKgAtCapture,
    required this.bodyFatPercentAtCapture,
    this.waistCmAtCapture,
    required this.milestoneTag,
    this.userNotes,
    this.isEncryptedInVault = true,
  });
}

/// A comparative photo pair (e.g. Before vs After or Month 1 vs Month 3)
@immutable
class ComparativePhotoPair {
  final ProgressPhotoEntry beforePhoto;
  final ProgressPhotoEntry afterPhoto;
  final int daysElapsed;
  final double weightDeltaKg;
  final double bodyFatDeltaPercent;
  final double waistDeltaCm;
  final String transformationSummary;
  final String regionalTransformationSummary;

  const ComparativePhotoPair({
    required this.beforePhoto,
    required this.afterPhoto,
    required this.daysElapsed,
    required this.weightDeltaKg,
    required this.bodyFatDeltaPercent,
    required this.waistDeltaCm,
    required this.transformationSummary,
    required this.regionalTransformationSummary,
  });
}

/// Comprehensive Progress Photo Timeline & Vault Report
@immutable
class ProgressPhotoTimelineReport {
  final List<ProgressPhotoEntry> entries;
  final ComparativePhotoPair? activeComparison;
  final int totalPhotosCaptured;
  final int totalDaysTracked;
  final double totalWeightLossKg;
  final double totalBodyFatLossPercent;
  final bool isVaultEncrypted;
  final DateTime lastUpdated;

  const ProgressPhotoTimelineReport({
    required this.entries,
    this.activeComparison,
    required this.totalPhotosCaptured,
    required this.totalDaysTracked,
    required this.totalWeightLossKg,
    required this.totalBodyFatLossPercent,
    required this.isVaultEncrypted,
    required this.lastUpdated,
  });
}
