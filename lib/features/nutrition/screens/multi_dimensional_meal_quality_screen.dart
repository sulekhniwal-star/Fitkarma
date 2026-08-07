import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/multi_dimensional_meal_quality_engine.dart';

/// §P5-N Multi-Dimensional Meal Quality Score Screen
/// Route: /food/meal-quality-scoring
class MultiDimensionalMealQualityScreen extends StatefulWidget {
  const MultiDimensionalMealQualityScreen({super.key});

  @override
  State<MultiDimensionalMealQualityScreen> createState() => _MultiDimensionalMealQualityScreenState();
}

class _MultiDimensionalMealQualityScreenState extends State<MultiDimensionalMealQualityScreen> {
  final _engine = const MultiDimensionalMealQualityEngine();

  double _calories = 600.0;
  double _proteinG = 28.0;
  double _fiberG = 12.0;
  double _satietyIndex = 4.5;
  int _processingTier = 0; // 0 Whole Food, 3 Ultra-Processed

  late MultiDimensionalMealQualityResult _result;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final res = _engine.calculateScore(
      calories: _calories,
      proteinG: _proteinG,
      fiberG: _fiberG,
      satietyIndex: _satietyIndex,
      processingTier: _processingTier,
    );
    setState(() {
      _result = res;
    });
  }

  void _loadPreset(String type) {
    if (type == 'rajma') {
      setState(() {
        _calories = 600.0;
        _proteinG = 28.0;
        _fiberG = 12.0;
        _satietyIndex = 4.5;
        _processingTier = 0;
      });
    } else if (type == 'pizza') {
      setState(() {
        _calories = 600.0;
        _proteinG = 18.0;
        _fiberG = 1.5;
        _satietyIndex = 1.5;
        _processingTier = 3;
      });
    }
    _recalculate();
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
        title: Text('Meal Quality Score Engine', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indian Food Comparison Presets
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _loadPreset('rajma'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.success),
                    ),
                    child: Text('600 kcal Rajma Thali', style: AppTypography.labelMd.copyWith(color: AppColors.success)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _loadPreset('pizza'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: Text('600 kcal Fast Food Pizza', style: AppTypography.labelMd.copyWith(color: AppColors.error)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Controls GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Formula Metrics Input', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),

                  // Calories & Protein
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calories: ${_calories.round()} kcal', style: AppTypography.bodySm),
                      Text('Protein: ${_proteinG.round()} g', style: AppTypography.bodySm),
                    ],
                  ),
                  Slider(
                    value: _proteinG,
                    min: 0,
                    max: 60,
                    activeColor: AppColors.teal,
                    onChanged: (val) {
                      setState(() => _proteinG = val);
                      _recalculate();
                    },
                  ),

                  // Fiber
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dietary Fiber', style: AppTypography.bodySm),
                      Text('${_fiberG.toStringAsFixed(1)} g', style: AppTypography.labelLg),
                    ],
                  ),
                  Slider(
                    value: _fiberG,
                    min: 0,
                    max: 30,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _fiberG = val);
                      _recalculate();
                    },
                  ),

                  // Satiety Index (1 to 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Satiety Index (1=Low, 5=High)', style: AppTypography.bodySm),
                      Text('${_satietyIndex.toStringAsFixed(1)}/5', style: AppTypography.labelLg.copyWith(color: AppColors.teal)),
                    ],
                  ),
                  Slider(
                    value: _satietyIndex,
                    min: 1.0,
                    max: 5.0,
                    divisions: 8,
                    activeColor: AppColors.teal,
                    onChanged: (val) {
                      setState(() => _satietyIndex = val);
                      _recalculate();
                    },
                  ),

                  // Processing Tier (0 to 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Processing Tier (0=Whole, 3=NOVA 4)', style: AppTypography.bodySm),
                      Text('Tier $_processingTier', style: AppTypography.labelLg.copyWith(color: AppColors.error)),
                    ],
                  ),
                  Slider(
                    value: _processingTier.toDouble(),
                    min: 0,
                    max: 3,
                    divisions: 3,
                    activeColor: AppColors.error,
                    onChanged: (val) {
                      setState(() => _processingTier = val.round());
                      _recalculate();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Score Result Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: _getScoreColor(_result.score).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Meal Quality Score', style: AppTypography.h3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getScoreColor(_result.score).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_result.score.round()} / 100',
                          style: AppTypography.h2.copyWith(color: _getScoreColor(_result.score), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_result.gradeLabel, style: AppTypography.labelLg.copyWith(color: _getScoreColor(_result.score))),
                  const SizedBox(height: AppSpacing.md),

                  // Breakdown formula values
                  _FormulaRow(label: 'Protein Density (2.5x)', value: '${_result.proteinDensity} %'),
                  _FormulaRow(label: 'Fiber Contribution (3.0x)', value: '+${(_result.fiberG * 3).round()} pts'),
                  _FormulaRow(label: 'Satiety Score (20.0x)', value: '+${(_result.satietyIndex * 20).round()} pts'),
                  _FormulaRow(label: 'Processing Penalty (-15.0x)', value: '-${(_result.processingTier * 15).round()} pts'),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.teal;
    return AppColors.error;
  }
}

class _FormulaRow extends StatelessWidget {
  final String label;
  final String value;

  const _FormulaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
          Text(value, style: AppTypography.labelLg.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
