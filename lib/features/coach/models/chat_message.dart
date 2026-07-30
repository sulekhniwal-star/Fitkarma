enum MessageSender { user, coach, system }

/// Chat Message data model
class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final String? modelTierUsed;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.modelTierUsed,
  });
}

/// Conversation Memory holding last-5 window + summary
class ConversationMemory {
  final List<ChatMessage> lastFiveMessages;
  final String rollingSummary;

  const ConversationMemory({
    this.lastFiveMessages = const [],
    this.rollingSummary = '',
  });

  ConversationMemory addMessage(ChatMessage msg) {
    final updatedList = [...lastFiveMessages, msg];
    if (updatedList.length > 5) {
      updatedList.removeAt(0);
    }
    return ConversationMemory(
      lastFiveMessages: updatedList,
      rollingSummary: rollingSummary,
    );
  }
}
