import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/wearable_merge_engine.dart';

class WearableComparisonScreen extends StatelessWidget {
  const WearableComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock incoming multi-device conflict state
    final now = DateTime.now();

    final hrvSamples = [
      WearableSample(
        id: 's_1',
        source: WearableBrand.whoop,
        metric: MetricType.hrv,
        value: 62.0,
        recordedAt: now.subtract(const Duration(hours: 4)),
        syncedAt: now.subtract(const Duration(minutes: 15)),
      ),
      WearableSample(
        id: 's_2',
        source: WearableBrand.appleWatch,
        metric: MetricType.hrv,
        value: 58.0,
        recordedAt: now.subtract(const Duration(hours: 3)),
        syncedAt: now.subtract(const Duration(hours: 2)),
      ),
      WearableSample(
        id: 's_3',
        source: WearableBrand.noiseBoat,
        metric: MetricType.hrv,
        value: 45.0,
        recordedAt: now.subtract(const Duration(hours: 5)),
        syncedAt: now.subtract(const Duration(hours: 1)),
      ),
    ];

    final sleepSamples = [
      WearableSample(
        id: 's_4',
        source: WearableBrand.oura,
        metric: MetricType.sleep,
        value: 7.6,
        recordedAt: now.subtract(const Duration(hours: 8)),
        syncedAt: now.subtract(const Duration(hours: 1)),
      ),
      WearableSample(
        id: 's_5',
        source: WearableBrand.appleWatch,
        metric: MetricType.sleep,
        value: 7.2,
        recordedAt: now.subtract(const Duration(hours: 8)),
        syncedAt: now.subtract(const Duration(hours: 3)),
      ),
    ];

    final hrvResolution = WearableMergeEngine.resolveMetricConflict(
      metric: MetricType.hrv,
      incomingSamples: hrvSamples,
    );

    final sleepResolution = WearableMergeEngine.resolveMetricConflict(
      metric: MetricType.sleep,
      incomingSamples: sleepSamples,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Smart Wearables & Sync Matrix',
          regionalText: 'स्मार्ट वियरेबल्स एवं डेटा एकीकरण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Device Confidence Architecture Banner
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.focusBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.hub_rounded, color: AppColors.focusBlue, size: 20),
                        SizedBox(width: 8),
                        BilingualLabel(
                          primaryText: 'Device Confidence Matrix',
                          regionalText: 'स्वचालित स्रोत प्राथमिकता प्रणाली',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'FitKarma automatically resolves multi-device conflicts. Higher tier sensors (optical photoplethysmography & chest straps) supersede consumer pedometers and late syncs without duplicate counting.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Active Authoritative Streams Bento Grid
              const Text(
                'AUTHORITATIVE ACTIVE METRICS (सक्रिय प्राथमिक स्रोत)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              _buildResolutionCard(
                'Autonomic HRV (RMSSD)',
                '${hrvResolution.authoritativeValue.round()} ms',
                hrvResolution.selectedSource.name,
                hrvResolution.confidenceScore,
                hrvResolution.resolutionReason,
                AppColors.karmaGreen,
                hrvResolution.candidateSamples,
              ),
              const SizedBox(height: AppSpacing.sm),

              _buildResolutionCard(
                'Sleep Duration & Stages',
                '${hrvResolution.authoritativeValue > 0 ? sleepResolution.authoritativeValue : 7.6} hrs',
                sleepResolution.selectedSource.name,
                sleepResolution.confidenceScore,
                sleepResolution.resolutionReason,
                AppColors.aiPurple,
                sleepResolution.candidateSamples,
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Connected Devices Matrix
              const Text(
                'CONNECTED SENSOR HIERARCHY (संबद्ध डिवाइस सूची)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              BentoCard(
                child: Column(
                  children: [
                    _buildDeviceRow('WHOOP 4.0', 'Primary HRV & Recovery', 0.95, AppColors.karmaGreen),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    _buildDeviceRow('Oura Ring Gen 3', 'Primary Sleep Architecture', 0.98, AppColors.aiPurple),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    _buildDeviceRow('Apple Watch Ultra', 'Primary Steps & Workouts', 0.95, AppColors.focusBlue),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    _buildDeviceRow('Health Connect / Phone', 'Backup Pedometer', 0.85, AppColors.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResolutionCard(
    String title,
    String value,
    String sourceName,
    double confidence,
    String reason,
    Color accentColor,
    List<WearableSample> candidates,
  ) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${(confidence * 100).round()}% CONFIDENCE',
                  style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              GlowingMetric(label: 'Selected Value', value: value, accentColor: accentColor),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Source: $sourceName', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(reason, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${candidates.length} sources evaluated', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                const Text('Conflict Resolved', style: TextStyle(fontSize: 11, color: AppColors.karmaGreen, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String name, String role, double confidence, Color dotColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                Text(role, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
        Text('${(confidence * 100).round()}% Tier', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
