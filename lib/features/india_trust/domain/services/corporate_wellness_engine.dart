import '../models/india_trust_models.dart';

class CorporateWellnessEngine {
  const CorporateWellnessEngine();

  /// Calculates team wellness score and insurer health discount
  CorporateTeamSummary evaluateTeamWellness({
    required String id,
    required String companyName,
    required String teamName,
    required String corporateCode,
    required List<double> memberAdherencePercentages,
  }) {
    if (memberAdherencePercentages.isEmpty) {
      return CorporateTeamSummary(
        id: id,
        companyName: companyName,
        teamName: teamName,
        corporateCode: corporateCode,
        teamWellnessScore: 50.0,
        activeMembersCount: 0,
        insurerDiscountPct: 0.0,
      );
    }

    final avgAdherence = memberAdherencePercentages.reduce((a, b) => a + b) / memberAdherencePercentages.length;
    final wellnessScore = (avgAdherence * 100).clamp(0.0, 100.0);

    // Group health insurer premium discount scale (up to 15% discount for high team engagement)
    double discountPct = 0.0;
    if (wellnessScore >= 80) {
      discountPct = 15.0;
    } else if (wellnessScore >= 65) {
      discountPct = 10.0;
    } else if (wellnessScore >= 50) {
      discountPct = 5.0;
    }

    return CorporateTeamSummary(
      id: id,
      companyName: companyName,
      teamName: teamName,
      corporateCode: corporateCode,
      teamWellnessScore: double.parse(wellnessScore.toStringAsFixed(1)),
      activeMembersCount: memberAdherencePercentages.length,
      insurerDiscountPct: discountPct,
    );
  }
}
