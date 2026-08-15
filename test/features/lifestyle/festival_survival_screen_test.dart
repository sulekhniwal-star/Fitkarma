import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/festival_adaptation_engine.dart';
import 'package:fitkarma/features/lifestyle/screens/festival_survival_screen.dart';

void main() {
  group('§P12-A Festival Intelligence System Tests', () {
    const engine = FestivalCrossModuleEngine();

    test('adapt produces correct cross-module targets for Diwali', () {
      final fest = Festival(
        id: 'f1',
        name: 'Diwali',
        type: FestivalType.diwali,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 5),
        description: 'Diwali',
      );

      final adapt = engine.adapt(fest);
      expect(adapt.calorieBuffer, equals(200));
      expect(adapt.proteinFocus, contains('High'));
      expect(adapt.hydrationIncreaseLiters, equals(0.5));
      expect(adapt.workoutStrategy, contains('Morning-first'));
    });

    test('adapt produces fasting food mode and garba recovery for Navratri',
        () {
      final fest = Festival(
        id: 'f2',
        name: 'Navratri',
        type: FestivalType.navratri,
        startDate: DateTime(2026, 10, 3),
        endDate: DateTime(2026, 10, 12),
        description: 'Navratri',
      );

      final adapt = engine.adapt(fest);
      expect(adapt.foodDatabaseFilter, equals('fasting_foods_only'));
      expect(adapt.isFastingActive, isTrue);
    });

    test('isSurvivalModeActive activates 3 days prior to festival', () {
      final fest = Festival(
        id: 'f3',
        name: 'Diwali',
        type: FestivalType.diwali,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 5),
        description: 'Diwali',
      );

      final priorDate = DateTime(2026, 10, 30); // 2 days before start
      expect(engine.isSurvivalModeActive(fest, priorDate), isTrue);

      final farPriorDate = DateTime(2026, 10, 20); // 12 days before
      expect(engine.isSurvivalModeActive(fest, farPriorDate), isFalse);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'FestivalSurvivalScreen renders Survival Mode banner and cross-module matrix',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FestivalSurvivalScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Festival Survival Mode'), findsOneWidget);
      expect(find.text('SURVIVAL MODE ACTIVE'), findsOneWidget);
      expect(find.text('Cross-Module Targets Matrix'), findsOneWidget);
      expect(find.text('Tracked Festivals & Presets'), findsOneWidget);
      expect(find.text('Navratri'), findsOneWidget);
    });
  });
}
