/// §P5-E Indian Restaurant Intelligence 2.0
///
/// Pure-Dart menu database service, chain presets, Levenshtein fuzzy OCR matcher,
/// and goal-based color overlay classifier.
library;

import 'dart:math';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models
// ─────────────────────────────────────────────────────────────────────────────

/// Goal-based overlay colors for menu items.
enum OverlayColor {
  /// 🟢 High Protein (> 20g protein)
  green,

  /// 🔵 Low Calorie (< 300 kcal)
  blue,

  /// 🟠 Diabetic / PCOS Safe (low GI ≤ 55, low sugar ≤ 5g)
  orange,

  /// 🔴 Avoid / Alert (deep fried or high sugar > 15g)
  red,

  /// Neutral / No special highlight
  none,
}

/// A menu item entry from an Indian restaurant or chain.
class RestaurantMenuItem {
  const RestaurantMenuItem({
    required this.id,
    required this.restaurantName,
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.glycemicIndex,
    required this.isDeepFried,
    required this.sugarG,
    this.category = 'Main Course',
  });

  final String id;
  final String restaurantName;
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int glycemicIndex;
  final bool isDeepFried;
  final double sugarG;
  final String category;
}

/// Preset highlights for major Indian restaurant chains.
class ChainPreset {
  const ChainPreset({
    required this.chainName,
    required this.bestProteinPick,
    required this.avoidItem,
    required this.diabeticPick,
  });

  final String chainName;
  final String bestProteinPick;
  final String avoidItem;
  final String diabeticPick;
}

/// Parsed OCR text line with matched dish and goal overlay color.
class ParsedMenuItemOverlay {
  const ParsedMenuItemOverlay({
    required this.rawLine,
    required this.dishName,
    required this.calories,
    required this.proteinG,
    required this.colorOverlay,
    this.matchedItem,
  });

  final String rawLine;
  final String dishName;
  final double calories;
  final double proteinG;
  final OverlayColor colorOverlay;
  final RestaurantMenuItem? matchedItem;
}

// ─────────────────────────────────────────────────────────────────────────────
// Major Chain Optimization Presets (§P5-E Table)
// ─────────────────────────────────────────────────────────────────────────────

class ChainPresetDataset {
  ChainPresetDataset._();

