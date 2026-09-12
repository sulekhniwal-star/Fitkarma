enum BodyFatCategory {
  essential, // Men 2-5%, Women 10-13%
  athletic, // Men 6-13%, Women 14-20%
  fitness, // Men 14-17%, Women 21-24%
  acceptable, // Men 18-24%, Women 25-31%
  elevated, // Men 25%+, Women 32%+
}

enum WhtrCategory {
  takeCare, // < 0.4 (Underweight/slender)
  healthy, // 0.4 - 0.49 (Ideal)
  increasedRisk, // 0.5 - 0.59 (Central adiposity)
  highRisk, // >= 0.6 (High cardiometabolic hazard)
}

enum PhotoPoseType {
  front,
  side,
  back,
}

class BodyCompositionEstimate {
  final String id;
  final String userId;
  final double bodyFatPercent;
  final BodyFatCategory category;
  final double leanMassKg;
  final double fatMassKg;
  final double totalWeightKg;
  final double waistToHeightRatio;
  final WhtrCategory whtrCategory;
  final double ffmi; // Fat-Free Mass Index
  final String insight;
  final String insightHindi;
  final DateTime calculatedAt;

  const BodyCompositionEstimate({
    required this.id,
    required this.userId,
    required this.bodyFatPercent,
    required this.category,
    required this.leanMassKg,
    required this.fatMassKg,
    required this.totalWeightKg,
    required this.waistToHeightRatio,
    required this.whtrCategory,
    required this.ffmi,
    required this.insight,
    required this.insightHindi,
    required this.calculatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'body_fat_percent': bodyFatPercent,
        'category': category.name,
        'lean_mass_kg': leanMassKg,
        'fat_mass_kg': fatMassKg,
        'total_weight_kg': totalWeightKg,
        'waist_to_height_ratio': waistToHeightRatio,
        'whtr_category': whtrCategory.name,
        'ffmi': ffmi,
        'insight': insight,
        'insight_hindi': insightHindi,
        'calculated_at': calculatedAt.toIso8601String(),
      };
}

class ProgressPhotoEntry {
  final String id;
  final String userId;
  final PhotoPoseType poseType;
  final String localFilePath;
  final double poseConfidence; // 0.0 to 1.0
  final DateTime recordedAt;

  const ProgressPhotoEntry({
    required this.id,
    required this.userId,
    required this.poseType,
    required this.localFilePath,
    required this.poseConfidence,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'pose_type': poseType.name,
        'local_file_path': localFilePath,
        'pose_confidence': poseConfidence,
        'recorded_at': recordedAt.toIso8601String(),
      };
}

class VisualComparisonResult {
  final ProgressPhotoEntry baselinePhoto;
  final ProgressPhotoEntry latestPhoto;
  final int daysApart;
  final double? weightDeltaKg;
  final double? bodyFatDeltaPct;
  final double? waistDeltaCm;

  const VisualComparisonResult({
    required this.baselinePhoto,
    required this.latestPhoto,
    required this.daysApart,
    this.weightDeltaKg,
    this.bodyFatDeltaPct,
    this.waistDeltaCm,
  });
}
