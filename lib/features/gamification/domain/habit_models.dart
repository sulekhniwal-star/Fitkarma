enum HabitTimeSlot {
  morning(
    label: 'Morning (Pratah Kal)',
    regionalLabel: 'प्रातः काल (सूर्योदय से पूर्व)',
    timeRange: '06:00 - 09:00',
    iconName: 'wb_sunny',
  ),
  afternoon(
    label: 'Midday (Madhyahan)',
    regionalLabel: 'मध्याह्न (दोपहर)',
    timeRange: '12:00 - 15:00',
    iconName: 'wb_twilight',
  ),
  evening(
    label: 'Evening (Sandhya Kal)',
    regionalLabel: 'संध्या काल (शाम)',
    timeRange: '17:00 - 20:00',
    iconName: 'fitness_center',
  ),
  night(
    label: 'Night (Ratri Charya)',
    regionalLabel: 'रात्रि चर्या (सोने से पूर्व)',
    timeRange: '20:00 - 23:00',
    iconName: 'nightlight',
  ),
  anytime(
    label: 'All Day (Sarva Kal)',
    regionalLabel: 'दिनभर कभी भी',
    timeRange: 'Flexible',
    iconName: 'all_inclusive',
  );

  final String label;
  final String regionalLabel;
  final String timeRange;
  final String iconName;

  const HabitTimeSlot({
    required this.label,
    required this.regionalLabel,
    required this.timeRange,
    required this.iconName,
  });
}

enum HabitTriggerSource {
  manual(label: 'Manual Check', regionalLabel: 'मैनुअल चेक'),
  stepSensor(label: 'Auto: Step Counter / Wearable', regionalLabel: 'ऑटो: कदम ट्रैकर'),
  workoutLogger(label: 'Auto: Workout Tracker', regionalLabel: 'ऑटो: व्यायाम ट्रैकर'),
  mealLogger(label: 'Auto: Nutrition Scanner', regionalLabel: 'ऑटो: भोजन ट्रैकर'),
  sleepTracker(label: 'Auto: Sleep Monitor', regionalLabel: 'ऑटो: निद्रा ट्रैकर');

  final String label;
  final String regionalLabel;

  const HabitTriggerSource({
    required this.label,
    required this.regionalLabel,
  });
}

enum HabitAutomaticityTier {
  formation(
    title: 'Formation Phase',
    regionalTitle: 'निर्माण अवस्था (प्रयास आवश्यक)',
    colorCode: 0xFF00B0FF,
  ),
  reinforcement(
    title: 'Reinforcement Phase',
    regionalTitle: 'सुदृढ़ीकरण (आदत विकसित)',
    colorCode: 0xFF00E676,
  ),
  automatic(
    title: 'Automatic Reflex',
    regionalTitle: 'सहज स्वाभाविक (स्थाई आदत)',
    colorCode: 0xFFFFD700,
  );

  final String title;
  final String regionalTitle;
  final int colorCode;

  const HabitAutomaticityTier({
    required this.title,
    required this.regionalTitle,
    required this.colorCode,
  });
}

class Habit {
  final String id;
  final String title;
  final String regionalTitle;
  final String cueDescription;
  final String routineDescription;
  final int rewardKarmaPoints;
  final HabitTimeSlot timeSlot;
  final HabitTriggerSource triggerSource;
  final bool isCompletedToday;
  final DateTime? lastCompletedAt;
  final int streakDays;
  final int totalCompletions;
  final double habitStrengthIndex; // 0.0 to 100.0
  final HabitAutomaticityTier automaticityTier;
  final List<bool> history30Days; // true = completed, false = missed

  const Habit({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.cueDescription,
    required this.routineDescription,
    required this.rewardKarmaPoints,
    required this.timeSlot,
    required this.triggerSource,
    this.isCompletedToday = false,
    this.lastCompletedAt,
    this.streakDays = 0,
    this.totalCompletions = 0,
    this.habitStrengthIndex = 0.0,
    this.automaticityTier = HabitAutomaticityTier.formation,
    this.history30Days = const [],
  });

  Habit copyWith({
    bool? isCompletedToday,
    DateTime? lastCompletedAt,
    int? streakDays,
    int? totalCompletions,
    double? habitStrengthIndex,
    HabitAutomaticityTier? automaticityTier,
    List<bool>? history30Days,
  }) {
    return Habit(
      id: id,
      title: title,
      regionalTitle: regionalTitle,
      cueDescription: cueDescription,
      routineDescription: routineDescription,
      rewardKarmaPoints: rewardKarmaPoints,
      timeSlot: timeSlot,
      triggerSource: triggerSource,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      streakDays: streakDays ?? this.streakDays,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      habitStrengthIndex: habitStrengthIndex ?? this.habitStrengthIndex,
      automaticityTier: automaticityTier ?? this.automaticityTier,
      history30Days: history30Days ?? this.history30Days,
    );
  }
}

class HabitDailySummary {
  final int totalHabitsCount;
  final int completedTodayCount;
  final double adherencePercent;
  final double averageHabitStrengthIndex;
  final int totalEarnedKarmaPointsToday;
  final List<Habit> habits;

  const HabitDailySummary({
    required this.totalHabitsCount,
    required this.completedTodayCount,
    required this.adherencePercent,
    required this.averageHabitStrengthIndex,
    required this.totalEarnedKarmaPointsToday,
    required this.habits,
  });
}
