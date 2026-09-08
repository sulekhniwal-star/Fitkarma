import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/sharing_models.dart';

final activitySharingProvider =
    StateNotifierProvider<ActivitySharingNotifier, ActivitySharingState>((ref) {
  return ActivitySharingNotifier();
});

class ActivitySharingNotifier extends StateNotifier<ActivitySharingState> {
  ActivitySharingNotifier() : super(_buildInitialState());

  static ActivitySharingState _buildInitialState() {
    final achievements = [
      ShareableActivityPayload(
        id: 'achieve_shatpawali_21',
        authorName: 'Aarav Sharma',
        authorKarmaTier: 'Vanguard (Agrani)',
        authorCity: 'Bengaluru, Tier 1',
        category: ShareableAchievementCategory.shatpawaliStreak,
        primaryMetricValue: '21 Days',
        primaryMetricLabel: 'Consecutive Post-Dinner Walks',
        regionalMetricLabel: 'निरंतर शतपावली साधना',
        headline: '21-Day Post-Dinner Shatpawali Streak!',
        regionalHeadline: '२१ दिवसीय शतपावली साधना पूर्ण!',
        detailedSubtitle: '100 steps after every meal • Morning recovery at 92% • Zero postprandial lethargy',
        karmaPointsEarned: 150,
        recordedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        isVerifiedBiometric: true,
        verificationSource: 'Apple Health Pedometer',
        cardTheme: ShareCardTheme.karmaGreen,
      ),
      ShareableActivityPayload(
        id: 'achieve_pr_deadlift',
        authorName: 'Aarav Sharma',
        authorKarmaTier: 'Kshatriya Athlete',
        authorCity: 'Bengaluru, Tier 1',
        category: ShareableAchievementCategory.workoutPR,
        primaryMetricValue: '140 kg',
        primaryMetricLabel: 'Barbell Deadlift (1.9x BW)',
        regionalMetricLabel: 'डेडलिफ्ट कीर्तिमान',
        headline: 'Crushed New 140kg Deadlift PR!',
        regionalHeadline: '१४० किग्रा डेडलिफ्ट नया व्यक्तिगत रिकॉर्ड!',
        detailedSubtitle: 'Flawless hip-hinge mechanics • Form Checked by Vision AI • +75 Karma',
        karmaPointsEarned: 75,
        recordedAt: DateTime.now().subtract(const Duration(hours: 4)),
        isVerifiedBiometric: true,
        verificationSource: 'Adaptive Vision AI Loop',
        cardTheme: ShareCardTheme.kshatriyaGold,
      ),
      ShareableActivityPayload(
        id: 'achieve_whtr_reversal',
        authorName: 'Aarav Sharma',
        authorKarmaTier: 'Vanguard (Agrani)',
        authorCity: 'Bengaluru, Tier 1',
        category: ShareableAchievementCategory.biometricShift,
        primaryMetricValue: '0.47 WHtR',
        primaryMetricLabel: 'Optimal Cardiometabolic Protection',
        regionalMetricLabel: 'कमर-ऊंचाई अनुपात (<०.५०)',
        headline: 'Reversed Visceral Fat Risk Zone (<0.50 WHtR)',
        regionalHeadline: 'उपापचयी स्वास्थ्य में स्वर्ण मानक प्राप्त!',
        detailedSubtitle: 'Waist circumference reduced 6cm • Fasting glucose normalized • +250 Karma',
        karmaPointsEarned: 250,
        recordedAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerifiedBiometric: true,
        verificationSource: 'Biometric Vault Calibration',
        cardTheme: ShareCardTheme.focusBlue,
      ),
    ];

    return ActivitySharingState(
      activePayload: achievements.first,
      availableAchievements: achievements,
      shareHistory: const [],
      totalSharesCount: 4,
      totalShareBonusKarmaEarned: 60,
    );
  }

  void selectPayload(ShareableActivityPayload payload) {
    state = state.copyWith(activePayload: payload);
  }

  void switchCardTheme(ShareCardTheme theme) {
    final updated = state.activePayload.copyWith(cardTheme: theme);
    state = state.copyWith(activePayload: updated);
  }

  void recordShareBroadcast(ShareChannel channel) {
    const bonus = 15;
    final record = ShareBroadcastRecord(
      id: 'share_${DateTime.now().millisecondsSinceEpoch}',
      activityPayloadId: state.activePayload.id,
      channel: channel,
      sharedAt: DateTime.now(),
      bonusKarmaAwarded: bonus,
    );

    state = state.copyWith(
      shareHistory: [record, ...state.shareHistory],
      totalSharesCount: state.totalSharesCount + 1,
      totalShareBonusKarmaEarned: state.totalShareBonusKarmaEarned + bonus,
    );
  }
}
