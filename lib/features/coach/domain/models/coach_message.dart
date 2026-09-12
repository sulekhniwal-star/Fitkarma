enum MessageSender { user, coach, system }

class CoachMessage {
  final String id;
  final String sessionId;
  final MessageSender sender;
  final String content;
  final String? contentHindi;
  final String? modelUsed; // e.g. 'llama-3.3-70b', 'mixtral', 'offline-fallback'
  final DateTime timestamp;
  final bool isOptimistic; // true if queued locally before remote response

  const CoachMessage({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.content,
    this.contentHindi,
    this.modelUsed,
    required this.timestamp,
    this.isOptimistic = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_id': sessionId,
        'sender': sender.name,
        'content': content,
        'content_hindi': contentHindi,
        'model_used': modelUsed,
        'timestamp': timestamp.toIso8601String(),
      };

  factory CoachMessage.fromJson(Map<String, dynamic> json) => CoachMessage(
        id: json['id'] as String,
        sessionId: json['session_id'] as String,
        sender: MessageSender.values.firstWhere(
          (s) => s.name == (json['sender'] as String? ?? 'coach'),
          orElse: () => MessageSender.coach,
        ),
        content: json['content'] as String? ?? '',
        contentHindi: json['content_hindi'] as String?,
        modelUsed: json['model_used'] as String?,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
        isOptimistic: false,
      );
}
