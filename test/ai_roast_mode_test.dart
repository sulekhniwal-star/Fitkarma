/// §P12-D AI Roast Mode — Unit & Widget Tests

import 'package:fitkarma/features/coach/ai_coach_tone_controller.dart';
import 'package:fitkarma/features/coach/ai_coach_tone_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AiCoachToneToggleWidget(),
          ),
        ),
      ),
    );
  }

  group('§P12-D AiCoachToneNotifier Unit Tests', () {
    test('initializes with default motivational tone', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(aiCoachToneProvider);

      expect(state.selectedTone, equals(AiCoachTone.motivational));
      expect(state.isRoastEnabled, isFalse);
      expect(state.effectiveTone, equals(AiCoachTone.motivational));
    });

    test('toggles opt-in Roast Mode correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(aiCoachToneProvider.notifier);

      notifier.toggleRoastMode(true);
      var state = container.read(aiCoachToneProvider);

      expect(state.selectedTone, equals(AiCoachTone.roast));
      expect(state.isRoastEnabled, isTrue);
      expect(state.effectiveTone, equals(AiCoachTone.roast));
      expect(state.promptInstruction, contains('Tone: Roast. Witty, sarcastic, tough-love'));

      notifier.toggleRoastMode(false);
      state = container.read(aiCoachToneProvider);

      expect(state.selectedTone, equals(AiCoachTone.motivational));
      expect(state.isRoastEnabled, isFalse);
    });

    test('automatically disables Roast Mode when distress keywords are detected (§P12-D Safety Guardrail)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(aiCoachToneProvider.notifier);

      // User opts into Roast mode
      notifier.toggleRoastMode(true);
      expect(container.read(aiCoachToneProvider).isRoastEnabled, isTrue);

      // User sends a message containing distress/injury keyword
      final isDistress = notifier.evaluateMessageSafety('I skipped my workout because my leg is injured and in severe pain.');
      final state = container.read(aiCoachToneProvider);

      expect(isDistress, isTrue);
      expect(state.isCrisisOverrideActive, isTrue);
      expect(state.isRoastEnabled, isFalse); // Roast disabled!
      expect(state.effectiveTone, equals(AiCoachTone.gentle)); // Reverted to Gentle
      expect(state.promptInstruction, contains('Tone: Gentle. Empathetic, warm'));
    });
  });

  group('§P12-D AiCoachToneToggleWidget Tests', () {
    testWidgets('renders tone chips, roast opt-in switch, and updates state on toggle', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('AI Coach Persona & Tone'), findsOneWidget);
      expect(find.text('🌱 Gentle'), findsOneWidget);
      expect(find.text('🔥 Motivational'), findsOneWidget);
      expect(find.text('🌶️ Roast Mode'), findsOneWidget);
      expect(find.text('⚡ No-Nonsense'), findsOneWidget);

      // Tap Roast Mode chip/switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('🌶️ ROAST ACTIVE'), findsOneWidget);
    });
  });
}
