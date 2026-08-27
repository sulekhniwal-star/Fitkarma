import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/proactive_insight_engine.dart';

class ProactiveInsightCard extends StatelessWidget {
  final ProactiveInsight insight;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const ProactiveInsightCard({
    super.key,
    required this.insight,
    this.onAction,
    this.onDismiss,
  });

  Color _getUrgencyColor(InsightUrgency urgency) {
    switch (urgency) {
      case InsightUrgency.alert:
        return AppColors.alertRed;
      case InsightUrgency.high:
        return AppColors.energyOrange;
      case InsightUrgency.medium:
        return AppColors.focusBlue;
      case InsightUrgency.low:
        return AppColors.aiPurple;
    }
  }

  IconData _getTypeIcon(InsightType type) {
    switch (type) {
      case InsightType.milestonePr:
        return Icons.emoji_events_rounded;
      case InsightType.sleepDeficit:
        return Icons.bedtime_rounded;
      case InsightType.environmentalAlert:
        return Icons.warning_rounded;
      case InsightType.nutritionDeficit:
        return Icons.restaurant_rounded;
      case InsightType.circadianWindDown:
        return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor(insight.urgency);

    return BentoCard(
      hasGlow: insight.urgency == InsightUrgency.alert || insight.urgency == InsightUrgency.high,
      glowColor: urgencyColor,
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(
        color: urgencyColor.withValues(alpha: 0.5),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: urgencyColor.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: Icon(_getTypeIcon(insight.type), color: urgencyColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  BilingualLabel(
                    primaryText: insight.title,
                    regionalText: insight.regionalTitle,
                    primaryStyle: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (onDismiss != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                  onPressed: onDismiss,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            insight.message,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: urgencyColor.withValues(alpha: 0.12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
              ),
              icon: Icon(Icons.arrow_forward_rounded, size: 14, color: urgencyColor),
              label: Text(
                insight.actionLabel,
                style: TextStyle(
                  color: urgencyColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              onPressed: onAction,
            ),
          ),
        ],
      ),
    );
  }
}
