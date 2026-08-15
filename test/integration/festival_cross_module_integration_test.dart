import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/festival_adaptation_engine.dart';

void main() {
  group('§P14-C Integration: Festival Cross-Module Adaptation Engine', () {
    const engine = FestivalCrossModuleEngine();

    test(
        'Active Diwali festival applies +200 kcal feast buffer and morning workout strategy',
        () {
      final festivals = FestivalCrossModuleEngine.getSeededFestivals(2026);
      final diwali = festivals.firstWhere((f) => f.type == FestivalType.diwali);

      final adaptation = engine.adapt(diwali);

      // Feast buffer added
      expect(adaptation.calorieBuffer, equals(200));
      expect(adaptation.workoutStrategy, contains('Morning-first'));
      expect(adaptation.coachTone, contains('Celebratory'));
      expect(adaptation.proteinFocus, contains('counteract sweets'));
    });

    test('Navratri Fasting festival enables fasting macro protocol', () {
      final festivals = FestivalCrossModuleEngine.getSeededFestivals(2026);
      final navratri =
          festivals.firstWhere((f) => f.type == FestivalType.navratri);

      final adaptation = engine.adapt(navratri);

      expect(adaptation.isFastingActive, isTrue);
      expect(adaptation.foodDatabaseFilter, equals('fasting_foods_only'));
      expect(adaptation.proteinFocus, contains('Fasting friendly protein'));
    });

    test('Festival survival mode activates 3 days prior to festival start', () {
      final festivals = FestivalCrossModuleEngine.getSeededFestivals(2026);
      final diwali = festivals.firstWhere((f) => f.type == FestivalType.diwali);

      // 2 days before Diwali -> Survival mode active
      final twoDaysBefore = diwali.startDate.subtract(const Duration(days: 2));
      expect(engine.isSurvivalModeActive(diwali, twoDaysBefore), isTrue);

      // 10 days before Diwali -> Survival mode inactive
      final tenDaysBefore = diwali.startDate.subtract(const Duration(days: 10));
      expect(engine.isSurvivalModeActive(diwali, tenDaysBefore), isFalse);
    });
  });
}
