/// §P12-A Festival Intelligence Engine
///
/// Cross-module festival adaptation generator matching §P12-A specification.
/// Synchronizes Nutrition, Workout, Daily Mission, and AI Coach contexts for Indian festivals.
library;

import 'festival_models.dart';
import 'indian_festival_calendar.dart';

class FestivalIntelligenceEngine {
  const FestivalIntelligenceEngine();

  /// Detects active festival and adaptation phase for any given date.
  (IndianFestival?, FestivalAdaptationPhase) detectActiveFestival(
    DateTime targetDate, {
    List<IndianFestival>? customCalendar,
  }) {
    final calendar = customCalendar ?? IndianFestivalCalendarDataset.festivals;
    final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);

    for (final festival in calendar) {
      final startOnly = DateTime(festival.startDate.year, festival.startDate.month, festival.startDate.day);
      final endOnly = DateTime(festival.endDate.year, festival.endDate.month, festival.endDate.day);

      // Main festival day(s)
      if (dateOnly.isAfter(startOnly.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(endOnly.add(const Duration(days: 1)))) {
        return (festival, FestivalAdaptationPhase.mainFestival);
      }

      // Pre-compensation window (1–3 days before)
      final preStart = startOnly.subtract(const Duration(days: 3));
      if (dateOnly.isAfter(preStart.subtract(const Duration(days: 1))) && dateOnly.isBefore(startOnly)) {
        return (festival, FestivalAdaptationPhase.preCompensation);
      }

      // Post-recovery window (1 day after)
      final postDay = endOnly.add(const Duration(days: 1));
      if (dateOnly == postDay) {
        return (festival, FestivalAdaptationPhase.postRecovery);
      }
    }

    return (null, FestivalAdaptationPhase.none);
  }

  /// Generates synchronized cross-module adaptation for Nutrition, Workout, Mission & AI Context.
  CrossModuleFestivalAdaptation generateCrossModuleAdaptation(
    DateTime targetDate, {
    List<IndianFestival>? customCalendar,
  }) {
    final (festival, phase) = detectActiveFestival(targetDate, customCalendar: customCalendar);

    if (festival == null || phase == FestivalAdaptationPhase.none) {
      return CrossModuleFestivalAdaptation(
        phase: FestivalAdaptationPhase.none,
        nutritionAdaptation: const NutritionFestivalAdaptation(
          caloriesDelta: 0,
          proteinGDelta: 0,
          waterLDelta: 0.0,
          sattvicFocus: false,
          bannerNote: 'Standard Daily Nutrition Active',
        ),
        workoutAdaptation: const WorkoutFestivalAdaptation(
          recommendedRpeMax: 8,
          targetWorkoutType: 'Standard Scheduled Workout',
          cardioMinutes: 0,
          exerciseNote: 'Regular workout programming',
        ),
        missionAdaptation: const MissionFestivalAdaptation(
          missionTitle: 'Daily Target',
          missionDescription: 'Hit your regular daily nutrition & activity goals.',
          rewardXp: 100,
        ),
        aiCoachPromptContext: '',
      );
    }

    switch (phase) {
      case FestivalAdaptationPhase.preCompensation:
        return _buildPreCompensationAdaptation(festival);
      case FestivalAdaptationPhase.mainFestival:
        return _buildMainFestivalAdaptation(festival);
      case FestivalAdaptationPhase.postRecovery:
        return _buildPostRecoveryAdaptation(festival);
      case FestivalAdaptationPhase.none:
        break;
    }

    throw StateError('Unhandled festival phase');
  }

  CrossModuleFestivalAdaptation _buildPreCompensationAdaptation(IndianFestival festival) {
    return CrossModuleFestivalAdaptation(
      activeFestival: festival,
      phase: FestivalAdaptationPhase.preCompensation,
      nutritionAdaptation: NutritionFestivalAdaptation(
        caloriesDelta: -150,
        proteinGDelta: 10,
        waterLDelta: 0.5,
        sattvicFocus: festival.category == FestivalCategory.fasting,
        bannerNote: '🪔 Pre-${festival.name} Banking: Consuming -150 kcal buffer today for festival feasting!',
      ),
      workoutAdaptation: const WorkoutFestivalAdaptation(
        recommendedRpeMax: 8,
        targetWorkoutType: 'Glycogen Depletion Hypertrophy',
        cardioMinutes: 20,
        exerciseNote: 'Build muscle glycogen storage capacity before upcoming festival meals.',
      ),
      missionAdaptation: MissionFestivalAdaptation(
        missionTitle: 'Pre-Festival Calorie Bank 🏦',
        missionDescription: 'Save 150 kcal today & drink +0.5L water to prepare for ${festival.name}.',
        rewardXp: 150,
      ),
      aiCoachPromptContext: 'Pre-Festival Mode (${festival.name}): User is banking calories (-150 kcal buffer). Encourage high protein & hydration.',
    );
  }

