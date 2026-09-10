import 'package:flutter/foundation.dart';

/// Medication category
enum MedicationType {
  allopathicPrescription(
      name: 'Allopathic Prescription',
      regionalName: 'एलोपैथिक प्रिस्क्रिप्शन',
      iconName: 'medication'),
  ayurvedicHerb(
      name: 'Ayurvedic Rasayana / Herb',
      regionalName: 'आयुर्वेदिक जड़ी-बूटी / रसायन',
      iconName: 'eco'),
  supplementVitamin(
      name: 'Nutritional Supplement',
      regionalName: 'विटामिन व पोषक सप्लीमेंट',
      iconName: 'vaccines');

  final String name;
  final String regionalName;
  final String iconName;

  const MedicationType({
    required this.name,
    required this.regionalName,
    required this.iconName,
  });
}

/// Timing of medication dose
enum DoseTiming {
  morningEmptyStomach(
      label: 'Morning (Empty Stomach)',
      regionalLabel: 'सुबह (खाली पेट)',
      timeOfDay: '07:00 AM'),
  morningAfterBreakfast(
      label: 'Morning (After Breakfast)',
      regionalLabel: 'सुबह (नाश्ते के बाद)',
      timeOfDay: '08:30 AM'),
  afternoonPostLunch(
      label: 'Afternoon (Post Lunch)',
      regionalLabel: 'दोपहर (भोजनोपरांत)',
      timeOfDay: '01:30 PM'),
  evening(label: 'Evening', regionalLabel: 'शाम', timeOfDay: '06:00 PM'),
  nightBeforeBed(
      label: 'Night (Before Bed)',
      regionalLabel: 'रात (सोने से पूर्व)',
      timeOfDay: '10:00 PM');

  final String label;
  final String regionalLabel;
  final String timeOfDay;

  const DoseTiming({
    required this.label,
    required this.regionalLabel,
    required this.timeOfDay,
  });
}

/// Interaction Clinical Severity
enum InteractionSeverity {
  critical(
    label: 'Critical Contraindication (Gambhir)',
    regionalLabel: 'गंभीर परस्पर विरोध (तुरंत डॉक्टर से परामर्श करें)',
    colorCode: 0xFFFF5252,
  ),
  moderate(
    label: 'Moderate Precaution (Satark)',
    regionalLabel: 'मध्यम सावधानी (समय अंतराल रखें)',
    colorCode: 0xFFFFB300,
  ),
  minor(
    label: 'Minor Timing Advice (Sachet)',
    regionalLabel: 'सामान्य समय निर्देश (भोजन के साथ लें)',
    colorCode: 0xFF448AFF,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;

  const InteractionSeverity({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
  });
}

/// Individual Tracked Medication or Ayurvedic Rasayana
@immutable
class TrackedMedication {
  final String id;
  final String name;
  final String regionalName;
  final String genericOrHerbName;
  final MedicationType type;
  final String dosage; // e.g. "500 mg", "1 tablet", "2 capsules"
  final DoseTiming timing;
  final bool isTakenToday;
  final int totalPillsRemaining;
  final String clinicalPurpose;
  final String regionalClinicalPurpose;

  const TrackedMedication({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.genericOrHerbName,
    required this.type,
    required this.dosage,
    required this.timing,
    required this.isTakenToday,
    required this.totalPillsRemaining,
    required this.clinicalPurpose,
    required this.regionalClinicalPurpose,
  });

  TrackedMedication copyWith({
    bool? isTakenToday,
    int? totalPillsRemaining,
  }) {
    return TrackedMedication(
      id: id,
      name: name,
      regionalName: regionalName,
      genericOrHerbName: genericOrHerbName,
      type: type,
      dosage: dosage,
      timing: timing,
      isTakenToday: isTakenToday ?? this.isTakenToday,
      totalPillsRemaining: totalPillsRemaining ?? this.totalPillsRemaining,
      clinicalPurpose: clinicalPurpose,
      regionalClinicalPurpose: regionalClinicalPurpose,
    );
  }
}

/// Detected Drug-Drug or Herb-Drug Interaction
@immutable
class MedicationInteractionAlert {
  final String id;
  final String primaryAgent; // e.g. "Aspirin 75mg"
  final String secondaryAgent; // e.g. "Curcumin / Turmeric 1000mg"
  final InteractionSeverity severity;
  final String interactionMechanism;
  final String regionalInteractionMechanism;
  final String clinicalAction;
  final String regionalClinicalAction;
  final String
      safeSpacingGuideline; // e.g. "Separate intake by at least 3 hours"

  const MedicationInteractionAlert({
    required this.id,
    required this.primaryAgent,
    required this.secondaryAgent,
    required this.severity,
    required this.interactionMechanism,
    required this.regionalInteractionMechanism,
    required this.clinicalAction,
    required this.regionalClinicalAction,
    required this.safeSpacingGuideline,
  });
}

/// Comprehensive Medication & Interaction Safety Report
@immutable
class MedicationScheduleReport {
  final List<TrackedMedication> activeMedications;
  final List<MedicationInteractionAlert> detectedInteractions;
  final double adherenceScorePercent; // e.g. 94%
  final int dosesTakenToday;
  final int totalDosesToday;
  final bool hasCriticalContraindication;
  final String clinicalSafetySummary;
  final String regionalClinicalSafetySummary;
  final DateTime lastUpdated;

  const MedicationScheduleReport({
    required this.activeMedications,
    required this.detectedInteractions,
    required this.adherenceScorePercent,
    required this.dosesTakenToday,
    required this.totalDosesToday,
    required this.hasCriticalContraindication,
    required this.clinicalSafetySummary,
    required this.regionalClinicalSafetySummary,
    required this.lastUpdated,
  });
}
