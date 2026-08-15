class SmartSubstitute {
  final String originalFoodName;
  final String alternativeName;
  final double originalCalories;
  final double substituteCalories;
  final double originalProtein;
  final double substituteProtein;
  final String swapInstructions;

  const SmartSubstitute({
    required this.originalFoodName,
    required this.alternativeName,
    required this.originalCalories,
    required this.substituteCalories,
    required this.originalProtein,
    required this.substituteProtein,
    required this.swapInstructions,
  });

  double get calorieDelta => substituteCalories - originalCalories;
  double get proteinDelta => substituteProtein - originalProtein;
}

class SeededTargetSwapIndex {
  static const Map<String, SmartSubstitute> registry = {
    'samosa_fried': SmartSubstitute(
      originalFoodName: 'Deep-Fried Samosa',
      alternativeName: 'Air-Fried Samosa',
      originalCalories: 310.0,
      substituteCalories: 160.0,
      originalProtein: 4.0,
      substituteProtein: 4.5,
      swapInstructions:
          'Brush lightly with olive oil and bake/air-fry at 180°C for 15 mins instead of deep-frying.',
    ),
    'paneer_butter_masala': SmartSubstitute(
      originalFoodName: 'Paneer Butter Masala',
      alternativeName: 'High-Pro Paneer Makhani',
      originalCalories: 510.0,
      substituteCalories: 290.0,
      originalProtein: 14.0,
      substituteProtein: 26.0,
      swapInstructions:
          'Substitute cashew cream with low-fat Greek yogurt & skimmed milk; cut butter by 75%.',
    ),
    'gulab_jamun': SmartSubstitute(
      originalFoodName: 'Gulab Jamun / Mithai',
      alternativeName: 'Whey Protein Sattu Kheer',
      originalCalories: 320.0,
      substituteCalories: 140.0,
      originalProtein: 0.0,
      substituteProtein: 18.0,
      swapInstructions:
          'Boil skimmed milk with roasted sattu, sweeten with stevia, fold in 0.5 scoop vanilla whey.',
    ),
    'laccha_paratha': SmartSubstitute(
      originalFoodName: 'Maida Laccha Paratha',
      alternativeName: 'Oats & Missi Roti',
      originalCalories: 280.0,
      substituteCalories: 160.0,
      originalProtein: 5.0,
      substituteProtein: 9.0,
      swapInstructions:
          'Blend whole wheat atta with 30% besan and powdered oats for high-fiber & protein boost.',
    ),
  };
}

/// Pure-Dart Indian Food Substitution & Swap Engine per §P5-R spec
class FoodSwapService {
  const FoodSwapService();

  /// Retrieves culturally relevant, high-adherence smart substitutes
  SmartSubstitute? checkSubstitution(String foodKey) {
    final key = foodKey.toLowerCase().replaceAll(' ', '_');
    if (SeededTargetSwapIndex.registry.containsKey(key)) {
      return SeededTargetSwapIndex.registry[key];
    }

    // Fuzzy matcher fallback
    for (final entry in SeededTargetSwapIndex.registry.entries) {
      if (entry.value.originalFoodName
              .toLowerCase()
              .contains(foodKey.toLowerCase()) ||
          key.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }
}
