import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/life_event_models.dart';
import 'providers/life_event_provider.dart';

/// Screen displaying Life Events Engine, Routine Transition Adaptation,
/// Grace Streak Freezes, and Supportive Holistic Recalibration.
class LifeEventScreen extends ConsumerWidget {
  const LifeEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(lifeEventProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Life Events & Transitions',
          regionalText: 'जीवन परिवर्तन एवं अनुकूलन',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Life Event Category Horizontal Selector
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: LifeEventCategory.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = LifeEventCategory.values[index];
                  final isSelected = report.activeEvent == cat;
                  return ChoiceChip(
                    label: Text(
                      cat.name.split('/').first.trim(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.focusBlue,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (_) => ref.read(lifeEventProvider.notifier).selectLifeEvent(cat),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Life Event Adaptive Bento Card
            _buildHeroAdaptiveCard(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 3. Supportive Compassionate Coach Message
            _buildSupportiveCoachCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Days Elapsed Phase Progression Slider
            _buildTimelineProgressSlider(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 5. Dynamic Pillar Adjustments List
            const BilingualLabel(
              primaryText: 'Adaptive Pillar Recalibrations',
              regionalText: 'पुनर्गठित जीवनशैली लक्ष्य',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.pillarAdjustments.map((adj) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildAdjustmentCard(adj),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Ayurvedic Medhya Rasayana / Tonic
            _buildAyurvedicTonicCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroAdaptiveCard(
    BuildContext context,
    WidgetRef ref,
    LifeEventAdaptiveReport report,
  ) {
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
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, color: AppColors.karmaGreen, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Grace Streak Freeze Active',
                      style: TextStyle(
                        color: AppColors.karmaGreen,
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
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.activeEvent.name,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            report.activeEvent.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Step Target',
                value: '${report.stepGoalAdjustment}',
                unit: 'steps',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Movement Anchor',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${report.workoutDurationMinutes} Min Micro-Workout',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mode: ${report.nutritionMode}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
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

  Widget _buildSupportiveCoachCard(LifeEventAdaptiveReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_border, color: AppColors.karmaGreen, size: 18),
              SizedBox(width: 6),
              Text(
                'Compassionate Coaching Note',
                style: TextStyle(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.supportiveCoachMessage,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalSupportiveCoachMessage,
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

  Widget _buildTimelineProgressSlider(
    BuildContext context,
    WidgetRef ref,
    LifeEventAdaptiveReport report,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transition Timeline Progress',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Day ${report.daysElapsedInEvent} of 30',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.focusBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: report.daysElapsedInEvent.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            activeColor: AppColors.focusBlue,
            inactiveColor: AppColors.surfaceElevated,
            onChanged: (val) {
              ref.read(lifeEventProvider.notifier).updateDaysElapsed(val.toInt());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Acute (Days 1–7)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 9)),
              Text('Stabilization (Days 8–21)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 9)),
              Text('Re-entry (Days 22+)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentCard(LifeEventPillarAdjustment adj) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                adj.pillarTitle,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Text(
                  'Recalibrated',
                  style: TextStyle(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Target: ${adj.adaptedTarget}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.karmaGreen,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          Text(
            'Previous: ${adj.originalTarget}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            adj.rationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
              fontSize: 11,
            ),
          ),
          Text(
            adj.regionalRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyurvedicTonicCard(LifeEventAdaptiveReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.spa_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Ayurvedic Medhya Rasayana Support',
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
            report.ayurvedicNervineTonic,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalAyurvedicTonic,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showPhilosophyModal(BuildContext context) {
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
                primaryText: 'Life Events Resilience Philosophy',
                regionalText: 'जीवन परिवर्तन व स्वास्थ्य दर्शन',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Life is non-linear. Whether you are welcoming a newborn, preparing for competitive exams, or recovering from illness, FitKarma activates Grace Streak Freezes and automatically scales targets to keep your habit identity intact without cognitive burden.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
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
