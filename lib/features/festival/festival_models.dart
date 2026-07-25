/// §P12-A Festival Intelligence — Adaptation Models

import 'indian_festival_calendar.dart';

enum FestivalAdaptationPhase {
  preCompensation, // 1–3 Days prior to festival
  mainFestival, // Active Festival Day
  postRecovery, // 1 Day post festival
  none, // Regular day
}

class NutritionFestivalAdaptation {
  const NutritionFestivalAdaptation({
    required this.caloriesDelta,
    required this.proteinGDelta,
    required this.waterLDelta,
    required this.sattvicFocus,
    required this.bannerNote,
  });

  final int caloriesDelta; // e.g. +400 kcal or -150 kcal
  final int proteinGDelta; // e.g. +15g
  final double waterLDelta; // e.g. +1.0 L
  final bool sattvicFocus;
  final String bannerNote;
}

class WorkoutFestivalAdaptation {
  const WorkoutFestivalAdaptation({
    required this.recommendedRpeMax,
    required this.targetWorkoutType,
    required this.cardioMinutes,
    required this.exerciseNote,
  });

  final int recommendedRpeMax; // e.g. 5 (Light/Yoga during fasts) vs 8
  final String targetWorkoutType; // 'Gentle Yoga & Stretch', 'Post-Feast Walk', 'Hypertrophy'
  final int cardioMinutes;
  final String exerciseNote;
}

class MissionFestivalAdaptation {
  const MissionFestivalAdaptation({
    required this.missionTitle,
    required this.missionDescription,
    required this.rewardXp,
  });

  final String missionTitle;
  final String missionDescription;
  final int rewardXp;
}

class CrossModuleFestivalAdaptation {
  const CrossModuleFestivalAdaptation({
    this.activeFestival,
    required this.phase,
    required this.nutritionAdaptation,
    required this.workoutAdaptation,
    required this.missionAdaptation,
    required this.aiCoachPromptContext,
  });

  final IndianFestival? activeFestival;
  final FestivalAdaptationPhase phase;
  final NutritionFestivalAdaptation nutritionAdaptation;
  final WorkoutFestivalAdaptation workoutAdaptation;
  final MissionFestivalAdaptation missionAdaptation;
  final String aiCoachPromptContext;

  bool get hasActiveAdaptation => phase != FestivalAdaptationPhase.none;
}
