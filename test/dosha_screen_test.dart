import 'dart:convert';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/onboarding/dosha_controller.dart';
import 'package:fitkarma/features/onboarding/dosha_screen.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

AppDatabase testDb() => AppDatabase.executor(NativeDatabase.memory());

GoRouter _doshaRouter() => GoRouter(
      initialLocation: AppRoutes.onboardingDosha,
      routes: [
        GoRoute(
          path: AppRoutes.onboardingDosha,
          builder: (_, __) => const DoshaScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboardingProgramSelect,
          builder: (_, __) => const Scaffold(body: Text('ProgramSelect')),
        ),
      ],
    );

Widget buildSubject(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: _doshaRouter()),
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
  group('DoshaQuizScoringEngine Unit Tests', () {
    const engine = DoshaQuizScoringEngine();

    test('empty answers returns equal distribution with Vata fallback', () {
      final result = engine.calculateDoshaProfile({});
      expect(result.dominant, DoshaType.vata);
      expect(result.vataPct, 33.3);
      expect(result.pittaPct, 33.3);
      expect(result.kaphaPct, 33.3);
    });

    test('dominant Vata calculation', () {
      final answers = {
        'q1': DoshaType.vata,
        'q2': DoshaType.vata,
        'q3': DoshaType.pitta,
      };
      final result = engine.calculateDoshaProfile(answers);
      expect(result.dominant, DoshaType.vata);
      expect(result.vataPct, closeTo(66.7, 0.1));
      expect(result.pittaPct, closeTo(33.3, 0.1));
      expect(result.kaphaPct, 0.0);
    });

    test('dominant Pitta calculation', () {
      final answers = {
        'q1': DoshaType.pitta,
        'q2': DoshaType.pitta,
        'q3': DoshaType.kapha,
      };
      final result = engine.calculateDoshaProfile(answers);
      expect(result.dominant, DoshaType.pitta);
      expect(result.pittaPct, closeTo(66.7, 0.1));
      expect(result.kaphaPct, closeTo(33.3, 0.1));
      expect(result.vataPct, 0.0);
    });

    test('dominant Kapha calculation', () {
      final answers = {
        'q1': DoshaType.kapha,
        'q2': DoshaType.kapha,
        'q3': DoshaType.vata,
      };
      final result = engine.calculateDoshaProfile(answers);
      expect(result.dominant, DoshaType.kapha);
      expect(result.kaphaPct, closeTo(66.7, 0.1));
      expect(result.vataPct, closeTo(33.3, 0.1));
      expect(result.pittaPct, 0.0);
    });
  });

  group('DoshaScreen Widget Tests', () {
    late ProviderContainer container;
    late AppDatabase db;

    setUp(() async {
      db = testDb();
      // Insert onboarding_user row to satisfy DB constraints
      await db.into(db.users).insert(
            UsersCompanion.insert(id: 'onboarding_user'),
          );
      container = makeContainer(db);
      container.read(onboardingFlowProvider.notifier).jumpTo(OnboardingStep.dosha);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    testWidgets('renders progress indicator and first question', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      expect(find.textContaining('3 of 5'), findsOneWidget);
      expect(find.textContaining('Question 1 of 10'), findsOneWidget);
      expect(find.textContaining('body frame'), findsOneWidget);
    });

    testWidgets('answering questions advances screen, computes profile, saves to DB', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      // Tap through all 10 questions selecting the first option (which corresponds to Vata)
      for (int i = 0; i < 10; i++) {
        expect(find.textContaining('Question ${i + 1} of 10'), findsOneWidget);
        // Tap first option card (index 0)
        final optionCard = find.textContaining(doshaQuestions[i].options[0].text);
        expect(optionCard, findsOneWidget);
        await tester.tap(optionCard);
        await tester.pumpAndSettle();
      }

      // Check results view: Dominant Vata is displayed
      expect(find.text('VATA'), findsOneWidget);
      expect(find.textContaining('Vata (Air/Space)'), findsOneWidget);
      expect(find.textContaining('100.0%'), findsOneWidget);

      // Check guidelines
      expect(find.textContaining('Warm, cooked, and grounding foods'), findsOneWidget);

      // Tap save and continue
      final saveBtn = find.text('Save and Continue');
      expect(saveBtn, findsOneWidget);
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify redirection to next screen (programSelect)
      expect(find.text('ProgramSelect'), findsOneWidget);

      // Verify database has persisted the result
      final user = await (db.select(db.users)..where((t) => t.id.equals('onboarding_user'))).getSingle();
      expect(user.dosha, isNotNull);
      final jsonResult = jsonDecode(user.dosha!) as Map<String, dynamic>;
      expect(jsonResult['dominant'], 'vata');
      expect(jsonResult['vataPct'], 100.0);
    });
  });
}
