import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/router/ai_router.dart';
import 'package:fitkarma/features/coach/models/chat_message.dart';
import 'package:fitkarma/features/coach/providers/coach_provider.dart';
import 'package:fitkarma/features/coach/screens/coach_chat_screen.dart';

void main() {
  group('§P3-C AI Coach Screen & Notifier Tests', () {
    test('AiCoachChatState initializes with welcome message', () {
      final notifier = AiCoachChatNotifier(const AiRouter());
      expect(notifier.state.messages, hasLength(1));
      expect(notifier.state.messages.first.sender, equals(MessageSender.coach));
      expect(notifier.state.messages.first.text, contains('Namaste'));
    });

    test('sendMessage adds user message optimistically and triggers typewriter AI reply', () async {
      final notifier = AiCoachChatNotifier(const AiRouter());
      final initialCount = notifier.state.messages.length;

      await notifier.sendMessage('How can I improve my protein intake?');

      // Should have user message + AI response
      expect(notifier.state.messages.length, greaterThan(initialCount));
      expect(notifier.state.isAiTyping, isFalse);
      expect(notifier.state.errorOccurred, isFalse);

      final userMsg = notifier.state.messages
          .firstWhere((m) => m.sender == MessageSender.user);
      expect(userMsg.text, equals('How can I improve my protein intake?'));
      expect(userMsg.senderType, equals('user'));
    });

    test('ChatMessage has sourcesJson serialized correctly', () {
      final msg = ChatMessage(
        id: 1,
        conversationId: 'conv_001',
        sender: MessageSender.coach,
        senderType: 'ai',
        text: 'Your protein is 58g vs 110g target.',
        createdAt: DateTime.now(),
        sources: const ['7-day data', 'your profile'],
      );

      expect(msg.sourcesJson, contains('7-day data'));
      expect(msg.sourcesJson, contains('your profile'));
    });

    test('ProactiveInsightsEngine returns null when no threshold crossed', () {
      const engine = ProactiveInsightsEngine();
      final trigger = engine.checkAITrigger(
        userId: 'user_1',
        avg7DayProteinG: 90,  // >70% of 100g target
        proteinTargetG: 100,
        sleepDebtHours: 1.0,  // <3h
        plateauWeeks: 1,       // <3 weeks
      );
      expect(trigger, isNull); // No insight needed — skip LLM call
    });

    test('ProactiveInsightsEngine triggers protein_deficit when <70% target', () {
      const engine = ProactiveInsightsEngine();
      final trigger = engine.checkAITrigger(
        userId: 'user_2',
        avg7DayProteinG: 58,   // <70% of 110g
        proteinTargetG: 110,
        sleepDebtHours: 0.5,
        plateauWeeks: 0,
      );
      expect(trigger, isNotNull);
      expect(trigger!.triggerType, equals('protein_deficit'));
      expect(trigger.isTriggered, isTrue);
    });

    test('ProactiveInsightsEngine generates data-grounded protein insight (not generic)', () {
      const engine = ProactiveInsightsEngine();
      final trigger = engine.checkAITrigger(
        userId: 'user_3',
        avg7DayProteinG: 58,
        proteinTargetG: 110,
        sleepDebtHours: 0.0,
        plateauWeeks: 0,
      )!;

      final insight = engine.generateTargetedInsight(
        trigger: trigger,
        avg7DayProteinG: 58,
        proteinTargetG: 110,
        sleepDebtHours: 0,
        readinessScore: 75,
      );

      // Must reference specific numbers — not generic
      expect(insight.message, contains('58g'));
      expect(insight.message, contains('110g'));
      expect(insight.message, isNot(contains('Eat more protein')));
    });

    test('ProactiveInsightsEngine triggers sleep_debt_excess at 3h+ accumulated debt', () {
      const engine = ProactiveInsightsEngine();
      final trigger = engine.checkAITrigger(
        userId: 'user_4',
        avg7DayProteinG: 90,
        proteinTargetG: 110,
        sleepDebtHours: 3.5,  // >=3h threshold
        plateauWeeks: 0,
      );
      expect(trigger, isNotNull);
      expect(trigger!.triggerType, equals('sleep_debt_excess'));
    });

    testWidgets('CoachChatScreen renders context banner, and input bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: CoachChatScreen()),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      // Context banner items
      expect(find.text('Readiness'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('Goal'), findsOneWidget);

      // AppBar title
      expect(find.text('AI Karma Coach'), findsOneWidget);

      // Initial welcome message from AI
      expect(find.textContaining('Namaste'), findsOneWidget);

      // Input bar elements
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.byIcon(Icons.mic_none), findsOneWidget);
    });

    testWidgets('CoachChatScreen sends a user message and shows reply', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: CoachChatScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // Type a message in TextField
      final input = find.byType(TextField);
      await tester.enterText(input, 'Why am I plateauing?');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump(const Duration(milliseconds: 100));

      // User message should appear
      expect(find.text('Why am I plateauing?'), findsOneWidget);

      // Wait for typewriter to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // AI reply should appear
      expect(find.textContaining('sleep debt'), findsOneWidget);
    });
  });
}
