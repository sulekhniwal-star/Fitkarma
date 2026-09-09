import 'adaptive_metabolism_engine.dart';
import 'deepened_metabolism_models.dart';

/// Pure Dart Deterministic Engine for Deepened Adaptive Metabolism, Expenditure Decomposition,
/// and Leptin Refeed Cycling
class DeepenedMetabolismEngine {
  const DeepenedMetabolismEngine();

  /// Synthesizes complete multi-vector deepened adaptive metabolism report
  DeepenedMetabolismReport synthesizeDeepenedMetabolism({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
    required NutritionGoal goal,
    double? bodyFatPercentage,
    double activityMultiplier = 1.375,
    double? avgDailyIntake14Days,
    double? weightDelta14DaysKg,
    int dailySteps = 8000,
    int workoutMinutesDaily = 45,
    int weeksInDeficit = 0,
  }) {
    // 1. Calculate Base Profile
    final baseProfile = AdaptiveMetabolismEngine.computeMetabolism(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      goal: goal,
      activityMultiplier: activityMultiplier,
      avgDailyIntake14Days: avgDailyIntake14Days,
      weightDelta14DaysKg: weightDelta14DaysKg,
    );

    // 2. Compute Accurate BMR (Katch-McArdle if lean mass available, else Mifflin-St Jeor)
    final double bmr;
    if (bodyFatPercentage != null && bodyFatPercentage > 5 && bodyFatPercentage < 60) {
      final leanMassKg = weightKg * (1 - (bodyFatPercentage / 100.0));
      bmr = 370 + (21.6 * leanMassKg);
    } else {
      bmr = baseProfile.bmr;
    }

    // 3. Decompose Energy Expenditure (BMR + TEF + EAT + NEAT)
    final tef = (baseProfile.targetCalories * 0.12).clamp(150.0, 450.0);
    final eat = (workoutMinutesDaily * 7.5).clamp(0.0, 800.0);
    final neat = (dailySteps * 0.045).clamp(150.0, 900.0);
    final totalDecomposed = bmr + tef + eat + neat;

    final decomposition = EnergyExpenditureDecomposition(
      bmrCalories: double.parse(bmr.toStringAsFixed(1)),
      tefCalories: double.parse(tef.toStringAsFixed(1)),
      eatCalories: double.parse(eat.toStringAsFixed(1)),
      neatCalories: double.parse(neat.toStringAsFixed(1)),
      totalDecomposedTdee: double.parse(totalDecomposed.toStringAsFixed(1)),
    );

    // 4. Adaptive Thermogenesis Delta
    final double atDeltaKcal = baseProfile.dynamicTdee - baseProfile.staticTdee;
    final bool isSevereAdaptation = baseProfile.adaptationFactor < 0.88;

    // 5. Metabolic Resistance Score (0 to 100)
    // Measures resistance to fat loss from down-regulated NEAT/thyroid
    double resistanceScore = 0;
    if (baseProfile.adaptationFactor < 1.0) {
      final deficitPenalty = (1.0 - baseProfile.adaptationFactor) * 250;
      final timePenalty = weeksInDeficit * 4.5;
      resistanceScore = (deficitPenalty + timePenalty).clamp(0.0, 100.0);
    }

    // 6. Jatharagni (Digestive Metabolic Fire) State
    final JatharagniState jatharagni;
    if (baseProfile.adaptationFactor < 0.90) {
      jatharagni = JatharagniState.mandagni;
    } else if (baseProfile.adaptationFactor > 1.10) {
      jatharagni = JatharagniState.tikshnagni;
    } else if (baseProfile.adaptationFactor >= 0.92 && baseProfile.adaptationFactor <= 1.06) {
      jatharagni = JatharagniState.samagni;
    } else {
      jatharagni = JatharagniState.vishmagni;
    }

    // 7. Refeed / Diet Break Protocol
    final RefeedProtocol refeed;
    if (weeksInDeficit >= 6 && isSevereAdaptation) {
      refeed = RefeedProtocol.fullDietBreak;
    } else if (weeksInDeficit >= 3 && baseProfile.adaptationFactor < 0.93) {
      refeed = RefeedProtocol.twoDayRefeed;
    } else {
      refeed = RefeedProtocol.none;
    }

    // 8. Macro-Cycling splits (Training Day vs Rest Day)
    final targetCal = baseProfile.targetCalories;
    final trainingCalories = targetCal + 150;
    final trainingProtein = baseProfile.targetProteinGrams;
    final trainingCarbs = baseProfile.targetCarbsGrams + 35;
    final trainingFats = ((trainingCalories - (trainingProtein * 4) - (trainingCarbs * 4)) / 9).round();

    final restCalories = targetCal - 150;
    final restProtein = baseProfile.targetProteinGrams;
    final restCarbs = (baseProfile.targetCarbsGrams - 35).clamp(40, 500);
    final restFats = ((restCalories - (restProtein * 4) - (restCarbs * 4)) / 9).round().clamp(30, 150);

    final macroCycling = MacroCyclingPlan(
      trainingDayCalories: trainingCalories,
      trainingDayProteinGrams: trainingProtein,
      trainingDayCarbsGrams: trainingCarbs,
      trainingDayFatsGrams: trainingFats,
      restDayCalories: restCalories,
      restDayProteinGrams: restProtein,
      restDayCarbsGrams: restCarbs,
      restDayFatsGrams: restFats,
    );

    // 9. Circadian Chrono-Nutrition Agni Tip
    final mealTip = _generateAgniTip(jatharagni);

    return DeepenedMetabolismReport(
      baseProfile: baseProfile,
      decomposition: decomposition,
      adaptiveThermogenesisDeltaKcal: double.parse(atDeltaKcal.toStringAsFixed(1)),
      metabolicResistanceScore: double.parse(resistanceScore.toStringAsFixed(1)),
      isMetabolicAdaptationSevere: isSevereAdaptation,
      jatharagniState: jatharagni,
      recommendedRefeed: refeed,
      macroCycling: macroCycling,
      circadianAgniMealTip: mealTip.english,
      regionalCircadianAgniMealTip: mealTip.hindi,
      synthesizedAt: DateTime.now(),
    );
  }

