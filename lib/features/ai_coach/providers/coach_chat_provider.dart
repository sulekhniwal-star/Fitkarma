import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai_routing/data/ai_routing_repository.dart';
import '../../ai_routing/domain/template_fallback_engine.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/coach_chat_repository.dart';
import '../domain/coach_message.dart';

final aiRoutingRepositoryProvider = Provider<AiRoutingRepository>((ref) {
  return AiRoutingRepository();
});

final coachChatRepositoryProvider = Provider<CoachChatRepository>((ref) {
  return CoachChatRepository();
});

class CoachChatState {
  final List<CoachMessage> messages;
  final bool isThinking;

  const CoachChatState({
    required this.messages,
    this.isThinking = false,
  });

  CoachChatState copyWith({
    List<CoachMessage>? messages,
    bool? isThinking,
  }) {
    return CoachChatState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
    );
  }
}

class CoachChatNotifier extends StateNotifier<AsyncValue<CoachChatState>> {
  final CoachChatRepository _chatRepository;
  final AiRoutingRepository _aiRoutingRepository;
  final String _uid;
  final String _date;

  CoachChatNotifier({
    required CoachChatRepository chatRepository,
    required AiRoutingRepository aiRoutingRepository,
    required String uid,
    required String date,
  })  : _chatRepository = chatRepository,
        _aiRoutingRepository = aiRoutingRepository,
        _uid = uid,
        _date = date,
        super(const AsyncValue.loading()) {
    loadConversation();
  }

  Future<void> loadConversation() async {
    try {
      final list = await _chatRepository.getConversationMessages(uid: _uid, dateStr: _date);
      state = AsyncValue.data(CoachChatState(messages: list));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String text) async {
    final current = state.value;
    if (current == null || text.trim().isEmpty) return;

    final userMsg = CoachMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      isOptimistic: true,
    );

    // 1. Optimistic UI insert
    final optimisticList = [...current.messages, userMsg];
    state = AsyncValue.data(current.copyWith(messages: optimisticList, isThinking: true));

    // 2. Request AI Response via Router with fallback
    String replyText;
    try {
      replyText = await _aiRoutingRepository.askCoach(
        prompt: text,
      );
    } catch (_) {
      // Offline fallback from template engine
      replyText = TemplateFallbackEngine.getFallbackResponse(text);
    }

    final coachMsg = CoachMessage(
      id: 'msg_coach_${DateTime.now().millisecondsSinceEpoch}',
      text: replyText,
      sender: MessageSender.coach,
      timestamp: DateTime.now(),
    );

    final finalList = [...optimisticList, coachMsg];
    state = AsyncValue.data(current.copyWith(messages: finalList, isThinking: false));

    // 3. Persist to Firestore
    await _chatRepository.saveConversation(uid: _uid, dateStr: _date, messages: finalList);
  }
}

final coachChatProvider =
    StateNotifierProvider.autoDispose<CoachChatNotifier, AsyncValue<CoachChatState>>((ref) {
  final chatRepo = ref.watch(coachChatRepositoryProvider);
  final aiRepo = ref.watch(aiRoutingRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  return CoachChatNotifier(
    chatRepository: chatRepo,
    aiRoutingRepository: aiRepo,
    uid: uid,
    date: date,
  );
});
