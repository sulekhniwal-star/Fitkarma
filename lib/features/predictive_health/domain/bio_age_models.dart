import 'package:flutter/foundation.dart';

/// Biological organ & physiological subsystem domains
enum OrganSystemType {
  cardiovascular(
    name: 'Cardiovascular System',
    regionalName: 'हृदय संवहनी तंत्र',
    iconName: 'favorite',
    description: 'Heart rate efficiency, arterial stiffness & autonomic tone',
    regionalDescription: 'हृदय गति दक्षता, धमनी लचीलापन व स्वायत्त टोन',
  ),
  metabolic(
    name: 'Metabolic & Glycemic System',
    regionalName: 'उपापचयी व शर्करा संतुलन तंत्र',
    iconName: 'bolt',
    description: 'Insulin sensitivity, visceral adiposity & lipid balance',
    regionalDescription: 'इंसुलिन संवेदनशीलता, आंतरिक चर्बी व लिपिड संतुलन',
  ),
  musculoskeletal(
    name: 'Cardiorespiratory & Musculoskeletal',
    regionalName: 'मांसपेशी, अस्थि व फेफड़े की कार्यक्षमता',
    iconName: 'fitness_center',
    description: 'VO2 Max aerobic reserve, lean muscle mass & movement density',
    regionalDescription: 'VO2 Max एरोबिक क्षमता, मांसपेशी द्रव्यमान व दैनिक सक्रियता',
  ),
  cellularRecovery(
    name: 'Cellular Recovery & Neuro-Circadian',
    regionalName: 'कोशिकीय पुनर्जनन व जैविक घड़ी',
    iconName: 'nights_stay',
    description: 'Deep sleep architecture, chronic debt clearance & vagal recovery',
    regionalDescription: 'गहरी नींद संरचना, नींद ऋण निवारण व तनाव मुक्ति',
  );

  final String name;
  final String regionalName;
  final String iconName;
  final String description;
  final String regionalDescription;

  const OrganSystemType({
    required this.name,
    required this.regionalName,
    required this.iconName,
    required this.description,
    required this.regionalDescription,
  });
}

/// Aging pace velocity classification
enum AgingPaceStatus {
  rejuvenating(
    label: 'Decelerated (Rejuvenating)',
    regionalLabel: 'धीमी जैविक आयु गति (पुनर्जनन)',
    description: 'Aging slower than chronological time passage',
    regionalDescription: 'वास्तविक समय की तुलना में शरीर धीमी गति से वृद्ध हो रहा है',
    colorCode: 0xFF00E676,
  ),
  equilibrium(
    label: 'Normal Equilibrium',
    regionalLabel: 'संतुलित गति (सामान्य स्तर)',
    description: 'Aging at normal physiological rate (1.0x pace)',
    regionalDescription: 'शरीर सामान्य व संतुलित गति से बढ़ रहा है',
    colorCode: 0xFF448AFF,
  ),
  accelerated(
    label: 'Accelerated Aging',
    regionalLabel: 'तीव्र जैविक आयु गति (सतर्कता आवश्यक)',
    description: 'Aging faster than chronological time passage',
    regionalDescription: 'शरीर वास्तविक समय की तुलना में तेजी से वृद्ध हो रहा है',
    colorCode: 0xFFFF5252,
  );

  final String label;
  final String regionalLabel;
  final String description;
  final String regionalDescription;
  final int colorCode;

  const AgingPaceStatus({
    required this.label,
    required this.regionalLabel,
    required this.description,
    required this.regionalDescription,
    required this.colorCode,
  });
}

/// Evaluated system biological age
@immutable
class OrganSystemAge {
  final OrganSystemType system;
  final double estimatedAge;
  final double chronologicalAge;
  final double ageDelta; // estimatedAge - chronologicalAge
  final double performanceScore; // 0 to 100%
  final String keyBiomarkerSummary;
  final String regionalKeyBiomarkerSummary;

