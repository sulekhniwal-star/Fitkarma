import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/sleep_engine.dart';
import '../models/sleep_debt_engine.dart';
import '../providers/sleep_provider.dart';

/// §P4-C Sleep Screen
/// Route: /sleep
/// Scaffold: Deep indigo full-bleed gradient card stacks
class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  // Spec-defined stage colours
  static const _awakeColor  = Color(0xFFFB7185); // rose
  static const _remColor    = Color(0xFF7B6FF0); // indigo/secondary
  static const _lightColor  = Color(0xFF00D4B4); // teal
  static const _deepColor   = Color(0xFF4ADE80); // success green

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepProvider);
    final record = state.lastNight;
    final engine = const SleepDebtEngine();

    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: CustomScrollView(
        slivers: [
          // ── Deep Indigo SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D2B),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text('Sleep OS', style: AppTypography.h2),
            flexibleSpace: FlexibleSpaceBar(
              background: _IndigoHero(record: record, state: state, engine: engine),
            ),
          ),

          // ── Body Cards ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.lg),

                // Sleep Stages segmented bar
                _SleepStagesCard(stages: record.stages),
                const SizedBox(height: AppSpacing.lg),

                // 4-Pillar performance breakdown
                if (state.performance != null)
                  _PerformanceCard(perf: state.performance!),
                if (state.performance != null)
                  const SizedBox(height: AppSpacing.lg),

                // 7-Day HRV Trend sparkline
                _HrvTrendCard(points: state.hrvTrend),
                const SizedBox(height: AppSpacing.lg),

                // 7-Day sleep minutes bar chart
                _WeeklySleepCard(
                  weeklyMinutes: state.weeklyMinutes,
                  baselineMinutes: 480,
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Indigo Hero ───────────────────────────────────────────────────────────────

class _IndigoHero extends StatelessWidget {
  final NightSleepRecord record;
  final SleepState state;
  final SleepDebtEngine engine;

  const _IndigoHero({
    required this.record,
    required this.state,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    final debtLabel = engine.formatDebt(state.debtMinutes);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0D2B),
            Color(0xFF1A1A4E),
            Color(0xFF0F0F20),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last night duration + quality label
          Row(
            children: [
              Text(
                'Last Night: ${record.durationLabel}',
                style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              _QualityBadge(quality: record.quality),
            ],
          ),
          const SizedBox(height: 8),

          // Stars + debt chip
          Row(
            children: [
              _StarRating(stars: record.quality.starRating),
              const SizedBox(width: 12),
              _SleepDebtChip(debtLabel: debtLabel, level: state.debtLevel),
            ],
          ),
        ],
      ),
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final SleepQuality quality;
  const _QualityBadge({required this.quality});

  Color get _color {
    switch (quality) {
      case SleepQuality.excellent: return AppColors.success;
      case SleepQuality.good:      return AppColors.teal;
      case SleepQuality.normal:    return AppColors.secondary;
      case SleepQuality.fair:      return AppColors.warning;
      case SleepQuality.poor:      return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        quality.label,
        style: AppTypography.labelMd.copyWith(color: _color, fontSize: 10),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int stars;
  const _StarRating({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < stars ? Icons.star : Icons.star_border,
          color: i < stars ? AppColors.warning : AppColors.textMuted,
          size: 16,
        );
      }),
    );
  }
}

class _SleepDebtChip extends StatelessWidget {
  final String debtLabel;
  final SleepDebtLevel level;
  const _SleepDebtChip({required this.debtLabel, required this.level});

  Color get _color {
    switch (level) {
      case SleepDebtLevel.none:     return AppColors.success;
      case SleepDebtLevel.low:      return AppColors.teal;
      case SleepDebtLevel.moderate: return AppColors.warning;
      case SleepDebtLevel.high:     return AppColors.rose;
      case SleepDebtLevel.severe:   return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Sleep Debt: $debtLabel (${level.label})',
        style: AppTypography.labelMd.copyWith(color: _color, fontSize: 10),
      ),
    );
  }
}

// ── Sleep Stages Segmented Bar ────────────────────────────────────────────────

class _SleepStagesCard extends StatelessWidget {
  final SleepStageBreakdown stages;
  const _SleepStagesCard({required this.stages});

  static const _stageOrder = [
    SleepStage.awake,
    SleepStage.rem,
    SleepStage.light,
    SleepStage.deep,
  ];

  static const _stageColors = {
    SleepStage.awake: SleepScreen._awakeColor,
    SleepStage.rem:   SleepScreen._remColor,
    SleepStage.light: SleepScreen._lightColor,
    SleepStage.deep:  SleepScreen._deepColor,
  };

