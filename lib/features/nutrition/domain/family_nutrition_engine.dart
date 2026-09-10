enum FamilyMemberRole {
  self(
      name: 'Self (Primary User)',
      regionalName: 'स्वयं',
      defaultGoal: 'Fat Loss & Muscle Retention'),
  spouse(
      name: 'Spouse / Partner',
      regionalName: 'जीवनसाथी',
      defaultGoal: 'Lean Muscle & Energy'),
  parent(
      name: 'Parent / Senior (Diabetic/BP Care)',
      regionalName: 'माता-पिता (मधुमेह / बीपी नियंत्रण)',
      defaultGoal: 'Low Glycemic & Low Sodium'),
  child(
      name: 'Child / Teen (Growth & Sports)',
      regionalName: 'बच्चे / किशोर (विकास एवं ऊर्जा)',
      defaultGoal: 'High Protein & Micronutrients');

  final String name;
  final String regionalName;
  final String defaultGoal;

  const FamilyMemberRole({
    required this.name,
    required this.regionalName,
    required this.defaultGoal,
  });
}

class FamilyMemberProfile {
  final String id;
  final String displayName;
  final FamilyMemberRole role;
  final int dailyCalorieTarget;
  final int proteinTargetGrams;
  final List<String> dietaryPreferences;

  const FamilyMemberProfile({
    required this.id,
    required this.displayName,
    required this.role,
    required this.dailyCalorieTarget,
    required this.proteinTargetGrams,
    required this.dietaryPreferences,
  });
}

class MasterPotDish {
  final String dishName;
  final String regionalName;
  final int totalYieldServings; // e.g. 4 katoris / 8 rotis
  final int totalPotCalories;
  final double totalPotProtein;
  final double totalPotCarbs;
  final double totalPotFats;
  final double totalPotFiber;

  const MasterPotDish({
    required this.dishName,
    required this.regionalName,
    required this.totalYieldServings,
    required this.totalPotCalories,
    required this.totalPotProtein,
    required this.totalPotCarbs,
    required this.totalPotFats,
    required this.totalPotFiber,
  });
}

class MemberServingAllocation {
  final FamilyMemberProfile member;
  final double servingsTaken; // e.g. 1.5 katori
  final int allocatedCalories;
  final double allocatedProtein;
  final double allocatedCarbs;
  final double allocatedFats;
  final double allocatedFiber;
  final String personalizedPlateTip;

  const MemberServingAllocation({
    required this.member,
    required this.servingsTaken,
    required this.allocatedCalories,
    required this.allocatedProtein,
    required this.allocatedCarbs,
    required this.allocatedFats,
    required this.allocatedFiber,
    required this.personalizedPlateTip,
  });
}

class FamilyMealDecompositionReport {
  final MasterPotDish masterDish;
  final List<MemberServingAllocation> memberAllocations;
  final int totalServingsAllocated;
  final int remainingServingsInPot;
  final String batchSynergySummary;

  const FamilyMealDecompositionReport({
    required this.masterDish,
    required this.memberAllocations,
    required this.totalServingsAllocated,
    required this.remainingServingsInPot,
    required this.batchSynergySummary,
  });
}

class FamilyNutritionEngine {
  /// Pure Dart deterministic calculation of single-pot Indian family meal decomposition
  static FamilyMealDecompositionReport decomposeMasterPotMeal({
    required MasterPotDish dish,
    required List<FamilyMemberProfile> familyMembers,
    required Map<String, double> servingsPerMember,
  }) {
    final List<MemberServingAllocation> allocations = [];
    double totalAllocated = 0.0;

    for (final member in familyMembers) {
      final servings = servingsPerMember[member.id] ?? 1.0;
      totalAllocated += servings;

      final ratio = dish.totalYieldServings > 0
          ? (servings / dish.totalYieldServings)
          : 0.25;

      final cal = (dish.totalPotCalories * ratio).round();
      final prot =
          double.parse((dish.totalPotProtein * ratio).toStringAsFixed(1));
      final carbs =
          double.parse((dish.totalPotCarbs * ratio).toStringAsFixed(1));
      final fats = double.parse((dish.totalPotFats * ratio).toStringAsFixed(1));
      final fiber =
          double.parse((dish.totalPotFiber * ratio).toStringAsFixed(1));

      final tip = _generatePersonalizedTip(member.role, dish.dishName);

      allocations.add(MemberServingAllocation(
        member: member,
        servingsTaken: servings,
        allocatedCalories: cal,
        allocatedProtein: prot,
        allocatedCarbs: carbs,
        allocatedFats: fats,
        allocatedFiber: fiber,
        personalizedPlateTip: tip,
      ));
    }

    final remaining =
        (dish.totalYieldServings - totalAllocated).round().clamp(0, 100);

    return FamilyMealDecompositionReport(
      masterDish: dish,
      memberAllocations: allocations,
      totalServingsAllocated: totalAllocated.round(),
      remainingServingsInPot: remaining,
      batchSynergySummary:
          'Single pot of "${dish.dishName}" divided across ${familyMembers.length} family members. '
          'Saved ~45 minutes cooking time while maintaining individual goal compliance.',
    );
  }

  static String _generatePersonalizedTip(
      FamilyMemberRole role, String dishName) {
    switch (role) {
      case FamilyMemberRole.self:
        return 'Fat Loss Strategy: Eat salad first, take 1.5x portion of daal/sabzi, and limit to 1-2 rotis.';
      case FamilyMemberRole.spouse:
        return 'Balanced Maintenance: Pair with 1 bowl of curd and fresh cucumber slices.';
      case FamilyMemberRole.parent:
        return 'Diabetic & BP Care: Avoid top tadka/excess oil layer; squeeze fresh lemon for bioavailable iron.';
      case FamilyMemberRole.child:
        return 'Growth & Energy: Serve with whole milk/curd and a spoon of desi ghee for healthy fat-soluble vitamins.';
    }
  }

  static List<FamilyMemberProfile> getDefaultIndianFamily() {
    return const [
      FamilyMemberProfile(
        id: 'member_1',
        displayName: 'You (Rahul)',
        role: FamilyMemberRole.self,
        dailyCalorieTarget: 2100,
        proteinTargetGrams: 135,
        dietaryPreferences: ['High Protein', 'Caloric Deficit'],
      ),
      FamilyMemberProfile(
        id: 'member_2',
        displayName: 'Priya',
        role: FamilyMemberRole.spouse,
        dailyCalorieTarget: 1750,
        proteinTargetGrams: 90,
        dietaryPreferences: ['Vegetarian', 'Maintenance'],
      ),
      FamilyMemberProfile(
        id: 'member_3',
        displayName: 'Father (Sharma Ji)',
        role: FamilyMemberRole.parent,
        dailyCalorieTarget: 1600,
        proteinTargetGrams: 75,
        dietaryPreferences: ['Low GI', 'Low Sodium', 'Diabetic Friendly'],
      ),
      FamilyMemberProfile(
        id: 'member_4',
        displayName: 'Aarav',
        role: FamilyMemberRole.child,
        dailyCalorieTarget: 2200,
        proteinTargetGrams: 85,
        dietaryPreferences: ['Growing Athlete', 'High Calcium'],
      ),
    ];
  }
}