  const OrganSystemAge({
    required this.system,
    required this.estimatedAge,
    required this.chronologicalAge,
    required this.ageDelta,
    required this.performanceScore,
    required this.keyBiomarkerSummary,
    required this.regionalKeyBiomarkerSummary,
  });
}

/// Impact status of an individual biomarker
enum BiomarkerImpactType {
  rejuvenating, // Reduces biological age
  neutral,      // Minimal deviation
  accelerating, // Adds years to biological age
}

/// Individual Biomarker Contribution to Biological Age
@immutable
class BiomarkerAgeContribution {
  final String id;
  final OrganSystemType system;
  final String name;
  final String regionalName;
  final double measuredValue;
  final String unit;
  final double optimalReference;
  final double yearsImpact; // negative = younger, positive = older
  final BiomarkerImpactType impactType;
  final String clinicalRationale;
  final String regionalClinicalRationale;

  const BiomarkerAgeContribution({
    required this.id,
    required this.system,
    required this.name,
    required this.regionalName,
    required this.measuredValue,
    required this.unit,
    required this.optimalReference,
    required this.yearsImpact,
    required this.impactType,
    required this.clinicalRationale,
    required this.regionalClinicalRationale,
  });
}

/// Actionable rejuvenation lever with deterministic age reduction potential
@immutable
class RejuvenationLever {
  final String id;
  final OrganSystemType targetedSystem;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final double potentialYearsSaved; // e.g. 1.2 years
  final String timeframe; // e.g. "8-12 weeks"
  final String difficulty; // "Gentle", "Moderate", "Rigorous"
  final int karmaReward;

  const RejuvenationLever({
    required this.id,
    required this.targetedSystem,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.potentialYearsSaved,
    required this.timeframe,
    required this.difficulty,
    required this.karmaReward,
  });
}

/// Longitudinal Monthly Snapshot for Bio-Age Trajectory Tracking
@immutable
class MonthlyBioAgeSnapshot {
  final DateTime date;
  final String monthLabel;
  final double chronologicalAge;
  final double biologicalAge;
  final double agingPace; // e.g. 0.84 yrs/yr
  final double metabolicAge;
  final double cardiovascularAge;
  final double musculoskeletalAge;
  final double recoveryAge;

  const MonthlyBioAgeSnapshot({
    required this.date,
    required this.monthLabel,
    required this.chronologicalAge,
    required this.biologicalAge,
    required this.agingPace,
    required this.metabolicAge,
    required this.cardiovascularAge,
    required this.musculoskeletalAge,
    required this.recoveryAge,
  });
}

/// Comprehensive Biological Age Estimation Report
@immutable
class BiologicalAgeReport {
  final double chronologicalAge;
  final double biologicalAge;
  final double ageDelta; // biologicalAge - chronologicalAge (negative is younger)
  final double agingPace; // years aged per calendar year (e.g. 0.88x)
  final AgingPaceStatus paceStatus;
  final List<OrganSystemAge> systemAges;
  final List<BiomarkerAgeContribution> biomarkerContributions;
  final List<RejuvenationLever> topRejuvenationLevers;
  final List<MonthlyBioAgeSnapshot> trajectory12Months;
  final String topRejuvenatingAsset;
  final String regionalTopRejuvenatingAsset;
  final String primaryAgingDriver;
  final String regionalPrimaryAgingDriver;
  final DateTime calculatedAt;

  const BiologicalAgeReport({
    required this.chronologicalAge,
    required this.biologicalAge,
    required this.ageDelta,
    required this.agingPace,
    required this.paceStatus,
    required this.systemAges,
    required this.biomarkerContributions,
    required this.topRejuvenationLevers,
    required this.trajectory12Months,
    required this.topRejuvenatingAsset,
    required this.regionalTopRejuvenatingAsset,
    required this.primaryAgingDriver,
    required this.regionalPrimaryAgingDriver,
    required this.calculatedAt,
  });
}
