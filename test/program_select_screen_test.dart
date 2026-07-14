import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/onboarding/program_select_controller.dart';
import 'package:fitkarma/features/onboarding/program_select_screen.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

AppDatabase testDb() => AppDatabase.executor(NativeDatabase.memory());

GoRouter _programRouter() => GoRouter(
      initialLocation: AppRoutes.onboardingProgramSelect,
      routes: [
        GoRoute(
          path: AppRoutes.onboardingProgramSelect,
          builder: (_, __) => const ProgramSelectScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboardingPermissions,
          builder: (_, __) => const Scaffold(body: Text('Permissions')),
        ),
      ],
    );

Widget buildSubject(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: _programRouter()),
  );
}

ProviderContainer makeContainer(AppDatabase db) {
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
  );
}

void main() {
  group('ProgramSelectRecommendationEngine Unit Tests', () {
    const engine = ProgramSelectRecommendationEngine();

    test('recommends PCOS Fat Loss if goal contains pcos_management', () {
      final result = engine.recommend(
        age: 28,
        heightCm: 165.0,
        weightKg: 65.0,
        goals: ['pcos_management'],
        doshaDominant: null,
      );
      expect(result.id, 'pcos_fat_loss');
    });

    test('recommends Diabetes Reversal Support if goal contains diabetes_control', () {
      final result = engine.recommend(
        age: 35,
        heightCm: 175.0,
        weightKg: 80.0,
        goals: ['diabetes_control'],
        doshaDominant: null,
      );
      expect(result.id, 'diabetes_support');
    });

    test('recommends Senior Strength if age is 50 or older', () {
      final result = engine.recommend(
        age: 55,
        heightCm: 170.0,
        weightKg: 70.0,
        goals: ['general_fitness'],
        doshaDominant: null,
      );
      expect(result.id, 'senior_strength');
    });

    test('recommends Corporate Fat Loss if BMI >= 25', () {
      final result = engine.recommend(
        age: 30,
        heightCm: 170.0, // BMI = 80 / 1.7^2 = 27.68
        weightKg: 80.0,
        goals: ['weight_loss'],
        doshaDominant: null,
      );
      expect(result.id, 'corporate_fat_loss');
    });

    test('recommends Athletic Performance as fallback default', () {
      final result = engine.recommend(
        age: 25,
        heightCm: 175.0, // BMI = 65 / 1.75^2 = 21.2
        weightKg: 65.0,
        goals: ['general_fitness'],
        doshaDominant: null,
      );
      expect(result.id, 'athletic_performance');
    });
  });

  group('ProgramSelectScreen Widget Tests', () {
    late ProviderContainer container;
    late AppDatabase db;

    setUp(() async {
      db = testDb();
      // Insert onboarding_user row with demographics that trigger Corporate Fat Loss (age 30, BMI = 27.68)
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: 'onboarding_user',
              age: const Value(30),
              height: const Value(170.0),
              weight: const Value(80.0),
              goals: const Value('["weight_loss"]'),
            ),
          );
      container = makeContainer(db);
      container.read(onboardingFlowProvider.notifier).jumpTo(OnboardingStep.programSelect);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    testWidgets('renders progress indicator and recommended program', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      expect(find.textContaining('4 of 5'), findsOneWidget);
      expect(find.textContaining('RECOMMENDED'), findsOneWidget);
      expect(find.text('Corporate Fat Loss'), findsNWidgets(2));
      expect(find.textContaining('Office workers, high stress'), findsOneWidget);
      expect(find.textContaining('Select: Corporate Fat Loss'), findsOneWidget);
    });

    testWidgets('selecting alternate program updates button and saves to DB on continue', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      // Find the card for Indian Vegetarian Muscle Gain
      final vegMuscleCard = find.text('Indian Vegetarian Muscle Gain');
      expect(vegMuscleCard, findsOneWidget);
      
      // Tap alternate program card
      await tester.tap(vegMuscleCard);
      await tester.pumpAndSettle();

      // Verify that selected button changes
      expect(find.textContaining('Select: Indian Vegetarian Muscle Gain'), findsOneWidget);

      // Tap select button
      final selectBtn = find.textContaining('Select: Indian Vegetarian');
      expect(selectBtn, findsOneWidget);
      await tester.ensureVisible(selectBtn);
      await tester.tap(selectBtn);
      await tester.pumpAndSettle();

      // Verify navigation to Permissions
      expect(find.text('Permissions'), findsOneWidget);

      // Verify DB update
      final user = await (db.select(db.users)..where((t) => t.id.equals('onboarding_user'))).getSingle();
      expect(user.currentProgram, 'veg_muscle_gain');
    });
  });
}
