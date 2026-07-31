import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/transformation_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/transformation_provider.dart';

class TransformationDashboardScreen extends ConsumerWidget {
  const TransformationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transformationProvider);
    final forecast = state.forecast90Days;
    final intervention = state.relapseIntervention;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Transformation Engine', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Relapse Intervention Alert Banner (if active)
              if (intervention.tier != RelapseTier.none)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.warningAmber),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: AppColors.warningAmber),
                          const SizedBox(width: AppSpacing.sm),
                          Text(intervention.title, style: AppTypography.titleMedium.copyWith(color: AppColors.warningAmber)),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(intervention.message, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),

              // 90-Day Probabilistic Weight Forecast Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('90-Day Weight Trajectory Forecast', style: AppTypography.titleMedium),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text('Probabilistic Range', style: AppTypography.labelSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${forecast.expectedKg.toStringAsFixed(1)} kg',
                      style: AppTypography.displayLarge.copyWith(color: AppColors.primaryEmerald),
                    ),
                    Text(
                      'Expected Range: ${forecast.minKg.toStringAsFixed(1)} kg – ${forecast.maxKg.toStringAsFixed(1)} kg',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Encrypted Local Progress Photo Vault
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: AppColors.primaryViolet, size: 32.0),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Encrypted Progress Photo Vault', style: AppTypography.titleMedium),
                          Text('AES-256 local encryption with Biometric Lock', style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Monthly Transformation Memory Snapshots
              Text('Monthly Transformation Memory', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.monthlySnapshots.map(
                (snap) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snap.monthYear, style: AppTypography.titleMedium),
                            Text('${snap.weightKg} kg • ${snap.bodyFatPercentage}% Body Fat', style: AppTypography.labelSmall),
                          ],
                        ),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text('Avg Readiness: ${snap.averageReadinessScore}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
