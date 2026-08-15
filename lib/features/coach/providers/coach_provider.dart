import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/ai_router.dart';
import '../../../core/brain/ai_roast_mode_engine.dart';
import '../models/chat_message.dart';

/// §P3-C AiCoachChatState — Optimistic state model
class AiCoachChatState {
  final List<ChatMessage> messages;
  final bool isAiTyping;
  final bool errorOccurred;
  final String? currentConversationId;
  final ConversationMemory memory;
  final String? pendingSuggestedPrompt;

  const AiCoachChatState({
    this.messages = const [],
    this.isAiTyping = false,
    this.errorOccurred = false,
    this.currentConversationId,
    this.memory = const ConversationMemory(),
    this.pendingSuggestedPrompt,
  });

  // Legacy compat for existing code that uses isLoading
  bool get isLoading => isAiTyping;

  AiCoachChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAiTyping,
    bool? errorOccurred,
    String? currentConversationId,
    ConversationMemory? memory,
    String? pendingSuggestedPrompt,
  }) {
    return AiCoachChatState(
      messages: messages ?? this.messages,
      isAiTyping: isAiTyping ?? this.isAiTyping,
      errorOccurred: errorOccurred ?? this.errorOccurred,
      currentConversationId:
          currentConversationId ?? this.currentConversationId,
      memory: memory ?? this.memory,
      pendingSuggestedPrompt:
          pendingSuggestedPrompt ?? this.pendingSuggestedPrompt,
    );
  }
}

/// §P3-C AiCoachChatNotifier — Optimistic State + Typewriter Effect
class AiCoachChatNotifier extends StateNotifier<AiCoachChatState> {
  final AiRouter _router;

  AiCoachChatNotifier(this._router)
      : super(
          AiCoachChatState(
            messages: [
              ChatMessage(
                id: 0,
                conversationId: 'initial',
                sender: MessageSender.coach,
                senderType: 'ai',
                text:
                    'Namaste! I am your FitKarma AI Coach. How can I guide your workout or nutrition today?',
                createdAt: DateTime.now(),
                sources: const ['your profile'],
                modelTierUsed: 'medium',
              ),
            ],
          ),
        );

  String _generateConversationId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  /// Send a user message with optimistic updates
  Future<void> sendMessage(String text,
      {CoachTone tone = CoachTone.motivational,
      bool isDistress = false}) async {
    final conversationId =
        state.currentConversationId ?? _generateConversationId();

    // 1. Render user message immediately (optimistic)
    final userMsg = ChatMessage(
      id: -1,
      conversationId: conversationId,
      sender: MessageSender.user,
      senderType: 'user',
      text: text,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      currentConversationId: conversationId,
      messages: [...state.messages, userMsg],
      memory: state.memory.addMessage(userMsg),
      isAiTyping: true,
      errorOccurred: false,
    );

    // Determine AI model tier via router
    final tier = _router.routeTask(taskType: 'daily_coaching_summary');

    try {
      // 2. Fetch response from Cloudflare Worker (mocked in Pure Dart)
      final response = await _callCoachWorker(text, conversationId,
          tone: tone, isDistress: isDistress);

      // 3. Trigger typewriter simulation for AI response
      await _streamTypewriterResponse(
        responseText: response.reply,
        sources: response.sources,
        conversationId: conversationId,
        modelTier: tier.name,
      );
    } catch (e) {
      final errorMsg = ChatMessage(
        id: -2,
        conversationId: conversationId,
        sender: MessageSender.coach,
        senderType: 'ai',
        text:
            "Sorry, I'm having trouble connecting right now. Please try again.",
        createdAt: DateTime.now(),
        sources: const [],
      );
      state = state.copyWith(
        isAiTyping: false,
        errorOccurred: true,
        messages: [...state.messages, errorMsg],
      );
    }
  }

  /// Simulates char-by-char typewriter effect for AI replies
  Future<void> _streamTypewriterResponse({
    required String responseText,
    required List<String> sources,
    required String conversationId,
    required String modelTier,
  }) async {
    // Add placeholder AI message
    final placeholder = ChatMessage(
      id: -3,
      conversationId: conversationId,
      sender: MessageSender.coach,
      senderType: 'ai',
      text: '',
      createdAt: DateTime.now(),
      sources: sources,
      modelTierUsed: modelTier,
    );
    state = state.copyWith(
      messages: [...state.messages, placeholder],
    );

    String active = '';
    final chars = responseText.split('');
    for (int i = 0; i < chars.length; i++) {
      active += chars[i];
      await Future.delayed(const Duration(milliseconds: 15));

      final updated = List<ChatMessage>.from(state.messages);
      updated[updated.length - 1] = placeholder.copyWith(text: active);
      state = state.copyWith(messages: updated);
    }

    // Mark typing done, finalize message, update memory
    final finalMsg = placeholder.copyWith(text: responseText);
    final updatedFinal = List<ChatMessage>.from(state.messages);
    updatedFinal[updatedFinal.length - 1] = finalMsg;
    state = state.copyWith(
      isAiTyping: false,
      messages: updatedFinal,
      memory: state.memory.addMessage(finalMsg),
    );
  }

  /// Applies a suggested prompt to the composer (pre-fills without sending)
  void applySuggestedPrompt(String prompt) {
    state = state.copyWith(pendingSuggestedPrompt: prompt);
  }

  void clearSuggestedPrompt() {
    state = state.copyWith(pendingSuggestedPrompt: null);
  }

  /// Cloudflare Worker `fitkarma-coach` call wrapper (mocked in Pure Dart)
  Future<CoachWorkerResponse> _callCoachWorker(String message, String convId,
      {CoachTone tone = CoachTone.motivational,
      bool isDistress = false}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final effective = const AiRoastModeEngine().resolveEffectiveTone(
      selectedTone: tone,
      isDistressDetected: isDistress,
    );

    final String reply;
    switch (effective) {
      case CoachTone.roast:
        reply =
            'You burned 400 calories and then attacked 900 calories of biryani. Respect the hustle. Your goals don\'t. Let\'s make the next meal high-protein and hit your macros.';
        break;
      case CoachTone.gentle:
        reply =
            'I hear you. Recovery is part of progress. Let\'s prioritize getting 7.5 hours of restful sleep and a nourishing meal with paneer or dal tonight.';
        break;
      case CoachTone.noNonsense:
        reply =
            'Readiness: 82/100. Protein: 58g/110g. Sleep debt: -45m. Immediate action: 30g protein intake required, target 1,900 kcal today.';
        break;
      case CoachTone.motivational:
        reply =
            'Since your sleep debt is -45m and you have mild quad soreness, your recovery capacity is moderate. I have adjusted your calorie intake to 1,900 kcal (+100 kcal for repair). Let\'s keep this momentum going!';
        break;
    }

    return CoachWorkerResponse(
      reply: reply,
      sources: const ['7-day data', 'your profile'],
    );
  }
}

final aiCoachChatProvider =
    StateNotifierProvider<AiCoachChatNotifier, AiCoachChatState>(
        (ref) => AiCoachChatNotifier(const AiRouter()));

// Legacy alias for existing coach feature code
typedef CoachState = AiCoachChatState;
typedef CoachNotifier = AiCoachChatNotifier;

final coachProvider =
    StateNotifierProvider<AiCoachChatNotifier, AiCoachChatState>(
        (ref) => AiCoachChatNotifier(const AiRouter()));
