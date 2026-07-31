import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/daily_intelligence_package.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/health_score_ring.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../providers/dashboard_provider.dart';

/// §P4-A Dashboard Screen
/// Orchestration: DIP → Live Metrics → Render. Zero AI calls on open.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: RefreshIndicator(
        color: AppColors.teal,
        backgroundColor: AppColors.surface0,
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // ── SliverAppBar (no title — hero takes precedence) ─────────────
            SliverAppBar(
              backgroundColor: AppColors.bgPrimary,
              elevation: 0,
              pinned: false,
              floating: true,
              expandedHeight: 0,
              leading: null,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md, top: 4),
                  child: _GreetingBadge(),
                ),
              ],
            ),

            // ── Hero Section (Activity Rings + Step Count + TrendChip) ─────
            SliverToBoxAdapter(
              child: state.isLoading
                  ? const _HeroSkeleton()
                  : _HeroSection(
                      dip: state.dip,
                      live: state.liveMetrics,
                    ),
            ),

            // ── Body Panel ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSpacing.lg),

                  // ── Health Score + Readiness ────────────────────────────
                  state.isLoading
                      ? const ShimmerLoader(width: double.infinity, height: 110)
                      : _ScoreRow(dip: state.dip),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Bento Row 1: Water + Calories ───────────────────────
                  state.isLoading
                      ? const ShimmerLoader(width: double.infinity, height: 88)
                      : _BentoRow1(live: state.liveMetrics),
                  const SizedBox(height: AppSpacing.lg),

                  // ── AI Coach Insight (from DIP — no new call) ───────────
                  state.isLoading
                      ? const ShimmerLoader(width: double.infinity, height: 80)
                      : _DipInsightCard(dip: state.dip),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Bento Row 2: Sleep + Resting HR ────────────────────
                  state.isLoading
                      ? const ShimmerLoader(width: double.infinity, height: 88)
                      : _BentoRow2(live: state.liveMetrics),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Streak + Karma ──────────────────────────────────────
                  state.isLoading
                      ? const ShimmerLoader(width: double.infinity, height: 80)
                      : _StreakKarmaRow(live: state.liveMetrics),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Daily Missions ──────────────────────────────────────
                  if (!state.isLoading && state.dip != null)
                    _DailyMissionsCard(missions: state.dip!.dailyMissions),

                  const SizedBox(height: 100), // scroll padding for FAB
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Greeting Badge ────────────────────────────────────────────────────────────

class _GreetingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassBgMid,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(greeting, style: AppTypography.labelLg),
    );
  }
}

// ── Hero Section ──────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final DailyIntelligencePackage? dip;
  final DashboardLiveMetrics live;

  const _HeroSection({required this.dip, required this.live});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface0,
            AppColors.bgPrimary,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Activity rings — Steps · Calories · Active Minutes
          ActivityRings(
            size: 180,
            gap: 6,
            rings: [
              RingData(
                value: live.steps.toDouble(),
                target: live.stepGoal.toDouble(),
                colors: [AppColors.teal, AppColors.success],
                strokeWidth: 14,
              ),
              RingData(
                value: live.caloriesBurned.toDouble(),
                target: live.calorieGoal.toDouble(),
                colors: [AppColors.primary, AppColors.accent],
                strokeWidth: 12,
              ),
              RingData(
                value: live.activeMinutes.toDouble(),
                target: live.activeMinuteGoal.toDouble(),
                colors: [AppColors.secondary, AppColors.purple],
                strokeWidth: 10,
              ),
            ],
          ),

          // Step count overlay
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatNumber(live.steps),
                style: AppTypography.metricLg.copyWith(color: AppColors.teal),
              ),
              Text('steps', style: AppTypography.bodySm),
            ],
          ),

          // TrendChip bottom-right
          Positioned(
            bottom: 24,
            right: 24,
            child: _TrendChip(pct: live.stepsVsYesterdayPct),
          ),

          // Ring legend bottom-left
          Positioned(
            bottom: 24,
            left: 24,
            child: _RingLegend(),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return '$n';
  }
}

class _TrendChip extends StatelessWidget {
  final double pct;
  const _TrendChip({required this.pct});

  @override
  Widget build(BuildContext context) {
    final isUp = pct >= 0;
    final color = isUp ? AppColors.success : AppColors.error;
    final icon = isUp ? Icons.trending_up : Icons.trending_down;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 3),
          Text(
            '${isUp ? '+' : ''}${pct.toStringAsFixed(0)}% vs yesterday',
            style:
                AppTypography.labelMd.copyWith(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _RingLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _LegendDot(color: AppColors.teal, label: 'Steps'),
        const SizedBox(height: 2),
        _LegendDot(color: AppColors.primary, label: 'Calories'),
        const SizedBox(height: 2),
        _LegendDot(color: AppColors.secondary, label: 'Active min'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.bodySm.copyWith(fontSize: 9)),
      ],
    );
  }
}

