import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/festival_engine.dart';
import 'package:fitkarma/features/festivals/models/festival_model.dart';

void main() {
  group('FestivalEngine Survival Mode & Fasting Filter Tests', () {
    const engine = FestivalEngine();

    test('3-day Survival Mode pre-activates 2 days before festival start', () {
      final festival = FestivalEvent(
        id: 'diwali',
        name: 'Diwali',
        startDate: DateTime(2026, 11, 1),
        durationDays: 5,
        description: 'Diwali Feast',
      );

      final shouldActivate = engine.shouldActivateSurvivalMode(
        festival: festival,
        currentDate: DateTime(2026, 10, 30), // 2 days before
      );

      expect(shouldActivate, isTrue);
    });

    test('Navratri allowed foods list returns Satvik items', () {
      final foods = engine.getNavratriAllowedFoods();

      expect(foods, contains('Sabudana Khichdi (Low Oil)'));
      expect(foods, contains('Kuttu Atta Paratha'));
      expect(foods.any((f) => f.contains('Non-Veg')), isFalse);
    });
  });
}
