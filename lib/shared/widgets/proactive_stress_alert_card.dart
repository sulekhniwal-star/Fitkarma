import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/bento_card.dart';
import '../../core/brain/stress_detection_engine.dart';

/// §P10-E Proactive Stress Alert Widget
class ProactiveStressAlertCard extends StatelessWidget {
  final StressAssessment assessment;
  final VoidCallback? onDecompressPressed;

  const ProactiveStressAlertCard({
    super.key,
    required this.assessment,
    this.onDecompressPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (assessment.level == StressLevel.normal) {
      return BentoCard(
        child: Row(
          children: [
            const Icon(Icons.spa_outlined, color: AppColors.teal, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stress Equilibrium Normal', style: AppTypography.labelLg.copyWith(color: AppColors.teal)),
                  Text('Autonomic nervous system operating in optimal range.', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final isHigh = assessment.level == StressLevel.high;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: isHigh ? AppColors.error : AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text('📊 Stress Trending Up', style: AppTypography.h3),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isHigh ? AppColors.error : AppColors.warning).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assessment.level.name.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: isHigh ? AppColors.error : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          Text(
            'Your body data suggests elevated stress over the past 4 days — before you reported it.',
            style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),

          Text('Signals detected:', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          for (final desc in assessment.detectedSignalDescriptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                children: [
                  const Text('  • ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Expanded(
                    child: Text(desc, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.md),
          Text('Today\'s Recommendation:', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              assessment.recommendation,
              style: AppTypography.bodySm.copyWith(color: AppColors.primary, fontSize: 12),
            ),
          ),

          if (onDecompressPressed != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onDecompressPressed,
                icon: const Icon(Icons.self_improvement, color: Colors.white, size: 18),
                label: const Text('Start 20-Min Decompression Session', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
