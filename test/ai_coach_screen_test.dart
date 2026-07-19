import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/coach/ai_coach_screen.dart';
import 'package:fitkarma/features/coach/ai_coach_controller.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MaterialApp(
        home: AICoachScreen(userId: 'test_user'),
      ),
    );
  }

  testWidgets('AICoachScreen renders header bento statistics and default instructions', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // Verify stats header card items
    expect(find.text('READINESS'), findsOneWidget);
    expect(find.text('73'), findsOneWidget);
    expect(find.text('STREAK'), findsOneWidget);
    expect(find.text('12 days'), findsOneWidget);
    expect(find.text('GOAL'), findsOneWidget);
    expect(find.text('Recomp'), findsOneWidget);

    // Verify default welcome text
    expect(find.text('Ask me anything about your fitness, recovery, or diet!'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
  });

  testWidgets('AICoachScreen loads and renders cached chat messages from Drift', (tester) async {
    // Seed messages
    final now = DateTime.now();
    await db.saveChatMessage(ChatMessagesCompanion.insert(
      conversationId: '12345',
      senderType: 'user',
      messageContent: 'Hello Coach',
      createdAt: now.subtract(const Duration(minutes: 5)),
    ));
    await db.saveChatMessage(ChatMessagesCompanion.insert(
      conversationId: '12345',
      senderType: 'ai',
      messageContent: 'Hello Arjun! How can I help you today?',
      createdAt: now.subtract(const Duration(minutes: 4)),
      sourcesJson: const Value('["user profile"]'),
    ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: AICoachScreen(userId: 'test_user', conversationId: '12345'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify messages loaded
    expect(find.text('Hello Coach'), findsOneWidget);
    expect(find.text('Hello Arjun! How can I help you today?'), findsOneWidget);
    expect(find.text('user profile'), findsOneWidget); // Source badge
  });

  testWidgets('Sending a user message optimistically inserts and triggers typewriter simulation', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // Type query
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'Why am I plateauing?');
    await tester.pumpAndSettle();

    // Tap Send
    final sendFinder = find.byIcon(Icons.send_rounded);
    expect(sendFinder, findsOneWidget);
    await tester.tap(sendFinder);
    
    // Pump once to see optimistic message rendering and typing indicator
    await tester.pump();
    expect(find.text('Why am I plateauing?'), findsNWidgets(2));
    expect(find.text('Karma Coach is writing...'), findsOneWidget);

    // Let the mock network delay and typewriter effect play out
    // Typewriter does 15ms delay per character. Total duration ~ 2-3 seconds of pumps.
    await tester.pump(const Duration(milliseconds: 600)); // wait for network delay
    await tester.pumpAndSettle();

    // Verify AI reply is fully rendered
    expect(find.textContaining('Your protein intake has averaged 58g'), findsOneWidget);
    expect(find.text('7-day logs'), findsOneWidget); // Source badge
    expect(find.text('user profile'), findsOneWidget); // Source badge

    // In our implementation, the state notifier has currentConversationId. Let's fetch from DB:
    final cachedMsgs = await db.select(db.chatMessages).get();
    expect(cachedMsgs.any((m) => m.senderType == 'user' && m.messageContent == 'Why am I plateauing?'), true);
    expect(cachedMsgs.any((m) => m.senderType == 'ai' && m.messageContent.contains('protein')), true);
  });

  testWidgets('Tapping suggested prompt chip sends message automatically', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // Find suggested prompt chip
    final chipFinder = find.text('Adjust my macro splits');
    expect(chipFinder, findsOneWidget);
    await tester.tap(chipFinder);
    await tester.pump();

    // Verify message sent optimistically
    expect(find.text('Adjust my macro splits'), findsNWidgets(2));
    expect(find.text('Karma Coach is writing...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  });

  testWidgets('Toggling offline mode shows offline banner and handles offline error state', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // Verify banner is not there initially
    expect(find.text('Running in offline mode. Live AI responses will fail.'), findsNothing);

    // Toggle offline switch
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verify offline banner shows
    expect(find.text('Running in offline mode. Live AI responses will fail.'), findsOneWidget);

    // Type and send query
    await tester.enterText(find.byType(TextField), 'Hello coach');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    // Let connection delay pass
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify offline error response rendered
    expect(find.textContaining('System Error: You are currently offline.'), findsOneWidget);
  });
}

// Helper to access state if needed
extension StateAccessor on WidgetTester {
  T state<T extends State>(Finder finder) => this.firstState<T>(finder);
}
