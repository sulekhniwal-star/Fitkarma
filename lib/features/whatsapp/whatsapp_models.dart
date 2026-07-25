/// §P16-A WhatsApp Business Logging — Domain Models
///
/// Models for WhatsAppMessageType, WhatsAppMessage, WhatsAppUserBinding, and WhatsAppLogResult matching §P16-A spec.
library;

enum WhatsAppMessageType { text, image, unsupported }

class WhatsAppUserBinding {
  const WhatsAppUserBinding({
    required this.userId,
    required this.phoneNumber,
    required this.whatsAppOptIn,
  });

  final String userId;
  final String phoneNumber; // e.g., "+919876543210"
  final bool whatsAppOptIn;
}

class WhatsAppMessage {
  const WhatsAppMessage({
    required this.messageId,
    required this.fromPhoneNumber,
    required this.type,
    this.textBody,
    this.imageId,
  });

  final String messageId;
  final String fromPhoneNumber;
  final WhatsAppMessageType type;
  final String? textBody;
  final String? imageId;
}

class WhatsAppLogResult {
  const WhatsAppLogResult({
    required this.summary,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String summary;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  String toReplyMessage() {
    return 'Logged: $summary — $calories kcal, ${proteinG.toInt()}g protein';
  }
}
