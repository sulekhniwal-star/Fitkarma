import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/glycemic_response_engine.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class GlycemicResponseScreen extends ConsumerStatefulWidget {
  final MealPhase phase;

  const GlycemicResponseScreen({
    super.key,
    this.phase = MealPhase.lunch,
  });

  @override
  ConsumerState<GlycemicResponseScreen> createState() => _GlycemicResponseScreenState();
}

class _GlycemicResponseScreenState extends ConsumerState<GlycemicResponseScreen> {
  bool _isSaladFirst = false;
  bool _isWalkPlanned = true;

  @override
  Widget build(BuildContext context) {
    final nutrition = ref.watch(nutritionProvider);
    final meals = nutrition.getMealsForPhase(widget.phase);

    final report = GlycemicResponseEngine.evaluateMealGlycemicResponse(
      entries: meals,
      isSaladEatenFirst: _isSaladFirst,
      isPostMealWalkPlanned: _isWalkPlanned,
    );

    final Color tierColor = Color(report.riskTier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BilingualLabel(
          primaryText: '${widget.phase.name} Glycemic Spike Simulator',
          regionalText: '${widget.phase.regionalName} ग्लाइसेमिक प्रभाव',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Personal Food Score & Glycemic Load Card
              BentoCard(
                hasGlow: true,
                glowColor: tierColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Personal Food Score',
                          regionalText: 'व्यक्तिगत भोजन ग्लाइसेमिक स्कोर',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            report.riskTier.label.split('/')[0].trim().toUpperCase(),
                            style: TextStyle(color: tierColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Food Score',
                          value: '${report.personalFoodScore}',
                          unit: '/ 10',
                          isHero: true,
                          accentColor: tierColor,
                        ),
                        GlowingMetric(
                          label: 'Effective GL',
                          value: '${report.bufferedGlycemicLoad}',
                          unit: 'Load',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Predicted Rise',
                          value: '+${report.predictedGlucoseRiseMgDl}',
                          unit: 'mg/dL',
                          accentColor: tierColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Interactive Buffer & Sequencing Modifiers
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Eat Salad / Fiber First', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                      subtitle: const Text('Raw fiber coat reduces carb absorption rate by 30%', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      value: _isSaladFirst,
                      activeThumbColor: AppColors.karmaGreen,
                      onChanged: (val) => setState(() => _isSaladFirst = val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Plan Shatpawali Walk (+1,000 steps)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                      subtitle: const Text('Direct muscle glucose uptake via GLUT4 (-25% spike)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      value: _isWalkPlanned,
                      activeThumbColor: AppColors.focusBlue,
                      onChanged: (val) => setState(() => _isWalkPlanned = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Indian Meal Sequencing Protocol Card
              BentoCard(
                backgroundColor: AppColors.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_list_numbered_rounded, color: AppColors.gold, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('The Anti-Spike Sequencing Rule', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 3),
                          Text(report.sequencingPrescription, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Applied Buffering Interventions
              const Text(
                'ACTIVE GLYCEMIC BUFFERS (सक्रिय ग्लाइसेमिक ढाल)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.bufferingInterventions.map((buff) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.karmaGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            buff,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
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
}
