/// §P12-E Travel Intelligence — Domain Models & Data Structures
///
/// Models for TravelMode, TravelContext, TravelAdaptation, and DIP Timezone Scheduling matching §P12-E spec.
library;

enum TravelMode {
  domestic, // Domestic flight / train (same or minor timezone shift)
  international, // Long-haul flight / major timezone shift
  airport, // In transit / airport terminal
  none, // Home location
}

class TravelContext {
  const TravelContext({
    required this.origin,
    required this.destination,
    required this.mode,
    required this.originOffsetMinutes,
    required this.destinationOffsetMinutes,
    required this.startDate,
    this.endDate,
    this.direction = 'West',
    this.isActive = true,
  });

  final String origin; // e.g. 'Delhi'
  final String destination; // e.g. 'London'
  final TravelMode mode;
  final int originOffsetMinutes; // e.g. +330 (IST)
  final int destinationOffsetMinutes; // e.g. +0 (GMT)
  final DateTime startDate;
  final DateTime? endDate;
  final String direction; // 'East' vs 'West'
  final bool isActive;

  int get timezoneDeltaHours =>
      ((destinationOffsetMinutes - originOffsetMinutes) / 60.0).abs().round();
}

class JetLagProtocol {
  const JetLagProtocol({
    required this.direction,
    required this.recommendations,
  });

  final String direction;
  final List<String> recommendations;
}

class TravelAdaptation {
  const TravelAdaptation({
    required this.mode,
    required this.workoutTitle,
    required this.workoutDurationMin,
    required this.workoutDetails,
    required this.nutritionStrategy,
    required this.calorieBufferNote,
    required this.hydrationTargetL,
    required this.readinessAdjustment,
    required this.sleepNote,
    this.jetLagProtocol,
    required this.travelMissionTitle,
    required this.travelMissionDescription,
  });

  final TravelMode mode;
  final String workoutTitle;
  final int workoutDurationMin;
  final String workoutDetails;
  final String nutritionStrategy;
  final String calorieBufferNote;
  final double hydrationTargetL;
  final int readinessAdjustment; // e.g. -5% to -15%
  final String sleepNote;
  final JetLagProtocol? jetLagProtocol;
  final String travelMissionTitle;
  final String travelMissionDescription;
}
