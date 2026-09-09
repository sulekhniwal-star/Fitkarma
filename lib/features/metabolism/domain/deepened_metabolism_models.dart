import 'package:flutter/foundation.dart';
import 'adaptive_metabolism_engine.dart';

/// Ayurvedic Digestive Agni (Metabolic Fire) states
enum JatharagniState {
  samagni(
    name: 'Samagni (Optimal Balanced Metabolism)',
    regionalName: 'समाग्नि (संतुलित व आदर्श चयापचय)',
    description: 'Effortless digestion, regular hunger, stable blood sugar, and zero bloating.',
  ),
  mandagni(
    name: 'Mandagni (Sluggish / Suppressed Metabolism)',
    regionalName: 'मंदाग्नि (धीमा चयापचय व कफ दोष)',
    description: 'Sluggish digestion, slow gastric emptying, fatigue after meals, and easy weight gain.',
  ),
  tikshnagni(
    name: 'Tikshnagni (Hyperactive / Acidic Metabolism)',
    regionalName: 'तीक्ष्णाग्नि (अति-सक्रिय चयापचय व पित्त दोष)',
    description: 'Excessive heat, rapid hunger, acid reflux, and high metabolic turnover.',
  ),
  vishmagni(
    name: 'Vishamagni (Irregular / Volatile Metabolism)',
    regionalName: 'विषमाग्नि (अनियमित चयापचय व वात दोष)',
    description: 'Fluctuating hunger, erratic digestion, post-meal gas, and bloating.',
  );

  final String name;
  final String regionalName;
  final String description;

  const JatharagniState({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Refeed / Diet Break recommendation protocol
enum RefeedProtocol {
  none(
    name: 'Standard Caloric Deficit',
    regionalName: 'नियमित कैलोरी घाटा',
    extraCalories: 0,
    carbBoostGrams: 0,
    rationale: 'Metabolism is normal with no adaptive down-regulation.',
  ),
  twoDayRefeed(
    name: '48-Hour Leptin & Glycogen Refeed',
    regionalName: '४८-घंटे लेप्टिन व ग्लाइकोजन रीफीड',
    extraCalories: 350,
    carbBoostGrams: 75,
    rationale: 'Temporarily raises leptin, restores muscle glycogen, and blunts thyroid suppression.',
  ),
  fullDietBreak(
    name: '7-Day Maintenance Diet Break',
    regionalName: '७-दिवसीय आहार विराम (मेंटेनेंस ब्रेक)',
    extraCalories: 450,
    carbBoostGrams: 100,
    rationale: 'Full reset of basal metabolic rate after 6+ weeks of sustained caloric restriction.',
  );

  final String name;
  final String regionalName;
  final int extraCalories;
  final int carbBoostGrams;
  final String rationale;

  const RefeedProtocol({
    required this.name,
    required this.regionalName,
    required this.extraCalories,
    required this.carbBoostGrams,
    required this.rationale,
  });
}

/// Component decomposition of Total Daily Energy Expenditure (TDEE)
@immutable
class EnergyExpenditureDecomposition {
  final double bmrCalories; // Basal Metabolic Rate (~60-70%)
  final double tefCalories; // Thermic Effect of Food (~10-15%)
  final double eatCalories; // Exercise Activity Thermogenesis (~5-15%)
  final double neatCalories; // Non-Exercise Activity Thermogenesis (~15-20%)
  final double totalDecomposedTdee;

  const EnergyExpenditureDecomposition({
    required this.bmrCalories,
    required this.tefCalories,
    required this.eatCalories,
    required this.neatCalories,
    required this.totalDecomposedTdee,
  });
}

/// Training Day vs Rest Day Macro Split
@immutable
class MacroCyclingPlan {
  final int trainingDayCalories;
  final int trainingDayProteinGrams;
  final int trainingDayCarbsGrams;
  final int trainingDayFatsGrams;

  final int restDayCalories;
  final int restDayProteinGrams;
  final int restDayCarbsGrams;
  final int restDayFatsGrams;

  const MacroCyclingPlan({
    required this.trainingDayCalories,
    required this.trainingDayProteinGrams,
    required this.trainingDayCarbsGrams,
    required this.trainingDayFatsGrams,
    required this.restDayCalories,
    required this.restDayProteinGrams,
    required this.restDayCarbsGrams,
    required this.restDayFatsGrams,
  });
}

/// Deepened Adaptive Metabolism Comprehensive Report
@immutable
class DeepenedMetabolismReport {
  final AdaptiveMetabolismProfile baseProfile;
  final EnergyExpenditureDecomposition decomposition;
  final double adaptiveThermogenesisDeltaKcal; // Difference between expected and true expenditure
  final double metabolicResistanceScore; // 0 to 100
  final bool isMetabolicAdaptationSevere;
  final JatharagniState jatharagniState;
  final RefeedProtocol recommendedRefeed;
  final MacroCyclingPlan macroCycling;
  final String circadianAgniMealTip;
  final String regionalCircadianAgniMealTip;
  final DateTime synthesizedAt;

  const DeepenedMetabolismReport({
    required this.baseProfile,
    required this.decomposition,
    required this.adaptiveThermogenesisDeltaKcal,
    required this.metabolicResistanceScore,
    required this.isMetabolicAdaptationSevere,
    required this.jatharagniState,
    required this.recommendedRefeed,
    required this.macroCycling,
    required this.circadianAgniMealTip,
    required this.regionalCircadianAgniMealTip,
    required this.synthesizedAt,
  });
}
