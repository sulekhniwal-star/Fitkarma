// §P12-E Travel Intelligence (NEW v1 — Travel Mode, Pure Dart)
// Cross-reference: §P12-E in Fitkarma_documentation.md

enum TravelMode {
  domestic,
  international,
  airport;

  String get displayName {
    switch (this) {
      case TravelMode.domestic:
        return 'Domestic';
      case TravelMode.international:
        return 'International';
      case TravelMode.airport:
        return 'Airport Transit';
    }
  }
}

enum TravelDirection {
  east,
  west;

  String get displayName => this == TravelDirection.east ? 'East' : 'West';
}

class TravelContext {
  final TravelMode mode;
  final String origin;
  final String destination;
  final DateTime departureDate;
  final DateTime? returnDate;
  final TravelDirection direction;
  final int daysDuration;

  const TravelContext({
    required this.mode,
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    this.direction = TravelDirection.east,
    this.daysDuration = 3,
  });

  String get routeDisplay => '$origin → $destination (${mode.displayName})';
}

class WorkoutPlan {
  final String title;
  final int minutes;
  final List<String> exercises;
  final String tip;
  final bool noEquipment;

  const WorkoutPlan({
    required this.title,
    required this.minutes,
    required this.exercises,
    required this.tip,
    this.noEquipment = true,
  });

  factory WorkoutPlan.hotelBodyweight({required int minutes}) {
    return WorkoutPlan(
      title: '$minutes-min hotel bodyweight session',
      minutes: minutes,
      exercises: const ['Push-ups', 'Squats', 'Lunges', 'Plank'],
      tip: 'No equipment needed. Focus on continuous controlled tempo.',
      noEquipment: true,
    );
  }

  factory WorkoutPlan.airportWalk({required String tip}) {
    return WorkoutPlan(
      title: 'Airport Terminal Walk',
      minutes: 30,
      exercises: const ['Brisk terminal walking', 'Light calf raises'],
      tip: tip,
      noEquipment: true,
    );
  }
}

class NutritionPlan {
  final String title;
  final String strategy;
  final List<String> bestBets;
  final String? tip;

  const NutritionPlan({
    required this.title,
    required this.strategy,
    this.bestBets = const [
      'Grilled paneer',
      'Dal',
      'Boiled eggs',
      'Curd / Greek yogurt',
    ],
    this.tip,
  });

  factory NutritionPlan.travelSimplified({required String strategy}) {
    return NutritionPlan(
      title: 'Travel Simplified Nutrition',
      strategy: strategy,
      bestBets: const [
        'Grilled paneer',
        'Dal tadka / yellow dal',
        'Boiled or poached eggs',
        'Plain curd / dahi',
        'Roasted chana / nuts',
      ],
    );
  }

  factory NutritionPlan.airportSurvival({required String tip}) {
    return NutritionPlan(
      title: 'Airport Survival Nutrition',
      strategy:
          'Low glycemic, portable protein options with zero heavy sugar spikes.',
      bestBets: const [
        'Protein bars',
        'Roasted almonds / walnuts',
        'Fresh fruit / salads',
        'Grilled sandwiches',
      ],
      tip: tip,
    );
  }
}

class JetLagProtocol {
  final TravelDirection direction;
  final List<String> recommendations;

  const JetLagProtocol({
    required this.direction,
    required this.recommendations,
  });
}

class TravelAdaptation {
  final WorkoutPlan workoutPlan;
  final NutritionPlan nutritionPlan;
  final String calorieBudget;
  final String hydrationNote;
  final int readinessAdjustment;
  final String? sleepNote;
  final JetLagProtocol? jetLagProtocol;

  const TravelAdaptation({
    required this.workoutPlan,
    required this.nutritionPlan,
    required this.calorieBudget,
    this.hydrationNote = 'Carry water bottle — airports/hotels are dehydrating',
    this.readinessAdjustment = 0,
    this.sleepNote,
    this.jetLagProtocol,
  });

  String get readinessExpectationSummary {
    if (readinessAdjustment < 0) {
      final abs = readinessAdjustment.abs();
      return '$abs–${abs + 5}% lower (travel fatigue) — Not a failure, expected adaptation';
    }
    return 'Normal baseline expectation';
  }
}

/// §P12-E TravelIntelligenceEngine (Pure Dart, No AI)
class TravelIntelligenceEngine {
  const TravelIntelligenceEngine();

  TravelAdaptation adapt(TravelContext travel) {
    return switch (travel.mode) {
      TravelMode.domestic => TravelAdaptation(
          workoutPlan: WorkoutPlan.hotelBodyweight(minutes: 30),
          nutritionPlan: NutritionPlan.travelSimplified(
            strategy: 'Order high-protein items from hotel menu. '
                'Grilled options over fried. '
                'Carry nuts/seeds for snacks.',
          ),
          calorieBudget: '+150 kcal buffer for eating out',
          hydrationNote:
              'Carry water bottle — airports/hotels are dehydrating (+500ml)',
          readinessAdjustment: -5, // Travel fatigue
          sleepNote: 'Hotel blackout curtains on. '
              'Target same sleep time as home.',
        ),
      TravelMode.international => TravelAdaptation(
          workoutPlan: WorkoutPlan.hotelBodyweight(minutes: 25),
          jetLagProtocol: JetLagProtocol(
            direction: travel.direction, // East vs West
            recommendations: const [
              'Avoid caffeine 6h before new sleep time',
              'Get morning sunlight at destination ASAP',
              'Readiness will be 10–15% lower for 3 days — expected',
            ],
          ),
          nutritionPlan: NutritionPlan.travelSimplified(
            strategy: 'Prioritize protein to maintain muscle. '
                'Hydrate aggressively — cabin air is very dry.',
          ),
          calorieBudget: '+200 kcal buffer for travel days',
          hydrationNote: '+750ml aggressive hydration for dry cabin air',
          readinessAdjustment: -12,
          sleepNote:
              'Align with destination timezone immediately upon landing.',
        ),
      TravelMode.airport => TravelAdaptation(
          workoutPlan: WorkoutPlan.airportWalk(
            tip: 'Walk the terminal instead of sitting at the gate. '
                '30 min = ~3,000 steps.',
          ),
          nutritionPlan: NutritionPlan.airportSurvival(
            tip: 'Best airport options: salads, grilled sandwiches, nuts. '
                'Avoid: fried snacks, sugary drinks, pastries.',
          ),
          calorieBudget: 'Maintain standard maintenance calories',
          hydrationNote: 'Drink 250ml water per hour of flying.',
          readinessAdjustment: -3,
          sleepNote: 'Use eye mask and neck pillow during flight intervals.',
        ),
    };
  }
}
