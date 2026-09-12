enum WearableDeviceTier {
  tier1MedicalGrade, // Apple Watch, Garmin, Pixel Watch, Polar
  tier2MidTier, // Fitbit, Samsung Galaxy Watch, Amazfit
  tier3Budget, // Noise, Boat, Fire-Boltt, RealMe
  tier4Manual, // Manual User Entry
}

class WearableSample {
  final String id;
  final String source; // 'health_connect', 'healthkit', 'apple_watch', 'garmin', 'manual'
  final String metric; // 'steps', 'heart_rate', 'hrv_rmssd', 'sleep_stage', 'active_calories'
  final double value;
  final String unit; // 'count', 'bpm', 'ms', 'minutes', 'kcal'
  final DateTime timestamp;

  const WearableSample({
    required this.id,
    required this.source,
    required this.metric,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'metric': metric,
        'value': value,
        'unit': unit,
        'timestamp': timestamp.toIso8601String(),
      };
}

enum BiomarkerType { bloodPressure, fastingGlucose, postMealGlucose, hba1c, lipidProfile }

class BiomarkerReading {
  final String id;
  final String source; // 'manual', 'cgm', 'lab_report'
  final BiomarkerType type;
  final double primaryValue; // e.g. Systolic BP (120) or Fasting Glucose (95)
  final double? secondaryValue; // e.g. Diastolic BP (80)
  final String unit;
  final String? note;
  final DateTime measuredAt;

  const BiomarkerReading({
    required this.id,
    required this.source,
    required this.type,
    required this.primaryValue,
    this.secondaryValue,
    required this.unit,
    this.note,
    required this.measuredAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'type': type.name,
        'primary_value': primaryValue,
        'secondary_value': secondaryValue,
        'unit': unit,
        'note': note,
        'measured_at': measuredAt.toIso8601String(),
      };
}

class CgmTelemetryPoint {
  final String id;
  final double glucoseMgDl;
  final String trendArrow; // 'flat', 'rising_slow', 'rising_fast', 'falling_slow', 'falling_fast'
  final String? associatedMealId;
  final DateTime recordedAt;

  const CgmTelemetryPoint({
    required this.id,
    required this.glucoseMgDl,
    required this.trendArrow,
    this.associatedMealId,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'glucose_mg_dl': glucoseMgDl,
        'trend_arrow': trendArrow,
        'associated_meal_id': associatedMealId,
        'recorded_at': recordedAt.toIso8601String(),
      };
}
