import '../models/transformation_models.dart';

class TransformationJourneyEngine {
  const TransformationJourneyEngine();

  /// Evaluates multi-week transformation progression from body measurement logs
  TransformationProgressSummary evaluateProgress({
    required List<BodyTransformationPoint> logs,
    required int consistentWeeks,
    required List<TransformationMilestone> currentMilestones,
  }) {
    if (logs.isEmpty) {
      return const TransformationProgressSummary(
        initialWeightKg: 0,
        currentWeightKg: 0,
        totalWeightLossKg: 0,
        initialWaistCm: 0,
        currentWaistCm: 0,
        waistLossCm: 0,
        initialWaistToHipRatio: 0,
        currentWaistToHipRatio: 0,
        weeklyLossRateKg: 0,
        identityStage: HabitIdentityStage.noviceExplorer,
        stageTitle: 'Novice Explorer',
        stageTitleHindi: 'आरंभिक खोजी',
        unlockedMilestones: [],
      );
    }

    // Sort logs ascending by date
    final sorted = List<BodyTransformationPoint>.from(logs)..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final initial = sorted.first;
    final latest = sorted.last;

    final weightLoss = double.parse((initial.weightKg - latest.weightKg).toStringAsFixed(1));
    final waistLoss = double.parse((initial.waistCm - latest.waistCm).toStringAsFixed(1));

    final totalDays = latest.loggedAt.difference(initial.loggedAt).inDays;
    final totalWeeks = totalDays > 0 ? (totalDays / 7.0) : 1.0;
    final weeklyLossRate = totalWeeks > 0 ? double.parse((weightLoss / totalWeeks).toStringAsFixed(2)) : 0.0;

    // Evaluate Habit Identity Stage
    HabitIdentityStage stage;
    String stageTitle;
    String stageTitleHindi;

    if (consistentWeeks >= 12 && weightLoss >= 5.0) {
      stage = HabitIdentityStage.transformedMaster;
      stageTitle = 'Transformed Master (रूपांतरित योगी)';
      stageTitleHindi = 'स्वास्थ्य को अपनी पहचान बना चुके मास्टर';
    } else if (consistentWeeks >= 6) {
      stage = HabitIdentityStage.healthAthlete;
      stageTitle = 'Health Athlete (अनुशासित एथलीट)';
      stageTitleHindi = 'दैनिक अनुशासन व शक्ति संपन्न';
    } else if (consistentWeeks >= 2) {
      stage = HabitIdentityStage.disciplinedPractitioner;
      stageTitle = 'Disciplined Practitioner (अभ्यासी)';
      stageTitleHindi = 'नियमित आदतों का निर्माण';
    } else {
      stage = HabitIdentityStage.noviceExplorer;
      stageTitle = 'Novice Explorer (आरंभिक खोजी)';
      stageTitleHindi = 'स्वास्थ्य यात्रा का प्रारंभिक चरण';
    }

    return TransformationProgressSummary(
      initialWeightKg: initial.weightKg,
      currentWeightKg: latest.weightKg,
      totalWeightLossKg: weightLoss,
      initialWaistCm: initial.waistCm,
      currentWaistCm: latest.waistCm,
      waistLossCm: waistLoss,
      initialWaistToHipRatio: initial.waistToHipRatio,
      currentWaistToHipRatio: latest.waistToHipRatio,
      weeklyLossRateKg: weeklyLossRate,
      identityStage: stage,
      stageTitle: stageTitle,
      stageTitleHindi: stageTitleHindi,
      unlockedMilestones: currentMilestones,
    );
  }
}
