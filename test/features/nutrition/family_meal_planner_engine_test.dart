import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/family_meal_planner_engine.dart';
import 'package:fitkarma/features/nutrition/screens/family_dinner_screen.dart';

void main() {
  group('§P5-Q Family Nutrition Integration Tests', () {
    const engine = FamilyMealPlannerEngine();

    final family = const [
      FamilyMemberProfile(id: 'fam_1', name: 'Father (Rajesh)', role: 'Father', goals: ['diabetes_reversal']),
      FamilyMemberProfile(id: 'fam_2', name: 'Mother (Sunita)', role: 'Mother', goals: ['weight_loss']),
      FamilyMemberProfile(id: 'fam_3', name: 'Child (Aarav)', role: 'Child', goals: ['growth_stage']),
    ];

    test('planDinner enforces Low GI <= 55 base dish when diabetic member is present', () {
      final plan = engine.planDinner(familyMembers: family);

      expect(plan.selectedRecipe.glycemicIndex, lessThanOrEqualTo(55.0));
      expect(plan.conflictResolutionSummary, contains('Low Glycemic Index'));
    });

    test('planDinner calculates member portion multipliers per clinical goal (Father 1 Roti, Mother 2 Rotis, Child 3 Rotis)', () {
      final plan = engine.planDinner(familyMembers: family);

      final fatherPortion = plan.memberPortions['fam_1']!;
      expect(fatherPortion.rotiGuidance, contains('1 Multigrain Roti'));
      expect(fatherPortion.customInstruction, contains('Glycemic Defense'));

      final motherPortion = plan.memberPortions['fam_2']!;
      expect(motherPortion.rotiGuidance, contains('2 Multigrain Rotis'));

      final childPortion = plan.memberPortions['fam_3']!;
      expect(childPortion.rotiGuidance, contains('3 Multigrain Rotis'));
      expect(childPortion.customInstruction, contains('Calorie Surplus'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('FamilyDinnerScreen renders unified base dish, conflict summary, and 3 member portion cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FamilyDinnerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Family Dinner Engine'), findsOneWidget);
      expect(find.text('Palak Paneer + Multigrain Rotis'), findsOneWidget);
      expect(find.text('Father (Rajesh)'), findsOneWidget);
      expect(find.text('Mother (Sunita)'), findsOneWidget);
      expect(find.text('Child (Aarav)'), findsOneWidget);
    });
  });
}
