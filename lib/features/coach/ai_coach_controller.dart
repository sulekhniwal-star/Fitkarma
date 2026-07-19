import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/coach/coach_escalation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiCoachChatState {
  const AiCoachChatState({
    this.messages = const [],
    this.isAiTyping = false,
    this.errorOccurred = false,
    this.currentConversationId,
    this.isOffline = false,
    this.isEscalated = false,
    this.activeEscalationBriefing,
    this.subscriptionTier = 'free',
  });

  final List<ChatMessage> messages;
  final bool isAiTyping;
  final bool errorOccurred;
  final String? currentConversationId;
  final bool isOffline;
  final bool isEscalated;
  final String? activeEscalationBriefing;
  final String subscriptionTier;

  AiCoachChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAiTyping,
    bool? errorOccurred,
    String? currentConversationId,
    bool? isOffline,
    bool? isEscalated,
    String? activeEscalationBriefing,
    String? subscriptionTier,
  }) {
    return AiCoachChatState(
      messages: messages ?? this.messages,
      isAiTyping: isAiTyping ?? this.isAiTyping,
      errorOccurred: errorOccurred ?? this.errorOccurred,
      currentConversationId: currentConversationId ?? this.currentConversationId,
      isOffline: isOffline ?? this.isOffline,
      isEscalated: isEscalated ?? this.isEscalated,
      activeEscalationBriefing: activeEscalationBriefing ?? this.activeEscalationBriefing,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    );
  }
}

class AiCoachChatNotifier extends Notifier<AiCoachChatState> {
  @override
  AiCoachChatState build() {
    return const AiCoachChatState();
  }

  /// Initialized the conversation and loads cached messages from SQLite.
  Future<void> loadCachedConversation({
    required String userId,
    required String conversationId,
    required AppDatabase db,
  }) async {
    final cached = await db.getChatMessages(conversationId);
    final user = await (db.select(db.users)..where((t) => t.id.equals(userId))).getSingleOrNull();
    final tier = user?.subscriptionTier ?? 'free';

    final escalations = await db.getEscalationEvents(userId);
    final activeEscalation = escalations.where((e) => e.resolvedAt == null).firstOrNull;

    state = state.copyWith(
      currentConversationId: conversationId,
      messages: cached,
      errorOccurred: false,
      subscriptionTier: tier,
      isEscalated: activeEscalation != null,
      activeEscalationBriefing: activeEscalation?.briefing,
    );
  }

  /// Sets the offline status of the chat.
  void setOfflineStatus(bool isOffline) {
    state = state.copyWith(isOffline: isOffline);
  }

  /// Updates subscription tier helper.
  Future<void> updateSubscriptionTier(String tier, String userId, AppDatabase db) async {
    await db.updateUserProfile(userId: userId, subscriptionTier: tier);
    state = state.copyWith(subscriptionTier: tier);
  }

  /// Manually escalate to a human coach.
  Future<void> escalateToHumanCoach({
    required String userId,
    required String reason,
    required AppDatabase db,
  }) async {
    final service = CoachEscalationService();
    await service.escalate(userId: userId, reason: reason, db: db);

    final escalations = await db.getEscalationEvents(userId);
    final activeEscalation = escalations.where((e) => e.resolvedAt == null).firstOrNull;

    state = state.copyWith(
      isEscalated: true,
      activeEscalationBriefing: activeEscalation?.briefing,
      messages: [
        ...state.messages,
        ChatMessage(
          id: -4,
          conversationId: state.currentConversationId ?? 'temp',
          senderType: 'ai',
          messageContent: "Plan under human review. A certified coach will respond shortly.",
          createdAt: DateTime.now(),
        )
      ],
    );
  }

