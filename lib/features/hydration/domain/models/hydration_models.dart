/// FitKarma — Hydration Tracker Domain Models
/// Water intake tracking with Indian summer context awareness
library;

class HydrationLog {
  final String id;
  final String userId;
  final DateTime loggedAt;
  final double amountMl;
  final HydrationSource source;

  const HydrationLog({
    required this.id,
    required this.userId,
    required this.loggedAt,
    required this.amountMl,
    required this.source,
  });
}

enum HydrationSource {
  water('Water', '💧'),
  coconutWater('Coconut Water', '🥥'),
  lassi('Lassi', '🥛'),
  nimbuPani('Nimbu Pani', '🍋'),
  chaas('Chaas / Buttermilk', '🥛'),
  tea('Chai / Green Tea', '🍵'),
  otherBeverage('Other Beverage', '🫗');

  final String label;
  final String emoji;
  const HydrationSource(this.label, this.emoji);
}

/// Daily hydration goal calculator — adjusts for Indian climate
class HydrationGoalEngine {
  const HydrationGoalEngine();

  /// Calculates daily water goal in ml based on weight, activity, AQI and season.
  double calculateDailyGoalMl({
    required double weightKg,
    required bool isHighActivityDay,
    required int aqiLevel,
    required int temperatureC,
  }) {
    // Base: 35ml/kg bodyweight
    double base = weightKg * 35;

    // Indian summer heat bonus (Apr–Jun typical 35–45°C)
    if (temperatureC > 35) base += 500;
    if (temperatureC > 40) base += 500;

    // High pollution day — more flush needed
    if (aqiLevel > 150) base += 300;

    // Workout day bonus
    if (isHighActivityDay) base += 600;

    return base.clamp(1500, 5000);
  }

  /// Returns contextual hydration tip based on current state
  String getHydrationTip({
    required double consumedMl,
    required double goalMl,
    required int temperatureC,
  }) {
    final pct = consumedMl / goalMl;
    if (pct < 0.3) {
      return temperatureC > 35
          ? '🔥 Garmi mein pani kam mat piyo — dehydration bahut fast hoti hai!'
          : '💧 Start your day with 2 glasses of water to activate your metabolism.';
    }
    if (pct < 0.6) {
      return '⚡ Halfway there! Nimbu pani ya coconut water for electrolytes.';
    }
    if (pct < 1.0) {
      return '🌟 Almost done! Stay consistent — your kidneys will thank you.';
    }
    return '✅ Hydration goal achieved! Great job staying on track.';
  }

  /// Quick-add preset amounts in ml
  static const List<({int ml, String label, String emoji})> quickAddOptions = [
    (ml: 150, label: '1 Glass', emoji: '🥛'),
    (ml: 250, label: '1 Cup Chai', emoji: '☕'),
    (ml: 350, label: 'Small Bottle', emoji: '🍶'),
    (ml: 500, label: '500ml Bottle', emoji: '🧴'),
    (ml: 200, label: 'Nimbu Pani', emoji: '🍋'),
    (ml: 250, label: 'Coconut Water', emoji: '🥥'),
  ];
}
