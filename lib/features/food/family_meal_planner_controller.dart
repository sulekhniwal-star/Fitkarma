/// §P5-Q Family Meal Planner Controller
///
/// Riverpod Notifier managing family member profiles (Father, Mother, Child),
/// clinical goal updates, and reactive unified family meal generation.
library;

import 'package:fitkarma/features/food/family_meal_planner_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class FamilyMealPlannerState {
  const FamilyMealPlannerState({
    this.familyMembers = const [],
    required this.currentUnifiedMeal,
  });

  final List<FamilyMemberProfile> familyMembers;
  final UnifiedFamilyMeal currentUnifiedMeal;

  FamilyMealPlannerState copyWith({
    List<FamilyMemberProfile>? familyMembers,
    UnifiedFamilyMeal? currentUnifiedMeal,
  }) {
    return FamilyMealPlannerState(
      familyMembers: familyMembers ?? this.familyMembers,
      currentUnifiedMeal: currentUnifiedMeal ?? this.currentUnifiedMeal,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final familyMealPlannerEngineProvider = Provider<FamilyMealPlannerEngine>((
  ref,
) {
  return const FamilyMealPlannerEngine();
});

class FamilyMealPlannerNotifier extends Notifier<FamilyMealPlannerState> {
  static const defaultFamilyPresets = [
    FamilyMemberProfile(
      id: 'f_father',
      name: 'Rajesh (Father)',
      role: 'Father',
      clinicalGoals: ['diabetes_reversal'],
      baseCalorieTarget: 2200.0,
      proteinTargetG: 70.0,
    ),
    FamilyMemberProfile(
      id: 'f_mother',
      name: 'Sunita (Mother)',
      role: 'Mother',
      clinicalGoals: ['weight_loss'],
      baseCalorieTarget: 1800.0,
      proteinTargetG: 60.0,
    ),
    FamilyMemberProfile(
      id: 'f_child',
      name: 'Aarav (Child)',
      role: 'Child',
      clinicalGoals: ['growth_stage'],
      baseCalorieTarget: 2100.0,
      proteinTargetG: 65.0,
    ),
  ];

  @override
  FamilyMealPlannerState build() {
    final engine = ref.watch(familyMealPlannerEngineProvider);
    final initialMeal = engine.planDinner(familyMembers: defaultFamilyPresets);

    return FamilyMealPlannerState(
      familyMembers: defaultFamilyPresets,
      currentUnifiedMeal: initialMeal,
    );
  }

  /// Adds a new family member.
  void addFamilyMember(FamilyMemberProfile member) {
    final updated = List<FamilyMemberProfile>.from(state.familyMembers)
      ..add(member);
    final engine = ref.read(familyMealPlannerEngineProvider);
    final newMeal = engine.planDinner(familyMembers: updated);

    state = state.copyWith(familyMembers: updated, currentUnifiedMeal: newMeal);
  }

  /// Updates clinical goals for a family member.
  void updateMemberGoals(String memberId, List<String> goals) {
    final updated = state.familyMembers.map((m) {
      if (m.id == memberId) {
        return FamilyMemberProfile(
          id: m.id,
          name: m.name,
          role: m.role,
          clinicalGoals: goals,
          baseCalorieTarget: m.baseCalorieTarget,
          proteinTargetG: m.proteinTargetG,
        );
      }
      return m;
    }).toList();

    final engine = ref.read(familyMealPlannerEngineProvider);
    final newMeal = engine.planDinner(familyMembers: updated);

    state = state.copyWith(familyMembers: updated, currentUnifiedMeal: newMeal);
  }
}

final familyMealPlannerProvider =
    NotifierProvider<FamilyMealPlannerNotifier, FamilyMealPlannerState>(
      FamilyMealPlannerNotifier.new,
    );
