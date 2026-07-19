/// §P5-B Meal Parser
///
/// Converts a free-text meal description (e.g. "2 rotis and dal tadka") into
/// a list of [ParsedMealItem]s by scanning a [FoodReference] catalog.
/// Fully offline — no network calls.
library;

// ignore_for_file: avoid_classes_with_only_static_members

/// A single matched food item with a serving multiplier.
class ParsedMealItem {
  const ParsedMealItem({
    required this.referenceId,
    required this.foodName,
    required this.servingMultiplier,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.glycemicIndex,
    required this.satietyIndex,
  });

  final String referenceId;
  final String foodName;
  final double servingMultiplier; // e.g. 2.0 for "2 rotis"
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final int glycemicIndex;
  final int satietyIndex;

  /// Macros scaled by [servingMultiplier].
  double get scaledCalories => calories * servingMultiplier;
  double get scaledProteinG => proteinG * servingMultiplier;
  double get scaledCarbsG => carbsG * servingMultiplier;
  double get scaledFatG => fatG * servingMultiplier;
  double get scaledFiberG => fiberG * servingMultiplier;
}

/// Lightweight catalog entry used by [MealParser] — mirrors [FoodReference]
/// from the Drift database but avoids a hard dependency on the generated code
/// in unit tests.
class FoodCatalogEntry {
  const FoodCatalogEntry({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.glycemicIndex,
    required this.satietyIndex,
    required this.searchTerms,
  });

  final String id;
  final String foodName;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final int glycemicIndex;
  final int satietyIndex;
  final List<String> searchTerms; // pre-split
}

/// Result returned by [MealParser.parse].
class MealParseResult {
  const MealParseResult({required this.items, required this.unknownTokens});

  final List<ParsedMealItem> items;
  final List<String> unknownTokens;
}

/// Parses a free-text meal description into [ParsedMealItem]s.
///
/// Algorithm:
/// 1. Normalise input: lowercase, replace `+`, `with`, `and`, `,` with spaces.
/// 2. Extract leading quantity words ("2", "two", "half", "a/an").
/// 3. Build 1-gram, 2-gram, 3-gram windows over remaining tokens.
/// 4. For each window, check all catalog entries' [FoodCatalogEntry.searchTerms].
/// 5. Greedily consume the longest matching n-gram first.
/// 6. Collect unmatched tokens as [MealParseResult.unknownTokens].
class MealParser {
  // Maps English quantity words → numeric multipliers.
  static const Map<String, double> _quantityWords = {
    'a': 1.0,
    'an': 1.0,
    'one': 1.0,
    'two': 2.0,
    'three': 3.0,
    'four': 4.0,
    'five': 5.0,
    'half': 0.5,
    'quarter': 0.25,
  };

  /// Parses [rawText] against [catalog] and returns a [MealParseResult].
  static MealParseResult parse(String rawText, List<FoodCatalogEntry> catalog) {
    // --- 1. Normalise ---
    final normalised = rawText
        .toLowerCase()
        .replaceAll('+', ' ')
        .replaceAll(',', ' ')
        .replaceAll(' with ', ' ')
        .replaceAll(' and ', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final tokens = normalised.split(' ').where((t) => t.isNotEmpty).toList();

    final matched = <ParsedMealItem>[];
    final consumed = <int>{}; // indices already used
    final unknownTokens = <String>[];

    int i = 0;
    while (i < tokens.length) {
      if (consumed.contains(i)) {
        i++;
        continue;
      }

      // --- 2. Try to read a quantity at position i ---
      double quantity = 1.0;
      int quantityConsumed = 0;

      final tok = tokens[i];
      final parsedNum = double.tryParse(tok);
      if (parsedNum != null) {
        quantity = parsedNum;
        quantityConsumed = 1;
      } else if (_quantityWords.containsKey(tok)) {
        quantity = _quantityWords[tok]!;
        quantityConsumed = 1;
      }

      final phraseStart = i + quantityConsumed;

      // --- 3. Try 3-gram → 2-gram → 1-gram from phraseStart ---
      bool foundMatch = false;
      for (int ngramLen = 3; ngramLen >= 1; ngramLen--) {
        final end = phraseStart + ngramLen;
        if (end > tokens.length) continue;

        final phrase = tokens.sublist(phraseStart, end).join(' ');
        final entry = _findInCatalog(phrase, catalog);
        if (entry != null) {
          matched.add(ParsedMealItem(
            referenceId: entry.id,
            foodName: entry.foodName,
            servingMultiplier: quantity,
            calories: entry.calories,
            proteinG: entry.proteinG,
            carbsG: entry.carbsG,
            fatG: entry.fatG,
            fiberG: entry.fiberG,
            glycemicIndex: entry.glycemicIndex,
            satietyIndex: entry.satietyIndex,
          ));
          // Mark all consumed indices
          for (int j = i; j < end; j++) {
            consumed.add(j);
          }
          i = end;
          foundMatch = true;
          break;
        }
      }

      if (!foundMatch) {
        // If there was a standalone quantity with no food after it, skip it.
        // Otherwise collect the unrecognised token.
        if (quantityConsumed > 0 && phraseStart < tokens.length) {
          // quantity was consumed but next token didn't match; treat both as unknown
          if (!consumed.contains(i)) unknownTokens.add(tokens[i]);
          consumed.add(i);
          i++;
        } else {
          if (!consumed.contains(i)) unknownTokens.add(tokens[i]);
          consumed.add(i);
          i++;
        }
      }
    }

    return MealParseResult(items: matched, unknownTokens: unknownTokens);
  }

  /// Looks up [phrase] (already lowercase) in [catalog] search terms.
  /// Also tries a depluralized form (strips trailing 's') to handle
  /// common Indian food plurals: "rotis", "idlis", "eggs", etc.
  static FoodCatalogEntry? _findInCatalog(
      String phrase, List<FoodCatalogEntry> catalog) {
    final candidates = [phrase];
    // Basic depluralization: strip trailing 's' if word is >2 chars
    if (phrase.endsWith('s') && phrase.length > 2) {
      candidates.add(phrase.substring(0, phrase.length - 1));
    }

    for (final candidate in candidates) {
      for (final entry in catalog) {
        // Check exact food name match
        if (entry.foodName.toLowerCase() == candidate) return entry;
        // Check search terms
        for (final term in entry.searchTerms) {
          if (term.trim().toLowerCase() == candidate) return entry;
        }
      }
    }
    return null;
  }
}
