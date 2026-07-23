import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/micronutrient_controller.dart';
import 'package:fitkarma/features/food/micronutrient_dashboard_screen.dart';
import 'package:fitkarma/features/food/micronutrient_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _makeTestDb() => AppDatabase.executor(NativeDatabase.memory());

ProviderContainer _makeContainer(AppDatabase db) =>
    ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: MicronutrientDashboardScreen()),
    );

void main() {
  group('MicronutrientEngine Unit Tests', () {
    const engine = MicronutrientEngine();

    test('MicroRdaConfig calculates cohort-specific RDA targets', () {
      final maleConfig = MicroRdaConfig.forUser(isFemale: false, isVegetarian: false);
      expect(maleConfig.ironMg, 8.0);
      expect(maleConfig.vitaminB12Mcg, 2.4);

      final vegFemaleConfig = MicroRdaConfig.forUser(isFemale: true, isVegetarian: true);
      // Non-heme iron 1.8x RDA (18 * 1.8 = 32.4mg)
      expect(vegFemaleConfig.ironMg, 32.4);
      expect(vegFemaleConfig.vitaminB12Mcg, 3.0);
    });

    test('estimateMicrosForFood maps Indian food queries accurately', () {
      final spinach = engine.estimateMicrosForFood('Palak Paneer');
      expect(spinach.ironMg, greaterThan(0));
      expect(spinach.calciumMg, greaterThan(0));

      final eggs = engine.estimateMicrosForFood('Egg Bhurji');
      expect(eggs.vitaminB12Mcg, greaterThan(0));
    });

    test('evaluateDeficiencyRisk triggers B12 warning for low vegetarian B12 intake', () {
      final rda = MicroRdaConfig.forUser(isFemale: true, isVegetarian: true);
      const lowB12Summary = DailyMicronutrientSummary(
        ironMg: 20.0,
        vitaminB12Mcg: 0.5, // 0.5 / 3.0 = 16.6% (< 50%)
      );

      final alerts = engine.evaluateDeficiencyRisk(
        recent7DayLogs: [lowB12Summary],
        rdaTargets: rda,
        isVegetarian: true,
        isFemale: true,
      );

      expect(alerts, isNotEmpty);
      expect(alerts.any((a) => a.affectedNutrient == MicronutrientType.vitaminB12), isTrue);
      expect(alerts.first.title, contains('B12 Depletion Risk'));
    });

    test('evaluateDeficiencyRisk triggers Iron warning for low female iron intake', () {
      final rda = MicroRdaConfig.forUser(isFemale: true, isVegetarian: false);
      const lowIronSummary = DailyMicronutrientSummary(
        ironMg: 5.0, // 5 / 18 = 27% (< 60%)
        vitaminB12Mcg: 2.5,
      );

      final alerts = engine.evaluateDeficiencyRisk(
        recent7DayLogs: [lowIronSummary],
        rdaTargets: rda,
        isVegetarian: false,
        isFemale: true,
      );

      expect(alerts.any((a) => a.affectedNutrient == MicronutrientType.iron), isTrue);
      expect(alerts.any((a) => a.recommendation.contains('Vitamin C')), isTrue);
    });
  });

  group('MicronutrientDashboardScreen UI & Drift Integration Tests', () {
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

    testWidgets('renders micronutrient dashboard with coverage gauge, alerts, and 8 biomarkers', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.text('Micronutrient Core 2.0'), findsOneWidget);
      expect(find.byKey(const Key('micro_overall_coverage_pct')), findsOneWidget);
      expect(find.text('Essential 8 Biomarker Progress'), findsOneWidget);
      expect(find.textContaining('Iron'), findsWidgets);
      expect(find.textContaining('Vitamin B12'), findsWidgets);
    });

    testWidgets('toggling demographics chip updates state and recalculates alerts', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Toggle vegetarian chip
      await tester.tap(find.byKey(const Key('micro_chip_veg')));
      await tester.pump();

      final state = container.read(micronutrientProvider);
      expect(state.isVegetarian, isFalse);
    });

    testWidgets('adding logged foods to foodProvider updates micronutrient summary and persists to Drift', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      container.read(foodProvider.notifier).addFood(
        const FoodItem(id: 'palak_1', name: 'Palak Paneer', calories: 350, protein: 18, carbs: 10, fat: 20, mealType: 'Lunch'),
      );
      await tester.pump();

      final microState = container.read(micronutrientProvider);
      expect(microState.summary.ironMg, greaterThan(0));

      final persistedLogs = await db.getMicronutrientLogs('local_user');
      expect(persistedLogs, isNotEmpty);
    });
  });
}