// ── Health Score + Readiness Row ──────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  final DailyIntelligencePackage? dip;
  const _ScoreRow({required this.dip});

  @override
  Widget build(BuildContext context) {
    final readiness = dip?.readinessScore ?? 82;
    final health = dip?.healthScore ?? 74;
    final focus = dip?.primaryFocus ?? 'Recovery';

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Health Score Ring
          HealthScoreRing(score: health, size: 80),
          const SizedBox(width: AppSpacing.md),

          // Readiness Ring
          _ReadinessRing(score: readiness, size: 80),
          const SizedBox(width: AppSpacing.md),

          // Mission tap
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Focus',
                    style: AppTypography.bodySm),
                const SizedBox(height: 4),
                Text(focus, style: AppTypography.h3.copyWith(color: AppColors.teal)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Tap to see today\'s mission',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios,
                        color: AppColors.textMuted, size: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessRing extends StatelessWidget {
  final int score;
  final double size;
  const _ReadinessRing({required this.score, required this.size});

  Color get _color {
    if (score >= 80) return AppColors.teal;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: score / 100.0,
            strokeWidth: size * 0.08,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.surface2.withValues(alpha: 0.3),
            color: _color,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score',
              style: AppTypography.displayMd.copyWith(
                fontSize: size * 0.32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'READY',
              style: AppTypography.labelMd.copyWith(
                fontSize: size * 0.08,
                color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Bento Row 1: Water + Calories ─────────────────────────────────────────────

class _BentoRow1 extends StatelessWidget {
  final DashboardLiveMetrics live;
  const _BentoRow1({required this.live});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricBento(
            emoji: '💧',
            label: 'Water',
            value: '${live.waterLitres.toStringAsFixed(1)}L',
            subValue: '/ ${live.waterGoal.toStringAsFixed(1)}L',
            progress: live.waterLitres / live.waterGoal,
            progressColor: AppColors.teal,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricBento(
            emoji: '🔥',
            label: 'Calories',
            value: '${live.caloriesBurned}',
            subValue: '/ ${live.calorieGoal}',
            progress: live.caloriesBurned / live.calorieGoal,
            progressColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// ── Bento Row 2: Sleep + Resting HR ──────────────────────────────────────────

class _BentoRow2 extends StatelessWidget {
  final DashboardLiveMetrics live;
  const _BentoRow2({required this.live});

  @override
  Widget build(BuildContext context) {
    final sleepH = live.sleepHours.floor();
    final sleepM = ((live.sleepHours - sleepH) * 60).round();

    return Row(
      children: [
        Expanded(
          child: _MetricBento(
            emoji: '😴',
            label: 'Sleep',
            value: '${sleepH}h ${sleepM}m',
            subValue: 'last night',
            progress: live.sleepHours / 8.0,
            progressColor: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricBento(
            emoji: '❤️',
            label: 'Resting HR',
            value: '${live.restingHrBpm}',
            subValue: 'bpm',
            progress: 1.0 - ((live.restingHrBpm - 50) / 50.0).clamp(0.0, 1.0),
            progressColor: AppColors.rose,
          ),
        ),
      ],
    );
  }
}

// ── Generic Metric Bento Card ─────────────────────────────────────────────────

class _MetricBento extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String subValue;
  final double progress;
  final Color progressColor;

  const _MetricBento({
    required this.emoji,
    required this.label,
    required this.value,
    required this.subValue,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: AppTypography.displayMd
                      .copyWith(color: progressColor, fontSize: 22)),
              const SizedBox(width: 3),
              Text(subValue, style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── DIP Insight Card ──────────────────────────────────────────────────────────

class _DipInsightCard extends StatelessWidget {
  final DailyIntelligencePackage? dip;
  const _DipInsightCard({required this.dip});

  @override
  Widget build(BuildContext context) {
    final insight = dip?.primaryInsight ??
        'Your daily intelligence package is loading...';
    final source = dip?.insightSource ?? 'DIP';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.accent.withValues(alpha: 0.04),
          ],
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.auto_awesome,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('AI Coach Insight',
                        style: AppTypography.labelLg
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.3)),
                      ),
                      child: Text(source,
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.teal, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(insight,
                    style: AppTypography.bodyMd.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Streak + Karma Row ────────────────────────────────────────────────────────

class _StreakKarmaRow extends StatelessWidget {
  final DashboardLiveMetrics live;
  const _StreakKarmaRow({required this.live});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBento(
            emoji: '🔥',
            label: 'Streak',
            value: '${live.streakDays}-day',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatBento(
            emoji: '⭐',
            label: 'Karma',
            value: _formatKarma(live.karmaPoints),
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  String _formatKarma(int k) {
    if (k >= 1000) return '${(k / 1000).toStringAsFixed(1)}k';
    return '$k';
  }
}

class _StatBento extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _StatBento({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySm),
              Text(value,
                  style: AppTypography.h2.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Daily Missions Card ───────────────────────────────────────────────────────

class _DailyMissionsCard extends StatelessWidget {
  final List<String> missions;
  const _DailyMissionsCard({required this.missions});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: AppColors.teal, size: 18),
              const SizedBox(width: 8),
              Text('Today\'s Missions',
                  style: AppTypography.h3.copyWith(color: AppColors.teal)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...missions.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.teal.withValues(alpha: 0.5)),
                        ),
                        child: Center(
                          child: Text('${e.key + 1}',
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.teal, fontSize: 9)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.value, style: AppTypography.bodyMd),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// ── Skeletons ─────────────────────────────────────────────────────────────────

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      color: AppColors.surface0,
      child: const Center(
        child: ShimmerLoader(height: 180, width: 180),
      ),
    );
  }
}
