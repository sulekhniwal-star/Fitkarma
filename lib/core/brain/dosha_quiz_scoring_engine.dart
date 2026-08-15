enum DoshaType { vata, pitta, kapha }

class DoshaAnswer {
  final String questionId;
  final DoshaType associatedDosha;

  const DoshaAnswer({
    required this.questionId,
    required this.associatedDosha,
  });
}

class DoshaGuidelines {
  final String dietaryFocus;
  final String stressFocus;
  final List<String> recommendedSpices;

  const DoshaGuidelines({
    required this.dietaryFocus,
    required this.stressFocus,
    required this.recommendedSpices,
  });
}

class DoshaResult {
  final DoshaType dominant;
  final double vataPct;
  final double pittaPct;
  final double kaphaPct;
  final DoshaGuidelines guidelines;

  const DoshaResult({
    required this.dominant,
    required this.vataPct,
    required this.pittaPct,
    required this.kaphaPct,
    required this.guidelines,
  });

  factory DoshaResult.equalDistribution() => const DoshaResult(
        dominant: DoshaType.vata,
        vataPct: 33.3,
        pittaPct: 33.3,
        kaphaPct: 33.3,
        guidelines: DoshaGuidelines(
          dietaryFocus: "Balanced diet containing equal elements.",
          stressFocus: "Alternate nostril breathing (Nadi Shodhana).",
          recommendedSpices: ["Ginger", "Fennel"],
        ),
      );
}

/// DoshaQuizScoringEngine (Pure Dart, No AI)
class DoshaQuizScoringEngine {
  const DoshaQuizScoringEngine();

  DoshaResult calculateDoshaProfile(List<DoshaAnswer> answers) {
    int vataScore = 0;
    int pittaScore = 0;
    int kaphaScore = 0;

    for (final answer in answers) {
      switch (answer.associatedDosha) {
        case DoshaType.vata:
          vataScore++;
          break;
        case DoshaType.pitta:
          pittaScore++;
          break;
        case DoshaType.kapha:
          kaphaScore++;
          break;
      }
    }

    final total = vataScore + pittaScore + kaphaScore;
    if (total == 0) return DoshaResult.equalDistribution();

    final vataPct = (vataScore / total) * 100;
    final pittaPct = (pittaScore / total) * 100;
    final kaphaPct = (kaphaScore / total) * 100;

    // Determine dominant Dosha
    DoshaType dominant = DoshaType.vata;
    double maxPct = vataPct;
    if (pittaPct > maxPct) {
      dominant = DoshaType.pitta;
      maxPct = pittaPct;
    }
    if (kaphaPct > maxPct) {
      dominant = DoshaType.kapha;
    }

    return DoshaResult(
      dominant: dominant,
      vataPct: vataPct,
      pittaPct: pittaPct,
      kaphaPct: kaphaPct,
      guidelines: _generateGuidelines(dominant),
    );
  }

  DoshaGuidelines _generateGuidelines(DoshaType dominant) {
    switch (dominant) {
      case DoshaType.vata:
        return const DoshaGuidelines(
          dietaryFocus:
              "Warm, cooked, and grounding foods. Favor sweet, sour, and salty tastes. Limit raw/cold items.",
          stressFocus:
              "Gentle grounding routines, warm oil self-massage (Abhyanga), and restorative yoga.",
          recommendedSpices: ["Ginger", "Cardamom", "Cinnamon", "Cumin"],
        );
      case DoshaType.pitta:
        return const DoshaGuidelines(
          dietaryFocus:
              "Cooling, hydrating foods. Favor sweet, bitter, and astringent tastes. Avoid spicy/fermented foods.",
          stressFocus:
              "Non-competitive exercise, cooling breathing practices (Shitali Pranayama), and spending time in nature.",
          recommendedSpices: ["Fennel", "Coriander", "Cilantro", "Turmeric"],
        );
      case DoshaType.kapha:
        return const DoshaGuidelines(
          dietaryFocus:
              "Warm, light, and dry foods. Favor pungent, bitter, and astringent tastes. Avoid heavy dairy and sweets.",
          stressFocus:
              "Vigorous daily physical activity, stimulating dynamic breathing (Kapalabhati), and warm-up stretches.",
          recommendedSpices: [
            "Black Pepper",
            "Ginger",
            "Mustard Seeds",
            "Cayenne"
          ],
        );
    }
  }
}
