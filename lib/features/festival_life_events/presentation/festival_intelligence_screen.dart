import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/festival_intelligence_models.dart';
import 'providers/festival_intelligence_provider.dart';

/// Screen displaying Pan-Indian Festival Adaptation,
/// Multi-Pillar Strategies (Workouts, Feasting, Agni, Sleep), and 3-Day Reset Roadmap.
class FestivalIntelligenceScreen extends ConsumerWidget {
  const FestivalIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(festivalIntelligenceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Festival Intelligence System',
          regionalText: 'त्योहार व व्रत जीवनशैली अनुकूलन',
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
            // 1. Horizontal Festival Selector
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: IndianFestival.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = IndianFestival.values[index];
                  final isSelected = plan.activeFestival == f;
                  return ChoiceChip(
                    label: Text(
                      f.name.split('(').first.trim(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.energyOrange,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (_) => ref.read(festivalIntelligenceProvider.notifier).selectFestival(f),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Festival Mode Bento Card
            _buildHeroFestivalCard(context, ref, plan),
            const SizedBox(height: AppSpacing.md),

            // 3. Mindful Feasting Tip Card
            _buildFeastingTipCard(plan),
            const SizedBox(height: AppSpacing.md),

            // 4. Multi-Pillar Adaptation Strategies
            const BilingualLabel(
              primaryText: 'Multi-Pillar Festival Adaptation Protocols',
              regionalText: 'त्योहारी समग्र जीवनशैली रणनीतियां',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...plan.pillarStrategies.map((strat) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildStrategyCard(strat),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. 3-Day Post-Festival Metabolic Reset Roadmap
            const BilingualLabel(
              primaryText: '3-Day Post-Festival Metabolic Reset',
              regionalText: 'उत्सव उपरांत ३-दिवसीय पाचन संतुलन व डिटॉक्स',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildResetRoadmapCard(plan.postFestivalResetProtocol),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroFestivalCard(
    BuildContext context,
    WidgetRef ref,
    FestivalIntelligencePlan plan,
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
                  color: AppColors.energyOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.energyOrange, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.celebration, color: AppColors.energyOrange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      plan.activeFestival.season,
                      style: const TextStyle(
                        color: AppColors.energyOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Festival Mode',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: plan.isFestivalModeActive,
                    activeThumbColor: AppColors.energyOrange,
                    onChanged: (val) {
                      ref.read(festivalIntelligenceProvider.notifier).toggleFestivalMode(val);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            plan.activeFestival.name,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            plan.activeFestival.regionalName,
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
                label: 'Calorie Target',
                value: plan.calorieDeltaTarget > 0 ? '+${plan.calorieDeltaTarget}' : '${plan.calorieDeltaTarget}',
                unit: 'kcal',
                accentColor: plan.calorieDeltaTarget >= 0 ? AppColors.karmaGreen : AppColors.focusBlue,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Coach Persona',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      plan.aiCoachToneOverride,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Focus: ${plan.activeFestival.primaryFocus}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
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

  Widget _buildFeastingTipCard(FestivalIntelligencePlan plan) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Mindful Festive Savoring Tip',
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
            plan.mindfulFeastingTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            plan.regionalMindfulFeastingTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard(PillarAdaptationStrategy strat) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strat.pillarName,
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
                child: Text(
                  strat.regionalPillarName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            strat.headlineAction,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.energyOrange,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            strat.detailedProtocol,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            strat.regionalDetailedProtocol,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              strat.keyMetricAdjustment,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.karmaGreen,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetRoadmapCard(List<ResetProtocolDay> days) {
    return BentoCard(
      child: Column(
        children: days.map((day) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.focusBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.dayNumber}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${day.dayNumber}: ${day.focusTheme}',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '🥗 Diet: ${day.dietaryProtocol}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '🏃 Workout: ${day.workoutProtocol}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '🌿 Ayurvedic: ${day.ayurvedicDigestiveRemedy}',
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
          );
        }).toList(),
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
                primaryText: 'Festival Intelligence Protocol',
                regionalText: 'त्योहार स्वास्थ्य अनुकूलन प्रणाली',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma honors the rich cultural heritage of Indian festivals with an intelligent, multi-pillar adaptation framework. Rather than forcing rigid restrictions, it dynamically recalibrates calorie buffers, micro-workouts, digestive Agni protection, and 3-day post-festival resets.',
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
