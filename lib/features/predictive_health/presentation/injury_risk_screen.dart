import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/injury_risk_models.dart';
import 'providers/injury_risk_provider.dart';

/// Screen displaying Injury Risk Prevention, ACWR Workload Dynamics,
/// Anatomical Joint Stress Analysis, and Prehab Protocols.
class InjuryRiskScreen extends ConsumerWidget {
  const InjuryRiskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(injuryRiskProvider);
    final tierColor = Color(report.overallRiskTier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Injury Risk & ACWR Engine',
          regionalText: 'चोट जोखिम व कार्यभार विश्लेषण प्रणाली',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showAcwrMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero ACWR & Composite Injury Risk Card
            _buildHeroAcwrCard(report, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Deload Warning Alert (if triggered)
            if (report.shouldDeload) ...[
              _buildDeloadAlertBanner(report),
              const SizedBox(height: AppSpacing.md),
            ],

            // 3. Clinical Workload Synthesis
            _buildWorkloadSummaryCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. 5-Joint Anatomical Risk Radar
            const BilingualLabel(
              primaryText: 'Anatomical Joint Stress Breakdown',
              regionalText: 'जोड़ों व मांसपेशियों का तनाव विश्लेषण',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.jointAssessments.map((joint) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildJointRiskCard(joint),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Corrective Prehab & Load Mitigation Protocols
            const BilingualLabel(
              primaryText: 'Prescribed Prehab & Mitigation Protocols',
              regionalText: 'चोट निवारण व मोबिलिटी व्यायाम',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeProtocols.map((protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildProtocolCard(protocol),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroAcwrCard(InjuryRiskReport report, Color tierColor) {
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
                    Icon(
                      report.overallRiskTier == InjuryRiskTier.optimal
                          ? Icons.shield_outlined
                          : Icons.warning_amber_rounded,
                      color: tierColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.overallRiskTier.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Risk Score: ${report.compositeRiskScore.toInt()}/100',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
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
                label: 'ACWR Ratio',
                value: '${report.acuteChronicWorkloadRatio.toStringAsFixed(2)}x',
                unit: 'ratio',
                accentColor: tierColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7-Day Acute Load',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.acuteLoad7Days.toInt()} AU (28d: ${report.chronicLoad28Days.toInt()} AU)',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fatigue Multiplier: ${report.recoveryDeficitMultiplier.toStringAsFixed(2)}x',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg, color: AppColors.surfaceElevated),
          Row(
            children: [
              Expanded(
                child: _buildAcwrZoneIndicator('Under (<0.8x)', report.acuteChronicWorkloadRatio < 0.85, AppColors.focusBlue),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildAcwrZoneIndicator('Sweet Spot (0.85-1.25x)', report.acuteChronicWorkloadRatio >= 0.85 && report.acuteChronicWorkloadRatio <= 1.25, AppColors.karmaGreen),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildAcwrZoneIndicator('Caution (1.25-1.45x)', report.acuteChronicWorkloadRatio > 1.25 && report.acuteChronicWorkloadRatio <= 1.45, AppColors.energyOrange),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildAcwrZoneIndicator('Spike (>1.45x)', report.acuteChronicWorkloadRatio > 1.45, AppColors.alertRed),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcwrZoneIndicator(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.25) : AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
        border: Border.all(
          color: isActive ? color : AppColors.surfaceElevated,
          width: 1,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTypography.bodySmall.copyWith(
          color: isActive ? color : AppColors.textSecondary,
          fontSize: 9,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDeloadAlertBanner(InjuryRiskReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.alertRed.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.alertRed, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: AppColors.alertRed, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deload Recommended (डीलोड आवश्यक)',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.alertRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Acute training workload has spiked rapidly. Reduce lifting tonnage by 30% and eliminate sets taken to failure over the next 5 days.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkloadSummaryCard(InjuryRiskReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.focusBlue, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Clinical Biomechanical Synthesis',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.clinicalWorkloadSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalClinicalWorkloadSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJointRiskCard(JointRiskAssessment joint) {
    final jointColor = Color(joint.tier.colorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getJointIcon(joint.area.iconName), color: AppColors.focusBlue, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    joint.area.name,
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
                  color: jointColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Risk: ${joint.riskScore.toInt()}/100 • ${joint.tier.label.split(" ").first}',
                  style: AppTypography.bodySmall.copyWith(
                    color: jointColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            joint.area.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '7d Tonnage: ${(joint.cumulativeLoadTonnage / 1000).toStringAsFixed(1)} tonnes',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• Soreness: ${joint.sorenessLevel}/10',
                style: AppTypography.bodySmall.copyWith(
                  color: joint.sorenessLevel > 4 ? AppColors.energyOrange : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            joint.primaryRiskFactor,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.health_and_safety, color: AppColors.karmaGreen, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Prehab: ${joint.recommendedPrehab}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(InjuryPreventionProtocol protocol) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  protocol.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      '+${protocol.karmaReward} Karma',
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
          const SizedBox(height: 2),
          Text(
            protocol.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            protocol.prescription,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.repeat, color: AppColors.focusBlue, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Dosage: ${protocol.targetSetsReps}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getJointIcon(String iconName) {
    switch (iconName) {
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'transfer_within_a_station':
        return Icons.transfer_within_a_station;
      default:
        return Icons.do_not_step;
    }
  }

  void _showAcwrMethodologyModal(BuildContext context) {
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
                primaryText: 'ACWR & Injury Biomechanics Methodology',
                regionalText: 'कार्यभार अनुपात व चोट निवारण सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'The Acute:Chronic Workload Ratio (ACWR) compares 7-day fatigue load against 28-day chronic fitness adaptation. Ratios between 0.85 and 1.25 minimize soft-tissue injury risk while maximizing strength progression.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Recovery suppression (elevated sleep debt, vagal HRV blunting, and movement breakdown) amplifies joint vulnerability and triggers proactive volume deload safeguards.',
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
