import 'package:flutter/foundation.dart';

/// Travel scenario context
enum TravelContext {
  flightTransit(
    name: 'Long Flight & Airport Transit',
    regionalName: 'हवाई यात्रा एवं पारगमन',
    description:
        'Pressurized dry cabin air, prolonged sitting, circadian shifting.',
  ),
  trainRoadTrip(
    name: 'Train / Highway Road Trip',
    regionalName: 'रेल व सड़क यात्रा',
    description:
        'Irregular meal stops, restricted legroom, station snack temptations.',
  ),
  hotelNoGym(
    name: 'Hotel Stay (No Gym / Minimal Space)',
    regionalName: 'होटल प्रवास (बिना जिम)',
    description: 'Compact room layout, luggage weight utility, dining out.',
  ),
  hotelWithGym(
    name: 'Hotel Stay (Equipped Gym)',
    regionalName: 'होटल प्रवास (जिम युक्त)',
    description: 'Hotel fitness center workout adaptation & buffet navigation.',
  ),
  internationalJetLag(
    name: 'Cross-Timezone Long Haul (>4h Shift)',
    regionalName: 'अंतरराष्ट्रीय समय क्षेत्र परिवर्तन (जेट लैग)',
    description:
        'Circadian misalignment, delayed sleep onset, altered digestion.',
  );

  final String name;
  final String regionalName;
  final String description;

  const TravelContext({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// A specific travel action item
@immutable
class TravelActionItem {
  final String category;
  final String title;
  final String regionalTitle;
  final String instruction;
  final String regionalInstruction;

  const TravelActionItem({
    required this.category,
    required this.title,
    required this.regionalTitle,
    required this.instruction,
    required this.regionalInstruction,
  });
}

/// Comprehensive Travel Intelligence Report
@immutable
class TravelIntelligenceReport {
  final bool isTravelModeActive;
  final TravelContext activeContext;
  final String destinationCityOrTimezone;
  final int timezoneShiftHours;
  final int adaptedStepGoal;
  final int hotelWorkoutDurationMinutes;
  final List<TravelActionItem> activeTravelActions;
  final String jetLagCircadianAdvice;
  final String regionalJetLagAdvice;
  final String vataBalancingRitual;
  final String regionalVataBalancingRitual;
  final String airportDhabaDiningTip;
  final String regionalAirportDhabaDiningTip;
  final DateTime generatedAt;

  const TravelIntelligenceReport({
    required this.isTravelModeActive,
    required this.activeContext,
    required this.destinationCityOrTimezone,
    required this.timezoneShiftHours,
    required this.adaptedStepGoal,
    required this.hotelWorkoutDurationMinutes,
    required this.activeTravelActions,
    required this.jetLagCircadianAdvice,
    required this.regionalJetLagAdvice,
    required this.vataBalancingRitual,
    required this.regionalVataBalancingRitual,
    required this.airportDhabaDiningTip,
    required this.regionalAirportDhabaDiningTip,
    required this.generatedAt,
  });
}
