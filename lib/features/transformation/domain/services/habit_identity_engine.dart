import '../models/transformation_models.dart';

class HabitIdentityEngine {
  const HabitIdentityEngine();

  /// Check which new milestones should be unlocked based on progress
  List<TransformationMilestone> evaluateNewMilestones({
    required String userId,
    required double initialWeightKg,
    required double currentWeightKg,
    required double currentWaistCm,
    required int streakDays,
    required List<TransformationMilestone> alreadyUnlocked,
  }) {
    final List<TransformationMilestone> newMilestones = [];
    final now = DateTime.now();

    final hasMilestone = (MilestoneType type) => alreadyUnlocked.any((m) => m.type == type);

    // 1. Baseline Set
    if (!hasMilestone(MilestoneType.baselineSet)) {
      newMilestones.add(TransformationMilestone(
        id: 'milestone_baseline_$userId',
        userId: userId,
        type: MilestoneType.baselineSet,
        title: 'Transformation Baseline Established',
        titleHindi: 'आरंभिक आधारभूत माप दर्ज',
        description: 'First body composition and measurement snapshot captured.',
        achievedAt: now,
      ));
    }

    final weightLoss = initialWeightKg - currentWeightKg;

    // 2. First 1kg Lost
    if (weightLoss >= 1.0 && !hasMilestone(MilestoneType.firstKgLost)) {
      newMilestones.add(TransformationMilestone(
        id: 'milestone_first_kg_$userId',
        userId: userId,
        type: MilestoneType.firstKgLost,
        title: 'First Kilogram Conquered',
        titleHindi: 'प्रथम किलोग्राम कम हुआ',
        description: 'Metabolic inertia broken! Fat oxidation pathways active.',
        achievedAt: now,
      ));
    }

    // 3. First 5kg Lost
    if (weightLoss >= 5.0 && !hasMilestone(MilestoneType.first5kgLost)) {
      newMilestones.add(TransformationMilestone(
        id: 'milestone_5kg_$userId',
        userId: userId,
        type: MilestoneType.first5kgLost,
        title: '5 Kilogram Transformation Milestone',
        titleHindi: '५ किलोग्राम वजन में कमी का मील का पत्थर',
        description: 'Substantial reduction in visceral adiposity and systemic inflammation.',
        achievedAt: now,
      ));
    }

    // 4. Four Week Consistency
    if (streakDays >= 28 && !hasMilestone(MilestoneType.fourWeekConsistency)) {
      newMilestones.add(TransformationMilestone(
        id: 'milestone_4weeks_$userId',
        userId: userId,
        type: MilestoneType.fourWeekConsistency,
        title: '4-Week Discipline Anchor',
        titleHindi: '४ सप्ताह का अटूट अनुशासन',
        description: 'Habits successfully converted into automatic subconscious routines.',
        achievedAt: now,
      ));
    }

    return newMilestones;
  }
}
