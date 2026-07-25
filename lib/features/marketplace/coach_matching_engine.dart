/// §P13-B Creator & Coach Matchmaking Engine
///
/// Computes algorithmic match scores between client goals/demographics and certified coaches matching §P13-B spec.
library;

import 'marketplace_models.dart';

class MatchResult {
  const MatchResult({required this.coach, required this.matchScore});

  final CreatorProfile coach;
  final double matchScore;
}

class CoachMatchingEngine {
  const CoachMatchingEngine();

  /// Matches user goals with verified coach profiles and ranks them by relevance score (§P13-B spec).
  List<MatchResult> match({
    required List<String> clientGoals,
    String? clientDietType,
    required List<CreatorProfile> allCoaches,
  }) {
    final results = <MatchResult>[];

    for (final coach in allCoaches) {
      if (!coach.isVerified) continue;

      double score = 0.0;
      final normalizedGoals = clientGoals.map((g) => g.toLowerCase()).toList();

      for (final specialty in coach.specialties) {
        switch (specialty) {
          case CoachSpecialty.pcosManagement:
            if (normalizedGoals.any((g) => g.contains('pcos') || g.contains('hormonal'))) {
              score += 50.0;
            }
            break;
          case CoachSpecialty.muscleBuilding:
            if (normalizedGoals.any((g) => g.contains('muscle') || g.contains('hypertrophy') || g.contains('strength'))) {
              score += 40.0;
            }
            break;
          case CoachSpecialty.diabeticReversal:
            if (normalizedGoals.any((g) => g.contains('diabet') || g.contains('glucose') || g.contains('hba1c'))) {
              score += 50.0;
            }
            break;
          case CoachSpecialty.runningMarathon:
            if (normalizedGoals.any((g) => g.contains('running') || g.contains('marathon') || g.contains('stamina'))) {
              score += 40.0;
            }
            break;
          case CoachSpecialty.weightLoss:
            if (normalizedGoals.any((g) => g.contains('weight_loss') || g.contains('fat_loss') || g.contains('shred'))) {
              score += 40.0;
            }
            break;
          case CoachSpecialty.generalFitness:
            score += 20.0;
            break;
        }
      }

      // Add weighting based on average rating (e.g. 4.8 rating = +48 pts)
      score += coach.averageRating * 10.0;

      results.add(MatchResult(coach: coach, matchScore: score));
    }

    results.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return results;
  }
}
