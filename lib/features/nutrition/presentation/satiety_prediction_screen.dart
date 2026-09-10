import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/nutrition_models.dart';
import '../domain/satiety_prediction_engine.dart';
import '../providers/nutrition_provider.dart';

class SatietyPredictionScreen extends ConsumerStatefulWidget {
  final MealPhase initialPhase;

  const SatietyPredictionScreen({
    super.key,
    this.initialPhase = MealPhase.lunch,
  });

  @override
  ConsumerState<SatietyPredictionScreen> createState() =>
      _SatietyPredictionScreenState();
}

class _SatietyPredictionScreenState
    extends ConsumerState<SatietyPredictionScreen> {
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
    final report = SatietyPredictionEngine.predictMealSatiety(entries: meals);

    final Color gradeColor = Color(report.grade.colorCode);
    final timeFormatter = DateFormat('h:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Satiety & Hunger Predictor',
          regionalText: 'तृप्ति एवं भूख पूर्वानुमान इंजन',
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
                        selectedColor:
                            AppColors.karmaGreen.withValues(alpha: 0.2),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.glassBorder,
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

              // 1. Hero Fullness Duration & Horizon Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: gradeColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Predicted Satiety Duration',
                          regionalText: report.grade.regionalLabel,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: gradeColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: gradeColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            report.grade.grade,
                            style: TextStyle(
                              color: gradeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Fullness Window',
                          value: '${report.predictedFullnessHours}',
                          unit: 'hours',
                          isHero: true,
                          accentColor: gradeColor,
                        ),
                        GlowingMetric(
                          label: 'Next Hunger',
                          value: timeFormatter.format(report.nextHungerHorizon),
                          unit: 'Horizon',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Satiety Score',
                          value: '${report.satietyScore}',
                          unit: '/ 100',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.biologicalMechanismSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Satiety Hormone Vectors
              const Text(
                'SATIETY PHYSIOLOGY VECTORS (तृप्ति हार्मोन कारक)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  children: [
                    _buildVectorRow(
                      title: 'Protein (PYY & CCK Trigger)',
                      regionalTitle: 'प्रोटीन तृप्ति कारक (३५% प्रभाव)',
                      score: report.proteinFullnessWeight,
                      accentColor: AppColors.energyOrange,
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    _buildVectorRow(
                      title: 'Dietary Fiber & Viscosity',
                      regionalTitle: 'फाइबर एवं पाचन मंदता (३०% प्रभाव)',
                      score: report.fiberFullnessWeight,
                      accentColor: AppColors.karmaGreen,
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    _buildVectorRow(
                      title: 'Volume & Water Matrix',
                      regionalTitle: 'भोजन आयतन व जल सामग्री (२०% प्रभाव)',
                      score: report.volumeWeight,
                      accentColor: AppColors.focusBlue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Personalized Satiety Boosters
              const Text(
                'ACTIONABLE SATIETY BOOSTERS (तृप्ति वर्धक सुझाव)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.personalizedBoosters.map((booster) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: AppColors.gold, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      booster.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (booster.addedSatietyMinutes > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: AppRadii.radiusSm,
                                      ),
                                      child: Text(
                                        '+${booster.addedSatietyMinutes}m • +${booster.addedCalories} kcal',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.karmaGreen,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                booster.regionalTitle,
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booster.physiologicalMechanism,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVectorRow({
    required String title,
    required String regionalTitle,
    required double score,
    required Color accentColor,
  }) {
    final double scoreFrac = (score / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.textPrimary)),
                Text(regionalTitle,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
            Text('${score.round()}%',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: accentColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: scoreFrac,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
