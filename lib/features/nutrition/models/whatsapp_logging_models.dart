// §P16-A WhatsApp Logging Data Models
// Cross-reference: §P16-A in Fitkarma_documentation.md

enum WhatsAppMessageType { text, image, unsupported }

/// Incoming WhatsApp Message Payload
class WhatsAppMessagePayload {
  final String senderPhone;
  final WhatsAppMessageType type;
  final String? textBody;
  final String? imageId;
  final DateTime receivedAt;

  const WhatsAppMessagePayload({
    required this.senderPhone,
    required this.type,
    this.textBody,
    this.imageId,
    required this.receivedAt,
  });
}

/// Food Log Result from WhatsApp Ingestion
class WhatsAppLogResult {
  final bool isSuccess;
  final String responseMessage;
  final String? foodSummary;
  final int? calories;
  final double? proteinG;
  final bool isOptInError;

  const WhatsAppLogResult({
    required this.isSuccess,
    required this.responseMessage,
    this.foodSummary,
    this.calories,
    this.proteinG,
    this.isOptInError = false,
  });

  factory WhatsAppLogResult.unlinked() => const WhatsAppLogResult(
        isSuccess: false,
        responseMessage:
            "This number isn't linked to a FitKarma account yet. Open the app → Settings → Link WhatsApp to get started.",
        isOptInError: true,
      );

  factory WhatsAppLogResult.unsupported() => const WhatsAppLogResult(
        isSuccess: false,
        responseMessage:
            'Send a text description or a photo of your meal to log it.',
      );

  factory WhatsAppLogResult.logged({
    required String foodSummary,
    required int calories,
    required double proteinG,
  }) =>
      WhatsAppLogResult(
        isSuccess: true,
        foodSummary: foodSummary,
        calories: calories,
        proteinG: proteinG,
        responseMessage:
            'Logged: $foodSummary — $calories kcal, ${proteinG.toStringAsFixed(0)}g protein',
      );
}

/// User WhatsApp Connection & Privacy Opt-In State
class WhatsAppUserLinkState {
  final bool isOptedIn;
  final String? linkedPhoneNumber;
  final DateTime? linkedAt;
  final int totalWhatsAppLogs;

  const WhatsAppUserLinkState({
    this.isOptedIn = false, // OFF by default per §P16-A
    this.linkedPhoneNumber,
    this.linkedAt,
    this.totalWhatsAppLogs = 0,
  });

  WhatsAppUserLinkState copyWith({
    bool? isOptedIn,
    String? linkedPhoneNumber,
    DateTime? linkedAt,
    int? totalWhatsAppLogs,
  }) {
    return WhatsAppUserLinkState(
      isOptedIn: isOptedIn ?? this.isOptedIn,
      linkedPhoneNumber: linkedPhoneNumber ?? this.linkedPhoneNumber,
      linkedAt: linkedAt ?? this.linkedAt,
      totalWhatsAppLogs: totalWhatsAppLogs ?? this.totalWhatsAppLogs,
    );
  }
}
