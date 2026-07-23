import 'package:fitkarma/features/food/smart_festival_controller.dart';
import 'package:fitkarma/features/food/smart_festival_nutrition_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SmartFestivalNutritionEngine Unit Tests', () {
    const engine = SmartFestivalNutritionEngine();
    const baseline = BaselineNutritionTargets(
      calories: 2000,
      proteinG: 110,
      carbsG: 220,
      fatG: 65,
      waterL: 2.5,
    );

    test('detectFestival matches exact festival date for Diwali 2026', () {
      final diwaliDate = DateTime(2026, 11, 8);
      final (event, phase) = engine.detectFestival(diwaliDate);

      expect(event, isNotNull);
      expect(event!.type, FestivalType.diwali);
      expect(phase, FestivalDayRelative.festivalDay);
    });

    test(
      'detectFestival matches pre3Days pre-compensation window for Diwali 2026',
      () {
        final preDiwaliDate = DateTime(2026, 11, 6);
        final (event, phase) = engine.detectFestival(preDiwaliDate);

        expect(event, isNotNull);
        expect(event!.type, FestivalType.diwali);
        expect(phase, FestivalDayRelative.pre3Days);
      },
    );

    test('detectFestival matches post1Day recovery window for Diwali 2026', () {
      final postDiwaliDate = DateTime(2026, 11, 11);
      final (event, phase) = engine.detectFestival(postDiwaliDate);

      expect(event, isNotNull);
      expect(event!.type, FestivalType.diwali);
      expect(phase, FestivalDayRelative.post1Day);
    });

    test(
      'Diwali pre3Days protocol reduces target calories by -150 kcal for buffer',
      () {
        final event = SmartFestivalNutritionEngine.festivalCalendar2026
            .firstWhere((e) => e.type == FestivalType.diwali);
        final adjusted = engine.adjustTargets(
          baseline: baseline,
          event: event,
          relativeDay: FestivalDayRelative.pre3Days,
        );

        expect(adjusted.adjustedCalories, 1850); // 2000 - 150 = 1850
        expect(adjusted.bannerMessage, contains('Diwali Buffer Active'));
      },
    );

    test(
      'Diwali festivalDay protocol allocates +400 kcal & +15g protein for sweets',
      () {
        final event = SmartFestivalNutritionEngine.festivalCalendar2026
            .firstWhere((e) => e.type == FestivalType.diwali);
        final adjusted = engine.adjustTargets(
          baseline: baseline,
          event: event,
          relativeDay: FestivalDayRelative.festivalDay,
        );

        expect(adjusted.adjustedCalories, 2400); // 2000 + 400 = 2400
        expect(adjusted.adjustedProteinG, 125); // 110 + 15 = 125g
        expect(
          adjusted.satietyNudge,
          contains('Eat your high-protein sources'),
        );
      },
    );

    test(
      'Diwali post1Day protocol allocates +1.0L water & 45-min recovery walk',
      () {
        final event = SmartFestivalNutritionEngine.festivalCalendar2026
            .firstWhere((e) => e.type == FestivalType.diwali);
        final adjusted = engine.adjustTargets(
          baseline: baseline,
          event: event,
          relativeDay: FestivalDayRelative.post1Day,
        );

        expect(adjusted.adjustedWaterL, 3.5); // 2.5 + 1.0 = 3.5L
        expect(adjusted.recommendedCardioMin, 45);
        expect(adjusted.bannerMessage, contains('Post-Diwali Hydration'));
      },
    );

    test(
      'Holi festivalDay protocol allocates +1.0L water & +350 kcal buffer',
      () {
        final event = SmartFestivalNutritionEngine.festivalCalendar2026
            .firstWhere((e) => e.type == FestivalType.holi);
        final adjusted = engine.adjustTargets(
          baseline: baseline,
          event: event,
          relativeDay: FestivalDayRelative.festivalDay,
        );

        expect(adjusted.adjustedCalories, 2350); // 2000 + 350 = 2350
        expect(adjusted.adjustedWaterL, 3.5); // 2.5 + 1.0 = 3.5L
        expect(adjusted.bannerMessage, contains('Happy Holi'));
      },
    );
  });

  group('FestivalNutritionNotifier Integration Tests', () {
    test(
      'FestivalNutritionNotifier updates state reactively when checking festival dates',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(festivalNutritionProvider.notifier);
        expect(
          container.read(festivalNutritionProvider).hasActiveAdaptation,
          isFalse,
        );

        // Check Diwali festival date
        notifier.checkFestivalForDate(DateTime(2026, 11, 8));

        final state = container.read(festivalNutritionProvider);
        expect(state.hasActiveAdaptation, isTrue);
        expect(state.activeEvent!.name, contains('Diwali'));
        expect(state.adjustedTargets.adjustedCalories, 2400);
      },
    );
  });
}