  static const List<ChainPreset> presets = [
    ChainPreset(
      chainName: "Haldiram's",
      bestProteinPick: "Paneer Tikka Platter (34g Pro)",
      avoidItem: "Chole Bhature (850 kcal)",
      diabeticPick: "Sprouted Moong Chaat",
    ),
    ChainPreset(
      chainName: "Bikanervala",
      bestProteinPick: "Grilled Soya Chaap (22g Pro)",
      avoidItem: "Special Thali (1100 kcal)",
      diabeticPick: "Tandoori Roti + Mix Veg",
    ),
    ChainPreset(
      chainName: "Domino's India",
      bestProteinPick: "Grilled Chicken Breast Topping (24g Pro)",
      avoidItem: "Cheese Burst Pizza (+320 kcal)",
      diabeticPick: "Thin Crust Veggie Pizza",
    ),
    ChainPreset(
      chainName: "McDonald's India",
      bestProteinPick: "McProtein Egg Burger (16g Pro)",
      avoidItem: "McSpicy Chicken (deep-fried)",
      diabeticPick: "Grilled Chicken Wrap (no mayo)",
    ),
    ChainPreset(
      chainName: "Barbeque Nation",
      bestProteinPick: "Unlimited Grilled Paneer / Chicken (35g Pro)",
      avoidItem: "Dessert Counter (excessive sugar)",
      diabeticPick: "Grilled Mushrooms & Broccoli",
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Restaurant Database Service
// ─────────────────────────────────────────────────────────────────────────────

class RestaurantDatabaseService {
  const RestaurantDatabaseService();

  /// Seeded list of common Indian menu items across top chains and local eateries.
  static const List<RestaurantMenuItem> _seededLocalDishes = [
    RestaurantMenuItem(
      id: 'hald_1',
      restaurantName: "Haldiram's",
      name: "Paneer Tikka",
      calories: 280,
      proteinG: 22,
      carbsG: 8,
      fatG: 18,
      glycemicIndex: 15,
      isDeepFried: false,
      sugarG: 2,
      category: 'Starters',
    ),
    RestaurantMenuItem(
      id: 'hald_2',
      restaurantName: "Haldiram's",
      name: "Chole Bhature",
      calories: 850,
      proteinG: 12,
      carbsG: 95,
      fatG: 45,
      glycemicIndex: 65,
      isDeepFried: true,
      sugarG: 4,
      category: 'Main Course',
    ),
    RestaurantMenuItem(
      id: 'hald_3',
      restaurantName: "Haldiram's",
      name: "Sprouted Moong Chaat",
      calories: 180,
      proteinG: 9,
      carbsG: 28,
      fatG: 3,
      glycemicIndex: 25,
      isDeepFried: false,
      sugarG: 3,
      category: 'Healthy Chaat',
    ),
    RestaurantMenuItem(
      id: 'bikan_1',
      restaurantName: 'Bikanervala',
      name: 'Grilled Soya Chaap',
      calories: 240,
      proteinG: 22,
      carbsG: 18,
      fatG: 10,
      glycemicIndex: 20,
      isDeepFried: false,
      sugarG: 1,
      category: 'Starters',
    ),
    RestaurantMenuItem(
      id: 'bikan_2',
      restaurantName: 'Bikanervala',
      name: 'Special Thali',
      calories: 1100,
      proteinG: 28,
      carbsG: 135,
      fatG: 48,
      glycemicIndex: 55,
      isDeepFried: true,
      sugarG: 12,
      category: 'Thali',
    ),
    RestaurantMenuItem(
      id: 'bikan_3',
      restaurantName: 'Bikanervala',
      name: 'Tandoori Roti',
      calories: 120,
      proteinG: 4,
      carbsG: 24,
      fatG: 1,
      glycemicIndex: 60,
      isDeepFried: false,
      sugarG: 0,
      category: 'Breads',
    ),
    RestaurantMenuItem(
      id: 'bikan_4',
      restaurantName: 'Bikanervala',
      name: 'Mix Veg',
      calories: 150,
      proteinG: 3,
      carbsG: 16,
      fatG: 8,
      glycemicIndex: 40,
      isDeepFried: false,
      sugarG: 2,
      category: 'Main Course',
    ),
    RestaurantMenuItem(
      id: 'dom_1',
      restaurantName: "Domino's India",
      name: 'Grilled Chicken Breast Pizza',
      calories: 310,
      proteinG: 24,
      carbsG: 32,
      fatG: 10,
      glycemicIndex: 50,
      isDeepFried: false,
      sugarG: 3,
      category: 'Pizza',
    ),
    RestaurantMenuItem(
      id: 'mcd_1',
      restaurantName: "McDonald's India",
      name: 'McProtein Egg Burger',
      calories: 290,
      proteinG: 16,
      carbsG: 30,
      fatG: 12,
      glycemicIndex: 52,
      isDeepFried: false,
      sugarG: 4,
      category: 'Burgers',
    ),
    RestaurantMenuItem(
      id: 'bbq_1',
      restaurantName: 'Barbeque Nation',
      name: 'Unlimited Grilled Paneer',
      calories: 320,
      proteinG: 25,
      carbsG: 10,
      fatG: 20,
      glycemicIndex: 20,
      isDeepFried: false,
      sugarG: 2,
      category: 'Grill',
    ),
    RestaurantMenuItem(
      id: 'gen_1',
      restaurantName: 'General Indian',
      name: 'Butter Naan',
      calories: 350,
      proteinG: 8,
      carbsG: 52,
      fatG: 12,
      glycemicIndex: 70,
      isDeepFried: false,
      sugarG: 1,
      category: 'Breads',
    ),
    RestaurantMenuItem(
      id: 'gen_2',
      restaurantName: 'General Indian',
      name: 'Dal Makhani',
      calories: 350,
      proteinG: 12,
      carbsG: 34,
      fatG: 18,
      glycemicIndex: 45,
      isDeepFried: false,
      sugarG: 2,
      category: 'Main Course',
    ),
    RestaurantMenuItem(
      id: 'gen_3',
      restaurantName: 'General Indian',
      name: 'Yellow Dal Tadka',
      calories: 180,
      proteinG: 9,
      carbsG: 24,
      fatG: 5,
      glycemicIndex: 30,
      isDeepFried: false,
      sugarG: 1,
      category: 'Main Course',
    ),
  ];

  /// Searches the restaurant menu database by restaurant name or dish query.
  List<RestaurantMenuItem> search({
    String? restaurantName,
    String? dishQuery,
  }) {
    return _seededLocalDishes.where((item) {
      if (restaurantName != null &&
          restaurantName.isNotEmpty &&
          restaurantName != 'All') {
        if (!item.restaurantName
            .toLowerCase()
            .contains(restaurantName.toLowerCase())) {
          return false;
        }
      }

      if (dishQuery != null && dishQuery.trim().isNotEmpty) {
        final query = dishQuery.trim().toLowerCase();
        final matchName = item.name.toLowerCase().contains(query);
        final matchCategory = item.category.toLowerCase().contains(query);
        final matchChain = item.restaurantName.toLowerCase().contains(query);
        return matchName || matchCategory || matchChain;
      }

      return true;
    }).toList();
  }

  /// Classifies a menu item into a goal overlay color badge.
  OverlayColor computeGoalOverlay(
    RestaurantMenuItem? item, {
    bool isPcosOrDiabetic = false,
  }) {
    if (item == null) return OverlayColor.none;

    // 🔴 Red: Avoid / Deep fried or high sugar (> 15g)
    if (item.isDeepFried || item.sugarG > 15) {
      return OverlayColor.red;
    }

    // 🟢 Green: High Protein (> 20g protein)
    if (item.proteinG >= 20) {
      return OverlayColor.green;
    }

    // 🔵 Blue: Low Calorie (< 300 kcal)
    if (item.calories < 300) {
      return OverlayColor.blue;
    }

    // 🟠 Orange: Diabetic / PCOS Safe (low GI ≤ 55 and low sugar ≤ 5g)
    if (isPcosOrDiabetic && item.glycemicIndex <= 55 && item.sugarG <= 5) {
      return OverlayColor.orange;
    }

    return OverlayColor.none;
  }

  /// 3-tier fuzzy matcher checking normalized string equality, substring containment,
  /// and Levenshtein edit distance (threshold ≥ 0.70).
  RestaurantMenuItem? matchDishInDatabase(String ocrLine) {
    if (ocrLine.trim().isEmpty) return null;

    final normalizedOcr = _normalizeString(ocrLine);
    RestaurantMenuItem? bestMatch;
    double highestSimilarity = 0.0;

    for (final item in _seededLocalDishes) {
      final normalizedDb = _normalizeString(item.name);

      // 1. Exact normalized match
      if (normalizedOcr == normalizedDb) {
        return item;
      }

      // 2. Substring containment check (e.g. "Special Paneer Tikka Platter" contains "Paneer Tikka")
      if (normalizedOcr.contains(normalizedDb) ||
          normalizedDb.contains(normalizedOcr)) {
        final double score = normalizedDb.length / max(1, normalizedOcr.length);
        final adjustedScore = score > 1.0 ? 1.0 / score : score;
        final containmentBoost = max(0.80, adjustedScore);
        if (containmentBoost > highestSimilarity) {
          highestSimilarity = containmentBoost;
          bestMatch = item;
        }
      }

      // 3. Levenshtein edit distance calculation
      final distance = _calculateLevenshteinDistance(normalizedOcr, normalizedDb);
      final maxLength = max(normalizedOcr.length, normalizedDb.length);
      final similarity = maxLength > 0 ? 1.0 - (distance / maxLength) : 0.0;

      if (similarity > highestSimilarity) {
        highestSimilarity = similarity;
        bestMatch = item;
      }
    }

    if (highestSimilarity >= 0.70) {
      return bestMatch;
    }

    return null;
  }

  /// Parses raw text lines (from OCR or manual paste) and returns goal-highlighted items.
  List<ParsedMenuItemOverlay> parseMenuText(
    List<String> rawOcrLines, {
    bool isPcosOrDiabetic = false,
  }) {
    return rawOcrLines
        .where((line) => line.trim().isNotEmpty)
        .map((line) {
      final matchedItem = matchDishInDatabase(line);
      final overlayColor = computeGoalOverlay(
        matchedItem,
        isPcosOrDiabetic: isPcosOrDiabetic,
      );
      return ParsedMenuItemOverlay(
        rawLine: line.trim(),
        dishName: matchedItem?.name ?? line.trim(),
        calories: matchedItem?.calories ?? 0,
        proteinG: matchedItem?.proteinG ?? 0,
        colorOverlay: overlayColor,
        matchedItem: matchedItem,
      );
    }).toList();
  }

  // ── Helper math / string functions ──────────────────────────────────────

  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  int _calculateLevenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final v0 = List<int>.generate(t.length + 1, (i) => i);
    final v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        final cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  int _min3(int a, int b, int c) =>
      a < b ? (a < c ? a : c) : (b < c ? b : c);
}
