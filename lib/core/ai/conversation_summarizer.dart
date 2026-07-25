// lib/core/ai/conversation_summarizer.dart
// §P0-F Conversation Memory Management
// Manages sliding-window chat context and background summarization for the AI Coach.

import 'package:flutter/foundation.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:drift/drift.dart';

/// A single chat message in the coach conversation.
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  /// 'user' | 'assistant' | 'system'
  final String role;
  final String content;
  final DateTime createdAt;
}

/// Minimal AI client interface — implemented by the actual Azure/Groq client.
abstract class AIClient {
  Future<SummaryResult> generateSummary(String chatLog);
}

class SummaryResult {
  const SummaryResult({required this.summaryText});
  final String summaryText;
}

/// §P0-F ConversationMemory — builds the AI coach context window.
///
/// Strategy:
///   - Compressed background summary (entire history → 1 paragraph)
///   - Sliding window of last 5 messages for immediate context
///   - Background summarization triggers when message count ≥ 10
///   - Summarization debounced to every 15 minutes minimum
class ConversationMemory {
  ConversationMemory(this._db, this._aiClient);

  final AppDatabase _db;
  final AIClient _aiClient;

  /// Builds context for the AI coach request.
  /// Returns system summary + last 5 messages in chronological order.
  Future<List<ChatMessage>> buildContext(String userId) async {
    // 1. Fetch compressed background summary from user profile
    final user = await (_db.select(_db.users)
          ..where((t) => t.id.equals(userId)))
        .getSingleOrNull();

    final String summaryText =
        user?.conversationSummary ?? 'User is starting their FitKarma journey.';

    // 2. Fetch sliding window of last 5 messages
    final recentMessages = await (_db.select(_db.chatMessages)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(5))
        .get();

    // Reverse to chronological order
    final chronologicalRecent = recentMessages.reversed.toList();

    // 3. Construct message array with system profile + recent history
    final contextMessages = <ChatMessage>[
      ChatMessage(
        role: 'system',
        content: '''
You are FitKarma's AI Health Coach for India. Adhere to the following user profile summary:
$summaryText

Respond concisely in warm, supportive language. Use occasional Hindi-English (Hinglish) phrases only when natural.
Never give generic advice — always reference the user's specific data.
''',
        createdAt: DateTime.now(),
      ),
      ...chronologicalRecent.map(
        (m) => ChatMessage(
          role: m.role,
          content: m.content,
          createdAt: m.createdAt,
        ),
      ),
    ];

    // 4. Proactively check if background summarization is needed
    _triggerAsyncSummaryCheck(userId);

    return contextMessages;
  }

  /// Evaluates conversation size and triggers background summarization if needed.
  Future<void> _triggerAsyncSummaryCheck(String userId) async {
    final allMessages = await (_db.select(_db.chatMessages)
          ..where((t) => t.userId.equals(userId)))
        .get();

    if (allMessages.length >= 10) {
      final user = await (_db.select(_db.users)
            ..where((t) => t.id.equals(userId)))
          .getSingleOrNull();

      final lastSummaryUpdate = user?.lastSummaryUpdatedAt ?? DateTime(1970);

      // Debounce: minimum 15 minutes between summarization runs
      if (DateTime.now().difference(lastSummaryUpdate).inMinutes >= 15) {
        _executeBackgroundSummarization(userId, allMessages);
      }
    }
  }

  /// Sends full conversation history for summarization and updates the user profile.
  /// Runs in background — never blocks the active UI session.
  Future<void> _executeBackgroundSummarization(
    String userId,
    List<ChatMessageData> messages,
  ) async {
    try {
      final chatLogString = messages
          .map((m) => '${m.role == 'user' ? 'User' : 'Coach'}: ${m.content}')
          .join('\n');

      final summaryResult = await _aiClient.generateSummary(chatLogString);

      // Update user row with new summary
      await (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
        UsersCompanion(
          conversationSummary: Value(summaryResult.summaryText),
          lastSummaryUpdatedAt: Value(DateTime.now()),
        ),
      );

      // Consolidate: delete old messages now captured in the summary
      // Keep the last 5 messages as the active context buffer
      if (messages.length > 5) {
        final cutOffDate = messages[messages.length - 5].createdAt;
        await (_db.delete(_db.chatMessages)
              ..where(
                (t) => t.userId.equals(userId) & t.createdAt.isBefore(cutOffDate),
              ))
            .go();
      }
    } catch (e) {
      // Fail silently — never disrupt the active UI session
      debugPrint('Background conversation summarization failed: $e');
    }
  }

  /// Saves a new message to the chat history.
  Future<void> saveMessage({
    required String userId,
    required String role,
    required String content,
  }) async {
    await _db.into(_db.chatMessages).insert(
          ChatMessagesCompanion.insert(
            userId: userId,
            role: role,
            content: content,
            createdAt: DateTime.now(),
          ),
        );
  }
}
