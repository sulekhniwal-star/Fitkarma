enum HungerType {
  biological(name: 'Biological Hunger', regionalName: 'शारीरिक भूख (ऊर्जा आवश्यकता)', isTrueHunger: true),
  hedonicCraving(name: 'Hedonic / Emotional Craving', regionalName: 'भावनात्मक तृष्णा / डोपामाइन लालसा', isTrueHunger: false),
  sleepDeprivedGhrelin(name: 'Sleep-Debt Ghrelin Surge', regionalName: 'नींद की कमी से प्रेरित भूख', isTrueHunger: false);

  final String name;
  final String regionalName;
  final bool isTrueHunger;

  const HungerType({
    required this.name,
    required this.regionalName,
    required this.isTrueHunger,
  });
}

class SatietyVolumeHack {
  final String title;
  final String regionalTitle;
  final String portion;
  final int calories;
  final String satietyMechanism;

  const SatietyVolumeHack({
    required this.title,
    required this.regionalTitle,
    required this.portion,
    required this.calories,
    required this.satietyMechanism,
  });
}

class HungerDiagnosticReport {
  final HungerType detectedType;
  final String rootCauseAnalysis;
  final List<SatietyVolumeHack> recommendedVolumeHacks;
  final String instantActionStep;

  const HungerDiagnosticReport({
    required this.detectedType,
    required this.rootCauseAnalysis,
    required this.recommendedVolumeHacks,
    required this.instantActionStep,
  });
}

class HungerCravingsEngine {
  static const List<SatietyVolumeHack> indianVolumeHacks = [
    SatietyVolumeHack(
      title: 'Cucumber & Kakdi Chaat',
      regionalTitle: 'खीरा एवं ककड़ी चाट (काला नमक)',
      portion: '2 large whole cucumbers (300g)',
      calories: 45,
      satietyMechanism: '96% water volume distends gastric mechanoreceptors without caloric load.',
    ),
    SatietyVolumeHack(
      title: 'Roasted Spiced Makhana (Foxnuts)',
      regionalTitle: 'भुने हुए नमकीन मखाने',
      portion: '1 large bowl (30g)',
      calories: 105,
      satietyMechanism: 'Crunchy auditory sensory feedback satisfies chewing compulsion; provides 3g fiber.',
    ),
    SatietyVolumeHack(
      title: 'Warm Water + Sabja (Basil Seeds)',
      regionalTitle: 'गुनगुना पानी एवं भीगे सब्जा के बीज',
      portion: '1 tall glass with 1 tsp soaked seeds',
      calories: 20,
      satietyMechanism: 'Soluble mucilage expands into a viscous gel in the stomach, slowing gastric emptying.',
    ),
    SatietyVolumeHack(
      title: 'Ginger Kahwa / Masala Green Tea',
      regionalTitle: 'अदरक कहवा / मसाला ग्रीन टी',
      portion: '1 warm mug (250ml)',
      calories: 0,
      satietyMechanism: 'Therapeutic warm liquid stimulates thermogenesis and oral satiety.',
    ),
  ];

  /// Pure Dart deterministic diagnosis of biological vs emotional cravings
  static HungerDiagnosticReport diagnoseHunger({
    required bool isSuddenOnset,
    required bool isSpecificFoodCraved,
    required double sleepHoursLastNight,
    required bool willingToEatSimpleDalKhichdi,
  }) {
    if (sleepHoursLastNight < 6.0 && !willingToEatSimpleDalKhichdi) {
      return const HungerDiagnosticReport(
        detectedType: HungerType.sleepDeprivedGhrelin,
        rootCauseAnalysis: 'Sleep deprivation (<6 hrs) elevates circulating ghrelin by +28% and suppresses leptin. Your brain is seeking fast glucose to compensate for central nervous fatigue.',
        recommendedVolumeHacks: indianVolumeHacks,
        instantActionStep: 'Drink 400ml chilled water and take a 15-minute power nap or light stroll. Do not keep open snacks in sight.',
      );
    } else if (isSuddenOnset || (isSpecificFoodCraved && !willingToEatSimpleDalKhichdi)) {
      return const HungerDiagnosticReport(
        detectedType: HungerType.hedonicCraving,
        rootCauseAnalysis: 'Sudden, hyper-specific cravings for sweets, fried food, or bakery items are driven by dopamine loops and emotional stress (cortisol), not genuine biological energy depletion.',
        recommendedVolumeHacks: indianVolumeHacks,
        instantActionStep: 'Activate the 15-minute craving delay protocol: Drink 400ml water and engage in an alternate task.',
      );
    } else {
      return const HungerDiagnosticReport(
        detectedType: HungerType.biological,
        rootCauseAnalysis: 'Gradual onset and willingness to eat plain nutritious whole foods indicates true physiological glycogen and amino acid demand.',
        recommendedVolumeHacks: indianVolumeHacks,
        instantActionStep: 'Consume a balanced high-protein meal: 30g protein (Paneer / Eggs / Daal) paired with complex carbs and fiber.',
      );
    }
  }
}
