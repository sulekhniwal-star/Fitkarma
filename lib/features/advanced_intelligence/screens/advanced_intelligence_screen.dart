import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/womens_health_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/advanced_intelligence_provider.dart';

class AdvancedIntelligenceScreen extends ConsumerWidget {
  const AdvancedIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(advancedIntelligenceProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Advanced Health OS Intelligence', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adaptive TDEE Metabolism Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adaptive TDEE Metabolism Engine', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${state.tdeeResult.dynamicTdee.round()} kcal / day',
                      style: AppTypography.displayLarge.copyWith(color: AppColors.primaryEmerald),
                    ),
                    Text(state.tdeeResult.metabolicAdaptationState, style: AppTypography.labelSmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Environmental Health AQI Warning Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Environmental Health Layer', style: AppTypography.titleMedium),
                        Chip(
                          backgroundColor: AppColors.warningAmber.withValues(alpha: 0.2),
                          side: const BorderSide(color: AppColors.warningAmber),
                          label: Text('AQI: ${state.envResult.aqi}', style: AppTypography.labelSmall.copyWith(color: AppColors.warningAmber)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(state.envResult.workoutRecommendation, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Longevity Score Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Longevity Score (0–100)', style: AppTypography.titleMedium),
                        Text(state.longevityResult.primaryDriver, style: AppTypography.labelSmall),
                      ],
                    ),
                    Text(
                      '${state.longevityResult.longevityScore}',
                      style: AppTypography.displayLarge.copyWith(color: AppColors.primaryCyan),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Women's Advanced Health Cycle Selector
              Text('Women\'s Advanced Health Layer', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menstrual Cycle Phase Adaptation', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: MenstrualPhase.values.map((phase) {
                        final isSelected = state.womensPrescription.phase == phase;
                        return ChoiceChip(
                          label: Text(phase.name.toUpperCase()),
                          selected: isSelected,
                          selectedColor: AppColors.primaryViolet,
                          backgroundColor: AppColors.bgSecondary,
                          onSelected: (_) => ref.read(advancedIntelligenceProvider.notifier).updateCyclePhase(phase),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Strength Multiplier: ${(state.womensPrescription.strengthTargetMultiplier * 100).round()}%', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan)),
                    Text(state.womensPrescription.nutritionAdvice, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
