import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/nutrition_periodization_controller.dart';
import 'package:fitkarma/features/food/nutrition_periodization_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _makeTestDb() => AppDatabase.executor(NativeDatabase.memory());

ProviderContainer _makeContainer(AppDatabase db) =>
    ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

void main() {
  group('NutritionPeriodizationEngine Unit Tests', () {
    const engine = NutritionPeriodizationEngine();

    test('calculateMacroTargets computes -20% deficit for Fat Loss phase', () {
      final targets = engine.calculateMacroTargets(
        phase: PeriodizationPhase.fatLoss,
        tdee: 2000.0,
        weightKg: 70.0,
      );

      expect(targets.phase, PeriodizationPhase.fatLoss);
      expect(targets.targetCalories, 1600); // 2000 * 0.80 = 1600
      expect(targets.proteinGrams, 140); // 70 * 2.0 = 140g
    });

    test(
      'calculateMacroTargets computes maintenance TDEE and high protein for Recomposition',
      () {
        final targets = engine.calculateMacroTargets(
          phase: PeriodizationPhase.recomposition,
          tdee: 2500.0,
          weightKg: 80.0,
        );

        expect(targets.phase, PeriodizationPhase.recomposition);
        expect(targets.targetCalories, 2500);
        expect(targets.proteinGrams, 176); // 80 * 2.2 = 176g
      },
    );

    test('calculateMacroTargets computes +10% surplus for Lean Gain phase', () {
      final targets = engine.calculateMacroTargets(
        phase: PeriodizationPhase.leanGain,
        tdee: 2200.0,
        weightKg: 65.0,
      );

      expect(targets.phase, PeriodizationPhase.leanGain);
      expect(targets.targetCalories, 2420); // 2200 * 1.10 = 2420
      expect(targets.proteinGrams, 130); // 65 * 2.0 = 130g
    });

    test(
      'Rule 1: Auto-triggers Diet Break after 8 consecutive weeks in Fat Loss',
      () {
        final eightWeeksAgo = DateTime.now().subtract(const Duration(days: 57));
        final status = engine.checkPhaseProgression(
          currentPhase: PeriodizationPhase.fatLoss,
          phaseStartedAt: eightWeeksAgo,
          recentWeightLogsKg: const [],
        );

        expect(status.actionRequired, isTrue);
        expect(status.nextPhase, PeriodizationPhase.dietBreak);
        expect(status.reason, contains('8+ weeks'));
      },
    );

    test(
      'Rule 2: Auto-triggers Diet Break when weight plateau is detected',
      () {
        // 3 weeks of weight logs with zero variance (< 0.2kg)
        final plateauLogs = List<double>.filled(10, 75.0);
        final threeWeeksAgo = DateTime.now().subtract(const Duration(days: 22));

        final status = engine.checkPhaseProgression(
          currentPhase: PeriodizationPhase.fatLoss,
          phaseStartedAt: threeWeeksAgo,
          recentWeightLogsKg: plateauLogs,
        );

        expect(status.actionRequired, isTrue);
        expect(status.nextPhase, PeriodizationPhase.dietBreak);
        expect(status.reason, contains('Plateau detected'));
      },
    );

    test('Rule 3: Auto-expires Diet Break back to Fat Loss after 2 weeks', () {
      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 15));

      final status = engine.checkPhaseProgression(
        currentPhase: PeriodizationPhase.dietBreak,
        phaseStartedAt: twoWeeksAgo,
        recentWeightLogsKg: const [],
      );

      expect(status.actionRequired, isTrue);
      expect(status.nextPhase, PeriodizationPhase.fatLoss);
      expect(status.reason, contains('completed'));
    });
  });

  group('PeriodizationNotifier & Database Tests', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = _makeTestDb();
      container = _makeContainer(db);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('transitionToPhase updates phase state and target macros', () async {
      final notifier = container.read(periodizationProvider.notifier);
      expect(
        container.read(periodizationProvider).currentPhase,
        PeriodizationPhase.maintenance,
      );

      await notifier.transitionToPhase(PeriodizationPhase.fatLoss);

      final updatedState = container.read(periodizationProvider);
      expect(updatedState.currentPhase, PeriodizationPhase.fatLoss);
      expect(updatedState.macroTargets!.targetCalories, lessThan(2200));
    });

    test('evaluateProgression auto-transitions phase on plateau', () async {
      final notifier = container.read(periodizationProvider.notifier);
      await notifier.transitionToPhase(PeriodizationPhase.fatLoss);

      // Manually set phaseStartedAt to 4 weeks ago
      notifier.state = notifier.state.copyWith(
        phaseStartedAt: DateTime.now().subtract(const Duration(days: 28)),
      );

      final plateauLogs = List<double>.filled(10, 70.0);
      notifier.evaluateProgression(plateauLogs);

      expect(
        container.read(periodizationProvider).currentPhase,
        PeriodizationPhase.dietBreak,
      );
    });
  });
}
