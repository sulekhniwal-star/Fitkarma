enum FestivalType {
  navratri,
  diwali,
  holi,
  ramadan,
  eid,
  ganeshChaturthi,
  onam,
  christmas,
  karwaChauth,
  makarSankranti,
  generic,
}

class Festival {
  final String id;
  final String name;
  final FestivalType type;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const Festival({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
}

class FestivalAdaptation {
  final int calorieBuffer;
  final String proteinFocus;
  final double hydrationIncreaseLiters;
  final String workoutStrategy;
  final int stepTargetAdjust;
  final String sleepEmphasis;
  final String coachTone;
  final String? foodDatabaseFilter;
  final bool isFastingActive;
  final String? mealTimingMode;

  const FestivalAdaptation({
    required this.calorieBuffer,
    required this.proteinFocus,
    required this.hydrationIncreaseLiters,
    required this.workoutStrategy,
    required this.stepTargetAdjust,
    required this.sleepEmphasis,
    required this.coachTone,
    this.foodDatabaseFilter,
    this.isFastingActive = false,
    this.mealTimingMode,
  });

  factory FestivalAdaptation.standard() {
    return const FestivalAdaptation(
      calorieBuffer: 0,
      proteinFocus: 'Standard target',
      hydrationIncreaseLiters: 0.0,
      workoutStrategy: 'Normal scheduled workout',
      stepTargetAdjust: 0,
      sleepEmphasis: 'Normal 7-8h bedtime',
      coachTone: 'Balanced & supportive',
    );
  }
}

/// Pure-Dart Festival Adaptation Engine per §P12-A spec
class FestivalCrossModuleEngine {
  const FestivalCrossModuleEngine();

  FestivalAdaptation adapt(Festival festival) {
    switch (festival.type) {
      case FestivalType.diwali:
        return const FestivalAdaptation(
          calorieBuffer: 200,
          proteinFocus: 'High — counteract sweets',
          hydrationIncreaseLiters: 0.5,
          workoutStrategy: 'Morning-first — burn before celebrating',
          stepTargetAdjust: 1000,
          sleepEmphasis: 'High — late nights risk recovery',
          coachTone: 'Celebratory — allow flexibility',
        );

      case FestivalType.navratri:
        return const FestivalAdaptation(
          calorieBuffer: 0,
          proteinFocus: 'Fasting friendly protein (curd, paneer, nuts)',
          hydrationIncreaseLiters: 0.5,
          workoutStrategy: 'Moderate — energy may be lower on fasting days',
          stepTargetAdjust: 500,
          sleepEmphasis: 'Garba night recovery buffer',
          coachTone: 'Spiritually aligned & encouraging',
          foodDatabaseFilter: 'fasting_foods_only',
          isFastingActive: true,
        );

      case FestivalType.ramadan:
        return const FestivalAdaptation(
          calorieBuffer: 0,
          proteinFocus: 'Iftar & Sehri dense protein',
          hydrationIncreaseLiters: 1.0,
          workoutStrategy: 'Post-Taraweeh or pre-Sehri light session',
          stepTargetAdjust: -1000,
          sleepEmphasis: 'Split sleep schedule management',
          coachTone: 'Mindful & accommodating',
          mealTimingMode: 'sehri_iftar',
          isFastingActive: true,
        );

      case FestivalType.holi:
        return const FestivalAdaptation(
          calorieBuffer: 300,
          proteinFocus: 'Balanced post-play recovery',
          hydrationIncreaseLiters: 0.8,
          workoutStrategy: 'Social active play — outdoor step burn',
          stepTargetAdjust: 2000,
          sleepEmphasis: 'Hydration & skin/body rest',
          coachTone: 'Festive & high-energy',
        );

      case FestivalType.eid:
        return const FestivalAdaptation(
          calorieBuffer: 250,
          proteinFocus: 'Lean meat & legume focus with feasts',
          hydrationIncreaseLiters: 0.5,
          workoutStrategy: 'Light maintenance or active family walk',
          stepTargetAdjust: 500,
          sleepEmphasis: 'Standard rest',
          coachTone: 'Joyful & festive',
        );

      case FestivalType.ganeshChaturthi:
      case FestivalType.onam:
        return const FestivalAdaptation(
          calorieBuffer: 150,
          proteinFocus: 'Sadya / Prasad macro balancing',
          hydrationIncreaseLiters: 0.4,
          workoutStrategy: 'Morning session before family gathering',
          stepTargetAdjust: 500,
          sleepEmphasis: 'Standard rest',
          coachTone: 'Culturally festive',
        );

      case FestivalType.christmas:
        return const FestivalAdaptation(
          calorieBuffer: 250,
          proteinFocus: 'Party feast macro budgeting',
          hydrationIncreaseLiters: 0.5,
          workoutStrategy: 'Holiday morning circuit',
          stepTargetAdjust: 1000,
          sleepEmphasis: 'Late party recovery buffer',
          coachTone: 'Holiday cheer & balanced',
        );

      case FestivalType.karwaChauth:
        return const FestivalAdaptation(
          calorieBuffer: -100,
          proteinFocus: 'Sargi pre-fast & Moonrise post-fast nutrition',
          hydrationIncreaseLiters: 0.5,
          workoutStrategy: 'Rest day / gentle stretching only',
          stepTargetAdjust: -2000,
          sleepEmphasis: 'Conservation rest',
          coachTone: 'Gentle & supportive',
          isFastingActive: true,
        );

      case FestivalType.makarSankranti:
        return const FestivalAdaptation(
          calorieBuffer: 100,
          proteinFocus: 'Til + jaggery micronutrient benefits',
          hydrationIncreaseLiters: 0.3,
          workoutStrategy: 'Kite flying active outdoor burn',
          stepTargetAdjust: 1500,
          sleepEmphasis: 'Standard rest',
          coachTone: 'Energetic',
        );

      case FestivalType.generic:
        return FestivalAdaptation.standard();
    }
  }

  /// Checks if festival survival mode should activate (starts 3 days before festival)
  bool isSurvivalModeActive(Festival festival, DateTime currentDate) {
    final survivalStart = festival.startDate.subtract(const Duration(days: 3));
    return currentDate.isAfter(survivalStart) &&
        currentDate.isBefore(festival.endDate.add(const Duration(days: 1)));
  }

  /// Seeded list of top Indian & international festivals per §P12-A spec
  static List<Festival> getSeededFestivals(int year) {
    return [
      Festival(
        id: 'f_navratri_$year',
        name: 'Navratri',
        type: FestivalType.navratri,
        startDate: DateTime(year, 10, 3),
        endDate: DateTime(year, 10, 12),
        description: '9 days of fasting, Garba, and celebration',
      ),
      Festival(
        id: 'f_diwali_$year',
        name: 'Diwali',
        type: FestivalType.diwali,
        startDate: DateTime(year, 11, 1),
        endDate: DateTime(year, 11, 5),
        description: 'Festival of lights, sweets, and family feasting',
      ),
      Festival(
        id: 'f_holi_$year',
        name: 'Holi',
        type: FestivalType.holi,
        startDate: DateTime(year, 3, 25),
        endDate: DateTime(year, 3, 26),
        description: 'Festival of colors, outdoor play, and gujiya treats',
      ),
      Festival(
        id: 'f_ramadan_$year',
        name: 'Ramadan',
        type: FestivalType.ramadan,
        startDate: DateTime(year, 3, 10),
        endDate: DateTime(year, 4, 9),
        description: 'Holy month of dawn-to-dusk fasting',
      ),
      Festival(
        id: 'f_eid_$year',
        name: 'Eid al-Fitr',
        type: FestivalType.eid,
        startDate: DateTime(year, 4, 10),
        endDate: DateTime(year, 4, 11),
        description: 'Festival of breaking the fast, biryani & sheer khurma',
      ),
      Festival(
        id: 'f_ganesh_$year',
        name: 'Ganesh Chaturthi',
        type: FestivalType.ganeshChaturthi,
        startDate: DateTime(year, 9, 7),
        endDate: DateTime(year, 9, 17),
        description: '10-day celebration with modak treats',
      ),
      Festival(
        id: 'f_karwa_$year',
        name: 'Karwa Chauth',
        type: FestivalType.karwaChauth,
        startDate: DateTime(year, 10, 20),
        endDate: DateTime(year, 10, 20),
        description: 'Full day waterless fast until moonrise',
      ),
      Festival(
        id: 'f_christmas_$year',
        name: 'Christmas & New Year',
        type: FestivalType.christmas,
        startDate: DateTime(year, 12, 24),
        endDate: DateTime(year, 1, 1),
        description: 'Year-end holiday feasts & gatherings',
      ),
    ];
  }
}
