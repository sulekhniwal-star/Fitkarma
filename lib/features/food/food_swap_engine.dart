/// §P5-R Indian Food Substitution & Swap Engine
///
/// Pure-Dart substitution engine maintaining the Indian Target Swap Index,
/// computing calorie deltas, protein boosts, satiety gains, and culinary preparation tips.
library;

import 'package:fitkarma/features/food/food_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Domain Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Smart Substitute option payload (§P5-R Specification).
class SmartSubstitute {
  const SmartSubstitute({
    required this.originalFoodName,
    required this.originalCalories,
    required this.originalProtein,
    required this.alternativeName,
    required this.alternativeCalories,
    required this.alternativeProtein,
    required this.calorieDelta,
    required this.proteinDelta,
    required this.satietyGain,
    required this.swapInstructions,
    required this.culinaryPreparationTip,
  });

  final String originalFoodName;
  final double originalCalories;
  final double originalProtein;
  final String alternativeName;
  final double alternativeCalories;
  final double alternativeProtein;

  /// Alternative - Original (negative = calories saved)
  final double calorieDelta;

  /// Alternative - Original (positive = protein gain)
  final double proteinDelta;

  /// Satiety score gain (e.g. +30.0 pts)
  final double satietyGain;

  final String swapInstructions;
  final String culinaryPreparationTip;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class FoodSwapEngine {
  const FoodSwapEngine();

  /// Indian Target Swap Index Registry (§P5-R Specification Table).
  static const List<SmartSubstitute> targetSwapRegistry = [
    SmartSubstitute(
      originalFoodName: 'Deep-Fried Samosa',
      originalCalories: 310.0,
      originalProtein: 5.0,
      alternativeName: 'Air-Fried Samosa',
      alternativeCalories: 160.0,
      alternativeProtein: 5.0,
      calorieDelta: -150.0,
      proteinDelta: 0.0,
      satietyGain: 30.0,
      swapInstructions: 'Air-fry instead of deep frying.',
      culinaryPreparationTip:
          'Brush lightly with olive oil and bake/air-fry at 180°C for 15 mins.',
    ),
    SmartSubstitute(
      originalFoodName: 'Paneer Butter Masala',
      originalCalories: 510.0,
      originalProtein: 14.0,
      alternativeName: 'High-Protein Paneer Makhani',
      alternativeCalories: 290.0,
      alternativeProtein: 26.0,
      calorieDelta: -220.0,
      proteinDelta: 12.0,
      satietyGain: 40.0,
      swapInstructions:
          'Use low-fat yogurt and skimmed milk instead of heavy cashew cream.',
      culinaryPreparationTip:
          'Substitute cashew cream with low-fat yogurt/skimmed milk; reduce butter.',
    ),
    SmartSubstitute(
      originalFoodName: 'Gulab Jamun / Mithai',
      originalCalories: 320.0,
      originalProtein: 3.0,
      alternativeName: 'Whey Protein Sattu Kheer',
      alternativeCalories: 140.0,
      alternativeProtein: 21.0,
      calorieDelta: -180.0,
      proteinDelta: 18.0,
      satietyGain: 55.0,
      swapInstructions: 'Replace fried khoya with sattu & whey kheer.',
      culinaryPreparationTip:
          'Boil skimmed milk with roasted sattu, sweeten with stevia, add 0.5 scoop whey.',
    ),
    SmartSubstitute(
      originalFoodName: 'Maida Laccha Paratha',
      originalCalories: 280.0,
      originalProtein: 4.0,
      alternativeName: 'Oats & Missi Roti',
      alternativeCalories: 160.0,
      alternativeProtein: 8.0,
      calorieDelta: -120.0,
      proteinDelta: 4.0,
      satietyGain: 35.0,
      swapInstructions:
          'Use 50% besan + 50% oats flour instead of refined maida.',
      culinaryPreparationTip:
          'Knead oats flour & besan with ajwain & chopped coriander; cook on tawa without ghee.',
    ),
    SmartSubstitute(
      originalFoodName: 'Butter Naan',
      originalCalories: 320.0,
      originalProtein: 6.0,
      alternativeName: 'Tandoori Roti',
      alternativeCalories: 120.0,
      alternativeProtein: 4.0,
      calorieDelta: -200.0,
      proteinDelta: -2.0,
      satietyGain: 25.0,
      swapInstructions: 'Opt for unbuttered tandoori roti.',
      culinaryPreparationTip:
          'Ask restaurant for dry whole wheat Tandoori Roti with no butter.',
    ),
    SmartSubstitute(
      originalFoodName: 'Chole Bhature',
      originalCalories: 650.0,
      originalProtein: 15.0,
      alternativeName: 'Air-Fried Kulcha & Baked Chole',
      alternativeCalories: 380.0,
      alternativeProtein: 18.0,
      calorieDelta: -270.0,
      proteinDelta: 3.0,
      satietyGain: 45.0,
      swapInstructions: 'Bake kulcha without deep frying.',
      culinaryPreparationTip:
          'Air-fry yeast kulchas and simmer chole in whole spices without oil floaters.',
    ),
  ];

  /// Case-insensitive search against Target Swap Registry.
  SmartSubstitute? findBestSwap(String query) {
    if (query.trim().isEmpty) return null;
    final lc = query.toLowerCase();

    for (final sub in targetSwapRegistry) {
      if (lc.contains(sub.originalFoodName.toLowerCase()) ||
          sub.originalFoodName.toLowerCase().contains(lc)) {
        return sub;
      }
    }

    // Keyword fallback matching
    if (lc.contains('samosa')) return targetSwapRegistry[0];
    if (lc.contains('paneer') &&
        (lc.contains('butter') || lc.contains('masala')))
      return targetSwapRegistry[1];
    if (lc.contains('jamun') || lc.contains('mithai') || lc.contains('sweet'))
      return targetSwapRegistry[2];
    if (lc.contains('paratha')) return targetSwapRegistry[3];
    if (lc.contains('naan')) return targetSwapRegistry[4];
    if (lc.contains('bhature') || lc.contains('chole'))
      return targetSwapRegistry[5];

    return null;
  }

  /// Scans logged meals and returns list of applicable smart substitutes.
  List<SmartSubstitute> findSubstitutesForLoggedFoods(
    List<FoodItem> loggedFoods,
  ) {
    if (loggedFoods.isEmpty) return const [];
    final matches = <SmartSubstitute>[];

    for (final food in loggedFoods) {
      final swap = findBestSwap(food.name);
      if (swap != null &&
          !matches.any((m) => m.alternativeName == swap.alternativeName)) {
        matches.add(swap);
      }
    }

    return matches;
  }
}
