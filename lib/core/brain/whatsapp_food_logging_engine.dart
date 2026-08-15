// §P16-A WhatsApp Food Logging Engine (Pure Dart)
// Cross-reference: §P16-A in Fitkarma_documentation.md

import '../../features/nutrition/models/indian_food_item.dart';
import '../../features/nutrition/models/whatsapp_logging_models.dart';

/// Pure Dart WhatsApp Food Logging Ingestion & Validation Engine
class WhatsAppFoodLoggingEngine {
  const WhatsAppFoodLoggingEngine();

  /// Process incoming WhatsApp message with strict opt-in verification
  WhatsAppLogResult processIncomingMessage({
    required WhatsAppMessagePayload payload,
    required WhatsAppUserLinkState userLinkState,
  }) {
    // 1. Privacy Opt-In Check (Off by default, §P16-A)
    if (!userLinkState.isOptedIn ||
        userLinkState.linkedPhoneNumber == null ||
        userLinkState.linkedPhoneNumber != payload.senderPhone) {
      return WhatsAppLogResult.unlinked();
    }

    // 2. Route based on message type
    switch (payload.type) {
      case WhatsAppMessageType.text:
        return _parseTextMessage(payload.textBody ?? '');

      case WhatsAppMessageType.image:
        return _parseImageMessage(payload.imageId ?? '');

      case WhatsAppMessageType.unsupported:
        return WhatsAppLogResult.unsupported();
    }
  }

  /// Parses quick-log food text description (Reuses seeded taxonomy)
  WhatsAppLogResult _parseTextMessage(String text) {
    if (text.trim().isEmpty) {
      return WhatsAppLogResult.unsupported();
    }

    final lower = text.toLowerCase();
    int calories = 0;
    double proteinG = 0.0;
    final matchedFoods = <String>[];

    for (final item in SeededIndianFoodDatabase.items) {
      final nameLower = item.name.toLowerCase();
      // Check if food name or primary keyword is mentioned in the message
      if (lower.contains(nameLower) ||
          nameLower.split(' ').any((word) => word.length > 3 && lower.contains(word))) {
        calories += item.calories;
        proteinG += item.proteinGrams;
        matchedFoods.add(item.name);
      }
    }

    // Fallback baseline estimation for generic Indian meals
    if (matchedFoods.isEmpty) {
      calories = 380;
      proteinG = 12.0;
      matchedFoods.add(text.trim());
    }

    final summary = matchedFoods.join(', ');
    return WhatsAppLogResult.logged(
      foodSummary: summary,
      calories: calories,
      proteinG: proteinG,
    );
  }

  /// Simulated meal photo parsing pipeline (Reuses §P5-C response structure)
  WhatsAppLogResult _parseImageMessage(String imageId) {
    return WhatsAppLogResult.logged(
      foodSummary: 'Dal Tadka, 2 Roti, Sabzi',
      calories: 450,
      proteinG: 16.0,
    );
  }
}
