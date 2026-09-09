import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/performance_models.dart';
import 'providers/performance_provider.dart';

/// Screen displaying Enterprise Performance Diagnostics, 60/120 FPS Frame Budgets,
/// Engine Calculation Micro-benchmarks, and Memory Cache Optimization.
class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(performanceProvider);
    final notifier = ref.read(performanceProvider.notifier);
    final report = state.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Enterprise Performance & Profiling',
          regionalText: 'सिस्टम प्रदर्शन एवं अनुकूलन',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.speed, color: AppColors.textSecondary),
            tooltip: 'Run Benchmarks',
            onPressed: () => notifier.runBenchmarks(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success / Error Banner
            if (state.successMessage != null)
              _buildMessageBanner(state.successMessage!),

            // 1. Hero Performance Score & Framerate Card
            _buildHeroScoreCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Performance Mode & Framerate Controls
            _buildPerformanceControls(report.settings, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. Engine Calculation Micro-benchmarks
            _buildEngineBenchmarksCard(context, state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 4. Memory & Cache Optimization Card
            _buildMemoryCacheCard(report, notifier, state.isLoading),
            const SizedBox(height: AppSpacing.md),

            // 5. Optimization Architectural Tips
            _buildOptimizationTipsCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.karmaGreen, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScoreCard(PerformanceAuditReport report) {
    final gradeColor = report.overallPerformanceScore >= 90
        ? AppColors.karmaGreen
        : (report.overallPerformanceScore >= 75 ? AppColors.focusBlue : AppColors.energyOrange);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: gradeColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: AppColors.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report.performanceGrade.name.toUpperCase(),
                      style: TextStyle(color: gradeColor, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${report.averageFps.toStringAsFixed(1)} FPS (${report.settings.targetFps}Hz Target)',
                  style: const TextStyle(color: AppColors.karmaGreen, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Performance Score',
                value: '${report.overallPerformanceScore}',
                unit: '/100',
                accentColor: gradeColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              GlowingMetric(
                label: 'Active Memory',
                value: report.currentMemoryUsageMb.toStringAsFixed(1),
                unit: 'MB',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceControls(
    PerformanceSettings settings,
    PerformanceNotifier notifier,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: AppColors.focusBlue, size: 18),
              SizedBox(width: 6),
              Text(
                'Performance Profiles & Framerate',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('60 FPS (Balanced)', style: TextStyle(fontSize: 11))),
                  selected: settings.targetFps == 60,
                  selectedColor: AppColors.focusBlue,
                  backgroundColor: AppColors.surfaceElevated,
                  labelStyle: TextStyle(
                    color: settings.targetFps == 60 ? Colors.white : AppColors.textSecondary,
                    fontWeight: settings.targetFps == 60 ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => notifier.setTargetFps(60),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('120 FPS (ProMotion)', style: TextStyle(fontSize: 11))),
                  selected: settings.targetFps == 120,
                  selectedColor: AppColors.gold,
                  backgroundColor: AppColors.surfaceElevated,
                  labelStyle: TextStyle(
                    color: settings.targetFps == 120 ? Colors.black : AppColors.textSecondary,
                    fontWeight: settings.targetFps == 120 ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => notifier.setTargetFps(120),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Battery Saver Mode (Throttled Background Sync)',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11),
              ),
              Switch(
                value: settings.batterySaverMode,
                activeThumbColor: AppColors.karmaGreen,
                onChanged: (val) => notifier.toggleBatterySaver(val),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RepaintBoundary Layer Isolation',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11),
              ),
              Switch(
                value: settings.enableRepaintBoundaries,
                activeThumbColor: AppColors.focusBlue,
                onChanged: (val) => notifier.toggleRepaintBoundaries(val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngineBenchmarksCard(
    BuildContext context,
    PerformanceState state,
    PerformanceNotifier notifier,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_outlined, color: AppColors.energyOrange, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Engine Calculation Benchmarks',
                    style: TextStyle(color: AppColors.energyOrange, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.refresh, color: AppColors.focusBlue, size: 14),
                label: const Text('Re-run', style: TextStyle(color: AppColors.focusBlue, fontSize: 11)),
                onPressed: state.isLoading ? null : () => notifier.runBenchmarks(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...state.report.benchmarkResults.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.engineName,
                              style: AppTypography.titleSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              b.regionalEngineName,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.karmaGreen.withValues(alpha: 0.15),
                          borderRadius: AppRadii.radiusSm,
                        ),
                        child: Text(
                          '${b.executionMilliseconds} ms',
                          style: const TextStyle(
                            color: AppColors.karmaGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMemoryCacheCard(
    PerformanceAuditReport report,
    PerformanceNotifier notifier,
    bool isLoading,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.storage_outlined, color: AppColors.gold, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Memory & Offline Cache Purge',
                    style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Text(
                'Max Budget: ${report.settings.maxCacheSizeMb} MB',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Purges cached AI response payloads and resets in-memory sliding telemetry buffers.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceElevatedHigh,
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              icon: const Icon(Icons.cleaning_services_outlined, color: AppColors.focusBlue, size: 16),
              label: isLoading
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Purge Offline Cache & Telemetry', style: TextStyle(color: AppColors.focusBlue, fontSize: 12)),
              onPressed: () => notifier.clearCache(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationTipsCard(PerformanceAuditReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Enterprise Optimization Standards',
            regionalText: 'सिस्टम गति एवं तकनीकी सुधार',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...report.optimizationTips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.karmaGreen, size: 13),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'FitKarma Performance Philosophy',
                regionalText: 'उच्च प्रदर्शन व गति सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma maintains strict sub-16.6ms frame budgets for 60 FPS (and sub-8.3ms for 120 FPS ProMotion) across all health dashboards. Mathematical analysis pipelines are deterministic and execute in sub-10ms, eliminating UI thread jank.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
