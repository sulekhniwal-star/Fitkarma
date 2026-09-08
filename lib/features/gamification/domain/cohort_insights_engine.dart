import 'dart:math' as math;
import 'cohort_models.dart';

/// Pure Dart Deterministic Engine for Demographic Cohorts, Percentile Benchmarks,
/// and Positive Social Contagion Network Effects.
class DemographicCohortEngine {
  const DemographicCohortEngine._();

  /// Approximate Normal Cumulative Distribution Function
  static double _normalCdf(double z) {
    return 1.0 / (1.0 + math.exp(-1.702 * z));
  }

  /// Calculates percentile from value, mean, and standard deviation
  static double calculatePercentile({
    required double value,
    required double mean,
    required double stdDev,
    bool higherIsBetter = true,
  }) {
    if (stdDev <= 0.0001) return 50.0;
    final z = (value - mean) / stdDev;
    final effectiveZ = higherIsBetter ? z : -z;
    final rawPercentile = _normalCdf(effectiveZ) * 100.0;
    return rawPercentile.clamp(1.0, 99.9);
  }

  /// Evaluates the User's Network Influence Tier
  static NetworkInfluenceTier evaluateNetworkInfluence({
    required double compositePercentile,
    required int activeStreakDays,
    required double adherenceScore,
  }) {
    if (compositePercentile >= 90.0 && activeStreakDays >= 21 && adherenceScore >= 85.0) {
      return NetworkInfluenceTier.luminary;
    } else if (compositePercentile >= 75.0 && activeStreakDays >= 14 && adherenceScore >= 75.0) {
      return NetworkInfluenceTier.vanguard;
    } else if (compositePercentile >= 55.0 && activeStreakDays >= 7 && adherenceScore >= 60.0) {
      return NetworkInfluenceTier.catalyst;
    }
    return NetworkInfluenceTier.seed;
  }

  /// Computes the Social Contagion Index (0.0 to 100.0)
  /// Represents the statistical likelihood of positively lifting peers' adherence.
  static double calculateSocialContagionIndex({
    required double adherenceScore,
    required int activeStreakDays,
    required double compositePercentile,
  }) {
    final adherenceComponent = adherenceScore * 0.40;
    final streakComponent = (activeStreakDays / 30.0).clamp(0.0, 1.0) * 30.0;
    final percentileComponent = compositePercentile * 0.30;
    
    return (adherenceComponent + streakComponent + percentileComponent).clamp(10.0, 99.0);
  }

