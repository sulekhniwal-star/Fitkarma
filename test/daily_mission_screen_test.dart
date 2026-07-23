import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/daily_mission/daily_mission_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: DailyMissionScreen()),
    );
  }

  testWidgets(
    'DailyMissionScreen renders loading state initially, then loads DIP from Drift under 100ms target',
    (tester) async {
      // 1. Seed user profile
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              id: 'onboarding_user',
              name: const Value('Arjun'),
              age: const Value(30),
              weight: const Value(70.0),
              height: const Value(175.0),
              isCycleTrackingEnabled: const Value(false),
            ),
          );

      // 2. Seed today's Daily Intelligence Package
      final today = DateTime.now().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      await db
          .into(db.dailyIntelligencePackages)
          .insert(
            DailyIntelligencePackagesCompanion.insert(
              localId: 'dip_today_test',
              userId: 'onboarding_user',
              packageDate: today,
              primaryInsight:
                  'Your recovery is optimal. Perfect day to push harder.',
              todaysMission: 'Complete 30 min high intensity run',
              nutritionFocus: 'Aim for 120g protein',
              recoveryFocus: 'Stretch after workout',
              motivationMessage: 'Keep pushing your limits!',
              adjustedCalories: 2300,
              adjustedProtein: 120,
              adjustedHydrationL: 3.0,
              recommendedIntensity: 'high',
              isRestDay: const Value(false),
              activeRisks: '[]',
              createdAt: DateTime.now(),
            ),
          );

      // 3. Render screen. The first pump displays the layout immediately
      final startTime = clock.now();
      await tester.pumpWidget(buildSubject());

      // Shimmer / loading might show briefly before data resolves
      await tester.pumpAndSettle(const Duration(milliseconds: 10));
      final endTime = clock.now();

      // Verify open time to load is extremely fast (well under 100ms locally)
      final loadTimeMs = endTime.difference(startTime).inMilliseconds;
      expect(loadTimeMs, lessThan(100));

      // 4. Verify UI elements are loaded from Drift correctly
      expect(find.text('Good morning, Arjun 👋'), findsOneWidget);
      expect(
        find.text('85'),
        findsOneWidget,
      ); // High intensity corresponds to mock readiness score 85
      expect(find.text('HIGH · VERY HIGH CONFIDENCE'), findsOneWidget);

      // Health Score section
      expect(find.text('Health Score'), findsOneWidget);
      expect(find.textContaining('Consistency improving'), findsOneWidget);

      // Today's Mission section
      expect(find.text("Today's Mission"), findsOneWidget);
      expect(find.text('Complete 30 min high intensity run'), findsOneWidget);
      expect(find.text('Aim for 120g protein'), findsOneWidget);
      expect(find.text('Stretch after workout'), findsOneWidget);

      // Bento grid focus items
      expect(find.text('😴 Sleep Debt'), findsOneWidget);
      expect(findRichText('-45'), findsOneWidget);
      expect(find.text('⚡ Energy'), findsOneWidget);
      expect(find.text('🔥 Streak'), findsOneWidget);
      expect(findRichText('12 days'), findsOneWidget);
      expect(find.text('🏆 Karma Today'), findsOneWidget);
      expect(findRichText('+45'), findsOneWidget);

      // AI Coach Insights
      expect(find.text('AI Coach Insight'), findsOneWidget);
      expect(
        find.text('Your recovery is optimal. Perfect day to push harder.'),
        findsOneWidget,
      );
      expect(find.text('Keep pushing your limits!'), findsOneWidget);

      // Quick Actions
      expect(find.text('Log Breakfast'), findsOneWidget);
      expect(find.text('Start Workout'), findsOneWidget);
      expect(find.text('Log Water'), findsOneWidget);
    },
  );
}

Finder findRichText(String text) {
  return find.byWidgetPredicate((widget) {
    if (widget is RichText) {
      return widget.text.toPlainText().contains(text);
    }
    return false;
  });
}
