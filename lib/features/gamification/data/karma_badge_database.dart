import '../domain/karma_models.dart';

class KarmaBadgeDatabase {
  static const List<KarmaBadge> defaultBadges = [
    // Metabolic Mastery
    KarmaBadge(
      id: 'badge_shatpawali_pioneer',
      name: 'Shatpawali Pioneer',
      regionalName: 'शतपावली पथप्रदर्शक',
      description: 'Complete 7 post-meal Shatpawali 1000-step walks.',
      regionalDescription: 'भोजनोपरांत ७ बार शतपावली (१००० कदम) पूर्ण करें।',
      category: KarmaBadgeCategory.metabolicMastery,
      requirementLabel: '7 Shatpawali Walks',
    ),
    KarmaBadge(
      id: 'badge_shatpawali_master',
      name: 'Shatpawali Acharya',
      regionalName: 'शतपावली आचार्य',
      description: 'Complete 30 post-meal Shatpawali walks to regulate postprandial glucose.',
      regionalDescription: 'ब्लड शुगर संतुलन हेतु ३० शतपावली सत्र संपन्न करें।',
      category: KarmaBadgeCategory.metabolicMastery,
      requirementLabel: '30 Shatpawali Walks',
    ),
    KarmaBadge(
      id: 'badge_sattvic_nutrition',
      name: 'Sattvic Discipline',
      regionalName: 'सात्विक पोषण सिद्धि',
      description: 'Log 20 high-quality Indian meals with Meal Quality Score > 85.',
      regionalDescription: '८५+ गुणवत्ता स्कोर वाले २० भोजन दर्ज करें।',
      category: KarmaBadgeCategory.metabolicMastery,
      requirementLabel: '20 High MQS Meals',
    ),

    // Kinematic Excellence
    KarmaBadge(
      id: 'badge_iron_discipline_workouts',
      name: 'Loha Abhyas (Iron Habit)',
      regionalName: 'लौह अभ्यास',
      description: 'Complete 10 resistance training workout sessions.',
      regionalDescription: '१० स्ट्रेंथ / वजन प्रशिक्षण सत्र पूरे करें।',
      category: KarmaBadgeCategory.kinematicExcellence,
      requirementLabel: '10 Completed Workouts',
    ),
    KarmaBadge(
      id: 'badge_century_lifter',
      name: 'Shatak Lifter',
      regionalName: 'शतक लिफ्टर (१०० सत्र)',
      description: 'Complete 100 logged resistance workouts.',
      regionalDescription: '१०० व्यायाम सत्र पूरे करके आजीवन अनुशासन बनाएं।',
      category: KarmaBadgeCategory.kinematicExcellence,
      requirementLabel: '100 Workouts',
    ),

    // Recovery & Circadian
    KarmaBadge(
      id: 'badge_sleep_alchemist',
      name: 'Nidra Sadhak',
      regionalName: 'निद्रा साधक (गहरी नींद)',
      description: 'Achieve 14 nights with > 85% sleep recovery efficiency.',
      regionalDescription: '१४ रातों तक ८५%+ निद्रा रिकवरी दक्षता प्राप्त करें।',
      category: KarmaBadgeCategory.recoveryCircadian,
      requirementLabel: '14 Optimal Sleep Nights',
    ),

    // Consistency & Grit
    KarmaBadge(
      id: 'badge_streak_starter',
      name: 'Saptah Samarpit',
      regionalName: 'सप्ताह समर्पित (७ दिन स्ट्रीक)',
      description: 'Maintain an unbroken 7-day health logging streak.',
      regionalDescription: 'लगातार ७ दिनों तक स्वास्थ्य व पोषण लॉगिंग बनाए रखें।',
      category: KarmaBadgeCategory.consistencyGrit,
      requirementLabel: '7-Day Streak',
    ),
    KarmaBadge(
      id: 'badge_month_of_steel',
      name: 'Masa Tapasya',
      regionalName: 'मास तपस्या (३० दिन स्ट्रीक)',
      description: 'Maintain an unbroken 30-day health logging streak.',
      regionalDescription: 'लगातार ३० दिनों तक पूर्ण अनुशासन बनाए रखें।',
      category: KarmaBadgeCategory.consistencyGrit,
      requirementLabel: '30-Day Streak',
    ),
    KarmaBadge(
      id: 'badge_unbreakable_100',
      name: 'Akhand Sankalp',
      regionalName: 'अखंड संकल्प (१०० दिन स्ट्रीक)',
      description: 'Achieve a legendary 100-day unbroken consistency streak.',
      regionalDescription: '१०० दिनों का अखंड स्वास्थ्य संकल्प पूर्ण करें।',
      category: KarmaBadgeCategory.consistencyGrit,
      requirementLabel: '100-Day Streak',
    ),

    // Cultural & Tier Ascensions
    KarmaBadge(
      id: 'badge_sadhak_ascension',
      name: 'Sadhak Ascendant',
      regionalName: 'साधक दीक्षा (१,००० कर्म)',
      description: 'Accumulate 1,000 Lifetime Karma Points.',
      regionalDescription: '१००० कर्म अंक अर्जित कर साधक स्तर पर पहुंचें।',
      category: KarmaBadgeCategory.culturalAyurvedic,
      requirementLabel: '1,000 Lifetime KP',
    ),
    KarmaBadge(
      id: 'badge_abhyasi_ascension',
      name: 'Abhyasi Ascendant',
      regionalName: 'अभ्यासी पद (५,००० कर्म)',
      description: 'Accumulate 5,000 Lifetime Karma Points.',
      regionalDescription: '५००० कर्म अंक अर्जित कर अभ्यासी श्रेणी में प्रवेश करें।',
      category: KarmaBadgeCategory.culturalAyurvedic,
      requirementLabel: '5,000 Lifetime KP',
    ),
    KarmaBadge(
      id: 'badge_yogi_mastery',
      name: 'Param Yogi',
      regionalName: 'परम योगी (३५,००० कर्म)',
      description: 'Reach the pinnacle of health operating mastery with 35,000+ KP.',
      regionalDescription: '३५०००+ कर्म अंक अर्जित कर सर्वोच्च स्वास्थ्य पद प्राप्त करें।',
      category: KarmaBadgeCategory.culturalAyurvedic,
      requirementLabel: '35,000 Lifetime KP',
    ),
  ];
}
