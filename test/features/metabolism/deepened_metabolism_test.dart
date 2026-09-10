import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/metabolism/domain/adaptive_metabolism_engine.dart';
import 'package:fitkarma/features/metabolism/domain/deepened_metabolism_engine.dart';
import 'package:fitkarma/features/metabolism/domain/deepened_metabolism_models.dart';
import 'package:fitkarma/features/metabolism/providers/deepened_metabolism_provider.dart';

void main() {
  group('DeepenedMetabolismEngine Deterministic Tests', () {
    const engine = DeepenedMetabolismEngine();

    test('Decomposes TDEE into BMR, TEF, EAT, and NEAT components accurately',
        () {
      final report = engine.synthesizeDeepenedMetabolism(
        weightKg: 75.0,
        heightCm: 178.0,
        age: 30,
        sex: BiologicalSex.male,
        goal: NutritionGoal.fatLoss,
        bodyFatPercentage: 15.0,
        dailySteps: 10000,
        workoutMinutesDaily: 60,
      );

      final decomp = report.decomposition;
      expect(decomp.bmrCalories, greaterThan(1500));
      expect(decomp.tefCalories, greaterThan(150));
      expect(decomp.eatCalories, greaterThan(300));
      expect(decomp.neatCalories, greaterThan(350));
      expect(decomp.totalDecomposedTdee, greaterThan(2200));
    });

    test('Severe adaptive thermogenesis triggers 48-Hour Refeed or Diet Break',
        () {
      // User with prolonged deficit and suppressed dynamic TDEE
      final suppressedReport = engine.synthesizeDeepenedMetabolism(
        weightKg: 80.0,
        heightCm: 180.0,
        age: 28,
        sex: BiologicalSex.male,
        goal: NutritionGoal.fatLoss,
        avgDailyIntake14Days: 1600.0,
        weightDelta14DaysKg: 0.1, // Gained or stalled weight on low calories
        weeksInDeficit: 8,
      );

      expect(suppressedReport.isMetabolicAdaptationSevere, isTrue);
      expect(
          suppressedReport.jatharagniState, equals(JatharagniState.mandagni));
      expect(suppressedReport.recommendedRefeed,
          equals(RefeedProtocol.fullDietBreak));
      expect(suppressedReport.metabolicResistanceScore, greaterThan(50));
    });

    test('Calculates distinct macro-cycling targets for Training vs Rest days',
        () {
      final report = engine.synthesizeDeepenedMetabolism(
        weightKg: 70.0,
        heightCm: 172.0,
        age: 26,
        sex: BiologicalSex.male,
        goal: NutritionGoal.fatLoss,
      );

      final cycling = report.macroCycling;
      expect(cycling.trainingDayCalories, greaterThan(cycling.restDayCalories));
      expect(cycling.trainingDayCarbsGrams,
          greaterThan(cycling.restDayCarbsGrams));
      expect(
          cycling.trainingDayProteinGrams, equals(cycling.restDayProteinGrams));
    });
  });

  group('Deepened Metabolism StateNotifier Provider Tests', () {
    test('StateNotifier switches day type and activates refeed protocol', () {
      final notifier = DeepenedMetabolismNotifier();

      expect(notifier.state.dayType, equals(ActiveDayType.trainingDay));
      expect(notifier.state.isRefeedActive, isFalse);

      notifier.setDayType(ActiveDayType.restDay);
      expect(notifier.state.dayType, equals(ActiveDayType.restDay));

      notifier.toggleRefeedMode();
      expect(notifier.state.isRefeedActive, isTrue);
      expect(
          notifier.state.successMessage, contains('Refeed protocol activated'));

      notifier.toggleRefeedMode();
      expect(notifier.state.isRefeedActive, isFalse);
    });
  });
}
