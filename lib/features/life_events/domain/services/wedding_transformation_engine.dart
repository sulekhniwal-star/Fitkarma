import '../models/life_event_models.dart';

class WeddingTransformationEngine {
  const WeddingTransformationEngine();

  /// Builds a periodized wedding transformation plan
  WeddingTransformationPlan createWeddingPlan({
    required String id,
    required String userId,
    required DateTime weddingDate,
    required double currentWeightKg,
    required double targetWeightKg,
    required double currentWaistCm,
    required double targetWaistCm,
  }) {
    final now = DateTime.now();
    final daysRemaining = weddingDate.difference(now).inDays.clamp(0, 365);
    final weeksRemaining = (daysRemaining / 7.0).ceil();

    String phaseName;
    String phaseNameHi;
    List<String> milestones = [];

    if (weeksRemaining > 8) {
      phaseName = 'Phase 1: Metabolic Foundation & Muscle Shaping';
      phaseNameHi = 'चरण १: मेटाबोलिक सुधार व बॉडी टोनिंग';
      milestones = [
        'Establish 300 kcal moderate daily calorie deficit.',
        '4x weekly progressive strength training focusing on shoulders and upper back.',
        'Hit 10,000 daily steps for steady baseline fat oxidation.',
      ];
    } else if (weeksRemaining >= 4) {
      phaseName = 'Phase 2: Lean Definition & Sherwani/Lehenga Fit';
      phaseNameHi = 'चरण २: लीन कटिंग व फिटिंग सुधार';
      milestones = [
        'Taper carbohydrate intake slightly while keeping protein at 1.8g/kg.',
        'Core & postural exercises (Planks, Face Pulls) to perfect wedding stage posture.',
        'Schedule primary wedding garment trial measurements.',
      ];
    } else if (weeksRemaining > 1) {
      phaseName = 'Phase 3: Anti-Bloat & Garment Lock-in';
      phaseNameHi = 'चरण ३: ब्लोटिंग नियंत्रण व फाइनल फिट';
      milestones = [
        'Eliminate processed sugars and carbonated drinks to prevent water retention.',
        'Increase potassium intake with tender coconut water and spinach.',
        'Final garment trial verification.',
      ];
    } else {
      phaseName = 'Phase 4: Peak Week & Radiance Glow';
      phaseNameHi = 'चरण ४: पीक वीक व शादी का ग्लो';
      milestones = [
        'Moderate sodium intake, drink 3.5L plain water daily until 2 days before.',
        'Light bodyweight and yoga sessions only; no intense DOMS-inducing workouts.',
        'Prioritize 8 hours of sleep for radiant skin and calm nervous system.',
      ];
    }

    return WeddingTransformationPlan(
      id: id,
      userId: userId,
      weddingDate: weddingDate,
      daysRemaining: daysRemaining,
      baselineWeightKg: currentWeightKg,
      targetWeightKg: targetWeightKg,
      baselineWaistCm: currentWaistCm,
      targetWaistCm: targetWaistCm,
      currentPhaseName: phaseName,
      currentPhaseNameHindi: phaseNameHi,
      weeklyMilestones: milestones,
    );
  }
}
