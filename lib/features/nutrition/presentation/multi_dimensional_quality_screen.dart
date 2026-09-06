import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/multi_dimensional_quality_engine.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class MultiDimensionalQualityScreen extends ConsumerStatefulWidget {
  final MealPhase initialPhase;

  const MultiDimensionalQualityScreen({
    super.key,
    this.initialPhase = MealPhase.lunch,
  });

  @override
  ConsumerState<MultiDimensionalQualityScreen> createState() => _MultiDimensionalQualityScreenState();
}

class _MultiDimensionalQualityScreenState extends ConsumerState<MultiDimensionalQualityScreen> {
  late MealPhase _selectedPhase;

  @override
  void initState() {
    super.initState();
    _selectedPhase = widget.initialPhase;
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = ref.watch(nutritionProvider);
    final meals = nutrition.getMealsForPhase(_selectedPhase);
    final report = MultiDimensionalQualityEngine.evaluateMealQuality(entries: meals);

    final Color tierColor = Color(report.tier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Meal Quality Score',
          regionalText: 'बहु-आयामी भोजन गुणवत्ता सूचकांक',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phase Selector Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: MealPhase.values.map((phase) {
                    final isSelected = phase == _selectedPhase;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(phase.name.split('/')[0].trim()),
                        selected: isSelected,
                        selectedColor: AppColors.karmaGreen.withValues(alpha: 0.2),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.karmaGreen : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.karmaGreen : AppColors.glassBorder,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedPhase = phase);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 1. Hero Composite Quality Score Card
              BentoCard(
                hasGlow: true,
                glowColor: tierColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: '${_selectedPhase.name.split('/')[0].trim()} Quality Index',
                          regionalText: report.tier.regionalLabel,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                report.tier.grade,
                                style: TextStyle(color: tierColor, fontSize: 14, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '• ${report.tier.label.split('/')[0].trim()}',
                                style: TextStyle(color: tierColor, fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Quality Score',
                          value: '${report.compositeScore}',
                          unit: '/ 100',
                          isHero: true,
                          accentColor: tierColor,
                        ),
                        GlowingMetric(
                          label: 'Items Logged',
                          value: '${meals.length}',
                          unit: 'dishes',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Total Energy',
                          value: '${meals.fold<int>(0, (s, m) => s + m.totalCalories)}',
                          unit: 'kcal',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.executiveSummary,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. 5-Dimensional Breakdown Cards
              const Text(
                '5 QUALITY PILLARS (5 पोषण आधार स्तंभ)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.dimensions.map((dim) {
                final double scoreFrac = (dim.score / 100.0).clamp(0.0, 1.0);
                final Color dimColor = dim.score >= 80
                    ? AppColors.karmaGreen
                    : (dim.score >= 60 ? AppColors.focusBlue : (dim.score >= 40 ? AppColors.gold : AppColors.alertRed));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
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
                                  Row(
                                    children: [
                                      Text(
                                        dim.name,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: const BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: AppRadii.radiusSm,
                                        ),
                                        child: Text(
                                          '${(dim.weight * 100).toInt()}% wt',
                                          style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    dim.regionalName,
                                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${dim.score.round()}/100',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: dimColor),
                                ),
                                Text(
                                  dim.status,
                                  style: TextStyle(fontSize: 10, color: dimColor, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: scoreFrac,
                            backgroundColor: AppColors.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(dimColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dim.insight,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                dim.actionableOptimization,
                                style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),

              // 3. Indian Food Synergy & Ayurvedic Guidance Card
              BentoCard(
                backgroundColor: AppColors.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.spa_rounded, color: AppColors.karmaGreen, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayurvedic Shad-Rasa Synergy',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            report.ayurvedicSynergyNote,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