  /// Generates the complete Demographic Cohort Report
  static DemographicCohortReport evaluateCohortReport({
    required int userAge,
    required String biologicalSex,
    required IndianCityTier cityTier,
    required ActivityPersonaCluster persona,
    required double userDailySteps,
    required double userShatpawaliCompliancePercent,
    required double userProteinGramsPerKg,
    required double userSleepRecoveryPercent,
    required double userWeeklyWorkouts,
    required double userDailyKarmaVelocity,
    required int activeStreakDays,
    required double userAdherenceScore,
  }) {
    // 1. Determine age bracket
    final String ageBracket = userAge < 25
        ? '18-24 yrs'
        : userAge < 35
            ? '25-34 yrs'
            : userAge < 45
                ? '35-44 yrs'
                : userAge < 55
                    ? '45-54 yrs'
                    : '55+ yrs';

    // 2. Persona-adjusted baseline statistics
    final stepMean = persona.baselineDailySteps.toDouble() * (cityTier == IndianCityTier.tier1 ? 0.95 : 1.05);
    const stepStdDev = 2200.0;

    const shatpawaliMean = 45.0; // 45% compliance
    const shatpawaliStdDev = 20.0;

    const proteinMean = 0.85; // g/kg
    const proteinStdDev = 0.30;

    const sleepRecoveryMean = 72.0; // 72%
    const sleepRecoveryStdDev = 12.0;

    const workoutsMean = 2.8; // sessions/week
    const workoutsStdDev = 1.2;

    const karmaVelocityMean = 85.0; // karma pts/day
    const karmaVelocityStdDev = 35.0;

    // 3. Compute individual pillar metrics & percentiles
    final stepsPercentile = calculatePercentile(
      value: userDailySteps,
      mean: stepMean,
      stdDev: stepStdDev,
    );

    final shatpawaliPercentile = calculatePercentile(
      value: userShatpawaliCompliancePercent,
      mean: shatpawaliMean,
      stdDev: shatpawaliStdDev,
    );

    final proteinPercentile = calculatePercentile(
      value: userProteinGramsPerKg,
      mean: proteinMean,
      stdDev: proteinStdDev,
    );

    final sleepPercentile = calculatePercentile(
      value: userSleepRecoveryPercent,
      mean: sleepRecoveryMean,
      stdDev: sleepRecoveryStdDev,
    );

    final workoutsPercentile = calculatePercentile(
      value: userWeeklyWorkouts,
      mean: workoutsMean,
      stdDev: workoutsStdDev,
    );

    final karmaPercentile = calculatePercentile(
      value: userDailyKarmaVelocity,
      mean: karmaVelocityMean,
      stdDev: karmaVelocityStdDev,
    );

    final pillarMetrics = [
      CohortPillarMetric(
        pillarId: 'daily_steps',
        title: 'Daily Movement & Steps',
        regionalTitle: 'दैनिक गतिशीलता व कदम',
        userValue: userDailySteps,
        cohortAverage: stepMean,
        top10PercentileValue: stepMean + (1.28 * stepStdDev),
        unit: 'steps/day',
        userPercentile: stepsPercentile,
      ),
      CohortPillarMetric(
        pillarId: 'shatpawali',
        title: 'Post-Meal Shatpawali Consistency',
        regionalTitle: 'भोजनोपरांत शतपावली निरंतरता',
        userValue: userShatpawaliCompliancePercent,
        cohortAverage: shatpawaliMean,
        top10PercentileValue: 85.0,
        unit: '% meals',
        userPercentile: shatpawaliPercentile,
      ),
      CohortPillarMetric(
        pillarId: 'protein_density',
        title: 'Dietary Protein Density',
        regionalTitle: 'आहार में प्रोटीन अनुपात',
        userValue: userProteinGramsPerKg,
        cohortAverage: proteinMean,
        top10PercentileValue: 1.45,
        unit: 'g/kg BW',
        userPercentile: proteinPercentile,
      ),
      CohortPillarMetric(
        pillarId: 'sleep_recovery',
        title: 'Sleep Autonomic Recovery',
        regionalTitle: 'निद्रा पुनरुद्धार क्षमता',
        userValue: userSleepRecoveryPercent,
        cohortAverage: sleepRecoveryMean,
        top10PercentileValue: 88.0,
        unit: '% restorative',
        userPercentile: sleepPercentile,
      ),
      CohortPillarMetric(
        pillarId: 'workout_freq',
        title: 'Weekly Training Volume',
        regionalTitle: 'साप्ताहिक व्यायाम सत्र',
        userValue: userWeeklyWorkouts,
        cohortAverage: workoutsMean,
        top10PercentileValue: 5.0,
        unit: 'sessions/wk',
        userPercentile: workoutsPercentile,
      ),
      CohortPillarMetric(
        pillarId: 'karma_velocity',
        title: 'Daily Karma Velocity',
        regionalTitle: 'दैनिक कर्म अर्जन गति',
        userValue: userDailyKarmaVelocity,
        cohortAverage: karmaVelocityMean,
        top10PercentileValue: 140.0,
        unit: 'pts/day',
        userPercentile: karmaPercentile,
      ),
    ];

    // 4. Composite Percentile & Influence Tier
    final compositePercentile = (stepsPercentile * 0.25) +
        (shatpawaliPercentile * 0.15) +
        (proteinPercentile * 0.20) +
        (sleepPercentile * 0.15) +
        (workoutsPercentile * 0.15) +
        (karmaPercentile * 0.10);

    final influenceTier = evaluateNetworkInfluence(
      compositePercentile: compositePercentile,
      activeStreakDays: activeStreakDays,
      adherenceScore: userAdherenceScore,
    );

    final contagionIndex = calculateSocialContagionIndex(
      adherenceScore: userAdherenceScore,
      activeStreakDays: activeStreakDays,
      compositePercentile: compositePercentile,
    );

    // 5. Cohort Group
    final cohortGroup = DemographicCohortGroup(
      cohortId: 'IN_${cityTier.name.toUpperCase()}_${ageBracket.replaceAll(' ', '_')}',
      ageBracket: ageBracket,
      biologicalSex: biologicalSex,
      cityTier: cityTier,
      persona: persona,
      activePeersCount: cityTier == IndianCityTier.tier1 ? 14820 : cityTier == IndianCityTier.tier2 ? 8940 : 5410,
      cohortAverageAdherence: 68.5,
      cohortAverageKarma: 850.0,
    );

    // 6. Anonymized Peer Network Contagion Stream
    final recentActivities = [
      AnonymizedPeerActivity(
        id: 'act_1',
        peerAlias: 'Athlete from ${cityTier == IndianCityTier.tier1 ? 'Bengaluru' : 'Pune'}',
        regionalPeerAlias: '${cityTier == IndianCityTier.tier1 ? 'बेंगलुरु' : 'पुणे'} के साधक',
        actionDescription: 'Completed 100-step Shatpawali post-dinner',
        regionalActionDescription: 'रात्रि भोजनोपरांत १०० कदम शतपावली पूर्ण की',
        karmaGenerated: 25,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        iconName: 'directions_walk',
      ),
      AnonymizedPeerActivity(
        id: 'act_2',
        peerAlias: 'Practitioner in your age cluster',
        regionalPeerAlias: 'आपके आयु वर्ग के सह-साधक',
        actionDescription: 'Hit 1.3g/kg Protein goal with Sattu & Paneer',
        regionalActionDescription: 'सत्तू व पनीर द्वारा प्रोटीन लक्ष्य हासिल किया',
        karmaGenerated: 40,
        timestamp: DateTime.now().subtract(const Duration(minutes: 19)),
        iconName: 'restaurant',
      ),
      AnonymizedPeerActivity(
        id: 'act_3',
        peerAlias: 'Runner from ${cityTier == IndianCityTier.tier1 ? 'Mumbai' : 'Ahmedabad'}',
        regionalPeerAlias: '${cityTier == IndianCityTier.tier1 ? 'मुंबई' : 'अहमदाबाद'} के धावक',
        actionDescription: 'Maintained 8+ hrs sleep with 88% Recovery score',
        regionalActionDescription: '८+ घंटे निद्रा व ८८% रिकवरी स्तर बनाए रखा',
        karmaGenerated: 35,
        timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
        iconName: 'bedtime',
      ),
      AnonymizedPeerActivity(
        id: 'act_4',
        peerAlias: 'Yogi from ${cityTier == IndianCityTier.tier1 ? 'Delhi NCR' : 'Jaipur'}',
        regionalPeerAlias: '${cityTier == IndianCityTier.tier1 ? 'दिल्ली एनसीआर' : 'जयपुर'} के साधक',
        actionDescription: 'Completed Surya Namaskar & Pranayama flow',
        regionalActionDescription: 'सूर्य नमस्कार व प्राणायाम सत्र संपन्न किया',
        karmaGenerated: 30,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        iconName: 'self_improvement',
      ),
    ];

    // 7. Collective Sangha Goal
    final collectiveGoal = SanghaCollectiveGoal(
      id: 'sangha_10m_steps',
      title: '${cityTier.label.split(' ')[0]} 10-Million Step Challenge',
      regionalTitle: '${cityTier.regionalLabel} १ करोड़ कदम सामूहिक संकल्प',
      description: 'Collective movement milestone across all active members in your regional cluster.',
      regionalDescription: 'आपके क्षेत्र के सभी सक्रिय साधकों का सामूहिक गतिशीलता संकल्प।',
      targetQuantity: 10000000,
      currentQuantity: 7420000 + (userDailySteps * 45),
      unit: 'steps',
      deadline: DateTime.now().add(const Duration(days: 4)),
      participatingAthletes: cohortGroup.activePeersCount,
    );

    // 8. Positive Cultural Nudge
    String positiveNudge;
    String regionalPositiveNudge;

    if (compositePercentile >= 75.0) {
      positiveNudge = 'Your consistency puts you in the top quartile of ${persona.label}s in ${cityTier.name.toUpperCase()}. You are actively lifting the Sangha energy!';
      regionalPositiveNudge = 'आपकी साधना आपको अपने वर्ग में शीर्ष २५% में स्थापित करती है। आप संघ की ऊर्जा का संवर्धन कर रहे हैं!';
    } else if (shatpawaliPercentile < 50.0) {
      positiveNudge = 'Peers in your cohort who practice post-dinner Shatpawali report 22% better morning recovery. A 10-minute stroll tonight will elevate your rank.';
      regionalPositiveNudge = 'रात्रि शतपावली करने वाले साथियों की सुबह की रिकवरी २२% बेहतर होती है। आज १० मिनट की चहलकदमी से अपनी स्थिति उन्नत करें।';
    } else {
      positiveNudge = 'You are steadily building momentum alongside ${cohortGroup.activePeersCount} peers. Consistency is the true multiplier.';
      regionalPositiveNudge = 'आप ${cohortGroup.activePeersCount} साथियों के साथ निरंतर प्रगति कर रहे हैं। नियमितता ही सबसे बड़ी शक्ति है।';
    }

    return DemographicCohortReport(
      cohortGroup: cohortGroup,
      networkInfluence: influenceTier,
      socialContagionIndex: contagionIndex,
      networkBonusMultiplier: influenceTier.multiplier,
      pillarMetrics: pillarMetrics,
      recentPeerActivities: recentActivities,
      activeCollectiveGoal: collectiveGoal,
      primaryPositiveNudge: positiveNudge,
      regionalPrimaryPositiveNudge: regionalPositiveNudge,
    );
  }
}
