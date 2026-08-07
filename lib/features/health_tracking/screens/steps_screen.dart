import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/steps_sync_engine.dart';
import '../providers/steps_provider.dart';

/// §P4-B Steps Screen
/// Route: /steps
/// Hero → Daily Progress + Hourly Bar Chart + Coach Insight
class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stepsProvider);
    final record = state.record;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(context, ref, state),
      body: RefreshIndicator(
        color: AppColors.teal,
        backgroundColor: AppColors.surface0,
        onRefresh: () => ref.read(stepsProvider.notifier).triggerSync(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Card: Daily Progress ─────────────────────────────────
              _DailyProgressCard(record: record),
              const SizedBox(height: AppSpacing.lg),

              // ── Stat Row: Distance · Active · Calories ────────────────────
              _StatRow(record: record),
              const SizedBox(height: AppSpacing.lg),

              // ── Hourly Step Distribution chart ────────────────────────────
              _HourlyDistributionSection(buckets: record.hourlyDistribution),
              const SizedBox(height: AppSpacing.lg),

              // ── Coach Insight Card ────────────────────────────────────────
              _CoachInsightCard(nudge: state.coachNudge),
              const SizedBox(height: AppSpacing.lg),

              // ── Data Source Indicator ─────────────────────────────────────
              _DataSourceCard(
                source: record.source,
                lastSynced: record.lastSyncedAt,
                onSync: () => ref.read(stepsProvider.notifier).triggerSync(),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    StepsState state,
  ) {
    return AppBar(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text('Steps Tracker', style: AppTypography.h2),
      actions: [
        // Sync status chip
        Padding(
          padding:
              const EdgeInsets.only(right: AppSpacing.md, top: 4),
          child: _SyncChip(state: state),
        ),
      ],
    );
  }
}

// ── Sync Chip ─────────────────────────────────────────────────────────────────

class _SyncChip extends StatelessWidget {
  final StepsState state;
  const _SyncChip({required this.state});

  @override
  Widget build(BuildContext context) {
    final status = state.record.syncStatus;
    final Color color;
    final IconData icon;

    switch (status) {
      case SyncStatus.synced:
        color = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SyncStatus.syncing:
        color = AppColors.teal;
        icon = Icons.sync;
        break;
      case SyncStatus.error:
        color = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SyncStatus.idle:
        color = AppColors.textMuted;
        icon = Icons.circle_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          state.isSyncing
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5, color: color),
                )
              : Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            'Sync: ${status.label}',
            style: AppTypography.labelMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ── Daily Progress Hero Card ──────────────────────────────────────────────────

class _DailyProgressCard extends StatelessWidget {
  final StepsSyncRecord record;
  const _DailyProgressCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final pct = record.progressFraction;
    final remaining = record.remainingSteps;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Progress', style: AppTypography.bodySm),
              Text(
                '${_fmt(record.totalSteps)} / ${_fmt(record.stepGoal)} steps',
                style:
                    AppTypography.labelLg.copyWith(color: AppColors.teal),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Big step number
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _fmt(record.totalSteps),
                style: AppTypography.metricLg
                    .copyWith(color: AppColors.teal),
              ),
              const SizedBox(width: 6),
              Text('steps',
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Progress bar
          _StepProgressBar(progress: pct),
          const SizedBox(height: AppSpacing.sm),

          // Remaining label
          if (remaining > 0)
            Text(
              '${_fmt(remaining)} steps remaining',
              style: AppTypography.bodySm
                  .copyWith(color: AppColors.textMuted),
            )
          else
            Row(
              children: [
                const Icon(Icons.celebration,
                    color: AppColors.success, size: 14),
                const SizedBox(width: 5),
                Text(
                  'Daily goal achieved! 🎉',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.success),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ── Step Progress Bar ─────────────────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  final double progress;
  const _StepProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final w = constraints.maxWidth;
      final filledW = (w * progress).clamp(0.0, w);

      return Container(
        height: 10,
        decoration: BoxDecoration(
          color: AppColors.teal.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            // Filled portion
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              width: filledW,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [AppColors.teal, AppColors.success],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            // Arrow head
            if (progress < 1.0)
              Positioned(
                left: filledW - 1,
                top: 0,
                bottom: 0,
                child: const Icon(Icons.arrow_forward_ios,
                    color: AppColors.teal, size: 10),
              ),
          ],
        ),
      );
    });
  }
}

// ── Stat Row ──────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final StepsSyncRecord record;
  const _StatRow({required this.record});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            emoji: '📍',
            label: 'Distance',
            value: '${record.distanceKm.toStringAsFixed(1)} km',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            emoji: '⏱️',
            label: 'Active',
            value: '${record.activeMinutes} min',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            emoji: '🔥',
            label: 'Calories',
            value: '${record.caloriesBurned}',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StatTile({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTypography.labelLg.copyWith(
                  color: color, fontWeight: FontWeight.w700, fontSize: 14)),
          Text(label, style: AppTypography.bodySm),
        ],
      ),
    );
  }
}

