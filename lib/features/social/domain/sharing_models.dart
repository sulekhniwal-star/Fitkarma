import 'package:flutter/foundation.dart';

/// Available external & internal sharing channels
enum ShareChannel {
  whatsApp(
    label: 'WhatsApp Status / Chat',
    regionalLabel: 'व्हाट्सएप साझा करें',
    iconName: 'chat',
    colorCode: 0xFF25D366,
  ),
  instagramStories(
    label: 'Instagram Story (Visual Card)',
    regionalLabel: 'इंस्टाग्राम स्टोरी कार्ड',
    iconName: 'camera_alt',
    colorCode: 0xFFE1306C,
  ),
  sanghaFeed(
    label: 'Internal Sangha Community Feed',
    regionalLabel: 'संघ समुदाय में साझा करें',
    iconName: 'public',
    colorCode: 0xFF00E676,
  ),
  copyLink(
    label: 'Copy Public Verified Link',
    regionalLabel: 'प्रमाणित लिंक कॉपी करें',
    iconName: 'link',
    colorCode: 0xFF00B0FF,
  );

  final String label;
  final String regionalLabel;
  final String iconName;
  final int colorCode;

  const ShareChannel({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
    required this.colorCode,
  });
}

/// Visual theme palette for generated story card
enum ShareCardTheme {
  karmaGreen(
    name: 'Prana Green (Sattvic)',
    primaryColor: 0xFF00E676,
    secondaryColor: 0xFF00BFA5,
  ),
  focusBlue(
    name: 'Vayu Blue (Circadian)',
    primaryColor: 0xFF00B0FF,
    secondaryColor: 0xFF0081CB,
  ),
  kshatriyaGold(
    name: 'Kshatriya Gold (Strength)',
    primaryColor: 0xFFFFD700,
    secondaryColor: 0xFFFF9100,
  ),
  aiPurple(
    name: 'Groq AI Purple (Insight)',
    primaryColor: 0xFF7C4DFF,
    secondaryColor: 0xFF536DFE,
  );

  final String name;
  final int primaryColor;
  final int secondaryColor;

  const ShareCardTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

/// Category of the shareable health achievement
enum ShareableAchievementCategory {
  shatpawaliStreak(
    title: 'Shatpawali Streak Milestone',
    regionalTitle: 'शतपावली निरंतरता सिद्धि',
    defaultIcon: 'directions_walk',
  ),
  workoutPR(
    title: 'Strength Personal Record (PR)',
    regionalTitle: 'शक्ति कीर्तिमान (PR)',
    defaultIcon: 'fitness_center',
  ),
  biometricShift(
    title: 'Cardiometabolic Optimization',
    regionalTitle: 'उपापचयी स्वास्थ्य सुधार',
    defaultIcon: 'favorite',
  ),
  karmaTierPromotion(
    title: 'Sangha Karma Tier Elevation',
    regionalTitle: 'संघ कर्म पदोन्नति',
    defaultIcon: 'auto_awesome',
  );

  final String title;
  final String regionalTitle;
  final String defaultIcon;

  const ShareableAchievementCategory({
    required this.title,
    required this.regionalTitle,
    required this.defaultIcon,
  });
}

/// Complete payload for a generated shareable card
@immutable
class ShareableActivityPayload {
  final String id;
  final String authorName;
  final String authorKarmaTier;
  final String authorCity;
  final ShareableAchievementCategory category;
  final String primaryMetricValue; // e.g. "21 Days", "140 kg", "0.47 WHtR"
  final String primaryMetricLabel;
  final String regionalMetricLabel;
  final String headline;
  final String regionalHeadline;
  final String detailedSubtitle;
  final int karmaPointsEarned;
  final DateTime recordedAt;
  final bool isVerifiedBiometric;
  final String
      verificationSource; // e.g. "Apple Health Sync", "Vision AI Form Check"
  final ShareCardTheme cardTheme;

  const ShareableActivityPayload({
    required this.id,
    required this.authorName,
    required this.authorKarmaTier,
    required this.authorCity,
    required this.category,
    required this.primaryMetricValue,
    required this.primaryMetricLabel,
    required this.regionalMetricLabel,
    required this.headline,
    required this.regionalHeadline,
    required this.detailedSubtitle,
    required this.karmaPointsEarned,
    required this.recordedAt,
    required this.isVerifiedBiometric,
    required this.verificationSource,
    this.cardTheme = ShareCardTheme.karmaGreen,
  });

  ShareableActivityPayload copyWith({
    ShareCardTheme? cardTheme,
  }) {
    return ShareableActivityPayload(
      id: id,
      authorName: authorName,
      authorKarmaTier: authorKarmaTier,
      authorCity: authorCity,
      category: category,
      primaryMetricValue: primaryMetricValue,
      primaryMetricLabel: primaryMetricLabel,
      regionalMetricLabel: regionalMetricLabel,
      headline: headline,
      regionalHeadline: regionalHeadline,
      detailedSubtitle: detailedSubtitle,
      karmaPointsEarned: karmaPointsEarned,
      recordedAt: recordedAt,
      isVerifiedBiometric: isVerifiedBiometric,
      verificationSource: verificationSource,
      cardTheme: cardTheme ?? this.cardTheme,
    );
  }
}

/// Record of an executed share broadcast
@immutable
class ShareBroadcastRecord {
  final String id;
  final String activityPayloadId;
  final ShareChannel channel;
  final DateTime sharedAt;
  final int bonusKarmaAwarded;

  const ShareBroadcastRecord({
    required this.id,
    required this.activityPayloadId,
    required this.channel,
    required this.sharedAt,
    required this.bonusKarmaAwarded,
  });
}

/// Sharing Hub State
@immutable
class ActivitySharingState {
  final ShareableActivityPayload activePayload;
  final List<ShareableActivityPayload> availableAchievements;
  final List<ShareBroadcastRecord> shareHistory;
  final int totalSharesCount;
  final int totalShareBonusKarmaEarned;

  const ActivitySharingState({
    required this.activePayload,
    required this.availableAchievements,
    required this.shareHistory,
    required this.totalSharesCount,
    required this.totalShareBonusKarmaEarned,
  });

  ActivitySharingState copyWith({
    ShareableActivityPayload? activePayload,
    List<ShareableActivityPayload>? availableAchievements,
    List<ShareBroadcastRecord>? shareHistory,
    int? totalSharesCount,
    int? totalShareBonusKarmaEarned,
  }) {
    return ActivitySharingState(
      activePayload: activePayload ?? this.activePayload,
      availableAchievements:
          availableAchievements ?? this.availableAchievements,
      shareHistory: shareHistory ?? this.shareHistory,
      totalSharesCount: totalSharesCount ?? this.totalSharesCount,
      totalShareBonusKarmaEarned:
          totalShareBonusKarmaEarned ?? this.totalShareBonusKarmaEarned,
    );
  }
}
