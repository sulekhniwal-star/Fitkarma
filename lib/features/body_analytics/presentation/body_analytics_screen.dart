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
import 'providers/body_analytics_provider.dart';

/// Screen displaying Visual Body Composition Analytics,
/// Anthropometric Circumferences, Bilateral Symmetry, and Ayurvedic 7 Dhatu Matrix.
class BodyAnalyticsScreen extends ConsumerWidget {
  const BodyAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(bodyAnalyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Body Analytics & Composition',
          regionalText: 'शारीरिक गठन एवं धातु विश्लेषण',
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
            // 1. Hero Body Composition Bento Card
            _buildHeroCompositionCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Mass Distribution & Visceral Index
            _buildMassBreakdownCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Anthropometric Circumferences Grid
            const BilingualLabel(
              primaryText: 'Anthropometric Circumferences (cm)',
              regionalText: 'शारीरिक माप एवं घेरा (सेमी)',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildCircumferencesGrid(report.circumferences),
            const SizedBox(height: AppSpacing.md),

            // 4. Cardiometabolic Ratios & Bilateral Symmetry
            _buildRatiosAndSymmetryCard(report),
            const SizedBox(height: AppSpacing.md),

            // 5. Ayurvedic 7 Dhatu Tissue Quality Matrix
            const BilingualLabel(
              primaryText: 'Ayurvedic 7 Dhatu Health Matrix',
              regionalText: 'सप्त धातु पोषण एवं संतुलन',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildDhatuMatrixCard(report.dhatuProfile),
            const SizedBox(height: AppSpacing.md),

            // 6. Actionable Body Guidance
            _buildGuidanceCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCompositionCard(BodyAnalyticsReport report) {
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
                  color: zoneColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: zoneColor, width: 1),
                ),
                child: Text(
                  report.zone.name,
                  style: TextStyle(
                    color: zoneColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                '${report.weightKg} kg • ${report.heightCm.toInt()} cm',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
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
                label: 'Body Fat',
                value: '${report.bodyFatPercent}%',
                accentColor: zoneColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lean Muscle Mass',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.leanMuscleMassKg} kg (${((report.leanMuscleMassKg / report.weightKg) * 100).toStringAsFixed(1)}%)',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Metabolic Age: ${report.metabolicAge} yrs (BMR: ${report.basalMetabolicRateKcal.toInt()} kcal)',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.focusBlue,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.zone.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMassBreakdownCard(BodyAnalyticsReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Compartment Distribution',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Multi-segmented compartment bar
          ClipRRect(
            borderRadius: AppRadii.radiusSm,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (report.leanMuscleMassKg * 10).toInt(),
                    child: Container(color: AppColors.focusBlue),
                  ),
                  Expanded(
                    flex: (report.fatMassKg * 10).toInt(),
                    child: Container(color: AppColors.energyOrange),
                  ),
                  Expanded(
                    flex: (report.boneMassKg * 10).toInt(),
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
              _buildMassChip('Lean Muscle', '${report.leanMuscleMassKg} kg', AppColors.focusBlue),
              _buildMassChip('Fat Mass', '${report.fatMassKg} kg', AppColors.energyOrange),
              _buildMassChip('Bone Mass', '${report.boneMassKg} kg', AppColors.karmaGreen),
              _buildMassChip('Hydration', '${report.totalBodyWaterPercent}%', AppColors.focusBlue),
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
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCircumferencesGrid(BodyCircumferences c) {
    return BentoCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildCircumferenceTile('Neck', '${c.neckCm} cm', Icons.person_outline)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildCircumferenceTile('Chest', '${c.chestCm} cm', Icons.accessibility_new)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(child: _buildCircumferenceTile('Waist (Navel)', '${c.waistCm} cm', Icons.straighten)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildCircumferenceTile('Hips', '${c.hipsCm} cm', Icons.line_weight)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(child: _buildCircumferenceTile('Biceps (L / R)', '${c.bicepLeftCm} / ${c.bicepRightCm} cm', Icons.fitness_center)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildCircumferenceTile('Thighs (L / R)', '${c.thighLeftCm} / ${c.thighRightCm} cm', Icons.directions_walk)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircumferenceTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.focusBlue, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
                ),
                Text(
                  value,
                  style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatiosAndSymmetryCard(BodyAnalyticsReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cardiometabolic & Symmetry Indices',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Symmetry: ${report.symmetryIndexScore}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Waist-to-Height (WHtR)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  Text('${report.waistToHeightRatio} (Target < 0.50)', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Waist-to-Hip (WHR)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  Text('${report.waistToHipRatio} (Target < 0.90)', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visceral Fat Index', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  Text('${report.visceralFatIndex} (Optimal 1-9)', style: AppTypography.titleSmall.copyWith(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDhatuMatrixCard(AyurvedicDhatuProfile dhatu) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7 Dhatu Tissue Quality Scores',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ojas Reserve: ${dhatu.shukraQualityScore.toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDhatuBar('Rasa (रस - Hydration & Lymph)', dhatu.rasaQualityScore),
          _buildDhatuBar('Rakta (रक्त - Vitality & Hemoglobin)', dhatu.raktaQualityScore),
          _buildDhatuBar('Mamsa (मांस - Muscle Density)', dhatu.mamsaQualityScore),
          _buildDhatuBar('Meda (मेद - Lipid Balance)', dhatu.medaQualityScore),
          _buildDhatuBar('Asthi (अस्थि - Bone Matrix)', dhatu.asthiQualityScore),
          _buildDhatuBar('Majja (मज्जा - Neuromuscular Tone)', dhatu.majjaQualityScore),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dhatu.dominantDhatuObservation,
            style: AppTypography.bodySmall.copyWith(color: AppColors.karmaGreen, fontSize: 11),
          ),
          Text(
            dhatu.regionalDhatuObservation,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDhatuBar(String name, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              Text('${score.toInt()}%', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: AppRadii.radiusSm,
            child: LinearProgressIndicator(
              value: (score / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.focusBlue),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceCard(BodyAnalyticsReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: AppColors.focusBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Personalized Body Recomposition Guidance',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.actionableBodyRecommendation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalBodyRecommendation,
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
                primaryText: 'Body Composition Analytics',
                regionalText: 'शारीरिक गठन विश्लेषण पद्धति',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma utilizes validated US Navy Anthropometric equations, waist-to-height ratio (WHtR), and bilateral circumference tracking to compute fat mass, lean mass, visceral index, and Ayurvedic 7 Dhatu tissue nourishment without requiring expensive DEXA hardware.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
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
