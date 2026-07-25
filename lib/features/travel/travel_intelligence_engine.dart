/// §P12-E Travel Intelligence Engine & Timezone-Aware DIP Scheduler
///
/// Implements automatic travel detection (timezone/location offset shifts),
/// travel-adjusted workout/nutrition adaptations, and per-user timezone DIP scheduling verification (§P12-E spec).
library;

import 'travel_models.dart';

class TravelDetector {
  const TravelDetector();

  /// Detects travel mode from device timezone offset shifts or location names (§P12-E spec).
  TravelContext detect({
    required String origin,
    required String destination,
    required int originOffsetMinutes,
    required int destinationOffsetMinutes,
    DateTime? startDate,
  }) {
    final offsetDelta = (destinationOffsetMinutes - originOffsetMinutes).abs();
    final destLower = destination.toLowerCase();

    TravelMode mode;
    if (destLower.contains('airport') || destLower.contains('terminal') || destLower.contains('gate')) {
      mode = TravelMode.airport;
    } else if (offsetDelta >= 180 || _isInternationalName(origin, destination)) {
      mode = TravelMode.international;
    } else {
      mode = TravelMode.domestic;
    }

    final direction = (destinationOffsetMinutes >= originOffsetMinutes) ? 'East' : 'West';

    return TravelContext(
      origin: origin,
      destination: destination,
      mode: mode,
      originOffsetMinutes: originOffsetMinutes,
      destinationOffsetMinutes: destinationOffsetMinutes,
      startDate: startDate ?? DateTime.now(),
      direction: direction,
    );
  }

  bool _isInternationalName(String origin, String dest) {
    final o = origin.toLowerCase();
    final d = dest.toLowerCase();
    if (o.contains('india') && (d.contains('london') || d.contains('dubai') || d.contains('ny') || d.contains('us') || d.contains('singapore'))) {
      return true;
    }
    return false;
  }
}

class TravelIntelligenceEngine {
  const TravelIntelligenceEngine();

  /// Generates travel-adjusted workout, nutrition, hydration & readiness adaptation.
  TravelAdaptation adapt(TravelContext context) {
    switch (context.mode) {
      case TravelMode.domestic:
        return const TravelAdaptation(
          mode: TravelMode.domestic,
          workoutTitle: '30-min Hotel Bodyweight Session',
          workoutDurationMin: 30,
          workoutDetails: 'Push-ups · Air Squats · Walking Lunges · Plank (No equipment needed)',
          nutritionStrategy: 'Order high-protein hotel options: Grilled paneer, eggs, dal, curd. Avoid deep-fried appetizers.',
          calorieBufferNote: '+150 kcal flexibility buffer for eating out',
          hydrationTargetL: 3.0,
          readinessAdjustment: -5,
          sleepNote: 'Use hotel blackout curtains & maintain home sleep window.',
          travelMissionTitle: 'Domestic Travel Compliance ✈️',
          travelMissionDescription: 'Complete 30-min hotel workout & drink 3.0L water while traveling.',
        );

      case TravelMode.international:
        return TravelAdaptation(
          mode: TravelMode.international,
          workoutTitle: '25-min Express Hotel Workout',
          workoutDurationMin: 25,
          workoutDetails: 'Bodyweight mobility circuits & light cardio flush',
          nutritionStrategy: 'Prioritize lean protein to prevent muscle breakdown. Hydrate aggressively against cabin air dryness.',
          calorieBufferNote: '+200 kcal flexibility buffer for travel days',
          hydrationTargetL: 3.5,
          readinessAdjustment: -12,
          sleepNote: 'Immediate destination sleep alignment. Blackout curtains on.',
          jetLagProtocol: JetLagProtocol(
            direction: context.direction,
            recommendations: [
              'Avoid caffeine 6 hours before destination bedtime.',
              'Get 15 mins of direct morning sunlight at destination ASAP.',
              'Expect readiness to be 10–15% lower for 3 days — normal jetlag adaptation.',
            ],
          ),
          travelMissionTitle: 'International Jetlag Resilience 🌍',
          travelMissionDescription: 'Hydrate 3.5L & get morning sunlight to reset your circadian clock.',
        );

      case TravelMode.airport:
        return const TravelAdaptation(
          mode: TravelMode.airport,
          workoutTitle: 'Airport Terminal Walk (3,000 steps)',
          workoutDurationMin: 30,
          workoutDetails: 'Walk the gate concourse instead of sitting. 30 min = ~3,000 steps.',
          nutritionStrategy: 'Airport survival: Choose salads, grilled sandwiches, almonds/seeds. Avoid pastries & sugary sodas.',
          calorieBufferNote: '+150 kcal airport dining buffer',
          hydrationTargetL: 3.5,
          readinessAdjustment: -5,
          sleepNote: 'Wear eye mask & earplugs for plane naps.',
          travelMissionTitle: 'Airport Concourse Walk 🚶‍♂️',
          travelMissionDescription: 'Log 3,000 steps by walking the gate terminal before departure.',
        );

      case TravelMode.none:
        return const TravelAdaptation(
          mode: TravelMode.none,
          workoutTitle: 'Standard Workout',
          workoutDurationMin: 45,
          workoutDetails: 'Scheduled routine',
          nutritionStrategy: 'Standard daily targets',
          calorieBufferNote: 'No buffer',
          hydrationTargetL: 2.5,
          readinessAdjustment: 0,
          sleepNote: 'Standard sleep schedule',
          travelMissionTitle: 'Daily Home Target',
          travelMissionDescription: 'Hit your regular daily targets.',
        );
    }
  }

  /// 🔒 v1.0 Hardening Verification Helper: Per-User Timezone DIP Scheduler (§P12-E / §P0-C)
  ///
  /// Verifies that DIP generation is scheduled according to the user's active local time
  /// (taking into account their home or Travel Mode destination timezone offset).
  static bool isUserDueForDIP({
    required int preferredDIPHour,
    required int timezoneOffsetMinutes,
    required DateTime utcTime,
  }) {
    // Convert UTC time to user's local time by adding their configured timezone offset
    final localTime = utcTime.add(Duration(minutes: timezoneOffsetMinutes));
    return localTime.hour == preferredDIPHour;
  }
}
