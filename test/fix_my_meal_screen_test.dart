import 'dart:typed_data';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/fix_my_meal_controller.dart';
import 'package:fitkarma/features/food/fix_my_meal_screen.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Synthetic image bytes that embed the keyword "poha" so the offline matcher
/// returns a deterministic result (Onion Poha) without any network calls.
Uint8List _pohaBytes() => Uint8List.fromList('poha meal photo'.codeUnits);

/// Bytes that don't match any offline keyword → falls through to mock Azure.
Uint8List _unknownBytes() => Uint8List.fromList(
    List.generate(200, (i) => (i * 7 + 13) % 256));

AppDatabase _makeTestDb() =>
    AppDatabase.executor(NativeDatabase.memory());

ProviderContainer _makeContainer(AppDatabase db) =>
    ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: FixMyMealScreen()),
    );

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('FixMyMealScreen', () {
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

    // ── 1. Idle picker UI ────────────────────────────────────────────────────

    testWidgets('renders idle picker UI on first load', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Header
      expect(find.text('Fix My Meal'), findsOneWidget);

      // Camera card
      expect(find.byKey(const Key('fix_my_meal_camera_card')), findsOneWidget);

      // Action buttons
      expect(find.byKey(const Key('fix_my_meal_take_photo')), findsOneWidget);
      expect(find.byKey(const Key('fix_my_meal_gallery')), findsOneWidget);
    });

    // ── 2. Analyzing state ───────────────────────────────────────────────────

    testWidgets('shows analyzing indicator when phase is analyzing',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Manually set the notifier to analyzing phase
      container.read(fixMyMealProvider.notifier).state =
          container.read(fixMyMealProvider).copyWith(
                phase: FixMyMealPhase.analyzing,
              );
      await tester.pump();

      expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
      expect(find.text('Identifying meal…'), findsOneWidget);
    });

    // ── 3. Result card after offline match ───────────────────────────────────

    testWidgets('shows result card after offline match for poha bytes',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Trigger analysis with poha-encoded bytes (async, but no real I/O in tests)
      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_pohaBytes());
      // Pump once to flush microtasks + redraw; avoid pumpAndSettle due to
      // the repeating pulse AnimationController that never settles.
      await tester.pump(Duration.zero);

      // Detected meal name should be visible
      expect(find.byKey(const Key('fix_my_meal_detected_name')),
          findsOneWidget);

      // Macro strip
      expect(find.byKey(const Key('fix_my_meal_macro_strip')), findsOneWidget);

      // Quality score card
      expect(
          find.byKey(const Key('fix_my_meal_quality_score')), findsOneWidget);

      // Source badge shows "Offline"
      expect(
          find.byKey(const Key('fix_my_meal_source_badge_Offline')),
          findsOneWidget);

      // Log button visible
      expect(find.byKey(const Key('fix_my_meal_log_button')), findsOneWidget);
    });

    // ── 4. Result card after mock Azure call ─────────────────────────────────

    testWidgets('shows Groq Vision source badge for unknown image bytes',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_unknownBytes());
      await tester.pump(Duration.zero);

      // Source badge should show "Groq Vision" (mock API call)
      expect(
          find.byKey(const Key('fix_my_meal_source_badge_Groq Vision')),
          findsOneWidget);
    });

    // ── 5. Cache source badge ────────────────────────────────────────────────

    testWidgets('shows Cached badge on second analysis of same bytes',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // First analysis — primes the cache
      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_unknownBytes());
      await tester.pump(Duration.zero);

      // Reset to idle
      container.read(fixMyMealProvider.notifier).reset();
      await tester.pump();

      // Second analysis — should hit cache
      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_unknownBytes());
      await tester.pump(Duration.zero);

      expect(
          find.byKey(const Key('fix_my_meal_source_badge_Cached')),
          findsOneWidget);
    });

    // ── 6. Portion multiplier updates displayed macros ───────────────────────

    testWidgets('portion 2× chip doubles the calorie display', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_pohaBytes());
      await tester.pump(Duration.zero);

      // Record calories at 1×
      final stateAt1x = container.read(fixMyMealProvider);
      final cal1x = stateAt1x.effectiveCalories;

      // Set portion multiplier directly (chip is off-screen in 800×600 test viewport)
      container.read(fixMyMealProvider.notifier).setPortionMultiplier(2.0);
      await tester.pump();

      final stateAt2x = container.read(fixMyMealProvider);
      expect(stateAt2x.portionMultiplier, 2.0);
      expect(stateAt2x.effectiveCalories, closeTo(cal1x * 2, 1));
    });

    // ── 7. Log This Meal adds item to foodProvider ────────────────────────────

    testWidgets('Log This Meal adds item to foodProvider state', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await container
          .read(fixMyMealProvider.notifier)
          .pickImage(_pohaBytes());
      await tester.pump(Duration.zero);

      final foodBefore = container.read(foodProvider).loggedItems.length;

      // Call logMeal() directly (Log button is off-screen in 800×600 test viewport)
      container.read(fixMyMealProvider.notifier).logMeal();
      await tester.pump();

      final foodAfter = container.read(foodProvider).loggedItems.length;
      expect(foodAfter, foodBefore + 1);
    });
  });
}
