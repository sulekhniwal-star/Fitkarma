/// §P8-C Habit Identity Layer (Behavior Science)
///
/// Implements identity-reinforcement messaging logic, identity persona evolution rules,
/// and AI Coach / Daily Mission prompt formatting matching §P8-C specification.
library;

import 'package:fitkarma/features/karma/adherence_score_calculator.dart';
import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P8-C Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum IdentityPersona {
  athlete(
    'Athlete Identity',
    'I am becoming an athlete',
    'Athletes don\'t ask if they\'ll work out. They decide where.',
    '🏋️',
  ),
  disciplinedPro(
    'Disciplined Professional',
    'I am a disciplined professional who protects health',
    'High performers prioritize recovery so work never derails their baseline.',
    '💼',
  ),
  fitParent(
    'Fit Parent Leader',
    'I am a fit parent who leads by example',
    'Children follow actions, not instructions. You are building family legacy.',
    '👨‍👩‍👧',
  ),
  strengthBuilder(
    'Strength Builder',
    'I am building serious strength and physical resilience',
    'Progressive overload isn\'t just lifting weights — it\'s building grit.',
    '💪',
  ),
  longevitySeeker(
    'Longevity Seeker',
    'I am investing in my long-term health and vitality',
    'Health is cumulative compounding interest for your future self.',
    '🌱',
  ),
  healthyIndian(
    'Healthy Indian Foodie',
    'I am proving Indian food fuels peak performance',
    'Traditional Indian spices and macronutrient balance create world-class fuel.',
    '🍛',
  );

  const IdentityPersona(
    this.displayName,
    this.identityStatement,
    this.coreQuote,
    this.iconSymbol,
  );

  final String displayName;
  final String identityStatement;
  final String coreQuote;
  final String iconSymbol;
}

class IdentityEvolution {
  const IdentityEvolution({
    required this.persona,
    required this.milestoneMessage,
    required this.badgeTitle,
    required this.xpBonus,
    required this.evidencePoints,
    required this.quote,
  });

  factory IdentityEvolution.none() => const IdentityEvolution(
        persona: IdentityPersona.longevitySeeker,
        milestoneMessage: 'Keep building consistency to unlock your identity evolution.',
        badgeTitle: 'Consistency Builder',
        xpBonus: 0,
        evidencePoints: ['Every workout counts towards your identity.'],
        quote: 'Small habits aggregate into massive transformations.',
      );

  final IdentityPersona persona;
  final String milestoneMessage;
  final String badgeTitle;
  final int xpBonus;
  final List<String> evidencePoints;
  final String quote;

  bool get hasEvolved => xpBonus > 0;
}

class UserProgressSnapshot {
  const UserProgressSnapshot({
    required this.workoutsCompletedTotal,
    required this.consecutiveCompliantWeeks,
    required this.proteinTargetHitCount,
    required this.isOfficeProfessional,
    required this.isParent,
    required this.strengthIncreaseKg,
    required this.isIndianDiet,
  });

  final int workoutsCompletedTotal;
  final int consecutiveCompliantWeeks;
  final int proteinTargetHitCount;
  final bool isOfficeProfessional;
  final bool isParent;
  final double strengthIncreaseKg;
  final bool isIndianDiet;
}

// ─────────────────────────────────────────────────────────────────────────────
// Habit Identity Engine
// ─────────────────────────────────────────────────────────────────────────────

class HabitIdentityEngine {
  const HabitIdentityEngine();

