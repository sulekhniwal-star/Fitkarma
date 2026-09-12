import '../models/life_event_models.dart';

class TravelIntelligenceEngine {
  const TravelIntelligenceEngine();

  /// Builds a customized travel health and workout plan
  TravelHealthPlan createTravelPlan({
    required String destination,
    required int tripDurationDays,
    bool hasHotelGym = false,
  }) {
    final List<String> workouts = [];

    if (hasHotelGym) {
      workouts.addAll([
        'Full-body Dumbbell Complex: Goblet Squats, DB Bench Press, Romanian Deadlifts (4 sets x 10 reps).',
        '20-minute Incline Treadmill Walk (Speed 5.5 km/h, Incline 10%) for low-impact conditioning.',
      ]);
    } else {
      workouts.addAll([
        'Hotel Room HIIT: 20 Bodyweight Squats, 15 Pushups, 20 Lunges, 30s Plank (5 Rounds).',
        'Morning Surya Namaskar: 12 rounds for full spinal mobility and blood circulation.',
      ]);
    }

    final digestionTips = [
      'Carry roasted Ajwain & Jeera: Chew a pinch post-flight to prevent bloating and sluggish gut motility.',
      'Sip warm water with lemon upon waking at your hotel to stimulate peristalsis.',
      'Avoid high-sodium airport processed snacks; carry roasted chana or almonds.',
    ];

    final diningTips = [
      'At restaurants: Order Tandoori/Grilled proteins and Yellow Dal Tadka instead of heavy cream gravies (Butter Masala/Korma).',
      'Ask for plain Roti (without butter brush) and a double portion of fresh cucumber-tomato salad.',
    ];

    return TravelHealthPlan(
      destination: destination,
      tripDurationDays: tripDurationDays,
      hotelWorkouts: workouts,
      digestionChecklist: digestionTips,
      regionalDiningTips: diningTips,
      hydrationStrategy: 'Drink 500ml water for every 2 hours of flight/road travel. Avoid excess coffee in transit.',
    );
  }
}
