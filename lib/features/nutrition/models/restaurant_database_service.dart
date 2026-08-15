import 'restaurant_intelligence_models.dart';

/// §P5-E Smart Item Recognition & OCR Parser Engine (Pure Dart)
class RestaurantDatabaseService {
  final List<RestaurantMenuItem> _seededLocalDishes;

  RestaurantDatabaseService({List<RestaurantMenuItem>? customDishes})
      : _seededLocalDishes = customDishes ?? _defaultSeededDishes;

  static const List<RestaurantMenuItem> _defaultSeededDishes = [
    RestaurantMenuItem(
        name: "Paneer Tikka",
        calories: 280,
        proteinG: 22.0,
        glycemicIndex: 15,
        isDeepFried: false,
        sugarG: 2),
    RestaurantMenuItem(
        name: "Paneer Tikka Masala",
        calories: 450,
        proteinG: 18.0,
        glycemicIndex: 35,
        isDeepFried: false,
        sugarG: 5),
    RestaurantMenuItem(
        name: "Chole Bhature",
        calories: 850,
        proteinG: 12.0,
        glycemicIndex: 65,
        isDeepFried: true,
        sugarG: 4),
    RestaurantMenuItem(
        name: "Sprouted Moong Chaat",
        calories: 180,
        proteinG: 9.0,
        glycemicIndex: 25,
        isDeepFried: false,
        sugarG: 3),
    RestaurantMenuItem(
        name: "Grilled Soya Chaap",
        calories: 240,
        proteinG: 22.0,
        glycemicIndex: 20,
        isDeepFried: false,
        sugarG: 1),
    RestaurantMenuItem(
        name: "Special Thali",
        calories: 1100,
        proteinG: 28.0,
        glycemicIndex: 55,
        isDeepFried: true,
        sugarG: 12),
    RestaurantMenuItem(
        name: "Tandoori Roti",
        calories: 120,
        proteinG: 4.0,
        glycemicIndex: 60,
        isDeepFried: false,
        sugarG: 0),
    RestaurantMenuItem(
        name: "Mix Veg",
        calories: 150,
        proteinG: 3.0,
        glycemicIndex: 40,
        isDeepFried: false,
        sugarG: 2),
    RestaurantMenuItem(
        name: "Butter Naan",
        calories: 350,
        proteinG: 8.0,
        glycemicIndex: 70,
        isDeepFried: false,
        sugarG: 1),
    RestaurantMenuItem(
        name: "Dal Makhani",
        calories: 350,
        proteinG: 12.0,
        glycemicIndex: 45,
        isDeepFried: false,
        sugarG: 2),
    RestaurantMenuItem(
        name: "Yellow Dal Tadka",
        calories: 180,
        proteinG: 9.0,
        glycemicIndex: 30,
        isDeepFried: false,
        sugarG: 1),
  ];

  /// OCR Menu Parser processing raw OCR text lines per §P5-E spec
  List<ParsedMenuItemOverlay> parseMenuText(List<String> rawOcrLines,
      {String userGoal = 'Fat Loss'}) {
    return rawOcrLines.map((line) {
      final matchedItem = matchDishInDatabase(line);
      final overlayColor = computeGoalOverlay(matchedItem, userGoal: userGoal);
      return ParsedMenuItemOverlay(
        dishName: matchedItem?.name ?? line,
        calories: matchedItem?.calories ?? 0,
        proteinG: matchedItem?.proteinG ?? 0.0,
        colorOverlay: overlayColor,
      );
    }).toList();
  }

  /// Computes Goal Overlay Color Badge based on item attributes per §P5-E
  MenuGoalOverlayCategory computeGoalOverlay(RestaurantMenuItem? item,
      {required String userGoal}) {
    if (item == null) return MenuGoalOverlayCategory.neutral;

    // 🔴 Red Highlights (Avoid/Alert): Deep-fried or high-glycemic/empty-calorie items
    if (item.isDeepFried || item.glycemicIndex >= 65 || item.calories >= 800) {
      return MenuGoalOverlayCategory.redAvoidAlert;
    }

    // 🟢 Green Highlights (High Protein): Items yielding > 20g protein per serving
    if (item.proteinG >= 20.0) {
      return MenuGoalOverlayCategory.greenHighProtein;
    }

    // 🔵 Blue Highlights (Low Calorie): Items containing < 300 kcal per serving
    if (item.calories < 300) {
      return MenuGoalOverlayCategory.blueLowCalorie;
    }

    // 🟠 Orange Highlights (Diabetic/PCOS Safe): Low GI <= 45, low sugar
    if (item.glycemicIndex <= 45 && item.sugarG <= 3.0) {
      return MenuGoalOverlayCategory.orangeDiabeticPcos;
    }

    return MenuGoalOverlayCategory.neutral;
  }

  /// Fuzzy matcher checking normalized Levenshtein similarity & token containment (threshold >= 0.70)
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

      // 2. Substring containment check
      if (normalizedOcr.contains(normalizedDb) ||
          normalizedDb.contains(normalizedOcr)) {
        final double containmentScore =
            normalizedDb.length / normalizedOcr.length;
        final score =
            containmentScore > 1.0 ? 1.0 / containmentScore : containmentScore;
        if (score > highestSimilarity && score >= 0.6) {
          highestSimilarity = score;
          bestMatch = item;
        }
      }

      // 3. Levenshtein edit distance calculation
      final distance =
          _calculateLevenshteinDistance(normalizedOcr, normalizedDb);
      final maxLength = normalizedOcr.length > normalizedDb.length
          ? normalizedOcr.length
          : normalizedDb.length;
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

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }

  int _min3(int a, int b, int c) {
    int min = a;
    if (b < min) min = b;
    if (c < min) min = c;
    return min;
  }
}
