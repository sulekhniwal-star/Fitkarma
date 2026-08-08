enum IdentityPersona {
  athlete,             // "I am becoming an athlete"
  disciplinedPro,      // "I am a disciplined professional"
  fitParent,           // "I am a fit parent who leads by example"
  strengthBuilder,     // "I am building serious strength"
  longevitySeeker,     // "I am investing in my long-term health"
  healthyIndian,       // "I am proving that Indian food can fuel peak performance"
}

class IdentityEvolution {
  final bool isUnlocked;
  final IdentityPersona persona;
  final String title;
  final String statement;
  final String milestoneText;
  final int xpBonus;
  final String badgeName;
  final List<String> evidenceList;
  final String quote;
  final String nextEvolutionPrompt;

  const IdentityEvolution({
    required this.isUnlocked,
    required this.persona,
    required this.title,
    required this.statement,
    required this.milestoneText,
    required this.xpBonus,
    required this.badgeName,
    required this.evidenceList,
    required this.quote,
    required this.nextEvolutionPrompt,
  });

  factory IdentityEvolution.none() {
    return const IdentityEvolution(
      isUnlocked: false,
      persona: IdentityPersona.strengthBuilder,
      title: 'Strength Builder',
      statement: 'You are becoming a Strength Builder',
      milestoneText: 'Keep training consistently to unlock your identity evolution.',
      xpBonus: 0,
      badgeName: 'Locked',
      evidenceList: [],
      quote: 'Small daily wins build long-term identity.',
      nextEvolutionPrompt: 'Complete 4 consecutive weeks with >= 80% adherence.',
    );
  }
}

class UserProgressData {
  final int workoutsCompletedTotal;
  final int consecutiveCompliantWeeks;
  final double benchPressIncreaseKg;
  final double trainingAdherencePct;
  final String activeProgramName;
  final int currentProgramWeek;

  const UserProgressData({
    required this.workoutsCompletedTotal,
    required this.consecutiveCompliantWeeks,
    required this.benchPressIncreaseKg,
    required this.trainingAdherencePct,
    required this.activeProgramName,
    required this.currentProgramWeek,
  });
}

/// Pure-Dart Habit Identity Evolution Engine per §P8-C spec
class HabitIdentityEngine {
  const HabitIdentityEngine();

  IdentityEvolution checkEvolution({
    required UserProgressData progress,
    required double overallAdherenceScore,
    required String workStyle,
  }) {
    // 1. Athlete identity: consistently high training adherence & 30+ workouts
    if (progress.trainingAdherencePct >= 85.0 && progress.workoutsCompletedTotal >= 30) {
      return IdentityEvolution(
        isUnlocked: true,
        persona: IdentityPersona.athlete,
        title: 'Athlete',
        statement: 'You are becoming an Athlete',
        milestoneText: 'You\'ve completed 30+ workouts. You\'re not just someone who exercises — you\'re becoming an athlete.',
        xpBonus: 500,
        badgeName: 'Athlete Identity Unlocked',
        evidenceList: [
          '${progress.workoutsCompletedTotal} workouts completed',
          'Training adherence: ${progress.trainingAdherencePct.round()}%',
          '${progress.consecutiveCompliantWeeks} consecutive weeks of high compliance',
        ],
        quote: '"Athletes don\'t ask if they\'ll work out. They decide when."',
        nextEvolutionPrompt: 'Maintain 90%+ training adherence for 4 more weeks.',
      );
    }

    // 2. Strength Builder: solid strength progression & training adherence >= 80%
    if (progress.benchPressIncreaseKg >= 10.0 && progress.trainingAdherencePct >= 80.0) {
      return IdentityEvolution(
        isUnlocked: true,
        persona: IdentityPersona.strengthBuilder,
        title: 'Strength Builder',
        statement: 'You are becoming a Strength Builder',
        milestoneText: 'Week ${progress.currentProgramWeek} of 12 in ${progress.activeProgramName}. Bench press +${progress.benchPressIncreaseKg.round()}kg since Week 1.',
        xpBonus: 450,
        badgeName: 'Strength Builder Unlocked',
        evidenceList: [
          '${progress.workoutsCompletedTotal} workouts completed',
          'Bench press +${progress.benchPressIncreaseKg.round()}kg since Week 1',
          'Training adherence: ${progress.trainingAdherencePct.round()}%',
        ],
        quote: '"Strength isn\'t given — it is earned set by set."',
        nextEvolutionPrompt: 'Complete Week 8 with 85%+ training score.',
      );
    }

    // 3. Disciplined Professional: office workstyle & 4+ weeks compliance
    if (overallAdherenceScore >= 80.0 && workStyle.toLowerCase() == 'office' && progress.consecutiveCompliantWeeks >= 4) {
      return IdentityEvolution(
        isUnlocked: true,
        persona: IdentityPersona.disciplinedPro,
        title: 'Disciplined Professional',
        statement: 'You are becoming a Disciplined Professional',
        milestoneText: '4 weeks of strong adherence despite a busy schedule. You\'re becoming someone who never lets work derail their health.',
        xpBonus: 400,
        badgeName: 'Disciplined Professional Unlocked',
        evidenceList: [
          '4 consecutive compliant weeks',
          'Overall adherence: ${overallAdherenceScore.round()}%',
          'Work-health balance maintained',
        ],
        quote: '"Professional excellence extends to personal health."',
        nextEvolutionPrompt: 'Reach 8 consecutive compliant weeks.',
      );
    }

    return IdentityEvolution.none();
  }

  /// Identity -> AI Coach integration prompt builder
  String buildAiCoachSystemPrompt(IdentityEvolution evolution) {
    if (!evolution.isUnlocked) {
      return 'User is establishing baseline health habits.';
    }
    return 'Identity Context: User identity is "${evolution.statement}". Frame coaching advice around identity reinforcement ("${evolution.quote}") rather than short-term guilt.';
  }
}
