import 'package:flutter/foundation.dart';

/// Inferred Autonomic Stress Classification Tier
enum StressLevelTier {
  calm(
    label: 'Calm & Restorative (Shanta)',
    regionalLabel: 'शांत व तनावमुक्त (प्रसन्न मन)',
    scoreRange: '0 - 25',
    colorCode: 0xFF00E676,
    description: 'Robust parasympathetic vagal tone; physiological recovery is high.',
    regionalDescription: 'वेगल नर्व सक्रिय है; शरीर व मस्तिष्क पूर्णतः तनावमुक्त हैं।',
  ),
  eustress(
    label: 'Engaged / Focused Eustress (Sachet)',
    regionalLabel: 'सचेत व एकाग्र (सकारात्मक ऊर्जा)',
    scoreRange: '26 - 50',
    colorCode: 0xFF448AFF,
    description: 'Optimal productive arousal with controlled autonomic reactivity.',
    regionalDescription: 'उत्पादक व सकारात्मक ऊर्जा; मानसिक एकाग्रता उच्च स्तर पर है।',
  ),
  elevated(
    label: 'Elevated Distress (Tanaav)',
    regionalLabel: 'तनावग्रस्त (मानसिक व शारीरिक दबाव)',
    scoreRange: '51 - 75',
    colorCode: 0xFFFFB300,
    description: 'Sympathetic tone dominance and suppressed heart rate variability.',
    regionalDescription: 'सहानुभूति तंत्रिका सक्रिय; हृदय परिवर्तनशीलता में कमी दर्ज।',
  ),
  acuteOverload(
    label: 'Sympathetic Overload (Ati-Tanaav)',
    regionalLabel: 'अत्यधिक तनाव (तुरंत शांति आवश्यक)',
    scoreRange: '76 - 100',
    colorCode: 0xFFFF5252,
    description: 'Severe autonomic strain; immediate vagal down-regulation recommended.',
    regionalDescription: 'तीव्र न्यूरोलॉजिकल दबाव; प्राणायाम व विश्राम अत्यंत आवश्यक।',
  );

  final String label;
  final String regionalLabel;
  final String scoreRange;
  final int colorCode;
  final String description;
  final String regionalDescription;

  const StressLevelTier({
    required this.label,
    required this.regionalLabel,
    required this.scoreRange,
    required this.colorCode,
    required this.description,
    required this.regionalDescription,
  });
}

/// Stress biomarker signal contributor
enum StressSignalType {
  hrvSuppression(name: 'HRV Vagal Suppression', regionalName: 'हृदय गति परिवर्तनशीलता में कमी'),
  sedentaryPulseSpike(name: 'Sedentary Heart Rate Spikes', regionalName: 'अक्रिय अवस्था में हृदय गति वृद्धि'),
  respirationRate(name: 'Elevated Respiration Rate', regionalName: 'तीव्र श्वसन गति'),
  sleepFragmentation(name: 'Nocturnal Restlessness', regionalName: 'रात में नींद में व्यवधान व बेचैनी'),
  screenBehaviorTension(name: 'Digital Device Tension', regionalName: 'स्क्रीन पर तीव्र प्रतिक्रिया व तनाव');

  final String name;
  final String regionalName;

  const StressSignalType({
    required this.name,
    required this.regionalName,
  });
}

/// Evaluated stress biomarker contributor
@immutable
class InferredStressSignal {
  final StressSignalType signalType;
  final double measuredValue;
  final String unit;
  final double baselineValue;
  final double stressPointsContribution; // 0 to 30 pts
  final String insight;
  final String regionalInsight;

  const InferredStressSignal({
    required this.signalType,
    required this.measuredValue,
    required this.unit,
    required this.baselineValue,
    required this.stressPointsContribution,
    required this.insight,
    required this.regionalInsight,
  });
}

/// Hourly Intraday Stress Reading (24-hour cycle)
@immutable
class HourlyStressReading {
  final int hour; // 0 to 23
  final String hourLabel; // e.g. "09:00", "14:00"
  final double stressScore; // 0 to 100
  final StressLevelTier tier;
  final double averageHeartRate;
  final double averageRmssd;

  const HourlyStressReading({
    required this.hour,
    required this.hourLabel,
    required this.stressScore,
    required this.tier,
    required this.averageHeartRate,
    required this.averageRmssd,
  });
}

/// Actionable Vagal Reset & Pranayama Intervention
@immutable
class VagalRecoveryProtocol {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final String breathingCadence; // e.g. "Inhale 4s • Hold 7s • Exhale 8s"
  final int durationMinutes;
  final int karmaReward;

  const VagalRecoveryProtocol({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.breathingCadence,
    required this.durationMinutes,
    required this.karmaReward,
  });
}

/// Comprehensive Inferred Stress Report
@immutable
class InferredStressReport {
  final double currentStressScore; // 0 to 100
  final StressLevelTier currentTier;
  final double dailyAverageStressScore;
  final int peakStressHour; // e.g. 15 (3 PM)
  final int calmestHour; // e.g. 6 (6 AM)
  final double totalHighStressMinutes; // minutes in elevated/overload
  final List<InferredStressSignal> activeSignals;
  final List<HourlyStressReading> intradayTimeline24h;
  final List<VagalRecoveryProtocol> recommendedProtocols;
  final String clinicalAutonomicSummary;
  final String regionalClinicalAutonomicSummary;
  final DateTime assessedAt;

  const InferredStressReport({
    required this.currentStressScore,
    required this.currentTier,
    required this.dailyAverageStressScore,
    required this.peakStressHour,
    required this.calmestHour,
    required this.totalHighStressMinutes,
    required this.activeSignals,
    required this.intradayTimeline24h,
    required this.recommendedProtocols,
    required this.clinicalAutonomicSummary,
    required this.regionalClinicalAutonomicSummary,
    required this.assessedAt,
  });
}
