import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/body_analytics_models.dart';
import '../domain/wearable_free_composition_models.dart';
import 'providers/wearable_free_composition_provider.dart';

/// Screen displaying Wearable-Free & Sensor-Free Body Composition Estimation,
/// Multi-Model Ensemble Consensus, and Statistical Concordance.
class WearableFreeCompositionScreen extends ConsumerWidget {
  const WearableFreeCompositionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(wearableFreeCompositionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Wearable-Free Composition',
          regionalText: 'उपकरण-मुक्त शारीरिक संरचना अनुमान',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Ensemble Consensus Card
            _buildHeroEnsembleCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Multi-Compartment Breakdown
            _buildCompartmentDistributionCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Multi-Model Individual Estimates Breakdown
            const BilingualLabel(
              primaryText: 'Clinical Model Estimates & Weights',
              regionalText: 'नैदानिक मॉडल अनुमान एवं भार विभाजन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.individualEstimates.map((est) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildModelEstimateCard(est),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Clinical Interpretation & Statistical Agreement
            _buildInterpretationCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroEnsembleCard(WearableFreeCompositionReport report) {
    Color zoneColor;
    switch (report.zone) {
      case BodyCompositionZone.athleticLean:
      case BodyCompositionZone.fitHealthy:
        zoneColor = AppColors.karmaGreen;
        break;
      case BodyCompositionZone.elevatedAdiposity:
        zoneColor = AppColors.energyOrange;
        break;
      case BodyCompositionZone.sarcopenicRisk:
        zoneColor = AppColors.alertRed;
        break;
    }

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.focusBlue, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hub_outlined, color: AppColors.focusBlue, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '4-Model Ensemble Consensus',
                      style: TextStyle(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (report.southAsianSpecificCutoffsApplied)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.karmaGreen.withValues(alpha: 0.12),
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: const Text(
                    'ICMR / Asian Calibrated',
                    style: TextStyle(
                      color: AppColors.karmaGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
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
                label: 'Ensemble Body Fat',
                value: '${report.ensembleBodyFatPercent}%',
                accentColor: zoneColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Lean Mass',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.ensembleLeanMassKg} kg (±${report.modelVarianceStdDev} SD)',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${report.confidenceScorePercent.toInt()}% Model Concordance',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.karmaGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompartmentDistributionCard(WearableFreeCompositionReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synthesized Body Compartments',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.radiusSm,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (report.ensembleLeanMassKg * 10).toInt(),
                    child: Container(color: AppColors.focusBlue),
                  ),
                  Expanded(
                    flex: (report.ensembleFatMassKg * 10).toInt(),
                    child: Container(color: AppColors.energyOrange),
                  ),
                  Expanded(
                    flex: (report.ensembleBoneMassKg * 10).toInt(),
                    child: Container(color: AppColors.karmaGreen),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMassChip('Lean Mass', '${report.ensembleLeanMassKg} kg', AppColors.focusBlue),
              _buildMassChip('Fat Mass', '${report.ensembleFatMassKg} kg', AppColors.energyOrange),
              _buildMassChip('Bone Mass', '${report.ensembleBoneMassKg} kg', AppColors.karmaGreen),
              _buildMassChip('Hydration', '${report.ensembleTotalBodyWaterPercent}%', AppColors.focusBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMassChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildModelEstimateCard(SingleModelEstimate est) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  est.model.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Weight: ${(est.modelWeighting * 100).toInt()}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Text(
            est.model.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Estimated BF: ${est.estimatedBodyFatPercent}%',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Lean: ${est.estimatedLeanMassKg} kg',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Fat: ${est.estimatedFatMassKg} kg',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.energyOrange,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            est.model.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationCard(WearableFreeCompositionReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: AppColors.karmaGreen, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Ensemble Concordance & Interpretation',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.clinicalInterpretation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalInterpretation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showMethodologyModal(BuildContext context) {
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
                primaryText: 'Wearable-Free Composition Method',
                regionalText: 'सेंसर-मुक्त शारीरिक संरचना पद्धति',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma eliminates dependency on expensive smart scales or bioelectrical impedance (BIA) hardware by combining 4 clinically validated equations (US Navy, YMCA, Deurenberg, Gallagher) into a weighted consensus model.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Adjusted with ICMR South Asian metabolic calibrations to account for visceral adiposity and lean mass density without requiring cloud computation.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
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
