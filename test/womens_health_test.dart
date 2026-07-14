import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/womens_health/womens_health_controller.dart';
import 'package:fitkarma/features/womens_health/womens_health_onboarding_screen.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

AppDatabase testDb() => AppDatabase.executor(NativeDatabase.memory());

GoRouter _womensHealthRouter() => GoRouter(
      initialLocation: AppRoutes.onboardingWomensHealth,
      routes: [
        GoRoute(
          path: AppRoutes.onboardingWomensHealth,
          builder: (_, __) => const WomensHealthOnboardingScreen(),
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
    child: MaterialApp.router(routerConfig: _womensHealthRouter()),
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
  group('DynamicCycleCalibrator Unit Tests', () {
    const calibrator = DynamicCycleCalibrator();

    test('default 28-day calendar with no logs defaults to follicular phase', () {
      final state = calibrator.recalibratePhase(symptomLogs: [], defaultCycleLengthDays: 28);
      expect(state.currentPhase, CyclePhase.follicular);
      expect(state.isIrregularDetected, isFalse);
    });

    test('menstrual flow start resets cycle day to 1 and sets menstrual phase', () {
      final now = DateTime.now();
      final logs = [
        MenstrualSymptomLogWrapper(logDate: now, hasMenstrualFlow: true, physicalSymptoms: []),
      ];
      final state = calibrator.recalibratePhase(symptomLogs: logs, defaultCycleLengthDays: 28);
      expect(state.currentCycleDay, 1);
      expect(state.currentPhase, CyclePhase.menstrual);
    });

    test('LH positive test correctly shifts ovulation date and phase', () {
      final now = DateTime.now();
      final cycleStart = now.subtract(const Duration(days: 12));
      final lhSurge = now.subtract(const Duration(days: 1)); // Ovulation will be today (lh + 1)
      final logs = [
        MenstrualSymptomLogWrapper(logDate: cycleStart, hasMenstrualFlow: true, physicalSymptoms: []),
        MenstrualSymptomLogWrapper(logDate: lhSurge, hasMenstrualFlow: false, positiveLhTest: true, physicalSymptoms: []),
      ];
      final state = calibrator.recalibratePhase(symptomLogs: logs, defaultCycleLengthDays: 28);
      expect(state.currentPhase, CyclePhase.luteal); // today is post-ovulation (ovulation is today, so day after is luteal or today is day 13/14)
    });

    test('BBT temperature rise shifts ovulation date correctly', () {
      final now = DateTime.now();
      final cycleStart = now.subtract(const Duration(days: 15));
      final logs = [
        MenstrualSymptomLogWrapper(logDate: cycleStart, hasMenstrualFlow: true, physicalSymptoms: []),
        // BBT baseline: 36.4
        MenstrualSymptomLogWrapper(logDate: now.subtract(const Duration(days: 3)), hasMenstrualFlow: false, basalBodyTemperatureCelsius: 36.4, physicalSymptoms: []),
        // BBT shift +0.3
        MenstrualSymptomLogWrapper(logDate: now.subtract(const Duration(days: 2)), hasMenstrualFlow: false, basalBodyTemperatureCelsius: 36.7, physicalSymptoms: []),
        MenstrualSymptomLogWrapper(logDate: now.subtract(const Duration(days: 1)), hasMenstrualFlow: false, basalBodyTemperatureCelsius: 36.7, physicalSymptoms: []),
      ];
      final state = calibrator.recalibratePhase(symptomLogs: logs, defaultCycleLengthDays: 28);
      expect(state.currentPhase, CyclePhase.luteal);
    });

    test('RHR elevation + subjective symptoms validates ovulation', () {
      final now = DateTime.now();
      final cycleStart = now.subtract(const Duration(days: 15));
      final logs = [
        MenstrualSymptomLogWrapper(logDate: cycleStart, hasMenstrualFlow: true, physicalSymptoms: []),
        // Follicular baseline RHR: 62 bpm
        MenstrualSymptomLogWrapper(logDate: cycleStart.add(const Duration(days: 3)), hasMenstrualFlow: false, restingHeartRateBpm: 62, physicalSymptoms: []),
        // Ovulation symptoms: RHR rise (+3 bpm) + egg_white_mucus
        MenstrualSymptomLogWrapper(
          logDate: now.subtract(const Duration(days: 2)),
          hasMenstrualFlow: false,
          restingHeartRateBpm: 65,
          physicalSymptoms: ['egg_white_mucus', 'ovulation_pain'],
        ),
      ];
      final state = calibrator.recalibratePhase(symptomLogs: logs, defaultCycleLengthDays: 28);
      expect(state.currentPhase, CyclePhase.luteal);
    });
  });

  group('CycleAwareTrainingAdapter Unit Tests', () {
    const adapter = CycleAwareTrainingAdapter();

    test('adapts correctly for menstrual phase', () {
      final adapt = adapter.adaptForCyclePhase(CyclePhase.menstrual);
      expect(adapt.intensityModifier, 0.7);
      expect(adapt.preferredTypes, contains('Yoga'));
      expect(adapt.avoidTypes, contains('HIIT'));
    });

    test('adapts correctly for follicular phase', () {
      final adapt = adapter.adaptForCyclePhase(CyclePhase.follicular);
      expect(adapt.intensityModifier, 1.1);
      expect(adapt.preferredTypes, contains('Strength Training'));
    });

    test('adapts correctly for luteal phase', () {
      final adapt = adapter.adaptForCyclePhase(CyclePhase.luteal);
      expect(adapt.intensityModifier, 0.85);
      expect(adapt.nutritionNote, contains('PMS cravings'));
    });
  });

  group('WomensHealthOnboardingScreen Widget Tests', () {
    late ProviderContainer container;
    late AppDatabase db;

    setUp(() async {
      db = testDb();
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: 'onboarding_user',
              gender: const Value('female'),
            ),
          );
      container = makeContainer(db);
      container.read(onboardingFlowProvider.notifier).jumpTo(OnboardingStep.womensHealth);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    testWidgets('renders screen initial state correctly', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      expect(find.textContaining('4 of 5'), findsOneWidget);
      expect(find.textContaining("Women's Health Sync"), findsOneWidget);
      expect(find.text('Enable Cycle Syncing'), findsOneWidget);
      
      // By default cycle sync switch is off, so slider and calendar icon are hidden
      expect(find.text('Average Cycle Length'), findsNothing);
      expect(find.byIcon(Icons.calendar_today_rounded), findsNothing);
    });

    testWidgets('enabling cycle tracking reveals details and clicking save updates DB', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      // Find switch and toggle it
      final syncSwitch = find.byType(Switch);
      expect(syncSwitch, findsOneWidget);
      await tester.tap(syncSwitch);
      await tester.pumpAndSettle();

      // Details are now visible
      expect(find.text('Average Cycle Length'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);

      // Tap select date container
      final dateSelector = find.text('Last Period Start Date');
      await tester.tap(dateSelector);
      await tester.pumpAndSettle();

      // Select date (press OK on date picker)
      final okBtn = find.text('OK');
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await tester.pumpAndSettle();
      }

      // Tap Save and Continue
      final saveBtn = find.text('Save and Continue');
      expect(saveBtn, findsOneWidget);
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Navigated to permissions screen
      expect(find.text('Permissions'), findsOneWidget);

      // Database has saved parameters
      final user = await (db.select(db.users)..where((t) => t.id.equals('onboarding_user'))).getSingle();
      expect(user.isCycleTrackingEnabled, isTrue);
      expect(user.averageCycleLength, 28);
      expect(user.lastPeriodDate, isNotNull);
    });

    testWidgets('skipping screen disables tracking and navigates', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pumpAndSettle();

      final skipBtn = find.text('Skip');
      expect(skipBtn, findsOneWidget);
      await tester.tap(skipBtn);
      await tester.pumpAndSettle();

      // Navigated to permissions screen
      expect(find.text('Permissions'), findsOneWidget);

      // Database has saved disabled parameters
      final user = await (db.select(db.users)..where((t) => t.id.equals('onboarding_user'))).getSingle();
      expect(user.isCycleTrackingEnabled, isFalse);
    });
  });
}
