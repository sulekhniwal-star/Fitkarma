import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/cgm_analysis_engine.dart';

final cgmEngineProvider =
    Provider<CgmAnalysisEngine>((ref) => const CgmAnalysisEngine());

final cgmReadingsProvider = Provider<List<GlucoseReading>>((ref) {
  final now = DateTime.now();
  return [
    GlucoseReading(
        readingId: 'g1',
        timestamp: now.subtract(const Duration(hours: 3)),
        glucoseValueMgDl: 95.0,
        trendDirection: GlucoseTrend.flat),
    GlucoseReading(
        readingId: 'g2',
        timestamp: now.subtract(const Duration(hours: 2)),
        glucoseValueMgDl: 120.0,
        trendDirection: GlucoseTrend.rising),
    GlucoseReading(
        readingId: 'g3',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        glucoseValueMgDl: 172.0,
        trendDirection: GlucoseTrend.rapidlyRising),
    GlucoseReading(
        readingId: 'g4',
        timestamp: now.subtract(const Duration(minutes: 5)),
        glucoseValueMgDl: 124.0,
        trendDirection: GlucoseTrend.rising),
  ];
});

final cgmFoodLogsProvider = Provider<List<CgmFoodLogSnapshot>>((ref) {
  final now = DateTime.now();
  return [
    CgmFoodLogSnapshot(
        foodName: 'White Rice (Thali)',
        consumeTime: now.subtract(const Duration(hours: 2, minutes: 15)),
        calories: 520),
    CgmFoodLogSnapshot(
        foodName: 'Oats & Eggs Chilla',
        consumeTime: now.subtract(const Duration(hours: 5)),
        calories: 380),
  ];
});

final cgmDetectedSpikesProvider = Provider<List<GlucoseSpikeEvent>>((ref) {
  final engine = ref.watch(cgmEngineProvider);
  final readings = ref.watch(cgmReadingsProvider);
  final foods = ref.watch(cgmFoodLogsProvider);
  return engine.detectSpikes(readings, foods);
});

/// §P10-H Continuous Biomarker Tracking (CGM Sync) Dashboard Screen
/// Route: /cgm
class CgmDashboardScreen extends ConsumerWidget {
  const CgmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(cgmReadingsProvider);
    final latestReading = readings.isNotEmpty
        ? readings.last
        : GlucoseReading(
            readingId: '0',
            timestamp: DateTime.now(),
            glucoseValueMgDl: 110.0,
            trendDirection: GlucoseTrend.flat);
    final spikes = ref.watch(cgmDetectedSpikesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('🩺 CGM Glucose Stream', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Syncing latest CGM glucose readings from Health Connect...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Glucose Indicator BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Live Glucose Stream',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('SENSOR ACTIVE',
                              style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${latestReading.glucoseValueMgDl.round()} ',
                            style: AppTypography.h1
                                .copyWith(color: AppColors.primary)),
                        Text('mg/dL ',
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.textSecondary)),
                        Text('[↗ ${_trendLabel(latestReading.trendDirection)}]',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.warning)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Visual Stream Sparkline Bar Simulation
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (latestReading.glucoseValueMgDl / 200.0)
                            .clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: AppColors.bg1,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.teal),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Last updated: 2 mins ago (Health Connect Stream)',
                        style: AppTypography.bodySm.copyWith(
                            color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Detected Spikes Section
              Text('⚠️ Detected Spikes (Last 24 Hours)',
                  style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              if (spikes.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: AppColors.success, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No major glucose spikes detected (+40 mg/dL rise). Glycemic variability is optimal.',
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (final spike in spikes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '🚨 Spike: +${spike.glucoseDelta.round()} mg/dL',
                                  style: AppTypography.labelLg.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold)),
                              Text('Peak: ${spike.peakGlucose.round()} mg/dL',
                                  style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Correlated food: ${spike.correlatedFoods.isNotEmpty ? spike.correlatedFoods.first.foodName : "Unlogged Snack"}',
                            style: AppTypography.bodySm
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.bg0.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb,
                                    color: AppColors.warning, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'AI Insight: ${spike.correlatedFoods.isNotEmpty ? spike.correlatedFoods.first.foodName : "High GI food"} triggers rapid digestion. Next time, add 150g salad (fiber) or paneer (protein) before eating to reduce the spike by ~30%.',
                                    style: AppTypography.bodySm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _trendLabel(GlucoseTrend trend) {
    return switch (trend) {
      GlucoseTrend.rapidlyRising => 'Rapidly Rising',
      GlucoseTrend.rising => 'Rising',
      GlucoseTrend.flat => 'Flat',
      GlucoseTrend.falling => 'Falling',
      GlucoseTrend.rapidlyFalling => 'Rapidly Falling',
    };
  }
}
