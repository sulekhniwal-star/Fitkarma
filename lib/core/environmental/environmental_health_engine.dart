import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum EnvironmentalRisk {
  aqiHazardous,
  aqiVeryPoor,
  aqiPoor,
  heatExtreme,
  heatHigh,
  uvExtreme,
}

enum WorkoutLocation {
  outdoor,
  indoorOnly,
  indoorPreferred,
  earlyMorningOrIndoor,
}

class EnvironmentalData {
  EnvironmentalData({
    required this.aqi,
    required this.heatIndexC,
    required this.uvIndex,
  });

  final int aqi;
  final double heatIndexC;
  final double uvIndex;
}

class EnvironmentalAdaptation {
  EnvironmentalAdaptation({
    required this.workoutRecommendation,
    required this.hydrationBoostL,
    required this.warningBanner,
    required this.bannerColor,
  });

  factory EnvironmentalAdaptation.clear() {
    return EnvironmentalAdaptation(
      workoutRecommendation: WorkoutLocation.outdoor,
      hydrationBoostL: 0.0,
      warningBanner: '',
      bannerColor: Colors.transparent,
    );
  }

  final WorkoutLocation workoutRecommendation;
  final double hydrationBoostL;
  final String warningBanner;
  final Color bannerColor;
}

class DailyMission {
  DailyMission({
    required this.title,
    required this.stepGoal,
    required this.workoutSuggestion,
    required this.hydrationGoalL,
  });

  final String title;
  final int stepGoal;
  final String workoutSuggestion;
  final double hydrationGoalL;
}

class EnvironmentalHealthEngine {
  /// Evaluates current weather/pollution metrics and flags active risks.
  EnvironmentalAdaptation evaluate(EnvironmentalData env) {
    final risks = <EnvironmentalRisk>[];

    // AQI classification (India NAQI standard thresholds)
    if (env.aqi > 300) {
      risks.add(EnvironmentalRisk.aqiHazardous);
    } else if (env.aqi > 200) {
      risks.add(EnvironmentalRisk.aqiVeryPoor);
    } else if (env.aqi > 100) {
      risks.add(EnvironmentalRisk.aqiPoor);
    }

    // Heat index threshold limits
    if (env.heatIndexC > 41) {
      risks.add(EnvironmentalRisk.heatExtreme);
    } else if (env.heatIndexC > 35) {
      risks.add(EnvironmentalRisk.heatHigh);
    }

    // UV Index threshold
    if (env.uvIndex > 10) {
      risks.add(EnvironmentalRisk.uvExtreme);
    }

    return _buildAdaptation(risks, env);
  }

  /// Transforms risks into actionable training adaptions and warnings.
  EnvironmentalAdaptation _buildAdaptation(List<EnvironmentalRisk> risks, EnvironmentalData env) {
    if (risks.contains(EnvironmentalRisk.aqiHazardous)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorOnly,
        hydrationBoostL: 0.5,
        warningBanner: 'AQI ${env.aqi} — Hazardous. '
            'Outdoor exercise not recommended. '
            'Switch to indoor workout today.',
        bannerColor: AppColorsDark.error,
      );
    }
    if (risks.contains(EnvironmentalRisk.aqiVeryPoor)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorPreferred,
        hydrationBoostL: 0.3,
        warningBanner: 'AQI ${env.aqi} — Very Poor air quality. '
            'Indoor workout strongly preferred.',
        bannerColor: AppColorsDark.warning,
      );
    }
    if (risks.contains(EnvironmentalRisk.heatExtreme)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.earlyMorningOrIndoor,
        hydrationBoostL: 0.8,
        warningBanner: 'Heat index ${env.heatIndexC}°C. '
            'Exercise before 7am or indoors. Hydration +800ml.',
        bannerColor: AppColorsDark.warning,
      );
    }
    if (risks.contains(EnvironmentalRisk.heatHigh)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.earlyMorningOrIndoor,
        hydrationBoostL: 0.5,
        warningBanner: 'Heat index ${env.heatIndexC}°C — High. '
            'Stay hydrated. Avoid peak sun hours.',
        bannerColor: AppColorsDark.warning,
      );
    }
    if (risks.contains(EnvironmentalRisk.uvExtreme)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorPreferred,
        hydrationBoostL: 0.2,
        warningBanner: 'UV Index ${env.uvIndex} — Extreme. '
            'Apply sunscreen SPF 50+. Exercise indoors during peak hours.',
        bannerColor: AppColorsDark.warning,
      );
    }
    if (risks.contains(EnvironmentalRisk.aqiPoor)) {
      return EnvironmentalAdaptation(
        workoutRecommendation: WorkoutLocation.indoorPreferred,
        hydrationBoostL: 0.1,
        warningBanner: 'AQI ${env.aqi} — Poor. sensitive groups should exercise indoors.',
        bannerColor: AppColorsDark.warning,
      );
    }
    return EnvironmentalAdaptation.clear();
  }

  /// Adjusts base Daily Missions based on active environmental adaptations.
  DailyMission adjustMission(DailyMission baseMission, EnvironmentalAdaptation adaptation) {
    int adjustedSteps = baseMission.stepGoal;
    String suggestion = baseMission.workoutSuggestion;

    if (adaptation.workoutRecommendation == WorkoutLocation.indoorOnly) {
      adjustedSteps = (baseMission.stepGoal * 0.7).round(); // Mute steps if stuck indoors
      suggestion = 'Indoor Cardio/Yoga (Outdoor blocked: Hazardous AQI)';
    } else if (adaptation.workoutRecommendation == WorkoutLocation.indoorPreferred) {
      suggestion = 'Indoor Treadmill / Strength training preferred';
    } else if (adaptation.workoutRecommendation == WorkoutLocation.earlyMorningOrIndoor) {
      suggestion = 'Early Morning Outdoor Session (before 7 AM) or Indoor Cardio';
    }

    return DailyMission(
      title: baseMission.title,
      stepGoal: adjustedSteps,
      workoutSuggestion: suggestion,
      hydrationGoalL: baseMission.hydrationGoalL + adaptation.hydrationBoostL,
    );
  }
}
