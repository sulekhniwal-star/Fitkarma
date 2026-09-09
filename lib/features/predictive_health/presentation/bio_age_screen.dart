import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/bio_age_models.dart';
import 'providers/bio_age_provider.dart';

/// Screen displaying Monthly Deterministic Biological Age Estimation,
/// Organ System Breakdown, Longitudinal 12-Month Trajectory, and Rejuvenation Levers.
class BiologicalAgeScreen extends ConsumerWidget {
  const BiologicalAgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(biologicalAgeProvider);
    final paceColor = Color(report.paceStatus.colorCode);
    final isYounger = report.ageDelta <= 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Biological Age & Longevity',
          regionalText: 'जैविक आयु व दीर्घायु विश्लेषण',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhenoAgeMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Biological Age vs Chronological Age Card
            _buildHeroBioAgeCard(report, paceColor, isYounger),
            const SizedBox(height: AppSpacing.md),

            // 2. Pace of Aging Velocity Banner
            _buildPaceVelocityBanner(report, paceColor),
            const SizedBox(height: AppSpacing.md),

            // 3. 4-Subsystem Organ Age Breakdown
            const BilingualLabel(
              primaryText: 'Organ System Biological Ages',
              regionalText: 'शारीरिक तंत्रों की जैविक आयु',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildOrganSystemGrid(report),
            const SizedBox(height: AppSpacing.md),

            // 4. 12-Month Trajectory Timeline
            const BilingualLabel(
              primaryText: '12-Month Longevity Trajectory',
              regionalText: '१२-मासिक जैविक आयु सुधार रेखा',
            ),
            const SizedBox(height: AppSpacing.sm),
            _build12MonthTrajectoryCard(report),
            const SizedBox(height: AppSpacing.md),

            // 5. Biomarker Contribution Breakdown
            const BilingualLabel(
              primaryText: 'Biomarker Age Impact Analysis',
              regionalText: 'बायोमार्कर्स का आयु पर प्रभाव',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.biomarkerContributions.map((biomarker) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildBiomarkerRow(biomarker),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Actionable Rejuvenation Levers
            const BilingualLabel(
              primaryText: 'Prescriptive Rejuvenation Levers',
              regionalText: 'आयु घटाने के सक्रिय वैज्ञानिक उपाय',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.topRejuvenationLevers.map((lever) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildRejuvenationLeverCard(lever),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBioAgeCard(
    BiologicalAgeReport report,
    Color paceColor,
    bool isYounger,
  ) {
    final deltaSign = report.ageDelta > 0 ? '+' : '';
    final deltaText = '${report.ageDelta.abs().toStringAsFixed(1)} Yrs ${isYounger ? 'Younger' : 'Older'}';
    final deltaRegionalText = '${report.ageDelta.abs().toStringAsFixed(1)} वर्ष ${isYounger ? 'युवा' : 'अधिक'}';

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
                  color: isYounger
                      ? AppColors.karmaGreen.withValues(alpha: 0.15)
                      : AppColors.alertRed.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(
                    color: isYounger ? AppColors.karmaGreen : AppColors.alertRed,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isYounger ? Icons.auto_awesome : Icons.trending_up,
                      color: isYounger ? AppColors.karmaGreen : AppColors.alertRed,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$deltaSign${report.ageDelta.toStringAsFixed(1)} Yrs ($deltaText)',
                      style: AppTypography.bodySmall.copyWith(
                        color: isYounger ? AppColors.karmaGreen : AppColors.alertRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Calculated Monthly',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
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
                label: 'Biological Age',
                value: report.biologicalAge.toStringAsFixed(1),
                unit: 'years',
                accentColor: isYounger ? AppColors.karmaGreen : AppColors.energyOrange,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chronological Age',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.chronologicalAge.toStringAsFixed(1)} yrs',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Biological Age ($deltaRegionalText)',
            style: AppTypography.bodyMedium.copyWith(
              color: isYounger ? AppColors.karmaGreen : AppColors.energyOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: AppSpacing.lg, color: AppColors.surfaceElevated),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, color: AppColors.karmaGreen, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Top Asset: ${report.topRejuvenatingAsset}',
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
              const Icon(Icons.speed, color: AppColors.energyOrange, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Primary Driver: ${report.primaryAgingDriver}',
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

  Widget _buildPaceVelocityBanner(BiologicalAgeReport report, Color paceColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: paceColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: paceColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              report.paceStatus == AgingPaceStatus.rejuvenating
                  ? Icons.hourglass_bottom
                  : Icons.timer,
              color: paceColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pace of Aging: ${report.agingPace.toStringAsFixed(2)}x',
                      style: AppTypography.titleSmall.copyWith(
                        color: paceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      report.paceStatus.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: paceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  report.paceStatus.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.paceStatus.regionalDescription,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
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

  Widget _buildOrganSystemGrid(BiologicalAgeReport report) {
    return Column(
      children: report.systemAges.map((sys) {
        final isSubYounger = sys.ageDelta <= 0;
        final sysColor = isSubYounger ? AppColors.karmaGreen : AppColors.energyOrange;
        final sign = sys.ageDelta > 0 ? '+' : '';

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getIconDataForSystem(sys.system),
                          color: AppColors.focusBlue,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          sys.system.name,
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: sysColor.withValues(alpha: 0.15),
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        '$sign${sys.ageDelta.toStringAsFixed(1)} yrs (${sys.estimatedAge.toStringAsFixed(1)}y)',
                        style: AppTypography.bodySmall.copyWith(
                          color: sysColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  sys.system.regionalName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: (sys.performanceScore / 100.0).clamp(0.0, 1.0),
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(sysColor),
                  minHeight: 4,
                  borderRadius: AppRadii.radiusSm,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  sys.keyBiomarkerSummary,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _build12MonthTrajectoryCard(BiologicalAgeReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1-Year Biological Age Evolution',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.show_chart, color: AppColors.karmaGreen, size: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: report.trajectory12Months.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final snap = report.trajectory12Months[index];
                final delta = snap.biologicalAge - snap.chronologicalAge;
                final isSnapYounger = delta <= 0;

                return Container(
                  width: 78,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: index == report.trajectory12Months.length - 1
                        ? AppColors.surfaceElevated
                        : AppColors.background,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: index == report.trajectory12Months.length - 1
                          ? AppColors.karmaGreen.withValues(alpha: 0.6)
                          : AppColors.surfaceElevated,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snap.monthLabel,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${snap.biologicalAge.toStringAsFixed(1)}y',
                        style: AppTypography.titleSmall.copyWith(
                          color: isSnapYounger ? AppColors.karmaGreen : AppColors.energyOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${delta > 0 ? "+" : ""}${delta.toStringAsFixed(1)}y',
                        style: AppTypography.bodySmall.copyWith(
                          color: isSnapYounger ? AppColors.karmaGreen : AppColors.energyOrange,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomarkerRow(BiomarkerAgeContribution biomarker) {
    Color impactColor;
    IconData impactIcon;

    switch (biomarker.impactType) {
      case BiomarkerImpactType.rejuvenating:
        impactColor = AppColors.karmaGreen;
        impactIcon = Icons.arrow_downward;
        break;
      case BiomarkerImpactType.neutral:
        impactColor = AppColors.focusBlue;
        impactIcon = Icons.remove;
        break;
      case BiomarkerImpactType.accelerating:
        impactColor = AppColors.alertRed;
        impactIcon = Icons.arrow_upward;
        break;
    }

    final sign = biomarker.yearsImpact > 0 ? '+' : '';

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biomarker.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      biomarker.regionalName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: impactColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: impactColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(impactIcon, color: impactColor, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '$sign${biomarker.yearsImpact.toStringAsFixed(1)} yrs',
                      style: AppTypography.bodySmall.copyWith(
                        color: impactColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Measured: ${biomarker.measuredValue.toStringAsFixed(1)} ${biomarker.unit}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• Optimal: ${biomarker.optimalReference.toStringAsFixed(1)} ${biomarker.unit}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            biomarker.clinicalRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            biomarker.regionalClinicalRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejuvenationLeverCard(RejuvenationLever lever) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lever.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '-${lever.potentialYearsSaved.toStringAsFixed(1)} Yrs',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            lever.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            lever.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            lever.regionalDescription,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildLeverBadge(Icons.timer, lever.timeframe, AppColors.focusBlue),
              const SizedBox(width: AppSpacing.xs),
              _buildLeverBadge(Icons.fitness_center, lever.difficulty, AppColors.energyOrange),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: AppColors.gold, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '+${lever.karmaReward} Karma',
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

  Widget _buildLeverBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconDataForSystem(OrganSystemType system) {
    switch (system) {
      case OrganSystemType.cardiovascular:
        return Icons.favorite;
      case OrganSystemType.metabolic:
        return Icons.bolt;
      case OrganSystemType.musculoskeletal:
        return Icons.fitness_center;
      case OrganSystemType.cellularRecovery:
        return Icons.nights_stay;
    }
  }

  void _showPhenoAgeMethodologyModal(BuildContext context) {
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
                primaryText: 'Biological Age Methodology',
                regionalText: 'जैविक आयु गणना पद्धति व सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma estimates biological aging velocity using principles from Klemera-Doubal & PhenoAge multi-system biomarker regression, adapted for South Asian metabolic phenotypes.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Key evaluated domains include resting hemodynamics (RHR, BP, HRV), central adiposity (WHtR), glycemic regulation (HbA1c), mitochondrial capacity (VO2 Max), and neuro-circadian slow-wave sleep architecture.',
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
                  child: const Text('Understand & Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
