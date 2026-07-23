import 'package:fitkarma/features/food/family_meal_planner_card.dart';
import 'package:fitkarma/features/food/family_meal_planner_controller.dart';
import 'package:fitkarma/features/food/family_meal_planner_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
  container: container,
  child: const MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: FamilyMealPlannerCard())),
  ),
);

void main() {
  group('FamilyMealPlannerEngine Unit Tests', () {
    const engine = FamilyMealPlannerEngine();

    test(
      'planDinner resolves clinical conflicts when family member has diabetes_reversal',
      () {
        const family = [
          FamilyMemberProfile(
            id: '1',
            name: 'Rajesh',
            role: 'Father',
            clinicalGoals: ['diabetes_reversal'],
            baseCalorieTarget: 2200,
            proteinTargetG: 70,
          ),
          FamilyMemberProfile(
            id: '2',
            name: 'Sunita',
            role: 'Mother',
            clinicalGoals: ['weight_loss'],
            baseCalorieTarget: 1800,
            proteinTargetG: 60,
          ),
        ];

        final meal = engine.planDinner(familyMembers: family);

        expect(meal.glycemicIndex, lessThanOrEqualTo(55));
        expect(meal.isClinicalConflictResolved, isTrue);
        expect(meal.clinicalSummary, contains('Diabetic Safe'));
        expect(meal.memberPortions['1']!.baseMultiplier, 0.9);
        expect(meal.memberPortions['2']!.baseMultiplier, 0.8);
      },
    );

    test(
      'planDinner scales portion multipliers correctly for growth_stage / muscle_gain',
      () {
        const family = [
          FamilyMemberProfile(
            id: '3',
            name: 'Aarav',
            role: 'Child',
            clinicalGoals: ['growth_stage'],
            baseCalorieTarget: 2100,
            proteinTargetG: 65,
          ),
        ];

        final meal = engine.planDinner(familyMembers: family);

        expect(meal.memberPortions['3']!.baseMultiplier, 1.3);
        expect(
          meal.memberPortions['3']!.customInstructions,
          contains('3 Rotis'),
        );
      },
    );
  });

  group('FamilyMealPlannerCard UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets(
      'renders FamilyMealPlannerCard with unified dinner header and member portion tiles',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        expect(
          find.byKey(const Key('family_meal_planner_card')),
          findsOneWidget,
        );
        expect(find.text('Unified Family Dinner 🍲'), findsOneWidget);
        expect(
          find.byKey(const Key('family_clinical_summary_text')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('member_portion_tile_Father')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('member_portion_tile_Mother')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('member_portion_tile_Child')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'updating member goals updates clinical summary and portion guides',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        container.read(familyMealPlannerProvider.notifier).updateMemberGoals(
          'f_father',
          ['diabetes_reversal', 'pcos'],
        );
        await tester.pump();

        final state = container.read(familyMealPlannerProvider);
        expect(state.currentUnifiedMeal.isClinicalConflictResolved, isTrue);
      },
    );
  });
}
