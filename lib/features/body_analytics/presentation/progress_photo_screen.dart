import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/progress_photo_models.dart';
import 'providers/progress_photo_provider.dart';

/// Screen displaying Encrypted Transformation Photo Vault,
/// Side-by-Side Milestone Comparisons, and Ghost Overlay Capture.
class ProgressPhotoScreen extends ConsumerWidget {
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(progressPhotoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Transformation Photo Vault',
          regionalText: 'प्रगति व शारीरिक परिवर्तन फोटो वॉल्ट',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline, color: AppColors.karmaGreen),
            tooltip: 'AES-256 Encrypted Vault',
            onPressed: () => _showVaultSecurityModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Progress Stats Bento Card
            _buildHeroStatsCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Action: Capture New Milestone Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.focusBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                ),
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                label: const Text(
                  'Capture New Milestone Photo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: () => _showCaptureModal(context, ref),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 3. Active Before & After Visual Comparison Card
            if (report.activeComparison != null) ...[
              const BilingualLabel(
                primaryText: 'Visual Transformation Comparison',
                regionalText: 'तुलनात्मक परिवर्तन विश्लेषण',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildComparisonCard(report.activeComparison!),
              const SizedBox(height: AppSpacing.md),
            ],

            // 4. Milestone Timeline Gallery
            const BilingualLabel(
              primaryText: 'Transformation Photo Timeline',
              regionalText: 'समयानुसार फोटो गैलरी',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPhotoEntryCard(context, ref, entry, report.entries),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStatsCard(ProgressPhotoTimelineReport report) {
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
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.enhanced_encryption, color: AppColors.karmaGreen, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Encrypted Local Vault',
                      style: TextStyle(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${report.totalPhotosCaptured} Captures • ${report.totalDaysTracked} Days',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
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
                label: 'Weight Loss',
                value: '-${report.totalWeightLossKg.abs()}',
                unit: 'kg',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Body Fat Reduction',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '-${report.totalBodyFatLossPercent.abs()}% Body Fat',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Zero Unencrypted Cloud Egress',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(ComparativePhotoPair comp) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${comp.daysElapsed}-Day Comparison',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${comp.weightDeltaKg > 0 ? "+" : ""}${comp.weightDeltaKg} kg | ${comp.bodyFatDeltaPercent > 0 ? "+" : ""}${comp.bodyFatDeltaPercent}% BF',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              // Before Photo Mock Silhouette
              Expanded(
                child: _buildComparisonPhotoTile(
                  label: 'BEFORE (${comp.beforePhoto.milestoneTag.name})',
                  date: '${comp.beforePhoto.capturedAt.day}/${comp.beforePhoto.capturedAt.month}/${comp.beforePhoto.capturedAt.year}',
                  weight: '${comp.beforePhoto.weightKgAtCapture} kg',
                  fat: '${comp.beforePhoto.bodyFatPercentAtCapture}% BF',
                  color: AppColors.surfaceElevated,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // After Photo Mock Silhouette
              Expanded(
                child: _buildComparisonPhotoTile(
                  label: 'AFTER (${comp.afterPhoto.milestoneTag.name})',
                  date: '${comp.afterPhoto.capturedAt.day}/${comp.afterPhoto.capturedAt.month}/${comp.afterPhoto.capturedAt.year}',
                  weight: '${comp.afterPhoto.weightKgAtCapture} kg',
                  fat: '${comp.afterPhoto.bodyFatPercentAtCapture}% BF',
                  color: AppColors.focusBlue.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comp.transformationSummary,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comp.regionalTransformationSummary,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonPhotoTile({
    required String label,
    required String date,
    required String weight,
    required String fat,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.surfaceElevatedHigh),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadii.radiusSm,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.accessibility_new, size: 54, color: AppColors.focusBlue),
                SizedBox(height: 4),
                Text('Encrypted Photo', style: TextStyle(color: AppColors.textSecondary, fontSize: 9)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$date • $weight • $fat',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoEntryCard(
    BuildContext context,
    WidgetRef ref,
    ProgressPhotoEntry entry,
    List<ProgressPhotoEntry> allEntries,
  ) {
    return BentoCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: const Icon(Icons.photo_camera_back, color: AppColors.focusBlue, size: 28),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.milestoneTag.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${entry.capturedAt.day}/${entry.capturedAt.month}/${entry.capturedAt.year}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${entry.weightKgAtCapture} kg • ${entry.bodyFatPercentAtCapture}% BF • ${entry.poseAngle.name}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (entry.userNotes != null)
                  Text(
                    entry.userNotes!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.karmaGreen,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.compare_arrows, color: AppColors.focusBlue, size: 20),
            tooltip: 'Compare with Day 1',
            onPressed: () {
              ref.read(progressPhotoProvider.notifier).selectComparison(allEntries.first, entry);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Comparing ${allEntries.first.milestoneTag.name} vs ${entry.milestoneTag.name}'),
                  backgroundColor: AppColors.focusBlue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCaptureModal(BuildContext context, WidgetRef ref) {
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
                primaryText: 'Ghost Overlay Photo Capture',
                regionalText: 'समान कोण व मुद्रा अनुसार फोटो खींचें',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma displays a translucent ghost silhouette of your baseline photo to ensure consistent standing posture, distance, and framing.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '• Stand 2 meters from camera at eye level\n• Same lighting conditions for reliable shadows\n• Encrypted immediately upon capture in local vault',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.camera, color: Colors.white),
                  label: const Text('Simulate Front Pose Capture', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    ref.read(progressPhotoProvider.notifier).addPhotoEntry(
                          poseAngle: PhotoPoseAngle.front,
                          weightKg: 73.9,
                          bodyFatPercent: 14.2,
                          waistCm: 79.5,
                          milestoneTag: MilestonePhaseTag.recomposition,
                          userNotes: 'New checkpoint: 14.2% Body Fat reached!',
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo encrypted and stored in local vault!'),
                        backgroundColor: AppColors.karmaGreen,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVaultSecurityModal(BuildContext context) {
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
                primaryText: 'Photo Vault Privacy Architecture',
                regionalText: 'गोपनीय फोटो सुरक्षा ढांचा',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'All transformation photos are encrypted using on-device AES-256 keys tied to your biometric secure enclave. FitKarma never uploads unencrypted visual media to external servers.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
