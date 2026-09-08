enum KarmaActionType {
  workoutCompletion(
    basePoints: 150,
    label: 'Workout Completed',
    regionalLabel: 'व्यायाम सत्र संपन्न',
  ),
  shatpawaliSteps(
    basePoints: 50,
    label: 'Post-Meal Shatpawali Walk (1000 Steps)',
    regionalLabel: 'भोजनोपरांत शतपावली (१००० कदम)',
  ),
  dailyStepGoal(
    basePoints: 100,
    label: 'Daily Step Target Achieved (10,000+ Steps)',
    regionalLabel: 'दैनिक कदम लक्ष्य पूर्ण (१०,०००+ कदम)',
  ),
  nutritionAdherence(
    basePoints: 100,
    label: 'Macronutrient & Protein Target Hit (±5%)',
    regionalLabel: 'दैनिक प्रोटीन व पोषण लक्ष्य पूर्ण',
  ),
  mealQualityLog(
    basePoints: 50,
    label: 'High Meal Quality Score Logged (>85)',
    regionalLabel: 'उत्कृष्ट भोजन गुणवत्ता स्कोर दर्ज',
  ),
  sleepGoalAchieved(
    basePoints: 75,
    label: 'Optimal Sleep Duration & Recovery (>85% Efficiency)',
    regionalLabel: 'उत्तम निद्रा अवधि एवं रिकवरी',
  ),
  biometricVaultLog(
    basePoints: 50,
    label: 'Biometrics Logged (BP / Glucose / Vitals)',
    regionalLabel: 'बायोमेट्रिक स्वास्थ्य आंकड़े दर्ज',
  ),
  mindfulnessPranayama(
    basePoints: 40,
    label: 'Pranayama & Circadian Mindfulness Logged',
    regionalLabel: 'प्राणायाम एवं मानसिक शांति अभ्यास',
  ),
  streakBonus(
    basePoints: 75,
    label: 'Daily Consistency Multiplier Bonus',
    regionalLabel: 'निरंतरता बोनस',
  ),
  festivalResilience(
    basePoints: 80,
    label: 'Festival & Life Event Nutrition Resilience',
    regionalLabel: 'त्योहार अनुशासन एवं संतुलन',
  );

  final int basePoints;
  final String label;
  final String regionalLabel;

  const KarmaActionType({
    required this.basePoints,
    required this.label,
    required this.regionalLabel,
  });
}

enum KarmaTier {
  arambh(
    minPoints: 0,
    maxPoints: 999,
    minLevel: 1,
    maxLevel: 5,
    title: 'Arambh',
    regionalTitle: 'प्रारंभ (शुरुआत)',
    badgeColorCode: 0xFF00B0FF,
  ),
  sadhak(
    minPoints: 1000,
    maxPoints: 4999,
    minLevel: 6,
    maxLevel: 15,
    title: 'Sadhak',
    regionalTitle: 'साधक (अभ्यासरत)',
    badgeColorCode: 0xFF00E676,
  ),
  abhyasi(
    minPoints: 5000,
    maxPoints: 14999,
    minLevel: 16,
    maxLevel: 30,
    title: 'Abhyasi',
    regionalTitle: 'अभ्यासी (अनुशासित)',
    badgeColorCode: 0xFF7C4DFF,
  ),
  veer(
    minPoints: 15000,
    maxPoints: 34999,
    minLevel: 31,
    maxLevel: 50,
    title: 'Veer',
    regionalTitle: 'वीर (योद्धा)',
    badgeColorCode: 0xFFFF9100,
  ),
  yogi(
    minPoints: 35000,
    maxPoints: 99999999,
    minLevel: 51,
    maxLevel: 999,
    title: 'Yogi',
    regionalTitle: 'योगी (सर्वोच्च सिद्धि)',
    badgeColorCode: 0xFFFFD700,
  );

  final int minPoints;
  final int maxPoints;
  final int minLevel;
  final int maxLevel;
  final String title;
  final String regionalTitle;
  final int badgeColorCode;

  const KarmaTier({
    required this.minPoints,
    required this.maxPoints,
    required this.minLevel,
    required this.maxLevel,
    required this.title,
    required this.regionalTitle,
    required this.badgeColorCode,
  });
}

enum KarmaBadgeCategory {
  metabolicMastery(
    label: 'Metabolic Mastery',
    regionalLabel: 'चयापचय दक्षता',
    iconName: 'local_fire_department',
  ),
  kinematicExcellence(
    label: 'Kinematic Excellence',
    regionalLabel: 'बायोमैकेनिक्स श्रेष्ठता',
    iconName: 'fitness_center',
  ),
  recoveryCircadian(
    label: 'Recovery & Circadian',
    regionalLabel: 'रिकवरी और सर्केडियन',
    iconName: 'bedtime',
  ),
  culturalAyurvedic(
    label: 'Cultural & Ayurvedic',
    regionalLabel: 'आयुर्वेदिक जीवनशैली',
    iconName: 'spa',
  ),
  consistencyGrit(
    label: 'Consistency & Grit',
    regionalLabel: 'दृढ़ता और निरंतरता',
    iconName: 'military_tech',
  );

  final String label;
  final String regionalLabel;
  final String iconName;

  const KarmaBadgeCategory({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

class KarmaBadge {
  final String id;
  final String name;
  final String regionalName;
  final String description;
  final String regionalDescription;
  final KarmaBadgeCategory category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final String requirementLabel;

  const KarmaBadge({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.description,
    required this.regionalDescription,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    required this.requirementLabel,
  });

  KarmaBadge copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return KarmaBadge(
      id: id,
      name: name,
      regionalName: regionalName,
      description: description,
      regionalDescription: regionalDescription,
      category: category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      requirementLabel: requirementLabel,
    );
  }
}

class KarmaTransaction {
  final String id;
  final DateTime timestamp;
  final KarmaActionType actionType;
  final int basePoints;
  final double multiplier;
  final int totalPointsAwarded;
  final String description;
  final String regionalDescription;

  const KarmaTransaction({
    required this.id,
    required this.timestamp,
    required this.actionType,
    required this.basePoints,
    required this.multiplier,
    required this.totalPointsAwarded,
    required this.description,
    required this.regionalDescription,
  });
}

class KarmaProfile {
  final int currentKarmaPoints;
  final int lifetimeKarmaPoints;
  final int currentLevel;
  final KarmaTier tier;
  final double levelProgressPercent; // 0.0 to 1.0 within current level
  final int pointsToNextLevel;
  final int currentStreakDays;
  final int longestStreakDays;
  final double streakMultiplier;
  final int unlockedBadgesCount;
  final int totalBadgesCount;
  final List<KarmaTransaction> recentTransactions;
  final List<KarmaBadge> allBadges;

  const KarmaProfile({
    required this.currentKarmaPoints,
    required this.lifetimeKarmaPoints,
    required this.currentLevel,
    required this.tier,
    required this.levelProgressPercent,
    required this.pointsToNextLevel,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.streakMultiplier,
    required this.unlockedBadgesCount,
    required this.totalBadgesCount,
    required this.recentTransactions,
    required this.allBadges,
  });
}
