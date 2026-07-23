/// §P5-Q Family Nutrition Integration
///
/// Pure-Dart multi-member meal planning engine resolving Indian household single-kitchen challenges.
/// Features clinical conflict hierarchy (Diabetic low GI <=55), per-member portion guides (Father, Mother, Child),
/// and aggregated multi-member family nutrition plans.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Profile for an individual family member (§P5-Q Specification).
class FamilyMemberProfile {
  const FamilyMemberProfile({
    required this.id,
    required this.name,
    required this.role,
    this.clinicalGoals = const [],
    this.baseCalorieTarget = 2000.0,
    this.proteinTargetG = 65.0,
  });

  final String id;
  final String name;

  /// "Father", "Mother", "Child", "Grandparent"
  final String role;

  /// e.g. ['diabetes_reversal'], ['weight_loss'], ['muscle_gain'], ['growth_stage'], ['pcos']
  final List<String> clinicalGoals;

  final double baseCalorieTarget;
  final double proteinTargetG;
}

/// Tailored portion guide for a specific family member.
class MemberPortionGuide {
  const MemberPortionGuide({
    required this.memberName,
    required this.role,
    required this.baseMultiplier,
    required this.allocatedCalories,
    required this.allocatedProteinG,
    required this.customInstructions,
  });

  final String memberName;
  final String role;
  final double baseMultiplier;
  final double allocatedCalories;
  final double allocatedProteinG;
  final String customInstructions;
}

/// Unified Family Meal payload output from [FamilyMealPlannerEngine].
class UnifiedFamilyMeal {
  const UnifiedFamilyMeal({
    required this.mealTitle,
    required this.baseRecipeName,
    required this.glycemicIndex,
    required this.totalFamilyPortions,
    required this.totalCalories,
    required this.totalProteinG,
    required this.memberPortions,
    required this.isClinicalConflictResolved,
    required this.clinicalSummary,
  });

  final String mealTitle;
  final String baseRecipeName;
  final int glycemicIndex;
  final int totalFamilyPortions;
  final double totalCalories;
  final double totalProteinG;

  /// Map of member id -> portion guide
  final Map<String, MemberPortionGuide> memberPortions;

  final bool isClinicalConflictResolved;
  final String clinicalSummary;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class FamilyMealPlannerEngine {
  const FamilyMealPlannerEngine();

  /// Plans a unified family meal adapting recipes and portions to meet multi-member clinical goals.
  UnifiedFamilyMeal planDinner({
    required List<FamilyMemberProfile> familyMembers,
    String? preferredBaseRecipe,
  }) {
    if (familyMembers.isEmpty) {
      return const UnifiedFamilyMeal(
        mealTitle: 'Standard Family Meal',
        baseRecipeName: 'Dal Tadka & Rice',
        glycemicIndex: 50,
        totalFamilyPortions: 0,
        totalCalories: 0.0,
        totalProteinG: 0.0,
        memberPortions: {},
        isClinicalConflictResolved: true,
        clinicalSummary: 'No family members specified.',
      );
    }

    // 1. Identify active clinical constraints across family members
    final hasDiabeticMember = familyMembers.any(
      (m) => m.clinicalGoals.contains('diabetes_reversal'),
    );
    final hasPcosMember = familyMembers.any(
      (m) => m.clinicalGoals.contains('pcos'),
    );

    // 2. Determine base unified recipe
    String recipeName =
        preferredBaseRecipe ??
        'Palak Paneer + Multigrain Rotis + Curd + Cucumber Salad';
    int gi = 42;
    String clinicalSummary = 'Standard balanced dinner planned.';

    if (hasDiabeticMember) {
      recipeName = 'Palak Paneer + Multigrain Rotis + Curd + Cucumber Salad';
      gi = 42; // Low GI <= 55 required
      clinicalSummary =
          '🟢 Diabetic Safe: Selected low GI (42) Palak Paneer & Multigrain Rotis as main dish.';
    } else if (hasPcosMember) {
      recipeName = 'Tofu Palak + Oats Roti + Greek Yogurt + Salad';
      gi = 40;
      clinicalSummary =
          '🟢 PCOS Friendly: Adjusted dairy & refined carbs to stabilize insulin.';
    }

    // 3. Generate portion guides per family member
    final memberPortions = <String, MemberPortionGuide>{};
    double totalCalories = 0.0;
    double totalProtein = 0.0;

    for (final member in familyMembers) {
      double multiplier = 1.0;
      String note = 'Standard serving (2 Rotis + 1 Bowl Paneer).';

      if (member.clinicalGoals.contains('diabetes_reversal')) {
        multiplier = 0.9;
        note =
            'Portion: 1 Multigrain Roti, double paneer & 200g cucumber salad (Glycemic defense).';
      } else if (member.clinicalGoals.contains('weight_loss')) {
        multiplier = 0.8;
        note = 'Portion: 2 Rotis, double curd, high salad (Deficit control).';
      } else if (member.clinicalGoals.contains('muscle_gain') ||
          member.clinicalGoals.contains('growth_stage')) {
        multiplier = 1.3;
        note =
            'Portion: 3 Rotis, high paneer, curd with honey (Calorie surplus & growth).';
      }

      final allocatedCal =
          member.baseCalorieTarget * 0.35 * multiplier; // Dinner = ~35% TDEE
      final allocatedPro = member.proteinTargetG * 0.35 * multiplier;

      totalCalories += allocatedCal;
      totalProtein += allocatedPro;

      memberPortions[member.id] = MemberPortionGuide(
        memberName: member.name,
        role: member.role,
        baseMultiplier: multiplier,
        allocatedCalories: double.parse(allocatedCal.toStringAsFixed(1)),
        allocatedProteinG: double.parse(allocatedPro.toStringAsFixed(1)),
        customInstructions: note,
      );
    }

    return UnifiedFamilyMeal(
      mealTitle: 'Family Dinner: $recipeName',
      baseRecipeName: recipeName,
      glycemicIndex: gi,
      totalFamilyPortions: familyMembers.length,
      totalCalories: double.parse(totalCalories.toStringAsFixed(1)),
      totalProteinG: double.parse(totalProtein.toStringAsFixed(1)),
      memberPortions: memberPortions,
      isClinicalConflictResolved: true,
      clinicalSummary: clinicalSummary,
    );
  }
}
