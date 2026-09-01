enum FestivalType {
  diwaliHoli(
    name: 'Diwali / Holi (Feast & Mithai)',
    regionalName: 'दीपावली / होली (त्यौहार एवं मिष्ठान)',
    isFasting: false,
    calorieAllowanceDelta: 400,
    proteinFocusGrams: 35,
  ),
  navratri(
    name: 'Navratri / Vrat (Sattvic Fasting)',
    regionalName: 'नवरात्रि / सात्विक व्रत',
    isFasting: true,
    calorieAllowanceDelta: -150,
    proteinFocusGrams: 28,
  ),
  ramadan(
    name: 'Ramadan (Suhoor & Iftar Protocol)',
    regionalName: 'रमज़ान (सहरी एवं इफ़्तार)',
    isFasting: true,
    calorieAllowanceDelta: 0,
    proteinFocusGrams: 35,
  ),
  eidPuja(
    name: 'Eid / Durga Puja / Ganesh Utsav',
    regionalName: 'ईद / दुर्गा पूजा / गणेश उत्सव',
    isFasting: false,
    calorieAllowanceDelta: 350,
    proteinFocusGrams: 30,
  );

  final String name;
  final String regionalName;
  final bool isFasting;
  final int calorieAllowanceDelta;
  final int proteinFocusGrams;

  const FestivalType({
    required this.name,
    required this.regionalName,
    required this.isFasting,
    required this.calorieAllowanceDelta,
    required this.proteinFocusGrams,
  });
}

class FestivalStrategyReport {
  final FestivalType festival;
  final int adjustedTargetCalories;
  final int adjustedTargetProtein;
  final List<String> damageControlSteps;
  final List<String> sweetSmartSwaps;
  final String culturalCoachingNote;

  const FestivalStrategyReport({
    required this.festival,
    required this.adjustedTargetCalories,
    required this.adjustedTargetProtein,
    required this.damageControlSteps,
    required this.sweetSmartSwaps,
    required this.culturalCoachingNote,
  });
}

class FestivalAdaptationEngine {
  /// Pure Dart deterministic calculation of festival nutrition calibrations & feast/fasting protocols
  static FestivalStrategyReport generateStrategy({
    required FestivalType festival,
    required int baseCalories,
    required int baseProtein,
  }) {
    final adjCalories = baseCalories + festival.calorieAllowanceDelta;
    final adjProtein = baseProtein;

    final List<String> steps = [];
    final List<String> swaps = [];
    final String note;

    switch (festival) {
      case FestivalType.diwaliHoli:
        steps.addAll([
          'Pre-Feast Protein Anchor: Consume 35-40g protein (Whey/Eggs/Paneer) before attending evening family dinners to blunt cravings.',
          'Shatpawali Walk: Complete a 15-minute brisk walk (1,000 to 1,500 steps) within 30 minutes after the feast to accelerate glucose uptake.',
          'Salad First Rule: Start with raw cucumber, kakdi, and lemon to slow down gastric emptying.',
        ]);
        swaps.addAll([
          'Sandesh / Rasgulla (85-120 kcal) instead of Gulab Jamun (280 kcal) — saves 160 kcal and eliminates deep-fried fats.',
          'Dry Fruit / Kaju Katli (55 kcal/pc) instead of Jalebi / Imarti (220 kcal/pc) — lower glycemic spike.',
          'Roasted Makhana / Salted Almonds instead of Fried Namkeen / Mathri.',
        ]);
        note = 'Enjoy your festival guilt-free! Traditional celebrations are meant to be cherished. Savor your favorites mindfully without stress.';
        break;

      case FestivalType.navratri:
        steps.addAll([
          'Watch Sabudana Overload: Sabudana is 90% refined carbs. Replace half your sabudana with roasted makhana, boiled potatoes with curd, or paneer.',
          'Protein Anchors: Rely on Fresh Set Dahi (Curd), Grilled Paneer with sendha namak, and Kuttu (buckwheat) chilla for complete nutrition.',
          'Hydration & Sendha Namak: Drink coconut water and chaas with rock salt to maintain sodium-potassium balance during fasting.',
        ]);
        swaps.addAll([
          'Kuttu / Singhara Chilla instead of Deep-Fried Kuttu Puri.',
          'Roasted Makhana Chaat instead of Fried Sabudana Vada.',
        ]);
        note = 'Navratri fasting cleanses metabolic pathways when balanced with nutrient-dense Sattvic foods rather than deep-fried snacks.';
        break;

      case FestivalType.ramadan:
        steps.addAll([
          'Suhoor Sustained Release: Combine slow-digesting complex carbs (Oats/Eggs/Curd) with healthy fats (nuts/chia seeds) to sustain energy until sunset.',
          'Iftar Gradual Re-feed: Break fast with 1 date + water. Eat grilled chicken/fish or paneer tikka first before heavy biryani or rice.',
          'Night Hydration Window: Sip 2.5 to 3.0 Liters of water between Iftar and Suhoor.',
        ]);
        swaps.addAll([
          'Grilled Tandoori Kebabs instead of Deep-Fried Pakoras.',
          'Fruit Chaat with Mint instead of Sugar-Loaded Rooh Afza / Sherbet.',
        ]);
        note = 'Ramadan fasting is a powerful form of intermittent fasting that enhances autophagy and insulin sensitivity when paired with clean Iftar choices.';
        break;

      case FestivalType.eidPuja:
        steps.addAll([
          'Bank Calories: Cut 150 kcal per day for 2 days prior to create a 300 kcal buffer for the community feast.',
          'Hydrate Before Eating: Drink 2 glasses of water 15 minutes before the main meal.',
          'Portion Awareness: Eat lean meats / daal first, followed by rich biryani or sweets.',
        ]);
        swaps.addAll([
          'Sheer Khurma with Stevia / Sugar-Lite instead of Double-Sugar Sewaiyan.',
          'Tandoori Roti instead of Fried Bhature / Sheermal.',
        ]);
        note = 'Celebrate with family and community! A single joyous feast has zero negative impact on your long-term body composition.';
        break;
    }

    return FestivalStrategyReport(
      festival: festival,
      adjustedTargetCalories: adjCalories,
      adjustedTargetProtein: adjProtein,
      damageControlSteps: steps,
      sweetSmartSwaps: swaps,
      culturalCoachingNote: note,
    );
  }
}
