import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/karma_badge_database.dart';
import '../../domain/karma_engine.dart';
import '../../domain/karma_models.dart';

final karmaProvider = StateNotifierProvider<KarmaNotifier, KarmaProfile>((ref) {
  return KarmaNotifier();
});

class KarmaNotifier extends StateNotifier<KarmaProfile> {
  KarmaNotifier() : super(_getInitialProfile());

  static KarmaProfile _getInitialProfile() {
    const lifetimeKP = 2450;
    const streak = 8;
    final level = KarmaEngine.calculateLevel(lifetimeKP);
    final tier = KarmaEngine.determineTier(lifetimeKP);
    final progress = KarmaEngine.calculateLevelProgressPercent(lifetimeKP);
    final nextLevelKP = KarmaEngine.calculatePointsToNextLevel(lifetimeKP);
    final streakMult = KarmaEngine.calculateStreakMultiplier(streak);

    final initialTransactions = [
      KarmaTransaction(
        id: 'tx_init_1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionType: KarmaActionType.workoutCompletion,
        basePoints: 150,
        multiplier: 1.44, // 1.25 streak * 1.15 readiness
        totalPointsAwarded: 216,
        description: 'Upper Body Hypertrophy Session Completed',
        regionalDescription: 'व्यायाम सत्र संपन्न (१.४४x गुणक)',
      ),
      KarmaTransaction(
        id: 'tx_init_2',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        actionType: KarmaActionType.shatpawaliSteps,
        basePoints: 50,
        multiplier: 1.25,
        totalPointsAwarded: 63,
        description: 'Post-Lunch Shatpawali Walk (1000 Steps)',
        regionalDescription: 'भोजनोपरांत शतपावली (१.२५x गुणक)',
      ),
      KarmaTransaction(
        id: 'tx_init_3',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        actionType: KarmaActionType.nutritionAdherence,
        basePoints: 100,
        multiplier: 1.25,
        totalPointsAwarded: 125,
        description: 'Protein Target 140g Met (±3g)',
        regionalDescription: 'दैनिक प्रोटीन लक्ष्य पूर्ण (१.२५x गुणक)',
      ),
    ];

    final updatedBadges = KarmaEngine.evaluateBadgeProgression(
      currentBadges: KarmaBadgeDatabase.defaultBadges,
      lifetimePoints: lifetimeKP,
      streakDays: streak,
      completedWorkouts: 12,
      loggedShatpawaliCount: 15,
      highQualityMealsCount: 18,
      optimalSleepNightsCount: 10,
    );

    final unlockedCount = updatedBadges.where((b) => b.isUnlocked).length;

    return KarmaProfile(
      currentKarmaPoints: lifetimeKP,
      lifetimeKarmaPoints: lifetimeKP,
      currentLevel: level,
      tier: tier,
      levelProgressPercent: progress,
      pointsToNextLevel: nextLevelKP,
      currentStreakDays: streak,
      longestStreakDays: 14,
      streakMultiplier: streakMult,
      unlockedBadgesCount: unlockedCount,
      totalBadgesCount: updatedBadges.length,
      recentTransactions: initialTransactions,
      allBadges: updatedBadges,
    );
  }

  /// Awards Karma points for any completed health or wellness action
  void recordKarmaAction({
    required KarmaActionType action,
    double formQualityScore = 1.0,
    bool isReadinessAligned = true,
  }) {
    final transaction = KarmaEngine.generateKarmaReward(
      action: action,
      streakDays: state.currentStreakDays,
      formQualityScore: formQualityScore,
      isReadinessAligned: isReadinessAligned,
    );

    final newLifetimeKP = state.lifetimeKarmaPoints + transaction.totalPointsAwarded;
    final newCurrentKP = state.currentKarmaPoints + transaction.totalPointsAwarded;
    final newLevel = KarmaEngine.calculateLevel(newLifetimeKP);
    final newTier = KarmaEngine.determineTier(newLifetimeKP);
    final newProgress = KarmaEngine.calculateLevelProgressPercent(newLifetimeKP);
    final newPointsToNext = KarmaEngine.calculatePointsToNextLevel(newLifetimeKP);

    final updatedTransactions = [transaction, ...state.recentTransactions.take(19)];

    final updatedBadges = KarmaEngine.evaluateBadgeProgression(
      currentBadges: state.allBadges,
      lifetimePoints: newLifetimeKP,
      streakDays: state.currentStreakDays,
      completedWorkouts: action == KarmaActionType.workoutCompletion ? 13 : 12,
      loggedShatpawaliCount: action == KarmaActionType.shatpawaliSteps ? 16 : 15,
      highQualityMealsCount: action == KarmaActionType.mealQualityLog ? 19 : 18,
      optimalSleepNightsCount: action == KarmaActionType.sleepGoalAchieved ? 11 : 10,
    );

    final unlockedCount = updatedBadges.where((b) => b.isUnlocked).length;

    state = KarmaProfile(
      currentKarmaPoints: newCurrentKP,
      lifetimeKarmaPoints: newLifetimeKP,
      currentLevel: newLevel,
      tier: newTier,
      levelProgressPercent: newProgress,
      pointsToNextLevel: newPointsToNext,
      currentStreakDays: state.currentStreakDays,
      longestStreakDays: state.longestStreakDays,
      streakMultiplier: state.streakMultiplier,
      unlockedBadgesCount: unlockedCount,
      totalBadgesCount: updatedBadges.length,
      recentTransactions: updatedTransactions,
      allBadges: updatedBadges,
    );
  }
}