  CrossModuleFestivalAdaptation _buildMainFestivalAdaptation(IndianFestival festival) {
    if (festival.category == FestivalCategory.fasting) {
      return CrossModuleFestivalAdaptation(
        activeFestival: festival,
        phase: FestivalAdaptationPhase.mainFestival,
        nutritionAdaptation: NutritionFestivalAdaptation(
          caloriesDelta: 0,
          proteinGDelta: 15,
          waterLDelta: 1.0,
          sattvicFocus: true,
          bannerNote: '🕉️ ${festival.name}: Sattvic Fasting Mode active. Focus on Makhana, Paneer & Curd.',
        ),
        workoutAdaptation: WorkoutFestivalAdaptation(
          recommendedRpeMax: 5,
          targetWorkoutType: 'Gentle Yoga & Mobility Stretch',
          cardioMinutes: 15,
          exerciseNote: festival.recommendedActivity,
        ),
        missionAdaptation: MissionFestivalAdaptation(
          missionTitle: 'Sattvic Fasting & Zen 🧘',
          missionDescription: festival.dietaryGuidance,
          rewardXp: 250,
        ),
        aiCoachPromptContext: 'Festival Fasting Mode (${festival.name}): Recommend light yoga, electrolyte hydration & Sattvic protein (Paneer/Makhana).',
      );
    }

    return CrossModuleFestivalAdaptation(
      activeFestival: festival,
      phase: FestivalAdaptationPhase.mainFestival,
      nutritionAdaptation: NutritionFestivalAdaptation(
        caloriesDelta: 400,
        proteinGDelta: 15,
        waterLDelta: 1.0,
        sattvicFocus: false,
        bannerNote: '🎉 Happy ${festival.name}! +400 kcal festive sweet buffer enabled. Enjoy guilt-free!',
      ),
      workoutAdaptation: WorkoutFestivalAdaptation(
        recommendedRpeMax: 7,
        targetWorkoutType: 'Post-Feast Metabolic Walk & Pump',
        cardioMinutes: 25,
        exerciseNote: festival.recommendedActivity,
      ),
      missionAdaptation: MissionFestivalAdaptation(
        missionTitle: '${festival.name} Mindfulness 🌸',
        missionDescription: 'Enjoy festive sweets guilt-free & complete a 20-min post-meal walk.',
        rewardXp: 200,
      ),
      aiCoachPromptContext: 'Main Festival Mode (${festival.name}): User is celebrating. Remind them to enjoy sweets guilt-free and do a light post-dinner walk.',
    );
  }

  CrossModuleFestivalAdaptation _buildPostRecoveryAdaptation(IndianFestival festival) {
    return CrossModuleFestivalAdaptation(
      activeFestival: festival,
      phase: FestivalAdaptationPhase.postRecovery,
      nutritionAdaptation: NutritionFestivalAdaptation(
        caloriesDelta: -100,
        proteinGDelta: 10,
        waterLDelta: 1.0,
        sattvicFocus: false,
        bannerNote: '💧 Post-${festival.name} Flush: +1.0L extra water & high-fiber greens to clear bloat.',
      ),
      workoutAdaptation: const WorkoutFestivalAdaptation(
        recommendedRpeMax: 7,
        targetWorkoutType: 'Metabolic Flush & Sweat Session',
        cardioMinutes: 30,
        exerciseNote: 'Active 30-min steady cardio to flush excess sodium and restore insulin sensitivity.',
      ),
      missionAdaptation: MissionFestivalAdaptation(
        missionTitle: 'Post-Festival Hydration Flush 🌊',
        missionDescription: 'Drink 3.5L total water today & eat a high-fiber vegetable bowl.',
        rewardXp: 150,
      ),
      aiCoachPromptContext: 'Post-Festival Recovery Mode (${festival.name}): Focus on bloat flushing, +1.0L water, high fiber, and steady cardio.',
    );
  }
}
