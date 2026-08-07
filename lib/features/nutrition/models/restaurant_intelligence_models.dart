import 'package:flutter/material.dart';

/// Goal Overlay Color Categories
enum MenuGoalOverlayCategory {
  greenHighProtein,   // > 20g protein
  blueLowCalorie,     // < 300 kcal
  orangeDiabeticPcos, // Low GI <= 45, high fiber/healthy fat
  redAvoidAlert,      // Deep-fried or high GI / empty calories
  neutral,
}

extension MenuGoalOverlayCategoryStyle on MenuGoalOverlayCategory {
  Color get color {
    switch (this) {
      case MenuGoalOverlayCategory.greenHighProtein:
        return const Color(0xFF10B981); // Emerald Green
      case MenuGoalOverlayCategory.blueLowCalorie:
        return const Color(0xFF3B82F6); // Blue
      case MenuGoalOverlayCategory.orangeDiabeticPcos:
        return const Color(0xFFF59E0B); // Amber/Orange
      case MenuGoalOverlayCategory.redAvoidAlert:
        return const Color(0xFFEF4444); // Red
      case MenuGoalOverlayCategory.neutral:
        return const Color(0xFF9CA3AF); // Neutral Gray
    }
  }

  String get label {
    switch (this) {
      case MenuGoalOverlayCategory.greenHighProtein:
        return '🟢 High Protein (>20g)';
      case MenuGoalOverlayCategory.blueLowCalorie:
        return '🔵 Low Calorie (<300 kcal)';
      case MenuGoalOverlayCategory.orangeDiabeticPcos:
        return '🟠 Diabetic / PCOS Safe';
      case MenuGoalOverlayCategory.redAvoidAlert:
        return '🔴 Avoid / High Calorie';
      case MenuGoalOverlayCategory.neutral:
        return '⚪ Standard Option';
    }
  }
}

/// Menu Item Definition for Restaurant Intelligence
class RestaurantMenuItem {
  final String name;
  final int calories;
  final double proteinG;
  final double glycemicIndex;
  final bool isDeepFried;
  final double sugarG;
  final double priceRupees;

  const RestaurantMenuItem({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.glycemicIndex,
    required this.isDeepFried,
    required this.sugarG,
    this.priceRupees = 0.0,
  });
}

/// Parsed OCR Overlay Result Item
class ParsedMenuItemOverlay {
  final String dishName;
  final int calories;
  final double proteinG;
  final MenuGoalOverlayCategory colorOverlay;

  const ParsedMenuItemOverlay({
    required this.dishName,
    required this.calories,
    required this.proteinG,
    required this.colorOverlay,
  });
}

/// Seeded Major Restaurant Chain Preset Optimization Pick
class MajorChainPreset {
  final String chainName;
  final String bestProteinPick;
  final String avoidAlertItem;
  final String diabeticPcosPick;

  const MajorChainPreset({
    required this.chainName,
    required this.bestProteinPick,
    required this.avoidAlertItem,
    required this.diabeticPcosPick,
  });
}

/// Major Chain Optimization Presets database per §P5-E Table
class MajorChainPresetsDatabase {
  static const List<MajorChainPreset> presets = [
    MajorChainPreset(
      chainName: "Haldiram's",
      bestProteinPick: "Paneer Tikka Platter (34g Pro)",
      avoidAlertItem: "Chole Bhature (850 kcal)",
      diabeticPcosPick: "Sprouted Moong Chaat",
    ),
    MajorChainPreset(
      chainName: "Bikanervala",
      bestProteinPick: "Grilled Soya Chaap (22g Pro)",
      avoidAlertItem: "Special Thali (1100 kcal)",
      diabeticPcosPick: "Tandoori Roti + Mix Veg",
    ),
    MajorChainPreset(
      chainName: "Domino's India",
      bestProteinPick: "Grilled Chicken Breast Topping Pizza",
      avoidAlertItem: "Cheese Burst Pizza (+320 kcal)",
      diabeticPcosPick: "Thin Crust Veggie Pizza",
    ),
    MajorChainPreset(
      chainName: "McDonald's India",
      bestProteinPick: "McProtein Egg Burger (16g Pro)",
      avoidAlertItem: "McSpicy Chicken (fried)",
      diabeticPcosPick: "Grilled Chicken Wrap (no mayo)",
    ),
    MajorChainPreset(
      chainName: "Barbeque Nation",
      bestProteinPick: "Unlimited Grilled Paneer/Chicken",
      avoidAlertItem: "Dessert Counter (excessive sugar)",
      diabeticPcosPick: "Grilled Mushrooms & Broccoli",
    ),
  ];
}
