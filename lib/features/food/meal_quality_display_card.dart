/// §P5-N Multi-Dimensional Meal Quality Display UI Card
///
/// Interactive UI Card displaying composite 100-point Meal Quality Score,
/// color-coded letter grade badge (S/A/B/C/D), and 4 component progress bars:
/// Protein Density, Dietary Fiber, Satiety Index, and Processing Tier Penalty.
library;

import 'package:fitkarma/features/food/multi_dimensional_meal_quality_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _surfaceColor  = Color(0xFF1B1D2A);
const _accentOrange  = Color(0xFFFF6B35);
const _accentGreen   = Color(0xFF4ADE80);
const _accentRed     = Color(0xFFF87171);
const _accentBlue    = Color(0xFF60A5FA);
const _accentYellow  = Color(0xFFFBBF24);
const _accentPurple  = Color(0xFFA78BFA);
const _textPrimary   = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor   = Color(0xFF2E324A);

class MealQualityDisplayCard extends ConsumerWidget {
  const MealQualityDisplayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiDimensionalMealQualityProvider);
    final summary = state.summary;

    final gradeColor = _getGradeColor(summary.score);

    return Container(
      key: const Key('meal_quality_display_card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header & 100-Point Score Gauge ──
          Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: (summary.score / 100.0).clamp(0.0, 1.0),
                      backgroundColor: _borderColor,
                      valueColor: AlwaysStoppedAnimation(gradeColor),
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Text(
                        '${summary.score.round()}',
                        key: const Key('meal_quality_score_text'),
                        style: TextStyle(
                          color: gradeColor,
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Meal Quality Score',
                          style: TextStyle(
                            color: _textPrimary,
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: gradeColor.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: gradeColor.withAlpha(100)),
                          ),
                          child: Text(
                            summary.grade,
                            key: const Key('meal_quality_grade_badge'),
                            style: TextStyle(
                              color: gradeColor,
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.breakdownSummary,
                      style: const TextStyle(color: _textSecondary, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: _borderColor, height: 1),
          const SizedBox(height: 14),

          // ── 4 Component Progress Rows ──
          _ComponentRow(
            label: 'Protein Density (2.5x)',
            valueText: '${summary.proteinDensity.toStringAsFixed(1)} g / 100 kcal',
            progress: (summary.proteinDensity / 15.0).clamp(0.0, 1.0),
            color: _accentPurple,
          ),
          const SizedBox(height: 8),
          _ComponentRow(
            label: 'Dietary Fiber (3x)',
            valueText: '${summary.fiberG.toStringAsFixed(1)} g',
            progress: (summary.fiberG / 20.0).clamp(0.0, 1.0),
            color: _accentGreen,
          ),
          const SizedBox(height: 8),
          _ComponentRow(
            label: 'Satiety Index (20x)',
            valueText: '${summary.satietyIndex.toStringAsFixed(1)} / 5.0',
            progress: (summary.satietyIndex / 5.0).clamp(0.0, 1.0),
            color: _accentYellow,
          ),
          const SizedBox(height: 8),
          _ComponentRow(
            label: 'NOVA Processing Penalty (-15x)',
            valueText: '-${summary.processingTier.penaltyValue * 15} pts (${summary.processingTier.name})',
            progress: (summary.processingTier.penaltyValue / 3.0).clamp(0.0, 1.0),
            color: summary.processingTier.penaltyValue > 0 ? _accentRed : _accentBlue,
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double score) {
    if (score >= 85.0) return _accentGreen;
    if (score >= 70.0) return _accentBlue;
    if (score >= 50.0) return _accentYellow;
    if (score >= 35.0) return _accentOrange;
    return _accentRed;
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.color,
  });

  final String label;
  final String valueText;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              valueText,
              style: TextStyle(color: color, fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: _borderColor,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
