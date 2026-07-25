/// §P12-A Festival Intelligence System — Unit & Integration Tests

import 'package:fitkarma/features/festival/festival_controller.dart';
import 'package:fitkarma/features/festival/festival_intelligence_engine.dart';
import 'package:fitkarma/features/festival/festival_models.dart';
import 'package:fitkarma/features/festival/indian_festival_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = FestivalIntelligenceEngine();

  group('§P12-A Indian Festival Calendar Dataset Tests', () {
    test('contains comprehensive pan-Indian festival dates for 2026', () {
      final festivals = IndianFestivalCalendarDataset.festivals;

      expect(festivals, isNotEmpty);
      expect(festivals.any((f) => f.name.contains('Diwali')), isTrue);
      expect(festivals.any((f) => f.name.contains('Holi')), isTrue);
      expect(festivals.any((f) => f.name.contains('Navratri')), isTrue);
      expect(festivals.any((f) => f.name.contains('Eid')), isTrue);
      expect(festivals.any((f) => f.name.contains('Karwa Chauth')), isTrue);
      expect(festivals.any((f) => f.name.contains('Durga Puja')), isTrue);
    });
  });

  group('§P12-A FestivalIntelligenceEngine Detection & Phase Tests', () {
    test('detects main festival day for Diwali 2026', () {
      final (event, phase) = engine.detectActiveFestival(DateTime(2026, 11, 8));

      expect(event, isNotNull);
      expect(event!.name, contains('Diwali'));
      expect(phase, equals(FestivalAdaptationPhase.mainFestival));
    });

    test('detects pre-compensation phase 2 days prior to Diwali 2026', () {
      final (event, phase) = engine.detectActiveFestival(DateTime(2026, 11, 6));

      expect(event, isNotNull);
      expect(event!.name, contains('Diwali'));
      expect(phase, equals(FestivalAdaptationPhase.preCompensation));
    });

    test('detects post-recovery phase 1 day after Diwali 2026', () {
      final (event, phase) = engine.detectActiveFestival(DateTime(2026, 11, 11));

      expect(event, isNotNull);
      expect(event!.name, contains('Diwali'));
      expect(phase, equals(FestivalAdaptationPhase.postRecovery));
    });

    test('returns none phase for regular non-festival days', () {
      final (event, phase) = engine.detectActiveFestival(DateTime(2026, 5, 10));

      expect(event, isNull);
      expect(phase, equals(FestivalAdaptationPhase.none));
    });
  });

  group('§P12-A Cross-Module Festival Adaptation Hooks Tests', () {
    test('Diwali main festival day generates Nutrition +400 kcal & Workout post-feast walk', () {
      final adaptation = engine.generateCrossModuleAdaptation(DateTime(2026, 11, 8));

      expect(adaptation.hasActiveAdaptation, isTrue);
      expect(adaptation.phase, equals(FestivalAdaptationPhase.mainFestival));

      // Nutrition Hook
      expect(adaptation.nutritionAdaptation.caloriesDelta, equals(400));
      expect(adaptation.nutritionAdaptation.proteinGDelta, equals(15));
      expect(adaptation.nutritionAdaptation.bannerNote, contains('+400 kcal festive sweet buffer enabled'));

      // Workout Hook
      expect(adaptation.workoutAdaptation.targetWorkoutType, contains('Post-Feast'));
      expect(adaptation.workoutAdaptation.recommendedRpeMax, equals(7));

      // Daily Mission Hook
      expect(adaptation.missionAdaptation.missionTitle, contains('Mindfulness'));

      // AI Coach Context Hook
      expect(adaptation.aiCoachPromptContext, contains('User is celebrating'));
    });

    test('Navratri fasting day generates Sattvic Nutrition & RPE 5 Gentle Yoga Workout', () {
      final adaptation = engine.generateCrossModuleAdaptation(DateTime(2026, 3, 22));

      expect(adaptation.hasActiveAdaptation, isTrue);

      // Nutrition Hook
      expect(adaptation.nutritionAdaptation.sattvicFocus, isTrue);
      expect(adaptation.nutritionAdaptation.bannerNote, contains('Sattvic Fasting Mode'));

      // Workout Hook
      expect(adaptation.workoutAdaptation.recommendedRpeMax, equals(5));
      expect(adaptation.workoutAdaptation.targetWorkoutType, contains('Gentle Yoga'));

      // AI Coach Context Hook
      expect(adaptation.aiCoachPromptContext, contains('Sattvic protein'));
    });

    test('Post-festival recovery day generates Hydration Flush mission & cardio workout', () {
      final adaptation = engine.generateCrossModuleAdaptation(DateTime(2026, 11, 11));

      expect(adaptation.hasActiveAdaptation, isTrue);
      expect(adaptation.phase, equals(FestivalAdaptationPhase.postRecovery));

      // Nutrition Hook
      expect(adaptation.nutritionAdaptation.waterLDelta, equals(1.0));
      expect(adaptation.nutritionAdaptation.caloriesDelta, equals(-100));

      // Daily Mission Hook
      expect(adaptation.missionAdaptation.missionTitle, contains('Hydration Flush'));

      // Workout Hook
      expect(adaptation.workoutAdaptation.cardioMinutes, equals(30));
    });
  });

  group('§P12-A FestivalController Integration Tests', () {
    test('FestivalIntelligenceNotifier updates state reactively when checking dates', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(festivalIntelligenceProvider.notifier);

      // Check Diwali festival date
      notifier.checkDate(DateTime(2026, 11, 8));
      final state = container.read(festivalIntelligenceProvider);

      expect(state.hasActiveAdaptation, isTrue);
      expect(state.activeFestival!.name, contains('Diwali'));
    });
  });
}
