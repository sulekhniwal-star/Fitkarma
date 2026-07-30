import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/ai_router.dart';
import '../models/chat_message.dart';

class CoachState {
  final List<ChatMessage> messages;
  final ConversationMemory memory;
  final bool isLoading;

  const CoachState({
    this.messages = const [],
    this.memory = const ConversationMemory(),
    this.isLoading = false,
  });

  CoachState copyWith({
    List<ChatMessage>? messages,
    ConversationMemory? memory,
    bool? isLoading,
  }) {
    return CoachState(
      messages: messages ?? this.messages,
      memory: memory ?? this.memory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CoachNotifier extends StateNotifier<CoachState> {
  final AiRouter _router;

  CoachNotifier(this._router)
      : super(
          CoachState(
            messages: [
              ChatMessage(
                id: '1',
                text: 'Namaste! I am your FitKarma AI Coach. How can I guide your workout or nutrition today?',
                sender: MessageSender.coach,
                timestamp: DateTime.now(),
                modelTierUsed: 'medium',
              ),
            ],
          ),
        );

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    // Update state with user message & update last-5 memory
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      memory: state.memory.addMessage(userMsg),
      isLoading: true,
    );

    // Determine AI Model Tier
    final tier = _router.routeTask(taskType: 'daily_coaching_summary');

    // Simulate AI response stream / API response
    await Future.delayed(const Duration(milliseconds: 600));

    final aiMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: 'Based on your readiness score, focus on steady hydration and light cardio today. ${userMsg.text} is well aligned with your goals!',
      sender: MessageSender.coach,
      timestamp: DateTime.now(),
      modelTierUsed: tier.name,
    );

    state = state.copyWith(
      messages: [...state.messages, aiMsg],
      memory: state.memory.addMessage(aiMsg),
      isLoading: false,
    );
  }
}

final coachProvider = StateNotifierProvider<CoachNotifier, CoachState>((ref) {
  return CoachNotifier(const AiRouter());
});
