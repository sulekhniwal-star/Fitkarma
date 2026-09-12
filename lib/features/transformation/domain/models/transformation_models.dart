enum HabitIdentityStage {
  noviceExplorer, // Day 1 - 7: Exploring routine
  disciplinedPractitioner, // Week 2 - 4: Building habit loops
  healthAthlete, // Month 2 - 3: Consistent internal motivation
  transformedMaster, // Month 3+: Fitness is core identity
}

enum MilestoneType {
  baselineSet,
  firstKgLost,
  first5kgLost,
  fourWeekConsistency,
  waistCircumferenceReduced,
  strengthDoubled,
  metabolicAgeOptimized,
}

class TransformationMilestone {
  final String id;
  final String userId;
  final MilestoneType type;
  final String title;
  final String titleHindi;
  final String description;
  final DateTime achievedAt;
  final String? photoUrl;

  const TransformationMilestone({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.achievedAt,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'type': type.name,
        'title': title,
        'title_hindi': titleHindi,
        'description': description,
        'achieved_at': achievedAt.toIso8601String(),
        'photo_url': photoUrl,
      };
}

class BodyTransformationPoint {
  final String id;
  final String userId;
  final double weightKg;
  final double waistCm;
  final double hipCm;
  final double bodyFatPct;
  final String? photoUrl;
  final DateTime loggedAt;

  const BodyTransformationPoint({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.waistCm,
    required this.hipCm,
    required this.bodyFatPct,
    this.photoUrl,
    required this.loggedAt,
  });

  double get waistToHipRatio => double.parse((waistCm / hipCm).toStringAsFixed(2));

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'weight_kg': weightKg,
        'waist_cm': waistCm,
        'hip_cm': hipCm,
        'body_fat_pct': bodyFatPct,
        'photo_url': photoUrl,
        'logged_at': loggedAt.toIso8601String(),
      };
}

class TransformationProgressSummary {
  final double initialWeightKg;
  final double currentWeightKg;
  final double totalWeightLossKg;
  final double initialWaistCm;
  final double currentWaistCm;
  final double waistLossCm;
  final double initialWaistToHipRatio;
  final double currentWaistToHipRatio;
  final double weeklyLossRateKg;
  final HabitIdentityStage identityStage;
  final String stageTitle;
  final String stageTitleHindi;
  final List<TransformationMilestone> unlockedMilestones;

  const TransformationProgressSummary({
    required this.initialWeightKg,
    required this.currentWeightKg,
    required this.totalWeightLossKg,
    required this.initialWaistCm,
    required this.currentWaistCm,
    required this.waistLossCm,
    required this.initialWaistToHipRatio,
    required this.currentWaistToHipRatio,
    required this.weeklyLossRateKg,
    required this.identityStage,
    required this.stageTitle,
    required this.stageTitleHindi,
    required this.unlockedMilestones,
  });
}