// ── Hourly Distribution Chart ─────────────────────────────────────────────────

class _HourlyDistributionSection extends StatelessWidget {
  final List<HourlyStepBucket> buckets;
  const _HourlyDistributionSection({required this.buckets});

  @override
  Widget build(BuildContext context) {
    // Only display hours 6–22 (where activity typically happens)
    final displayBuckets = buckets
        .where((b) => b.hour >= 6 && b.hour <= 22)
        .toList();

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hourly Step Distribution', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: _HourlyBarChart(buckets: displayBuckets),
          ),
        ],
      ),
    );
  }
}

class _HourlyBarChart extends StatelessWidget {
  final List<HourlyStepBucket> buckets;
  const _HourlyBarChart({required this.buckets});

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return Center(
        child: Text('No step data yet today',
            style: AppTypography.bodySm),
      );
    }

    final maxSteps =
        buckets.map((b) => b.steps).reduce(math.max).toDouble();

    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: _HourlyBarPainter(
        buckets: buckets,
        maxSteps: maxSteps == 0 ? 1 : maxSteps,
      ),
    );
  }
}

class _HourlyBarPainter extends CustomPainter {
  final List<HourlyStepBucket> buckets;
  final double maxSteps;

  _HourlyBarPainter({required this.buckets, required this.maxSteps});

  @override
  void paint(Canvas canvas, Size size) {
    final n = buckets.length;
    if (n == 0) return;

    final barW = (size.width / n) * 0.6;
    final gap = (size.width / n) * 0.4;
    final chartH = size.height - 20; // 20px for labels

    // Axis line
    final axisPaint = Paint()
      ..color = const Color(0x1AFFFFFF) // glassBorder
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, chartH),
      Offset(size.width, chartH),
      axisPaint,
    );

    for (int i = 0; i < n; i++) {
      final bucket = buckets[i];
      final x = i * (barW + gap) + gap / 2;
      final barH = bucket.steps > 0
          ? (bucket.steps / maxSteps) * chartH * 0.9
          : 0.0;

      if (barH > 0) {
        // Bar gradient fill
        final rect = Rect.fromLTWH(x, chartH - barH, barW, barH);
        final paint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFF00D4B4), // teal
              const Color(0xFF4ADE80), // success
            ],
          ).createShader(rect);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          paint,
        );
      }

      // Hour label (every 2nd hour to avoid crowding)
      if (i % 2 == 0) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${bucket.hour}',
            style: const TextStyle(
              color: Color(0xFF6B68A0), // textMuted
              fontSize: 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, chartH + 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HourlyBarPainter old) =>
      old.buckets != buckets || old.maxSteps != maxSteps;
}

// ── Coach Insight Card ────────────────────────────────────────────────────────

class _CoachInsightCard extends StatelessWidget {
  final String nudge;
  const _CoachInsightCard({required this.nudge});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
            color: AppColors.teal.withValues(alpha: 0.35), width: 1.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.teal.withValues(alpha: 0.07),
            AppColors.success.withValues(alpha: 0.04),
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
              color: AppColors.teal.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.directions_walk,
                color: AppColors.teal, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Coach',
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.teal)),
                const SizedBox(height: 5),
                Text(nudge,
                    style: AppTypography.bodyMd.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data Source Card ──────────────────────────────────────────────────────────

class _DataSourceCard extends StatelessWidget {
  final StepDataSource source;
  final DateTime lastSynced;
  final VoidCallback onSync;

  const _DataSourceCard({
    required this.source,
    required this.lastSynced,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final sourceLabel = _sourceLabel(source);
    final sourceIcon = _sourceIcon(source);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(sourceIcon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Source: $sourceLabel',
                    style: AppTypography.labelLg),
                Text(
                  'Last synced: ${_formatSyncTime(lastSynced)}',
                  style: AppTypography.bodySm,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSync,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.teal.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: AppColors.teal.withValues(alpha: 0.35)),
              ),
            ),
            child: Text('Sync',
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.teal)),
          ),
        ],
      ),
    );
  }

  String _sourceLabel(StepDataSource s) {
    switch (s) {
      case StepDataSource.healthConnect:
        return 'Health Connect';
      case StepDataSource.healthKit:
        return 'Apple HealthKit';
      case StepDataSource.manual:
        return 'Manual Entry';
      case StepDataSource.unknown:
        return 'Unknown';
    }
  }

  IconData _sourceIcon(StepDataSource s) {
    switch (s) {
      case StepDataSource.healthConnect:
        return Icons.health_and_safety;
      case StepDataSource.healthKit:
        return Icons.apple;
      case StepDataSource.manual:
        return Icons.edit_note;
      case StepDataSource.unknown:
        return Icons.device_unknown;
    }
  }

  String _formatSyncTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}