  /// Evaluates user behavioral evidence and checks if an identity evolution is unlocked.
  IdentityEvolution checkEvolution({
    required UserProgressSnapshot progress,
    required AdherenceResult adherence,
    required TransformationMemory memory,
  }) {
    // 1. Athlete Identity: High training adherence (≥ 85%) & ≥ 30 workouts completed
    if (adherence.trainingScore >= 85 && progress.workoutsCompletedTotal >= 30) {
      return IdentityEvolution(
        persona: IdentityPersona.athlete,
        milestoneMessage: "You've completed 30 workouts with 85%+ adherence. "
            "You're not just someone who exercises — you're becoming an athlete.",
        badgeTitle: 'Athlete Identity Unlocked',
        xpBonus: 500,
        evidencePoints: [
          '${progress.workoutsCompletedTotal} total workouts completed',
          'Training adherence: ${adherence.trainingScore}%',
          'Consistent performance across phases',
        ],
        quote: IdentityPersona.athlete.coreQuote,
      );
    }

    // 2. Disciplined Professional: High overall adherence (≥ 80%) & office work style & ≥ 4 weeks compliance
    if (adherence.overallScore >= 80 &&
        progress.isOfficeProfessional &&
        progress.consecutiveCompliantWeeks >= 4) {
      return IdentityEvolution(
        persona: IdentityPersona.disciplinedPro,
        milestoneMessage: '4 weeks of strong adherence despite a busy professional schedule. '
            "You're becoming someone who never lets work derail their health.",
        badgeTitle: 'Disciplined Professional',
        xpBonus: 400,
        evidencePoints: [
          '${progress.consecutiveCompliantWeeks} consecutive compliant weeks',
          'Overall adherence: ${adherence.overallScore}%',
          'Work/life health balance maintained',
        ],
        quote: IdentityPersona.disciplinedPro.coreQuote,
      );
    }

    // 3. Healthy Indian Foodie: Indian diet & protein targets hit ≥ 20 times
    if (progress.isIndianDiet && progress.proteinTargetHitCount >= 20) {
      return IdentityEvolution(
        persona: IdentityPersona.healthyIndian,
        milestoneMessage: '20+ daily protein goals hit using Indian food plans. '
            'You are proving that traditional Indian cuisine fuels peak performance.',
        badgeTitle: 'Healthy Indian Pioneer',
        xpBonus: 350,
        evidencePoints: [
          '${progress.proteinTargetHitCount} protein goals achieved',
          'Nutrient-dense Indian meals prioritized',
        ],
        quote: IdentityPersona.healthyIndian.coreQuote,
      );
    }

    // 4. Strength Builder: Strength increase ≥ 10kg & ≥ 6 compliant weeks
    if (progress.strengthIncreaseKg >= 10.0 && progress.consecutiveCompliantWeeks >= 6) {
      return IdentityEvolution(
        persona: IdentityPersona.strengthBuilder,
        milestoneMessage: 'Compound strength up +${progress.strengthIncreaseKg}kg. '
            'You are building serious strength and physical resilience.',
        badgeTitle: 'Strength Builder',
        xpBonus: 450,
        evidencePoints: [
          'Compound lift strength +${progress.strengthIncreaseKg}kg',
          '6+ weeks progressive overload compliance',
        ],
        quote: IdentityPersona.strengthBuilder.coreQuote,
      );
    }

    // 5. Fit Parent Leader: Parent & high adherence
    if (progress.isParent && adherence.overallScore >= 75) {
      return IdentityEvolution(
        persona: IdentityPersona.fitParent,
        milestoneMessage: 'Leading by example for your family. '
            'You are building a fit lifestyle legacy for your household.',
        badgeTitle: 'Fit Parent Leader',
        xpBonus: 400,
        evidencePoints: [
          'Family health example set',
          'Overall adherence: ${adherence.overallScore}%',
        ],
        quote: IdentityPersona.fitParent.coreQuote,
      );
    }

    return IdentityEvolution.none();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prompt Formatter (Wired into Daily Mission & AI Coach)
// ─────────────────────────────────────────────────────────────────────────────

abstract class IdentityPromptFormatter {
  /// Generates AI Coach system prompt reinforcement text based on persona.
  static String formatForAiCoach(IdentityPersona persona, String userName) {
    return 'COACH SYSTEM INSTRUCTION: $userName has achieved the "${persona.displayName}" identity level. '
        'Reinforce their identity: "${persona.identityStatement}". '
        'Use behavior science identity framing ("You are someone who...") rather than goal framing. '
        'Core quote: "${persona.coreQuote}".';
  }

  /// Generates Daily Mission screen identity header quote.
  static String formatForDailyMission(IdentityPersona persona) {
    return '${persona.iconSymbol} ${persona.identityStatement} — "${persona.coreQuote}"';
  }
}
