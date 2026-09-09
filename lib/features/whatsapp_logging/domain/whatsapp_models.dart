import 'package:flutter/foundation.dart';

/// WhatsApp Account Linking & Verification Status
enum WhatsAppLinkStatus {
  unlinked(label: 'Not Linked', regionalLabel: 'लिंक नहीं है'),
  pendingVerification(label: 'Verification Pending (OTP Sent)', regionalLabel: 'ओटीपी सत्यापन लंबित'),
  activeLinked(label: 'Active & Linked', regionalLabel: 'सत्यापित व सक्रिय'),
  optedOut(label: 'Opted Out / Paused', regionalLabel: 'स्थगित');

  final String label;
  final String regionalLabel;

  const WhatsAppLinkStatus({
    required this.label,
    required this.regionalLabel,
  });
}

/// User WhatsApp Profile & Automated Preferences
@immutable
class WhatsAppUserProfile {
  final String phoneNumber; // e.g. +919876543210
  final WhatsAppLinkStatus linkStatus;
  final String? verificationOtp;
  final String preferredLanguage; // 'en', 'hi', 'hinglish'
  final bool enableMorningBriefing;
  final bool enableMealLogging;
  final bool enableWaterNudges;
  final bool enablePostDinnerWalkAlert;
  final DateTime? linkedAt;

  const WhatsAppUserProfile({
    required this.phoneNumber,
    required this.linkStatus,
    this.verificationOtp,
    this.preferredLanguage = 'hinglish',
    this.enableMorningBriefing = true,
    this.enableMealLogging = true,
    this.enableWaterNudges = true,
    this.enablePostDinnerWalkAlert = true,
    this.linkedAt,
  });

  WhatsAppUserProfile copyWith({
    String? phoneNumber,
    WhatsAppLinkStatus? linkStatus,
    String? verificationOtp,
    String? preferredLanguage,
    bool? enableMorningBriefing,
    bool? enableMealLogging,
    bool? enableWaterNudges,
    bool? enablePostDinnerWalkAlert,
    DateTime? linkedAt,
  }) {
    return WhatsAppUserProfile(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      linkStatus: linkStatus ?? this.linkStatus,
      verificationOtp: verificationOtp ?? this.verificationOtp,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      enableMorningBriefing: enableMorningBriefing ?? this.enableMorningBriefing,
      enableMealLogging: enableMealLogging ?? this.enableMealLogging,
      enableWaterNudges: enableWaterNudges ?? this.enableWaterNudges,
      enablePostDinnerWalkAlert: enablePostDinnerWalkAlert ?? this.enablePostDinnerWalkAlert,
      linkedAt: linkedAt ?? this.linkedAt,
    );
  }
}

/// Type of Inbound WhatsApp Message
enum WhatsAppLogType {
  meal(label: 'Meal & Nutrition', regionalLabel: 'भोजन व पोषण'),
  water(label: 'Water Hydration', regionalLabel: 'जलयोजन / पानी'),
  workout(label: 'Workout & Steps', regionalLabel: 'व्यायाम व कदम'),
  weight(label: 'Weight & Body Comp', regionalLabel: 'वजन व शारीरिक माप'),
  quickCommand(label: 'Summary / Command', regionalLabel: 'दैनिक सारांश / कमांड'),
  general(label: 'General Inquiry', regionalLabel: 'सामान्य प्रश्न');

  final String label;
  final String regionalLabel;

  const WhatsAppLogType({
    required this.label,
    required this.regionalLabel,
  });
}

/// Parsed Nutrition/Activity Data from Natural WhatsApp Message
@immutable
class ParsedWhatsAppEntity {
  final WhatsAppLogType logType;
  final String parsedSummary;
  final String regionalParsedSummary;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;
  final int waterMl;
  final int workoutDurationMinutes;
  final int stepsCount;
  final double weightKg;
  final List<String> identifiedItems;

  const ParsedWhatsAppEntity({
    required this.logType,
    required this.parsedSummary,
    required this.regionalParsedSummary,
    this.calories = 0.0,
    this.proteinGrams = 0.0,
    this.carbsGrams = 0.0,
    this.fatGrams = 0.0,
    this.fiberGrams = 0.0,
    this.waterMl = 0,
    this.workoutDurationMinutes = 0,
    this.stepsCount = 0,
    this.weightKg = 0.0,
    this.identifiedItems = const [],
  });
}

/// Direction of WhatsApp Message
enum WhatsAppMessageDirection { inboundUser, outboundBot, outboundTemplate }

/// WhatsApp Message Delivery Status
enum WhatsAppDeliveryStatus { pending, sent, delivered, read, failed }

/// Complete Message Audit Record
@immutable
class WhatsAppMessageRecord {
  final String id;
  final String rawMessage;
  final WhatsAppMessageDirection direction;
  final ParsedWhatsAppEntity? parsedEntity;
  final String botReplyText;
  final String regionalBotReplyText;
  final WhatsAppDeliveryStatus deliveryStatus;
  final DateTime timestamp;

  const WhatsAppMessageRecord({
    required this.id,
    required this.rawMessage,
    required this.direction,
    this.parsedEntity,
    required this.botReplyText,
    required this.regionalBotReplyText,
    this.deliveryStatus = WhatsAppDeliveryStatus.read,
    required this.timestamp,
  });
}

/// Interactive WhatsApp Template Type
enum WhatsAppTemplateType {
  morningReadiness(title: 'Morning Readiness & Agni Briefing', regionalTitle: 'प्रातःकालीन स्वास्थ्य व अग्नि संदेश'),
  postMealShatapadi(title: 'Post-Meal Shatapadi Walk Reminder', regionalTitle: 'भोजनोपरांत शतपावली स्मरण'),
  waterHydrationNudge(title: 'Hydration & Nimbu-Pani Nudge', regionalTitle: 'जल व नींबू-पानी जलयोजन सूचना'),
  eveningRecap(title: 'Nightly Macro & Sleep Recap', regionalTitle: 'रात्रि मैक्रोज़ व नींद सारांश');

  final String title;
  final String regionalTitle;

  const WhatsAppTemplateType({
    required this.title,
    required this.regionalTitle,
  });
}
