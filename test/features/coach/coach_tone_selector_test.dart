import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/coach/screens/coach_chat_screen.dart';
import 'package:fitkarma/features/coach/providers/coach_tone_provider.dart';
import 'package:fitkarma/core/brain/ai_roast_mode_engine.dart';

void main() {
  testWidgets('CoachChatScreen renders Tone Selector with 4 tones per §P12-D',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CoachChatScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gentle'), findsOneWidget);
    expect(find.text('Motivational'), findsOneWidget);
    expect(find.text('Roast'), findsOneWidget);
    expect(find.text('No Nonsense'), findsOneWidget);
  });

  testWidgets('Tapping Roast mode triggers opt-in confirmation dialog if not opted-in',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CoachChatScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Roast
    await tester.tap(find.text('Roast'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Enable AI Roast Mode?'), findsOneWidget);
    expect(find.text('I Can Take It'), findsOneWidget);

    // Confirm opt-in
    await tester.tap(find.text('I Can Take It'));
    await tester.pumpAndSettle();

    // Verify dialog dismissed
    expect(find.text('Enable AI Roast Mode?'), findsNothing);
  });

  testWidgets('Crisis mode suppression banner appears when distress is detected on roast mode',
      (tester) async {
    final container = ProviderContainer();
    container.read(coachToneProvider.notifier).optInToRoast();
    container.read(coachToneProvider.notifier).evaluateDistressTrigger(
          userMessage: 'I am so depressed and overwhelmed',
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: CoachChatScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Safety Safeguard Active'), findsOneWidget);
    expect(find.textContaining('Roast mode auto-adjusted to Gentle'), findsOneWidget);
  });
}
