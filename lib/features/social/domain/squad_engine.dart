import 'squad_models.dart';

/// Pure Dart Deterministic Engine for Squad Dynamics, Streak Continuity,
/// Tier Promotions, and Sanjeevani Shield Protections.
class SquadEngine {
  const SquadEngine._();

  /// Determines squad tier from active streak days
  static SquadTier evaluateSquadTier(int activeStreakDays) {
    if (activeStreakDays >= SquadTier.mahasangha.requiredStreakDays) {
      return SquadTier.mahasangha;
    } else if (activeStreakDays >= SquadTier.vanguard.requiredStreakDays) {
      return SquadTier.vanguard;
    } else if (activeStreakDays >= SquadTier.abhyasi.requiredStreakDays) {
      return SquadTier.abhyasi;
    }
    return SquadTier.arambha;
  }

  /// Evaluates end-of-day squad streak resolution
  static SquadDetail resolveSquadDay(SquadDetail squad) {
    final allCheckedIn = squad.isSquadStreakCompleteToday;

    if (allCheckedIn) {
      final newStreak = squad.currentStreakDays + 1;
      final newBest = newStreak > squad.bestStreakDays ? newStreak : squad.bestStreakDays;
      final newTier = evaluateSquadTier(newStreak);
      final bonusKarma = (100 * newTier.multiplier).round();

      return squad.copyWith(
        currentStreakDays: newStreak,
        bestStreakDays: newBest,
        tier: newTier,
        totalCollectiveKarma: squad.totalCollectiveKarma + bonusKarma,
      );
    } else if (squad.availableSanjeevaniShields > 0) {
      // Auto-deploy Sanjeevani Shield to preserve the streak
      return squad.copyWith(
        availableSanjeevaniShields: squad.availableSanjeevaniShields - 1,
      );
    } else {
      // Streak resets to 1 (graceful floor)
      return squad.copyWith(
        currentStreakDays: 1,
        tier: SquadTier.arambha,
      );
    }
  }

  /// Calculates total collective steps walked today by all squad members
  static int calculateTotalSquadSteps(List<SquadMemberDetail> members) {
    return members.fold<int>(0, (sum, m) => sum + m.todaySteps);
  }
}
