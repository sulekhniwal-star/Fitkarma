import 'dart:math' as math;
import 'habit_identity_models.dart';

/// Pure Dart Deterministic Engine for Identity-Based Habit Formation,
/// Asymptotic Automaticity Curves, and Swadharma Identity Fusion.
class HabitIdentityEngine {
  const HabitIdentityEngine._();

  /// Calculates Identity Fusion Score (0.0 to 100.0)
  static double calculateIdentityFusionScore({
    required int totalVotesCast,
    required int activeStreakDays,
    required double adherenceScore,
  }) {
    // 1. Logarithmic vote saturation component (max 40 pts)
    final voteComponent =
        (math.log(1.0 + totalVotesCast) * 8.5).clamp(0.0, 40.0);

    // 2. Streak continuity component (max 35 pts)
    final streakComponent = ((activeStreakDays / 30.0).clamp(0.0, 1.0)) * 35.0;

    // 3. Adherence reliability component (max 25 pts)
    final adherenceComponent = (adherenceScore * 0.25).clamp(0.0, 25.0);

    return (voteComponent + streakComponent + adherenceComponent)
        .clamp(0.0, 100.0);
  }

  /// Calculates Asymptotic Habit Automaticity Index based on Lally et al. (2010)
  /// Au = 100 * (1 - exp(-k * repetitions))
  static double calculateAutomaticityIndex({
    required int consecutiveRepetitionDays,
  }) {
    const k = 0.038; // standard habit formation decay constant
    final rawAutomaticity =
        100.0 * (1.0 - math.exp(-k * consecutiveRepetitionDays));
    return rawAutomaticity.clamp(5.0, 99.0);
  }

  /// Evaluates Identity Fusion Stage based on fusion score
  static IdentityFusionStage determineFusionStage(double fusionScore) {
    if (fusionScore >= 85.0) {
      return IdentityFusionStage.sahaja;
    } else if (fusionScore >= 65.0) {
      return IdentityFusionStage.nishtha;
    } else if (fusionScore >= 30.0) {
      return IdentityFusionStage.abhyasi;
    }
    return IdentityFusionStage.jigyasu;
  }

  /// Compiles comprehensive Habit Identity Report
  static HabitIdentityReport evaluateHabitIdentity({
    required IdentityArchetype primaryArchetype,
    required int totalVotesCast,
    required int activeStreakDays,
    required double adherenceScore,
    required List<IdentityVoteRecord> recentVotes,
  }) {
    final fusionScore = calculateIdentityFusionScore(
      totalVotesCast: totalVotesCast,
      activeStreakDays: activeStreakDays,
      adherenceScore: adherenceScore,
    );

    final automaticityIndex = calculateAutomaticityIndex(
      consecutiveRepetitionDays: activeStreakDays,
    );

    final stage = determineFusionStage(fusionScore);
    final frictionReduction = (automaticityIndex * 0.92).clamp(0.0, 95.0);

    // Calculate archetype vote breakdown
    final Map<IdentityArchetype, int> tallyMap = {
      IdentityArchetype.dharmaYogi: 0,
      IdentityArchetype.kshatriyaAthlete: 0,
      IdentityArchetype.urbanPacesetter: 0,
      IdentityArchetype.holisticHealer: 0,
    };

    for (final v in recentVotes) {
      tallyMap[v.archetypeReinforced] =
          (tallyMap[v.archetypeReinforced] ?? 0) + v.votesCount;
    }

    // Add baseline proportional weight for primary archetype
    tallyMap[primaryArchetype] =
        (tallyMap[primaryArchetype] ?? 0) + (totalVotesCast ~/ 2);

    final totalTallyCount =
        tallyMap.values.fold<int>(0, (sum, val) => sum + val);
    final voteTallies = tallyMap.entries.map((entry) {
      final share =
          totalTallyCount > 0 ? (entry.value / totalTallyCount) * 100.0 : 25.0;
      return ArchetypeVoteTally(
        archetype: entry.key,
        totalVotes: entry.value,
        percentageShare: share,
      );
    }).toList();

    // Affirmation based on stage
    String affirmation;
    String regionalAffirmation;

    switch (stage) {
      case IdentityFusionStage.sahaja:
        affirmation =
            'Your habits are no longer tasks to complete; they are the natural expression of who you are.';
        regionalAffirmation =
            'आपकी आदतें अब कोई कार्य नहीं, अपितु आपके स्वाभाविक अस्तित्व की सहज अभिव्यक्ति हैं।';
        break;
      case IdentityFusionStage.nishtha:
        affirmation =
            'You have cast $totalVotesCast votes for your ${primaryArchetype.title}. Discipline is turning into devotion.';
        regionalAffirmation =
            'आपने अपने स्वरूप के पक्ष में $totalVotesCast संकल्प मत डाले हैं। अनुशासन अब निष्ठा में बदल चुका है।';
        break;
      case IdentityFusionStage.abhyasi:
        affirmation =
            'Every completed ritual lowers mental resistance. You are actively stepping into your athlete identity.';
        regionalAffirmation =
            'प्रत्येक पूर्ण अनुष्ठान मानसिक आलस्य को घटाता है। आप अपनी नई पहचान में प्रवेश कर रहे हैं।';
        break;
      case IdentityFusionStage.jigyasu:
        affirmation =
            'Every small action is a powerful vote for the person you are becoming today.';
        regionalAffirmation =
            'प्रत्येक छोटा सकारात्मक कदम आपके भावी स्वरूप के निर्माण का सशक्त प्रमाण है।';
        break;
    }

    return HabitIdentityReport(
      primaryArchetype: primaryArchetype,
      fusionStage: stage,
      identityFusionScore: fusionScore,
      habitAutomaticityIndex: automaticityIndex,
      totalVotesCast: totalVotesCast,
      voteTallies: voteTallies,
      recentVotes: recentVotes,
      dailySankalpaAffirmation: affirmation,
      regionalDailySankalpaAffirmation: regionalAffirmation,
      cognitiveFrictionReductionPercent: frictionReduction,
    );
  }
}
