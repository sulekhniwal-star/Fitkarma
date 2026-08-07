import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import 'package:fitkarma/features/health_tracking/models/device_reliability_engine.dart';
import 'package:fitkarma/features/health_tracking/providers/wearable_comparison_provider.dart';

/// §P4-G Wearable Data Source Card Component
/// Displays active connected wearable, star rating confidence badge,
/// current vs baseline HRV metrics, and readiness weighting notice per spec wireframe.
class WearableDataSourceCard extends ConsumerWidget {
  const WearableDataSourceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wearableComparisonProvider);
    final profile = DeviceReliabilityEngine.deviceProfiles[state.activeSource]!;
    final result = state.readingResult;

    final hrvDeltaPct = ((state.rawHrvMs - state.userBaselineHrvMs) / state.userBaselineHrvMs) * 100.0;
    final hrvDeltaLabel = hrvDeltaPct >= 0 ? '+${hrvDeltaPct.round()}%' : '${hrvDeltaPct.round()}%';

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Icon + Device Name + Star Rating ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.watch, color: AppColors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'HRV Source: ${state.activeSource.displayName}',
                    style: AppTypography.labelLg,
                  ),
                ],
              ),
              _ConfidenceStarsBadge(profile: profile),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Today's HRV vs Baseline ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s HRV', style: AppTypography.bodySm),
                  Text('${state.rawHrvMs.round()} ms', style: AppTypography.metricLg.copyWith(color: AppColors.teal)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Your Baseline', style: AppTypography.bodySm),
                  Text(
                    '${state.userBaselineHrvMs.round()} ms ($hrvDeltaLabel)',
                    style: AppTypography.labelLg.copyWith(
                      color: hrvDeltaPct >= 0 ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Readiness Weighting Notice ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.teal, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${state.activeSource.displayName} data is weighted at ${(result.readinessWeight * 100).round()}% confidence in your readiness score.',
                    style: AppTypography.bodySm.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Device Switcher Dropdown ────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Switch Source:', style: AppTypography.bodySm),
              DropdownButton<WearableSource>(
                value: state.activeSource,
                dropdownColor: AppColors.surface0,
                underline: const SizedBox(),
                items: WearableSource.values.map((source) {
                  return DropdownMenuItem(
                    value: source,
                    child: Text(source.displayName, style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary)),
                  );
                }).toList(),
                onChanged: (source) {
                  if (source != null) {
                    ref.read(wearableComparisonProvider.notifier).selectSource(source);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfidenceStarsBadge extends StatelessWidget {
  final DeviceConfidenceProfile profile;

  const _ConfidenceStarsBadge({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (i) {
            return Icon(
              i < profile.starRating ? Icons.star : Icons.star_border,
              color: i < profile.starRating ? AppColors.warning : AppColors.textMuted,
              size: 14,
            );
          }),
        ),
        const SizedBox(width: 4),
        Text(
          profile.confidenceLabel,
          style: AppTypography.bodySm.copyWith(color: AppColors.warning, fontSize: 10),
        ),
      ],
    );
  }
}
