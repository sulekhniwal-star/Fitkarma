import 'festival_intelligence_models.dart';

/// Pure Dart Deterministic Engine for Indian Festival Intelligence, Circadian Planning & Reset Protocols
class FestivalIntelligenceEngine {
  const FestivalIntelligenceEngine();

  /// Generates a comprehensive multi-pillar adaptation plan for any Indian festival
  FestivalIntelligencePlan generateFestivalPlan({
    required IndianFestival festival,
    bool isFestivalModeActive = true,
    int daysUntilFestival = 0,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();

    // 1. Determine Calorie Delta Target & Duration
    int calorieDelta;
    int durationDays;

    switch (festival) {
      case IndianFestival.diwali:
        calorieDelta = 450;
        durationDays = 5;
        break;
      case IndianFestival.holi:
        calorieDelta = 400;
        durationDays = 2;
        break;
      case IndianFestival.navratri:
        calorieDelta = -200;
        durationDays = 9;
        break;
      case IndianFestival.ramadanEid:
        calorieDelta = -100;
        durationDays = 30;
        break;
      case IndianFestival.durgaPuja:
        calorieDelta = 350;
        durationDays = 5;
        break;
      case IndianFestival.ganeshChaturthi:
        calorieDelta = 300;
        durationDays = 10;
        break;
      case IndianFestival.pongalSankranti:
        calorieDelta = 350;
        durationDays = 3;
        break;
      case IndianFestival.onam:
        calorieDelta = 400;
        durationDays = 4;
        break;
      case IndianFestival.karwaChauthEkadashi:
        calorieDelta = -500;
        durationDays = 1;
        break;
    }

    // 2. Generate Multi-Pillar Adaptation Strategies
    final pillarStrategies = _buildPillarStrategies(festival, calorieDelta);

    // 3. Generate 3-Day Post-Festival Reset Protocol
    final resetProtocol = _buildResetProtocol(festival);

    // 4. Mindful feasting tip & regional translation
    final (tip, regTip) = _generateFeastingTips(festival);

    return FestivalIntelligencePlan(
      activeFestival: festival,
      isFestivalModeActive: isFestivalModeActive,
      daysUntilFestival: daysUntilFestival,
      festivalDurationDays: durationDays,
      calorieDeltaTarget: calorieDelta,
      pillarStrategies: pillarStrategies,
      postFestivalResetProtocol: resetProtocol,
      mindfulFeastingTip: tip,
      regionalMindfulFeastingTip: regTip,
      aiCoachToneOverride:
          'Festive Harmony, Cultural Celebration & Non-Guilt Mindset',
      generatedAt: now,
    );
  }

  List<PillarAdaptationStrategy> _buildPillarStrategies(
      IndianFestival festival, int calorieDelta) {
    if (festival.isFastingCentric) {
      return [
        const PillarAdaptationStrategy(
          pillarName: 'Movement & Training',
          regionalPillarName: 'व्यायाम एवं शारीरिक गतिविधि',
          headlineAction: 'Low-Intensity Fasted Yoga & Evening Garba',
          detailedProtocol:
              'Shift high-load resistance training to post-prandial evening hours. Prioritize restorative pranayama and Garba/Dandiya step counting during Navratri.',
          regionalDetailedProtocol:
              'भारी व्यायाम के स्थान पर शाम को फलाहार उपरांत योग करें। गरबा/डांडिया के माध्यम से सक्रिय रहें।',
          keyMetricAdjustment:
              'Daily Step Goal: 10,000+ via festive dance / evening walk',
        ),
        PillarAdaptationStrategy(
          pillarName: 'Satvik Vrat Nutrition',
          regionalPillarName: 'सात्विक व्रत पोषण',
          headlineAction: 'Nutrient-Dense Phalahari Cleanse',
          detailedProtocol:
              'Incorporate Kuttu (Buckwheat), Samak rice, Makhana, roasted peanuts, and curd. Avoid excessive deep-fried potato chips; maintain optimal protein density.',
          regionalDetailedProtocol:
              'कुट्टू, समा के चावल, मखाना, मूंगफली व दही का सेवन करें। तले हुए चिप्स से बचें व प्रोटीन संतुलित रखें।',
          keyMetricAdjustment:
              'Calorie Target: ${calorieDelta > 0 ? "+$calorieDelta" : calorieDelta} kcal',
        ),
        const PillarAdaptationStrategy(
          pillarName: 'Electrolyte & Hydration',
          regionalPillarName: 'इलेक्ट्रोलाइट व जल संतुलन',
          headlineAction: 'Sendha Namak & Coconut Water Mineralization',
          detailedProtocol:
              'Supplement with Sendha Namak (Rock Salt), tender coconut water, and lemon water to prevent nocturnal muscle cramping and dehydration.',
          regionalDetailedProtocol:
              'सेंधा नमक, नारियल पानी व नींबू पानी का सेवन करें ताकि निर्जलीकरण व मांसपेशियों में खिंचाव न हो।',
          keyMetricAdjustment: 'Hydration Target: 3.2L water + electrolytes',
        ),
        const PillarAdaptationStrategy(
          pillarName: 'Circadian Sleep & Recharge',
          regionalPillarName: 'नींद एवं विश्राम संतुलन',
          headlineAction: '20-Minute Yoga Nidra Midday Recovery',
          detailedProtocol:
              'Compensate for late-night Aarti or Suhoor/Taraweeh with a disciplined 20-minute afternoon Yoga Nidra session to sustain cellular repair.',
          regionalDetailedProtocol:
              'देर रात की प्रार्थना के प्रभाव को संतुलित करने हेतु दोपहर में २० मिनट योग निद्रा करें।',
          keyMetricAdjustment:
              'Sleep Target: 7.5h split (Night + Afternoon Rest)',
        ),
      ];
    } else {
      return [
        const PillarAdaptationStrategy(
          pillarName: 'Workout Periodization',
          regionalPillarName: 'व्यायाम अनुकूलन',
          headlineAction: '15-Minute Morning High-Density Circuit',
          detailedProtocol:
              'Execute concise 15-20 minute morning metabolic bodyweight/dumbbell supersets before guest arrivals to prime insulin sensitivity for the day.',
          regionalDetailedProtocol:
              'त्योहार की व्यस्तता से पूर्व सुबह १५-२० मिनट का संक्षिप्त व प्रभावी व्यायाम करें ताकि चयापचय सक्रिय रहे।',
          keyMetricAdjustment:
              'Workout Duration: 20 min high-efficiency circuit',
        ),
        PillarAdaptationStrategy(
          pillarName: 'Festive Feasting Strategy',
          regionalPillarName: 'त्योहारी खान-पान रणनीति',
          headlineAction: 'Pre-Feast Fiber & 100-Step Shatapadi',
          detailedProtocol:
              'Consume a bowl of raw salad or soaked methi water 15 minutes before festive meals. Always complete a 100-step Shatapadi walk after heavy dining.',
          regionalDetailedProtocol:
              'मिठाई व मुख्य भोजन से पूर्व सलाद या मेथी पानी लें। भोजन पश्चात १०० कदम शतपदी भ्रमण अवश्य करें।',
          keyMetricAdjustment:
              'Calorie Target: +$calorieDelta kcal festive buffer',
        ),
        const PillarAdaptationStrategy(
          pillarName: 'Ayurvedic Agni Protection',
          regionalPillarName: 'अग्नि दीपन एवं पाचन सुरक्षा',
          headlineAction: 'Deepana-Pachana Warm Ginger Infusions',
          detailedProtocol:
              'Sip warm water infused with ginger, cumin (Jeera), and carom seeds (Ajwain) to sustain digestive fire and prevent Ama (metabolic endotoxins).',
          regionalDetailedProtocol:
              'अदरक, जीरा व अजवाइन युक्त गुनगुना पानी पिएं जिससे जठराग्नि प्रदीप्त रहे और भारी भोजन आसानी से पचे।',
          keyMetricAdjustment:
              'Digestive Tea: 2x daily after main festive meals',
        ),
        const PillarAdaptationStrategy(
          pillarName: 'Psychological Well-Being',
          regionalPillarName: 'मानसिक शांति व आनंद',
          headlineAction: 'Zero-Guilt Mindful Cherishing',
          detailedProtocol:
              'Festivals are meant for joy and family harmony. Never engage in compensatory starvation or shame. Mindfully savor traditional heirloom dishes.',
          regionalDetailedProtocol:
              'त्योहार का आनंद पूरे मन से लें। किसी भी प्रकार का पश्चाताप न करें, पारंपरिक व्यंजनों का स्वाद सजगता से लें।',
          keyMetricAdjustment: 'Mindset: 100% Guilt-Free Cultural Connection',
        ),
      ];
    }
  }

  List<ResetProtocolDay> _buildResetProtocol(IndianFestival festival) {
    return [
      const ResetProtocolDay(
        dayNumber: 1,
        focusTheme: 'Digestive Agni Reignition & Hydration',
        dietaryProtocol:
            'Light Moong Dal Soup, Lauki juice, warm water hydration, and zero refined sugar.',
        workoutProtocol: 'Restorative Hatha Yoga & 30-minute brisk walk.',
        ayurvedicDigestiveRemedy:
            'Triphala Churna (1 tsp) with warm water before bedtime.',
      ),
      const ResetProtocolDay(
        dayNumber: 2,
        focusTheme: 'Cellular Autophagy & Glycemic Normalization',
        dietaryProtocol:
            'Ayurvedic Green Moong & Rice Khichdi with a dash of A2 Cow Ghee and turmeric.',
        workoutProtocol: 'Full-body moderate resistance training (45 minutes).',
        ayurvedicDigestiveRemedy:
            'Ginger-Coriander-Cumin (CCF) tea post-lunch.',
      ),
      const ResetProtocolDay(
        dayNumber: 3,
        focusTheme: 'Peak Training Re-entry & Baseline Homeostasis',
        dietaryProtocol:
            'Return to standardized personalized macro target with 1.6g/kg protein distribution.',
        workoutProtocol:
            'Standard primary progressive overload training split.',
        ayurvedicDigestiveRemedy: 'Amla juice with warm water in the morning.',
      ),
    ];
  }

  (String, String) _generateFeastingTips(IndianFestival festival) {
    switch (festival) {
      case IndianFestival.diwali:
        return (
          'Savor artisan Kaju Katli or Besan Ladoo mindfully by pairing them with a glass of water and almonds to blunt glycemic response.',
          'काजू कतली या बेसन के लड्डू का आनंद बादाम व जल के साथ लें ताकि रक्त शर्करा में तीव्र उछाल न आए।',
        );
      case IndianFestival.holi:
        return (
          'Enjoy homemade Gujiya and Thandai prepared with natural nuts, saffron, and fennel for healthy cooling Agni.',
          'केसर, सौंफ व मेवों से युक्त ठंडाई और गुजिया का पारंपरिक आनंद लें।',
        );
      case IndianFestival.navratri:
        return (
          'Use rock salt (Sendha Namak) and ghee-roasted makhana for energy. Stay fully hydrated with coconut water.',
          'सेंधा नमक व घी में भुने मखाने का सेवन करें और नारियल पानी से शरीर में ऊर्जा बनाए रखें।',
        );
      case IndianFestival.ramadanEid:
        return (
          'Break fast at Iftar with 2 dates and water, followed by slow protein-rich savory dishes before desserts.',
          'इफ्तार में २ खजूर व जल से रोज़ा खोलें, तत्पश्चात प्रोटीन युक्त संतुलित आहार लें।',
        );
      default:
        return (
          'Cherish traditional festive foods with gratitude. Eat slowly, engage in conversations, and take a 100-step walk post-meal.',
          'त्योहारी भोजन का आनंद कृतज्ञतापूर्वक लें। भोजन के बाद शतपदी (१०० कदम चलना) अवश्य करें।',
        );
    }
  }
}
