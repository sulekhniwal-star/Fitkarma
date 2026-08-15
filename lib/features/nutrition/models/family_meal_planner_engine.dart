class FamilyMemberProfile {
  final String id;
  final String name;
  final String role; // "Father", "Mother", "Child", etc.
  final List<String>
      goals; // 'diabetes_reversal', 'weight_loss', 'muscle_gain', 'growth_stage'
  final bool isDairyHeavyAllowed;

  const FamilyMemberProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.goals,
    this.isDairyHeavyAllowed = true,
  });
}

class FamilyRecipe {
  final String id;
  final String name;
  final double glycemicIndex;
  final bool isDairyHeavy;
  final double baseCalories;
  final String description;

  const FamilyRecipe({
    required this.id,
    required this.name,
    required this.glycemicIndex,
    required this.isDairyHeavy,
    required this.baseCalories,
    required this.description,
  });
}

class MemberPortionGuide {
  final double portionMultiplier;
  final String customInstruction;
  final String rotiGuidance;
  final String sideDishGuidance;

  const MemberPortionGuide({
    required this.portionMultiplier,
    required this.customInstruction,
    required this.rotiGuidance,
    required this.sideDishGuidance,
  });
}

class UnifiedFamilyMealPlan {
  final FamilyRecipe selectedRecipe;
  final Map<String, MemberPortionGuide> memberPortions;
  final String conflictResolutionSummary;

  const UnifiedFamilyMealPlan({
    required this.selectedRecipe,
    required this.memberPortions,
    required this.conflictResolutionSummary,
  });
}

/// Pure-Dart Family Dinner & Multi-Profile Matching Engine per §P5-Q spec
class FamilyMealPlannerEngine {
  static const List<FamilyRecipe> seededRecipes = [
    FamilyRecipe(
      id: 'rec_1',
      name: 'Palak Paneer + Multigrain Rotis',
      glycemicIndex: 42.0, // Low GI safe for diabetics
      isDairyHeavy: false, // Paneer is protein-rich moderate dairy
      baseCalories: 450.0,
      description:
          'Iron & spinach enriched paneer gravy paired with high-fiber multigrain rotis.',
    ),
    FamilyRecipe(
      id: 'rec_2',
      name: 'Yellow Dal Tadka + Jeera Rice',
      glycemicIndex: 62.0, // Higher GI
      isDairyHeavy: false,
      baseCalories: 480.0,
      description: 'Lentil soup with cumin tempered rice.',
    ),
  ];

  const FamilyMealPlannerEngine();

  /// Plans a unified family dinner resolving clinical priorities & personal portion guides
  UnifiedFamilyMealPlan planDinner({
    required List<FamilyMemberProfile> familyMembers,
    List<FamilyRecipe> recipeDatabase = seededRecipes,
  }) {
    // 1. Identify active medical constraints across all family members
    final hasDiabeticMember =
        familyMembers.any((m) => m.goals.contains('diabetes_reversal'));
    final hasPcosMember = familyMembers.any((m) => m.goals.contains('pcos'));

    // 2. Filter base dish to fit clinical conflict hierarchy (Low GI <= 55 for Diabetes, Non-Dairy-Heavy for PCOS)
    final suitableRecipes = recipeDatabase.where((recipe) {
      if (hasDiabeticMember && recipe.glycemicIndex > 55) return false;
      if (hasPcosMember && recipe.isDairyHeavy) return false;
      return true;
    }).toList();

    final baseRecipe = suitableRecipes.isNotEmpty
        ? suitableRecipes.first
        : recipeDatabase.first;

    final summary = hasDiabeticMember
        ? 'Medical Priority: Low Glycemic Index (GI ≤ 55) enforced for diabetic health defense.'
        : 'Standard unified family dinner selection active.';

    // 3. Generate portion sizes and custom side-dish guides per member
    final portionGuides = <String, MemberPortionGuide>{};

    for (final member in familyMembers) {
      double multiplier = 1.0;
      String customNote = 'Standard serving.';
      String rotiText = '2 Multigrain Rotis';
      String sideText = '1 cup Curd + Cucumber Salad';

      if (member.goals.contains('diabetes_reversal')) {
        multiplier = 0.85;
        customNote = 'Glycemic Defense: Portion 1 Roti, double paneer & salad.';
        rotiText = '1 Multigrain Roti';
        sideText = 'Double Paneer & 200g Salad (Glycemic defense)';
      } else if (member.goals.contains('weight_loss')) {
        multiplier = 0.80;
        customNote =
            'Deficit Control: Portion 2 Rotis, double curd, high salad.';
        rotiText = '2 Multigrain Rotis';
        sideText = 'Double Curd + High Salad (Deficit control)';
      } else if (member.goals.contains('growth_stage') ||
          member.goals.contains('muscle_gain')) {
        multiplier = 1.30;
        customNote =
            'Calorie Surplus: Portion 3 Rotis, high paneer, curd with honey.';
        rotiText = '3 Multigrain Rotis';
        sideText = 'High Paneer + Curd with Honey (Calorie surplus)';
      }

      portionGuides[member.id] = MemberPortionGuide(
        portionMultiplier: multiplier,
        customInstruction: customNote,
        rotiGuidance: rotiText,
        sideDishGuidance: sideText,
      );
    }

    return UnifiedFamilyMealPlan(
      selectedRecipe: baseRecipe,
      memberPortions: portionGuides,
      conflictResolutionSummary: summary,
    );
  }
}
