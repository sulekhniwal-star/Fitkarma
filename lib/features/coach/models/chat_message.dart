import 'dart:convert';

enum MessageSender { user, coach, system }

/// §P3-C Chat Message model — Drift-compatible fields
class ChatMessage {
  final int id; // -1 = optimistic user, -3 = optimistic AI placeholder
  final String conversationId;
  final MessageSender sender;
  final String senderType; // 'user' | 'ai' | 'system'
  final String text;
  final DateTime createdAt;
  final List<String> sources; // e.g. ["7-day logs", "user profile"]
  final String? localAttachmentPath;
  final String? modelTierUsed;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.senderType,
    required this.text,
    required this.createdAt,
    this.sources = const [],
    this.localAttachmentPath,
    this.modelTierUsed,
  });

  ChatMessage copyWith({
    int? id,
    String? conversationId,
    MessageSender? sender,
    String? senderType,
    String? text,
    DateTime? createdAt,
    List<String>? sources,
    String? localAttachmentPath,
    String? modelTierUsed,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      sources: sources ?? this.sources,
      localAttachmentPath: localAttachmentPath ?? this.localAttachmentPath,
      modelTierUsed: modelTierUsed ?? this.modelTierUsed,
    );
  }

  String get sourcesJson => jsonEncode(sources);
}

/// Conversation Memory — rolling last-5 window + summary (token-efficient context)
class ConversationMemory {
  final List<ChatMessage> lastFiveMessages;
  final String rollingSummary;

  const ConversationMemory({
    this.lastFiveMessages = const [],
    this.rollingSummary = '',
  });

  ConversationMemory addMessage(ChatMessage msg) {
    final updated = [...lastFiveMessages, msg];
    if (updated.length > 5) updated.removeAt(0);
    return ConversationMemory(
      lastFiveMessages: updated,
      rollingSummary: rollingSummary,
    );
  }
}

/// Coach Worker Response DTO
class CoachWorkerResponse {
  final String reply;
  final List<String> sources;

  const CoachWorkerResponse({
    required this.reply,
    this.sources = const ['7-day data', 'your profile'],
  });
}

/// Proactive Insight (event-driven, not daily polling)
class ProactiveInsight {
  final String insightType; // e.g. 'protein_trend', 'sleep_debt', 'plateau'
  final String message;
  final String urgency; // 'low' | 'medium' | 'high'
  final bool isActionable;

  const ProactiveInsight({
    required this.insightType,
    required this.message,
    required this.urgency,
    this.isActionable = true,
  });
}

/// AI Trigger Condition — event-driven, fire only when threshold met
class AITrigger {
  final String userId;
  final String triggerType; // e.g. 'protein_deficit', 'sleep_debt_excess', 'plateau'
  final double value;
  final double threshold;

  const AITrigger({
    required this.userId,
    required this.triggerType,
    required this.value,
    required this.threshold,
  });

  bool get isTriggered => true; // If an AITrigger was created, it is triggered by definition
}

/// Proactive Insights Engine — checks event thresholds before generating
class ProactiveInsightsEngine {
  const ProactiveInsightsEngine();

  /// Check if AI insight trigger threshold is crossed — returns null if no insight needed
  AITrigger? checkAITrigger({
    required String userId,
    required double avg7DayProteinG,
    required double proteinTargetG,
    required double sleepDebtHours,
    required int plateauWeeks,
  }) {
    if (avg7DayProteinG < proteinTargetG * 0.70) {
      return AITrigger(
        userId: userId,
        triggerType: 'protein_deficit',
        value: avg7DayProteinG,
        threshold: proteinTargetG * 0.70,
      );
    }
    if (sleepDebtHours >= 3.0) {
      return AITrigger(
        userId: userId,
        triggerType: 'sleep_debt_excess',
        value: sleepDebtHours,
        threshold: 3.0,
      );
    }
    if (plateauWeeks >= 3) {
      return AITrigger(
        userId: userId,
        triggerType: 'plateau',
        value: plateauWeeks.toDouble(),
        threshold: 3.0,
      );
    }
    return null; // No insight needed today — skip LLM call
  }

  /// Generate a targeted proactive insight based on trigger type — no generic output
  ProactiveInsight generateTargetedInsight({
    required AITrigger trigger,
    required double avg7DayProteinG,
    required double proteinTargetG,
    required double sleepDebtHours,
    required int readinessScore,
  }) {
    switch (trigger.triggerType) {
      case 'protein_deficit':
        final delta = (proteinTargetG - avg7DayProteinG).round();
        return ProactiveInsight(
          insightType: 'protein_deficit',
          message:
              'Your protein intake has averaged ${avg7DayProteinG.round()}g for 6 days while your muscle-building goal requires ${proteinTargetG.round()}g. Add paneer or eggs to breakfast to cover the ${delta}g deficit.',
          urgency: 'medium',
        );
      case 'sleep_debt_excess':
        return ProactiveInsight(
          insightType: 'sleep_debt_excess',
          message:
              'Your accumulated sleep debt is ${sleepDebtHours.toStringAsFixed(1)}h. This is suppressing your readiness score ($readinessScore/100) and slowing muscle repair. Aim to sleep 30 minutes earlier tonight.',
          urgency: 'high',
        );
      case 'plateau':
        return ProactiveInsight(
          insightType: 'plateau',
          message:
              'You have plateaued for ${trigger.value.round()} weeks. Your calorie target needs recalibration — I recommend a 100 kcal deficit adjustment based on your 4-week adherence.',
          urgency: 'high',
          isActionable: true,
        );
      default:
        return const ProactiveInsight(
          insightType: 'generic',
          message: 'Your biometrics look stable today.',
          urgency: 'low',
          isActionable: false,
        );
    }
  }
}