  @override
  Widget build(BuildContext context) {
    final map = stages.asMap;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleep Stages', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),

          // Stage legend chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _stageOrder.map((stage) {
              final pct = (map[stage]! * 100).round();
              final color = _stageColors[stage]!;
              return _StageLegendChip(
                label: stage.label,
                pct: pct,
                color: color,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Horizontal segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 16,
              child: Row(
                children: _stageOrder.map((stage) {
                  final pct = map[stage]!;
                  final color = _stageColors[stage]!;
                  return Expanded(
                    flex: (pct * 100).round(),
                    child: Container(
                      color: color,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageLegendChip extends StatelessWidget {
  final String label;
  final int pct;
  final Color color;
  const _StageLegendChip({
    required this.label,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(
            '$label: $pct%',
            style: AppTypography.labelMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ── 4-Pillar Performance Card ─────────────────────────────────────────────────

class _PerformanceCard extends StatelessWidget {
  final SleepPerformanceResult perf;
  const _PerformanceCard({required this.perf});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sleep Performance', style: AppTypography.h3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${perf.overallScore}',
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.secondary, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _PillarBar(
            label: 'Duration (35%)',
            value: perf.durationScore,
            color: AppColors.teal,
          ),
          _PillarBar(
            label: 'Efficiency (25%)',
            value: perf.efficiencyScore,
            color: AppColors.success,
          ),
          _PillarBar(
            label: 'Restfulness (25%)',
            value: perf.restfulnessScore,
            color: AppColors.secondary,
          ),
          _PillarBar(
            label: 'Circadian (15%)',
            value: perf.circadianScore,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _PillarBar extends StatelessWidget {
  final String label;
  final double value; // 0–100
  final Color color;
  const _PillarBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodySm),
              Text(
                value.round().toString(),
                style: AppTypography.bodySm.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (value / 100.0).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 7-Day HRV Trend Sparkline ─────────────────────────────────────────────────

class _HrvTrendCard extends StatelessWidget {
  final List<HrvDataPoint> points;
  const _HrvTrendCard({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final maxHrv = points.map((p) => p.rmssdMs).reduce(math.max);
    final minHrv = points.map((p) => p.rmssdMs).reduce(math.min);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('7-Day HRV Trend', style: AppTypography.h3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Wearable',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.teal, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'rMSSD (ms) — driven by wearable integrations',
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _HrvLinePainter(
                points: points.map((p) => p.rmssdMs).toList(),
                maxVal: maxHrv,
                minVal: minHrv,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Min/Max labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${minHrv.toStringAsFixed(0)} ms min',
                style: AppTypography.bodySm,
              ),
              Text(
                '${maxHrv.toStringAsFixed(0)} ms max',
                style:
                    AppTypography.bodySm.copyWith(color: AppColors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HrvLinePainter extends CustomPainter {
  final List<double> points;
  final double maxVal;
  final double minVal;

  _HrvLinePainter({
    required this.points,
    required this.maxVal,
    required this.minVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final range = maxVal - minVal;
    final effectiveRange = range < 1 ? 1.0 : range;

    final path = Path();
    final dotPaint = Paint()
      ..color = AppColors.teal
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.secondary, AppColors.teal],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Area fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondary.withValues(alpha: 0.25),
          AppColors.secondary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final n = points.length;
    final step = size.width / (n - 1);

    Offset _pt(int i) {
      final x = i * step;
      final norm = (points[i] - minVal) / effectiveRange;
      final y = size.height - (norm * size.height * 0.85) - 4;
      return Offset(x, y.clamp(0.0, size.height));
    }

    path.moveTo(_pt(0).dx, _pt(0).dy);
    for (int i = 1; i < n; i++) {
      // Smooth cubic bezier
      final prev = _pt(i - 1);
      final curr = _pt(i);
      final cp1 = Offset((prev.dx + curr.dx) / 2, prev.dy);
      final cp2 = Offset((prev.dx + curr.dx) / 2, curr.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }

    // Area fill
    final fillPath = Path.from(path)
      ..lineTo(_pt(n - 1).dx, size.height)
      ..lineTo(_pt(0).dx, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    // Line
    canvas.drawPath(path, linePaint);

    // Dots
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(_pt(i), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HrvLinePainter old) =>
      old.points != points;
}

// ── 7-Day Sleep Minutes Bar Chart ─────────────────────────────────────────────

class _WeeklySleepCard extends StatelessWidget {
  final List<int> weeklyMinutes;
  final int baselineMinutes;
  const _WeeklySleepCard({
    required this.weeklyMinutes,
    required this.baselineMinutes,
  });

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final display = weeklyMinutes.length > 7
        ? weeklyMinutes.sublist(weeklyMinutes.length - 7)
        : weeklyMinutes;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('7-Day Sleep', style: AppTypography.h3),
              Text(
                'Goal: ${baselineMinutes ~/ 60}h',
                style: AppTypography.bodySm
                    .copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(display.length, (i) {
                final minutes = display[i];
                final ratio = (minutes / baselineMinutes).clamp(0.0, 1.2);
                final isGoalMet = minutes >= baselineMinutes;
                final barColor = isGoalMet ? AppColors.secondary : AppColors.warning;
                final labelIdx = (7 - display.length) + i;
                final label = labelIdx >= 0 && labelIdx < 7
                    ? dayLabels[labelIdx]
                    : '?';
                final h = minutes ~/ 60;
                final m = minutes % 60;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          m == 0 ? '${h}h' : '${h}h${m}m',
                          style: AppTypography.bodySm
                              .copyWith(fontSize: 8, color: barColor),
                        ),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: double.infinity,
                          height: 52 * ratio,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                barColor,
                                barColor.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(label,
                            style: AppTypography.bodySm.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
