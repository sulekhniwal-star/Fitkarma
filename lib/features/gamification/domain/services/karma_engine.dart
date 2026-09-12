import '../models/gamification_models.dart';

class KarmaEngine {
  const KarmaEngine();

  /// Base points awarded per activity
  int getBasePoints(KarmaActionType action) {
    switch (action) {
      case KarmaActionType.workoutCompleted:
        return 50;
      case KarmaActionType.mealLogged:
        return 20;
      case KarmaActionType.stepsTargetHit:
        return 30;
      case KarmaActionType.sleepTargetMet:
        return 25;
      case KarmaActionType.dailyBriefingDone:
        return 15;
      case KarmaActionType.sorenessLogged:
        return 10;
      case KarmaActionType.fastingGoalCompleted:
        return 40;
    }
  }

  /// Calculates streak multiplier bonus
  double getStreakMultiplier(int currentStreakDays) {
    if (currentStreakDays >= 14) return 1.50; // +50% bonus
    if (currentStreakDays >= 7) return 1.25; // +25% bonus
    if (currentStreakDays >= 3) return 1.10; // +10% bonus
    return 1.0;
  }

  /// Computes final points awarded with streak multiplier
  int calculatePointsAwarded({
    required KarmaActionType action,
    int currentStreakDays = 0,
  }) {
    final base = getBasePoints(action);
    final multiplier = getStreakMultiplier(currentStreakDays);
    return (base * multiplier).round();
  }

  /// Resolve current Karma Tier from total lifetime points
  KarmaTierInfo getTierInfo(int totalLifetimePoints) {
    if (totalLifetimePoints >= 7000) {
      return const KarmaTierInfo(
        tier: KarmaTier.guru,
        title: 'Karma Guru (परम योगी)',
        titleHindi: 'परम ज्ञानी व अनुशासित गुरु',
        minPoints: 7000,
        maxPoints: 999999,
        multiplier: 1.5,
      );
    }
    if (totalLifetimePoints >= 3500) {
      return const KarmaTierInfo(
        tier: KarmaTier.yogi,
        title: 'Karma Yogi (योगी)',
        titleHindi: 'उत्कृष्ट अभ्यासी व योगी',
        minPoints: 3500,
        maxPoints: 6999,
        multiplier: 1.3,
      );
    }
    if (totalLifetimePoints >= 1500) {
      return const KarmaTierInfo(
        tier: KarmaTier.abhyasi,
        title: 'Karma Abhyasi (अभ्यासी)',
        titleHindi: 'नियमित स्वास्थ्य अभ्यासी',
        minPoints: 1500,
        maxPoints: 3499,
        multiplier: 1.2,
      );
    }
    if (totalLifetimePoints >= 500) {
      return const KarmaTierInfo(
        tier: KarmaTier.sadhak,
        title: 'Karma Sadhak (साधक)',
        titleHindi: 'आरंभिक स्वास्थ्य साधक',
        minPoints: 500,
        maxPoints: 1499,
        multiplier: 1.1,
      );
    }
    return const KarmaTierInfo(
      tier: KarmaTier.novice,
      title: 'Karma Novice (प्रारंभिक)',
      titleHindi: 'स्वास्थ्य यात्रा का प्रारंभ',
      minPoints: 0,
      maxPoints: 499,
      multiplier: 1.0,
    );
  }
}
