import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/longevity_score_engine.dart';

class LongevityDashboardScreen extends ConsumerStatefulWidget {
  const LongevityDashboardScreen({super.key});

  @override
  ConsumerState<LongevityDashboardScreen> createState() => _LongevityDashboardScreenState();
}

class _LongevityDashboardScreenState extends ConsumerState<LongevityDashboardScreen> {
  final _engine = const LongevityScoreEngine();

  @override
  Widget build(BuildContext context) {
    final assessment = _engine.computeLongevityScore(
      id: 'longevity-1',
      userId: 'user-demo',
      restingHeartRate: 62.0,
      hrvRmssd: 58.0,
      fastingGlucoseMgDl: 92.0,
      systolicBp: 118.0,
      maxDesiBaithakReps: 45,
      weeklyActiveHours: 5.0,
      dailyPranayamaMinutes: 20,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Healthspan & Longevity OS', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Longevity Index Score Hero Card
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.primaryEmerald,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LONGEVITY SCORE', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('${assessment.overallLongevityScore}', style: AppTypography.heroMetric.copyWith(color: AppColors.primaryEmerald)),
                              Text('/100', style: AppTypography.h3.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.all_inclusive, color: AppColors.primaryEmerald, size: 36),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 24),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: AppColors.primaryCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Projected Lifespan Gain: +${assessment.projectedLifespanGainYears} Years',
                        style: AppTypography.h3.copyWith(color: AppColors.primaryCyan),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4 Longevity Pillars
            Text('Longevity Biomarker Pillars', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildPillarCard('Cardiometabolic Reserve', assessment.pillars.cardiometabolic, AppColors.primaryEmerald, Icons.favorite),
            const SizedBox(height: 8),
            _buildPillarCard('Cellular Recovery & HRV', assessment.pillars.cellularRecovery, AppColors.primaryCyan, Icons.nightlight_round),
            const SizedBox(height: 8),
            _buildPillarCard('Functional Strength & Mobility', assessment.pillars.functionalStrength, AppColors.accentAmber, Icons.fitness_center),
            const SizedBox(height: 8),
            _buildPillarCard('Pranayama & Stress Modulation', assessment.pillars.lifestyleHabits, AppColors.accentPurple, Icons.self_improvement),
            const SizedBox(height: 24),

            // Top Healthspan Lever
            Text('Primary Longevity Lever', style: AppTypography.h2),
            const SizedBox(height: 8),
            BentoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assessment.primaryLongevityLever, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(assessment.primaryLongevityLeverHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarCard(String title, double score, Color accent, IconData icon) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTypography.h3)),
              Text('${score.toInt()}%', style: AppTypography.h3.copyWith(color: accent)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 100.0,
              backgroundColor: AppColors.surfaceGlass,
              valueColor: AlwaysStoppedAnimation(accent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
