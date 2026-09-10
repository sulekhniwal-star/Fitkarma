import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/longevity_score_models.dart';
import 'providers/longevity_score_provider.dart';

/// Screen displaying Comprehensive Longevity Score, Projected Healthspan,
/// 6-Pillar Longevity Radar, and Actionable Longevity Accelerators.
class LongevityScoreScreen extends ConsumerWidget {
  const LongevityScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(longevityScoreProvider);
    final tierColor = Color(report.tier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Longevity Score & Healthspan',
          regionalText: 'दीर्घायु सूचकांक व शतायु स्वास्थ्य',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showLongevityMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Longevity Score & Healthspan Card
            _buildHeroLongevityCard(report, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Healthspan Bonus Banner
            _buildHealthspanBonusBanner(report, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 3. 6 Longevity Pillars Scorecard
            const BilingualLabel(
              primaryText: '6-Pillar Longevity Architecture',
              regionalText: 'षट्-आयामी दीर्घायु मूल्यांकन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.pillarScores.map((pillar) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPillarCard(pillar),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. High-Impact Longevity Accelerators
            const BilingualLabel(
              primaryText: 'High-Impact Longevity Accelerators',
              regionalText: 'स्वास्थ्य व आयु बढ़ाने के प्रमुख उपाय',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.topAccelerators.map((accel) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildAcceleratorCard(accel),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLongevityCard(LongevityReport report, Color tierColor) {
    final bonusSign = report.healthspanBonusYears > 0 ? '+' : '';

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: tierColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: tierColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report.tier.label.split("(").first.trim(),
                      style: AppTypography.bodySmall.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Bio-Age: ${report.biologicalAge.toStringAsFixed(1)}y',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Longevity Score',
                value: report.compositeScore.toInt().toString(),
                unit: '/100',
                accentColor: tierColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projected Healthspan',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${report.projectedHealthspanAge.toStringAsFixed(1)} yrs',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($bonusSign${report.healthspanBonusYears.toStringAsFixed(1)}y)',
                        style: AppTypography.bodySmall.copyWith(
                          color: report.healthspanBonusYears >= 0
                              ? AppColors.karmaGreen
                              : AppColors.alertRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Chrono: ${report.chronologicalAge.toInt()} yrs',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.tier.regionalLabel,
            style: AppTypography.bodySmall.copyWith(
              color: tierColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(
              height: AppSpacing.lg, color: AppColors.surfaceElevated),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined,
                  color: AppColors.karmaGreen, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Top Pillar: ${report.primaryLongevityAsset}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.tune, color: AppColors.energyOrange, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Target Focus: ${report.primaryVulnerability}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthspanBonusBanner(LongevityReport report, Color tierColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: tierColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.hourglass_top, color: tierColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Healthspan Potential: ${report.tier.projectedHealthspanBonus}',
                  style: AppTypography.titleSmall.copyWith(
                    color: tierColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.tier.regionalProjectedHealthspanBonus,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard(LongevityPillarScore pillar) {
    final isHigh = pillar.score >= 80;
    final pillarColor = isHigh
        ? AppColors.karmaGreen
        : (pillar.score >= 60 ? AppColors.focusBlue : AppColors.energyOrange);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getPillarIcon(pillar.pillar.iconName),
                      color: AppColors.focusBlue, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    pillar.pillar.name,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: pillarColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${pillar.score.toInt()}/100',
                  style: AppTypography.bodySmall.copyWith(
                    color: pillarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            pillar.pillar.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: (pillar.score / 100.0).clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(pillarColor),
            minHeight: 4,
            borderRadius: AppRadii.radiusSm,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            pillar.primaryStrength,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '• Opportunity: ${pillar.optimizationOpportunity}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceleratorCard(LongevityAccelerator accel) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  accel.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '+${accel.projectedHealthspanYearsGained.toStringAsFixed(1)} Yrs Healthspan',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            accel.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            accel.scientificRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            accel.regionalScientificRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Ease: ${accel.implementationEase}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: AppColors.gold, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '+${accel.karmaReward} Karma',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPillarIcon(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite;
      case 'bolt':
        return Icons.bolt;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.spa;
    }
  }

  void _showLongevityMethodologyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Longevity Score & Healthspan Methodology',
                regionalText: 'दीर्घायु सूचकांक व स्वास्थ्य सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'The FitKarma Longevity Score (0-100) measures multi-system physiological resilience across 6 evidence-based longevity pillars, forecasting disease-free healthspan and centenarian trajectory.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Calibrated for South Asian phenotypes, the engine evaluates arterial elasticity, metabolic reserve (WHtR, HbA1c), mitochondrial VO2 Max, and slow-wave cellular repair.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understand & Close',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
