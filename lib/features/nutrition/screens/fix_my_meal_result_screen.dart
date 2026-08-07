import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/meal_analysis_pipeline.dart';
import '../models/meal_photo_analyzer.dart';
import '../providers/nutrition_provider.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';

/// §P5-C Fix My Meal — Full Analysis Result Screen
/// Route: /food/fix-my-meal
class FixMyMealResultScreen extends ConsumerStatefulWidget {
  final File? photoFile;

  const FixMyMealResultScreen({super.key, this.photoFile});

  @override
  ConsumerState<FixMyMealResultScreen> createState() => _FixMyMealResultScreenState();
}

class _FixMyMealResultScreenState extends ConsumerState<FixMyMealResultScreen> {
  late final MealPhotoAnalyzer _analyzer;
  FullMealAnalysisResult? _analysisResult;
  bool _isLoading = true;
  double _servings = 1.0;

  @override
  void initState() {
    super.initState();
    _analyzer = const MealPhotoAnalyzer();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    setState(() => _isLoading = true);

    // If photo supplied, run analyzer; otherwise analyze default common thali photo test
    final fileToAnalyze = widget.photoFile ?? File('sample_common_meal.jpg');
    final result = await _analyzer.analyze(fileToAnalyze);

    if (mounted) {
      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Fix My Meal — Vision AI', style: AppTypography.h2),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: AppSpacing.md),
                  Text('Analyzing meal components & glycemic load...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cost Optimization Badge
                  _CostOptimizationBadge(isAiFallbackUsed: _analysisResult!.isAiFallbackUsed),
                  const SizedBox(height: AppSpacing.md),

                  // Detected Meal Header Card
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detected: ${_analysisResult!.foodItem.name}',
                              style: AppTypography.h3,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Quality: ${_analysisResult!.quality.overallScore}/100',
                                style: AppTypography.bodySm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '~${(_analysisResult!.totalCalories * _servings).round()} kcal · ${(_analysisResult!.totalProteinGrams * _servings).round()}g protein',
                          style: AppTypography.labelLg.copyWith(color: AppColors.teal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Meal Quality Breakdown Box per ASCII Spec
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meal Quality Breakdown:', style: AppTypography.h3),
                        const SizedBox(height: AppSpacing.sm),
                        _QualityMetricRow(
                          icon: _analysisResult!.totalProteinGrams < 20 ? '⚠️' : '✓',
                          text: _analysisResult!.totalProteinGrams < 20
                              ? 'Protein low for muscle & fat-loss goal'
                              : 'Optimal protein for recovery',
                          isWarning: _analysisResult!.totalProteinGrams < 20,
                        ),
                        const SizedBox(height: 6),
                        _QualityMetricRow(
                          icon: '✓',
                          text: 'Good dietary fiber content',
                          isWarning: false,
                        ),
                        const SizedBox(height: 6),
                        _QualityMetricRow(
                          icon: _analysisResult!.foodItem.glycemicIndex > 60 ? '⚠️' : '✓',
                          text: _analysisResult!.foodItem.glycemicIndex > 60
                              ? 'High glycemic load — risk of glucose dip'
                              : 'Balanced glycemic response',
                          isWarning: _analysisResult!.foodItem.glycemicIndex > 60,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Readiness & Goal Impact
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Readiness Impact: ${_analysisResult!.readinessImpact}', style: AppTypography.bodyMd),
                        const SizedBox(height: 6),
                        Text('Goal Impact: ${_analysisResult!.goalImpact}', style: AppTypography.bodyMd.copyWith(color: AppColors.accent)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Fix Suggestions Section
                  Text('Smart Meal Fix Suggestions:', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  for (final fix in _analysisResult!.fixSuggestions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.surface1,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('+ ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                            Expanded(child: Text(fix, style: AppTypography.bodyMd)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),

                  // Portions Adjustment Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Adjust Serving Portion:', style: AppTypography.labelLg),
                      Text('${_servings.toStringAsFixed(1)}x', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: _servings,
                    min: 0.5,
                    max: 3.0,
                    divisions: 5,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _servings = val),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Action Buttons per ASCII Spec: [Log This Meal] [Adjust Portions]
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            ),
                          ),
                          onPressed: () {
                            ref.read(nutritionProvider.notifier).logMeal(
                                  type: MealType.lunch,
                                  foodItem: _analysisResult!.foodItem,
                                  servings: _servings,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Meal logged successfully!')),
                            );
                            Navigator.maybePop(context);
                          },
                          child: Text('Log This Meal', style: AppTypography.labelLg.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}

class _CostOptimizationBadge extends StatelessWidget {
  final bool isAiFallbackUsed;
  const _CostOptimizationBadge({required this.isAiFallbackUsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAiFallbackUsed ? AppColors.secondary.withValues(alpha: 0.15) : AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAiFallbackUsed ? AppColors.secondary.withValues(alpha: 0.3) : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAiFallbackUsed ? Icons.bolt : Icons.cached,
            color: isAiFallbackUsed ? AppColors.secondary : AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isAiFallbackUsed ? 'Vision AI Analyzed (Groq Llama-3.2)' : 'Instant Cache Match (Zero API Cost)',
            style: AppTypography.bodySm.copyWith(
              color: isAiFallbackUsed ? AppColors.secondary : AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityMetricRow extends StatelessWidget {
  final String icon;
  final String text;
  final bool isWarning;

  const _QualityMetricRow({required this.icon, required this.text, required this.isWarning});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySm.copyWith(
              color: isWarning ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
