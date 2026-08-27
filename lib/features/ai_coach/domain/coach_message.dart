enum MessageSender { user, coach }

class CoachMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isOptimistic;

  const CoachMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isOptimistic = false,
  });

  CoachMessage copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isOptimistic,
  }) {
    return CoachMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isOptimistic: isOptimistic ?? this.isOptimistic,
    );
  }

  factory CoachMessage.fromMap(Map<String, dynamic> map) {
    return CoachMessage(
      id: map['id'] as String? ?? 'msg_${DateTime.now().microsecondsSinceEpoch}',
      text: map['text'] as String? ?? '',
      sender: (map['sender'] as String? ?? 'coach') == 'user'
          ? MessageSender.user
          : MessageSender.coach,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      isOptimistic: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
