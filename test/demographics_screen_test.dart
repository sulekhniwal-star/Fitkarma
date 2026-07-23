import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';
import 'package:fitkarma/features/onboarding/demographics_screen.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// In-memory AppDatabase for tests.
AppDatabase testDb() => AppDatabase.executor(NativeDatabase.memory());

/// GoRouter starting on demographics with stub routes for adjacent steps.
GoRouter _demographicsRouter() => GoRouter(
  initialLocation: AppRoutes.onboardingDemographics,
  routes: [
    GoRoute(
      path: AppRoutes.onboardingGoals,
      builder: (_, __) => const Scaffold(body: Text('Goals')),
    ),
    GoRoute(
      path: AppRoutes.onboardingDemographics,
      builder: (_, __) => const DemographicsScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingDietPlan,
      builder: (_, __) => const Scaffold(body: Text('DietPlan')),
    ),
  ],
);

/// Wraps subject in a [UncontrolledProviderScope] backed by [container].
Widget buildSubject(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: _demographicsRouter()),
  );
}

// ── Unit Tests — DemographicsNotifier ────────────────────────────────────────

void main() {
  group('DemographicsNotifier — state logic', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('initial state has expected defaults', () {
      final s = container.read(demographicsProvider);
      expect(s.gender, Gender.male);
      expect(s.age, 25);
      expect(s.unitIsMetric, isTrue);
    });

    test('setGender updates gender', () {
      container.read(demographicsProvider.notifier).setGender(Gender.female);
      expect(container.read(demographicsProvider).gender, Gender.female);
    });

    test('setAge clamps to valid range', () {
      final n = container.read(demographicsProvider.notifier);
      n.setAge(5); // below minimum
      expect(container.read(demographicsProvider).age, 13);
      n.setAge(200); // above maximum
      expect(container.read(demographicsProvider).age, 100);
    });

    test('setHeight clamps correctly', () {
      final n = container.read(demographicsProvider.notifier);
      n.setHeight(50);
      expect(container.read(demographicsProvider).heightCm, 100.0);
      n.setHeight(300);
      expect(container.read(demographicsProvider).heightCm, 250.0);
    });

    test('setWeight clamps correctly', () {
      final n = container.read(demographicsProvider.notifier);
      n.setWeight(10);
      expect(container.read(demographicsProvider).weightKg, 20.0);
      n.setWeight(400);
      expect(container.read(demographicsProvider).weightKg, 250.0);
    });

    test('setActivity updates activity level', () {
      container
          .read(demographicsProvider.notifier)
          .setActivity(ActivityLevel.veryActive);
      expect(
        container.read(demographicsProvider).activityLevel,
        ActivityLevel.veryActive,
      );
    });

    test('toggleUnit switches between metric and imperial', () {
      final n = container.read(demographicsProvider.notifier);
      expect(container.read(demographicsProvider).unitIsMetric, isTrue);
      n.toggleUnit();
      expect(container.read(demographicsProvider).unitIsMetric, isFalse);
      n.toggleUnit();
      expect(container.read(demographicsProvider).unitIsMetric, isTrue);
    });

    // ── BMI derivation ────────────────────────────────────────────────────────

    test('bmi returns underweight for low weight', () {
      final n = container.read(demographicsProvider.notifier);
      n.setHeight(170);
      n.setWeight(40);
      expect(
        container.read(demographicsProvider).bmi.category,
        BmiCategory.underweight,
      );
    });

    test('bmi returns normal for healthy weight', () {
      final n = container.read(demographicsProvider.notifier);
      n.setHeight(170);
      n.setWeight(65);
      final bmi = container.read(demographicsProvider).bmi;
      expect(bmi.category, BmiCategory.normal);
    });

    test('bmi returns overweight for BMI 27', () {
      final n = container.read(demographicsProvider.notifier);
      n.setHeight(170);
      n.setWeight(78);
      final bmi = container.read(demographicsProvider).bmi;
      expect(bmi.category, BmiCategory.overweight);
    });

    test('bmi returns obese for BMI >= 30', () {
      final n = container.read(demographicsProvider.notifier);
      n.setHeight(170);
      n.setWeight(90);
      final bmi = container.read(demographicsProvider).bmi;
      expect(bmi.category, BmiCategory.obese);
    });

    // ── TDEE derivation ───────────────────────────────────────────────────────

    test('tdee is positive for male with normal profile', () {
      final n = container.read(demographicsProvider.notifier);
      n.setGender(Gender.male);
      n.setAge(30);
      n.setHeight(175);
      n.setWeight(75);
      n.setActivity(ActivityLevel.moderatelyActive);
      final tdee = container.read(demographicsProvider).tdee;
      expect(tdee, greaterThan(1500));
      expect(tdee, lessThan(4000));
    });

    test('tdee for female is lower than male with same profile', () {
      final nm = ProviderContainer();
      final nf = ProviderContainer();
      addTearDown(() {
        nm.dispose();
        nf.dispose();
      });
      void configure(ProviderContainer c, Gender g) {
        final n = c.read(demographicsProvider.notifier);
        n.setGender(g);
        n.setAge(30);
        n.setHeight(165);
        n.setWeight(65);
        n.setActivity(ActivityLevel.sedentary);
      }

      configure(nm, Gender.male);
      configure(nf, Gender.female);

      expect(
        nm.read(demographicsProvider).tdee,
        greaterThan(nf.read(demographicsProvider).tdee),
      );
    });

    // ── Validation ────────────────────────────────────────────────────────────

    test('validate returns null for valid defaults', () {
      final error = container.read(demographicsProvider.notifier).validate();
      expect(error, isNull);
    });

    // ── Persistence ───────────────────────────────────────────────────────────

    test('saveToDb persists demographics to Users table', () async {
      final db = testDb();
      addTearDown(db.close);

      await db.into(db.users).insert(UsersCompanion.insert(id: 'u1'));

      final n = container.read(demographicsProvider.notifier);
      n.setGender(Gender.female);
      n.setAge(28);
      n.setHeight(160);
      n.setWeight(55);
      n.setActivity(ActivityLevel.lightlyActive);

      await n.saveToDb(db, 'u1');

      final user = await (db.select(
        db.users,
      )..where((u) => u.id.equals('u1'))).getSingle();

      expect(user.age, 28);
      expect(user.gender, 'female');
      expect(user.height, 160.0);
      expect(user.weight, 55.0);
      expect(user.activityLevel, 'lightlyActive');
      expect(user.dailyCalorieTarget, isNotNull);
    });
  });

  // ── Widget Tests — DemographicsScreen ────────────────────────────────────

  group('DemographicsScreen widget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });
    tearDown(() => container.dispose());

    testWidgets('renders progress indicator at step 2 of 5', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      expect(find.textContaining('2 of 5'), findsOneWidget);
    });

    testWidgets('renders Male and Female gender chips', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      expect(find.byKey(const Key('demographics_gender_male')), findsOneWidget);
      expect(
        find.byKey(const Key('demographics_gender_female')),
        findsOneWidget,
      );
    });

    testWidgets('renders BMI card', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      expect(find.byKey(const Key('demographics_bmi_card')), findsOneWidget);
    });

    testWidgets('renders Continue button always enabled', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      final btn = tester.widget<FitButton>(
        find.byKey(const Key('demographics_continue_btn')),
      );
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('tapping Female chip updates state', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('demographics_gender_female')));
      await tester.pumpAndSettle();

      expect(container.read(demographicsProvider).gender, Gender.female);
    });

    testWidgets('unit toggle key is present', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      expect(find.byKey(const Key('demographics_unit_toggle')), findsOneWidget);
    });

    testWidgets('tapping unit toggle switches unit', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      expect(container.read(demographicsProvider).unitIsMetric, isTrue);
      await tester.tap(find.byKey(const Key('demographics_unit_toggle')));
      await tester.pumpAndSettle();
      expect(container.read(demographicsProvider).unitIsMetric, isFalse);
    });

    testWidgets('Continue navigates to DietPlan', (tester) async {
      container
          .read(onboardingFlowProvider.notifier)
          .jumpTo(OnboardingStep.demographics);

      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('demographics_continue_btn')));
      await tester.pumpAndSettle();

      expect(find.text('DietPlan'), findsOneWidget);
    });

    testWidgets('Back button navigates to Goals', (tester) async {
      container
          .read(onboardingFlowProvider.notifier)
          .jumpTo(OnboardingStep.demographics);

      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('demographics_back_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Goals'), findsOneWidget);
    });
  });
}
