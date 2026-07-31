/// Medication Log Model
class MedicationLog {
  final String id;
  final String medicationName;
  final String dosage;
  final String scheduledTime;
  final bool isTaken;

  const MedicationLog({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.scheduledTime,
    this.isTaken = false,
  });
}

/// CGM Spike Event Log
class CgmSpikeEvent {
  final String id;
  final double glucoseMgDl;
  final String timestamp;
  final String triggeredMeal;

  const CgmSpikeEvent({
    required this.id,
    required this.glucoseMgDl,
    required this.timestamp,
    required this.triggeredMeal,
  });
}
