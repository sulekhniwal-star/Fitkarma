import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/dashboard/dashboard_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildSubject(GoRouter router) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('DashboardScreen renders steps, sleep, BP, and glucose widgets and handles navigation', (tester) async {
    // 1. Seed user profile
    await db.into(db.users).insert(
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
    final today = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    await db.into(db.dailyIntelligencePackages).insert(
      DailyIntelligencePackagesCompanion.insert(
        localId: 'dip_today_test',
        userId: 'onboarding_user',
        packageDate: today,
        primaryInsight: 'Insight from Database: focus on protein.',
        todaysMission: 'Complete 30 min high intensity run',
        nutritionFocus: 'Aim for 120g protein',
        recoveryFocus: 'Stretch after workout',
        motivationMessage: 'Keep pushing your limits!',
        adjustedCalories: 2300,
        adjustedProtein: 120,
        adjustedHydrationL: 3.5,
        recommendedIntensity: 'High',
        activeRisks: '[]',
        createdAt: DateTime.now(),
      ),
    );

    // 3. Create a test router
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.mission,
          builder: (context, state) => const Scaffold(body: Text('Daily Mission Screen')),
        ),
      ],
    );

    // 4. Pump Widget
    await tester.pumpWidget(buildSubject(router));
    await tester.pumpAndSettle();

    // 5. Verify header step count
    expect(find.text('8420'), findsOneWidget);
    expect(find.text('STEPS'), findsOneWidget);

    // 6. Verify AI Coach Insight from DIP database is rendered
    expect(find.text('Insight from Database: focus on protein.'), findsOneWidget);

    // 7. Verify bento widgets
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('BP'), findsOneWidget);
    expect(find.text('Glucose'), findsOneWidget);

    // 8. Verify BP values
    expect(find.text('120/80'), findsOneWidget);

    // 9. Verify Glucose values
    expect(find.text('95'), findsOneWidget);

    // 10. Tap mission banner and verify navigation
    final missionBanner = find.byKey(const Key('dashboard_mission_banner'));
    expect(missionBanner, findsOneWidget);
    await tester.tap(missionBanner);
    await tester.pumpAndSettle();

    // Verify router navigated to mission screen
    expect(find.text('Daily Mission Screen'), findsOneWidget);
  });
}
