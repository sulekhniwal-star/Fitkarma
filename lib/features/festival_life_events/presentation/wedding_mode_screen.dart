import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/wedding_mode_models.dart';
import 'providers/wedding_mode_provider.dart';

/// Screen displaying Wedding Transformation Mode,
/// Role-Based Aesthetic Periodization, Peak Week De-bloating, and Ojas Skin Radiance.
class WeddingModeScreen extends ConsumerWidget {
  const WeddingModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(weddingModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Wedding Transformation Mode',
          regionalText: 'विवाह कांति एवं शारीरिक तैयारी',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Role Selector Horizontal Carousel
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: WeddingRole.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final r = WeddingRole.values[index];
                  final isSelected = report.role == r;
                  return ChoiceChip(
                    label: Text(
                      r.name.split('(').first.trim(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.gold,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (_) =>
                        ref.read(weddingModeProvider.notifier).updateRole(r),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Wedding Countdown Bento Card
            _buildHeroCountdownCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Ayurvedic Ojas Skin Radiance Protocol Card
            _buildSkinRadianceCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Role-Specific Active Pillar Action Items
            const BilingualLabel(
              primaryText: 'Targeted Aesthetic & Posture Actions',
              regionalText: 'विशिष्ट शारीरिक गठन व मुद्रा रणनीतियां',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activePillarActions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPillarActionCard(action),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Peak Week De-Bloat & De-Puff Protocol
            _buildDeBloatCard(report),
            const SizedBox(height: AppSpacing.md),

            // 6. Sangeet Dance Stamina Card
            _buildSangeetCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCountdownCard(WeddingTransformationReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: AppColors.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report.role.name,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  report.currentPhase.name.split('(').first.trim(),
                  style: const TextStyle(
                    color: AppColors.focusBlue,
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
                label: 'Countdown',
                value: '${report.daysUntilWedding}',
                unit: 'Days',
                accentColor: AppColors.gold,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Milestone',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${report.targetWeightKg} kg (${report.targetBodyFatPercent}% BF)',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Focus: ${report.role.focus}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.karmaGreen,
                        fontSize: 10,
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

  Widget _buildSkinRadianceCard(WeddingTransformationReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Ojas & Rasa Dhatu Skin Glow Protocol',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.ojasSkinRadianceProtocol,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalOjasSkinRadianceProtocol,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarActionCard(WeddingPillarItem action) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                action.pillar,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Text(
                  'Priority Target',
                  style: TextStyle(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            action.actionTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.focusBlue,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          Text(
            action.regionalActionTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            action.detailedStrategy,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
              fontSize: 11,
            ),
          ),
          Text(
            action.regionalDetailedStrategy,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeBloatCard(WeddingTransformationReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_drop_outlined,
                  color: AppColors.focusBlue, size: 18),
              SizedBox(width: 6),
              Text(
                'De-Bloat & Anti-Puffiness Protocol',
                style: TextStyle(
                  color: AppColors.focusBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.peakWeekDeBloatTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalPeakWeekDeBloatTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSangeetCard(WeddingTransformationReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.music_note, color: AppColors.energyOrange, size: 18),
              SizedBox(width: 6),
              Text(
                'Sangeet Dance & Energy Conditioning',
                style: TextStyle(
                  color: AppColors.energyOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.sangeetStaminaRecommendation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
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
                primaryText: 'Wedding Transformation Protocol',
                regionalText: 'विवाह स्वास्थ्य व सौंदर्य विज्ञान',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Wedding Transformation Mode orchestrates countdown periodization (Foundation -> Sculpting -> Skin Radiance -> Peak Week). It emphasizes garment posture (Lehenga drape / Sherwani V-taper), Ojas skin nourishment, and safe anti-bloat strategies.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
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