  _AgniTip _generateAgniTip(JatharagniState state) {
    switch (state) {
      case JatharagniState.samagni:
        return const _AgniTip(
          english: 'Digestive fire is perfectly balanced. Consume 45% of daily calories between 12:00 - 14:00 (Solar Peak) and keep dinner light before 20:00.',
          hindi: 'जठराग्नि संतुलित है। मध्याह्न १२ से २ बजे के बीच ४५% मुख्य आहार लें तथा रात्रि भोजन हल्का रखें।',
        );
      case JatharagniState.mandagni:
        return const _AgniTip(
          english: 'Metabolic adaptation has suppressed digestive rate. Sip warm ginger water 20 min before meals and incorporate 1000-pace post-meal Shatapadi.',
          hindi: 'मंदाग्नि सक्रिय है। भोजन से २० मिनट पूर्व अदरक जल पिएं तथा भोजनोपरांत १००० कदम शतपावली अवश्य करें।',
        );
      case JatharagniState.tikshnagni:
        return const _AgniTip(
          english: 'Elevated Pitta metabolic heat. Prioritize cooling grains (barley, soaked chia) and avoid excessive chilies or fried spices.',
          hindi: 'तीक्ष्णाग्नि व पित्त अधिक है। जौ, चिया व शीतल आहार को प्राथमिकता दें तथा अधिक मिर्च-मसाले से बचें।',
        );
      case JatharagniState.vishmagni:
        return const _AgniTip(
          english: 'Vata erratic digestion. Maintain fixed meal timings every 4 hours, consume warm cooked stews, and avoid dry raw salads.',
          hindi: 'विषमाग्नि व वात दोष है। प्रत्येक ४ घंटे पर नियमित समय पर गर्म व ताजा भोजन लें, कच्चे सलाद से बचें।',
        );
    }
  }
}

class _AgniTip {
  final String english;
  final String hindi;
  const _AgniTip({required this.english, required this.hindi});
}
