// This is a basic Flutter widget test for the Fitkarma App.
import 'package:drift/native.dart';
import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/screens/style_guide_screen.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:fitkarma/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class LowTierNotifier extends DeviceTierNotifier {
  @override
  DeviceTier build() => DeviceTier.low;
}

class MediumTierNotifier extends DeviceTierNotifier {
  @override
  DeviceTier build() => DeviceTier.medium;
}

void main() {
  testWidgets('Fitkarma style guide screen loads correctly', (
    WidgetTester tester,
  ) async {
    late AppDatabase db;

    // Build our app and trigger a frame, overriding databaseProvider to use in-memory db
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) {
            db = AppDatabase.executor(NativeDatabase.memory());
            return db;
          }),
        ],
        child: const MaterialApp(home: StyleGuideScreen()),
      ),
    );

    // Let the initial database load stream complete
    await tester.pumpAndSettle();

    // Verify that our branding header and tabs are present.
    expect(find.text('FITKARMA'), findsOneWidget);
    expect(find.text('Health Dashboard'), findsOneWidget);

    // Explicitly close database and pump to flush any async stream timers
    await db.close();
    await tester.pumpAndSettle();
  });

  testWidgets('GlassCard handles low graphics tier fallback correctly', (
    WidgetTester tester,
  ) async {
    // 1. Test Low Tier Fallback (BackdropFilter bypassed)
    await tester.pumpWidget(
      ProviderScope(
        key: const Key('low-tier-scope'),
        overrides: [deviceTierProvider.overrideWith(LowTierNotifier.new)],
        child: const MaterialApp(
          home: Scaffold(body: GlassCard(child: Text('Test Card'))),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.text('Test Card'), findsOneWidget);

    // 2. Test Medium/High Tier Fallback (BackdropFilter active)
    await tester.pumpWidget(
      ProviderScope(
        key: const Key('medium-tier-scope'),
        overrides: [deviceTierProvider.overrideWith(MediumTierNotifier.new)],
        child: const MaterialApp(
          home: Scaffold(body: GlassCard(child: Text('Test Card'))),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('FitButton works correctly with loading and tap interactions', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    // Test active tap
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FitButton(
            onPressed: () => tapped = true,
            child: const Text('Submit'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(tapped, isTrue);

    // Test loading state disables taps and shows progress loader
    tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FitButton(
            onPressed: () => tapped = true,
            isLoading: true,
            child: const Text('Submit'),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Submit'), findsNothing);

    // Tapping should not trigger onPressed when loading
    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump();
    expect(tapped, isFalse);
  });
}
