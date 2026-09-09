import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/festival_intelligence_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/festival_intelligence_models.dart';

void main() {
  group('FestivalIntelligenceEngine Deterministic Tests', () {
    const engine = FestivalIntelligenceEngine();

    test('Generates positive calorie buffer and Agni protection strategies for Diwali feasting', () {
      final plan = engine.generateFestivalPlan(
        festival: IndianFestival.diwali,
        isFestivalModeActive: true,
        daysUntilFestival: 2,
      );

      expect(plan.activeFestival, equals(IndianFestival.diwali));
      expect(plan.isFestivalModeActive, isTrue);
      expect(plan.daysUntilFestival, equals(2));
      expect(plan.calorieDeltaTarget, equals(450));
      expect(plan.pillarStrategies.length, equals(4));
      expect(plan.pillarStrategies.any((p) => p.pillarName.contains('Workout')), isTrue);
      expect(plan.pillarStrategies.any((p) => p.pillarName.contains('Agni')), isTrue);
      expect(plan.mindfulFeastingTip, contains('Kaju Katli'));
      expect(plan.regionalMindfulFeastingTip, contains('काजू कतली'));
      expect(plan.aiCoachToneOverride, contains('Festive Harmony'));
    });

    test('Generates Satvik Vrat and electrolyte protocol for Navratri fasting', () {
      final plan = engine.generateFestivalPlan(
        festival: IndianFestival.navratri,
        isFestivalModeActive: true,
      );

      expect(plan.activeFestival.isFastingCentric, isTrue);
      expect(plan.calorieDeltaTarget, equals(-200));
      expect(plan.pillarStrategies.length, equals(4));
      expect(plan.pillarStrategies.any((p) => p.pillarName.contains('Satvik')), isTrue);
      expect(plan.pillarStrategies.any((p) => p.pillarName.contains('Electrolyte')), isTrue);
      expect(plan.pillarStrategies.any((p) => p.detailedProtocol.contains('Sendha Namak')), isTrue);
    });

    test('Generates 3-day post-festival metabolic reset roadmap with Ayurvedic remedies', () {
      final plan = engine.generateFestivalPlan(festival: IndianFestival.holi);

      expect(plan.postFestivalResetProtocol.length, equals(3));
      expect(plan.postFestivalResetProtocol[0].dayNumber, equals(1));
      expect(plan.postFestivalResetProtocol[0].ayurvedicDigestiveRemedy, contains('Triphala'));
      expect(plan.postFestivalResetProtocol[1].dayNumber, equals(2));
      expect(plan.postFestivalResetProtocol[1].dietaryProtocol, contains('Khichdi'));
      expect(plan.postFestivalResetProtocol[2].dayNumber, equals(3));
      expect(plan.postFestivalResetProtocol[2].focusTheme, contains('Peak Training'));
    });

    test('All Pan-Indian festival values produce complete valid adaptation plans', () {
      for (final festival in IndianFestival.values) {
        final plan = engine.generateFestivalPlan(festival: festival);
        expect(plan.activeFestival, equals(festival));
        expect(plan.pillarStrategies, isNotEmpty);
        expect(plan.postFestivalResetProtocol, isNotEmpty);
        expect(plan.mindfulFeastingTip, isNotEmpty);
        expect(plan.regionalMindfulFeastingTip, isNotEmpty);
      }
    });
  });
}