  /// Sends a user message with optimistic updates, triggers mock Azure Function,
  /// and streams typing responses.
  Future<void> sendMessage({
    required String userId,
    required String text,
    String? localAttachmentPath,
    required AppDatabase db,
    bool isOnline = true,
  }) async {
    final conversationId = state.currentConversationId ?? _generateUuid();
    final userCreatedAt = DateTime.now();

    // 1. Optimistic User Message Update
    final userMsg = ChatMessage(
      id: -1, // temporary ID
      conversationId: conversationId,
      senderType: 'user',
      messageContent: text,
      createdAt: userCreatedAt,
      localAttachmentPath: localAttachmentPath,
    );

    state = state.copyWith(
      currentConversationId: conversationId,
      messages: [...state.messages, userMsg],
      isAiTyping: true,
      errorOccurred: false,
    );

    // Save to Drift database in background
    await db.saveChatMessage(ChatMessagesCompanion.insert(
      conversationId: conversationId,
      senderType: 'user',
      messageContent: text,
      createdAt: userCreatedAt,
      localAttachmentPath: Value(localAttachmentPath),
    ));

    // Check triggers if eliteCoach tier
    bool triggered = false;
    String triggerReason = "";
    if (state.subscriptionTier == 'eliteCoach') {
      final lowerText = text.toLowerCase();
      if (lowerText.contains("plateau")) {
        triggered = true;
        triggerReason = "Metabolic plateau detected in message: '$text'";
      } else if (lowerText.contains("relapse") || lowerText.contains("distress")) {
        triggered = true;
        triggerReason = "Psychological distress signal in message: '$text'";
      } else if (lowerText.contains("human coach") || lowerText.contains("human review") || lowerText.contains("talk to a human")) {
        triggered = true;
        triggerReason = "User explicitly requested human coach in message: '$text'";
      }
    }

    if (triggered) {
      state = state.copyWith(isAiTyping: false);
      await escalateToHumanCoach(userId: userId, reason: triggerReason, db: db);
      return;
    }

    // 2. Handle Offline / Connection errors
    if (!isOnline || state.isOffline) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isAiTyping: false,
        errorOccurred: true,
        messages: [
          ...state.messages,
          ChatMessage(
            id: -2,
            conversationId: conversationId,
            senderType: 'ai',
            messageContent: "System Error: You are currently offline. Local cache loaded, but live coaching requires network connection.",
            createdAt: DateTime.now(),
          )
        ],
      );
      return;
    }

    try {
      // 3. Trigger mock fitkarma-coach Azure Function API call
      final azureResponse = await _callAzureCoachFunction(text, conversationId);

      // 4. Stream typing effect
      await _streamTypewriterResponse(
        responseText: azureResponse.reply,
        sources: azureResponse.sources,
        conversationId: conversationId,
        db: db,
      );
    } catch (e) {
      state = state.copyWith(
        isAiTyping: false,
        errorOccurred: true,
        messages: [
          ...state.messages,
          ChatMessage(
            id: -2,
            conversationId: conversationId,
            senderType: 'ai',
            messageContent: "Sorry, I'm having trouble connecting right now. Please try again.",
            createdAt: DateTime.now(),
          )
        ],
      );
    }
  }

  /// Simulates typing with 15ms throttled delays.
  Future<void> _streamTypewriterResponse({
    required String responseText,
    required List<String> sources,
    required String conversationId,
    required AppDatabase db,
  }) async {
    final aiCreatedAt = DateTime.now();
    final aiMsgPlaceholder = ChatMessage(
      id: -3,
      conversationId: conversationId,
      senderType: 'ai',
      messageContent: '',
      createdAt: aiCreatedAt,
      sourcesJson: jsonEncode(sources),
    );

    state = state.copyWith(messages: [...state.messages, aiMsgPlaceholder]);

    String activeText = '';
    final characters = responseText.split('');

    for (int i = 0; i < characters.length; i++) {
      activeText += characters[i];
      
      // Throttle update loops slightly to produce typing effect
      await Future<void>.delayed(const Duration(milliseconds: 15));

      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages[updatedMessages.length - 1] = aiMsgPlaceholder.copyWith(
        messageContent: activeText,
      );
      state = state.copyWith(messages: updatedMessages);
    }

    state = state.copyWith(isAiTyping: false);

    // Save finalized AI message to Drift
    await db.saveChatMessage(ChatMessagesCompanion.insert(
      conversationId: conversationId,
      senderType: 'ai',
      messageContent: responseText,
      createdAt: aiCreatedAt,
      sourcesJson: Value(jsonEncode(sources)),
    ));
  }

  String _generateUuid() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<AzureCoachResponse> _callAzureCoachFunction(String message, String convId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    
    // Core prompt mapping based on mock inputs
    String reply = "I analyzed your query: '$message'. Based on your profile and recovery metrics, everything looks solid. Keep up your active recovery routines.";
    List<String> sources = ["7-day logs"];

    if (message.toLowerCase().contains('plateau')) {
      reply = "Your weight has stabilized, but your muscle metrics are up. Your protein intake has averaged 58g for 6 days while your program requires 110g. Add paneer or 2 boiled eggs to breakfast to help your muscles recover.";
      sources = ["7-day logs", "user profile"];
    } else if (message.toLowerCase().contains('calorie')) {
      reply = "Since your sleep debt is -45m and you have mild quad soreness, your recovery capacity is moderate. I have adjusted your daily calorie intake target to 1,900 kcal (+100 kcal for repair).";
      sources = ["7-day logs", "body soreness map"];
    }

    return AzureCoachResponse(reply: reply, sources: sources);
  }
}

class AzureCoachResponse {
  AzureCoachResponse({
    required this.reply,
    required this.sources,
  });

  final String reply;
  final List<String> sources;
}

final aiCoachChatProvider = NotifierProvider<AiCoachChatNotifier, AiCoachChatState>(
  AiCoachChatNotifier.new,
);

