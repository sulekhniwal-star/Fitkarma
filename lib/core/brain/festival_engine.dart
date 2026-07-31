import 'package:fitkarma/features/festivals/models/festival_model.dart';

/// Core Festival & Life Events Cross-Module Adaptation Engine
class FestivalEngine {
  const FestivalEngine();

  /// Check if 3-day Survival Mode pre-activation should trigger for upcoming festival
  bool shouldActivateSurvivalMode({
    required FestivalEvent festival,
    required DateTime currentDate,
  }) {
    final difference = festival.startDate.difference(currentDate).inDays;
    return difference >= 0 && difference <= 3;
  }

  /// Filter allowed foods for Navratri Fasting
  List<String> getNavratriAllowedFoods() {
    return const [
      'Sabudana Khichdi (Low Oil)',
      'Kuttu Atta Paratha',
      'Samak Rice Pulao',
      'Roasted Makhana (Foxnuts)',
      'Paneer Tikka (Satvik)',
      'Boiled Sweet Potato',
    ];
  }
}
