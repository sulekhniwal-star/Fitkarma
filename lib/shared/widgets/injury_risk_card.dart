import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/bento_card.dart';
import '../../core/brain/injury_risk_engine.dart';

/// §P10-D Injury Risk UI Card Widget
class InjuryRiskCard extends StatelessWidget {
  final List<InjuryRiskAlert> alerts;

  const InjuryRiskCard({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return BentoCard(
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined,
                color: AppColors.success, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No Active Injury Risks',
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.success)),
                  Text(
                      'All movement patterns & volumes operating in safe zones.',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 24),
              const SizedBox(width: 8),
              Text('⚠️ Injury Risk Alerts', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final alert in alerts)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: alert.risk == InjuryRiskLevel.high
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: alert.risk == InjuryRiskLevel.high
                        ? AppColors.error.withValues(alpha: 0.3)
                        : AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${alert.risk == InjuryRiskLevel.high ? "🔴" : "🟡"} ${alert.region} — ${alert.risk == InjuryRiskLevel.high ? "High Risk" : "Moderate Risk"}',
                          style: AppTypography.labelLg.copyWith(
                            color: alert.risk == InjuryRiskLevel.high
                                ? AppColors.error
                                : AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(alert.message,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('Actions:',
                        style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    for (final action in alert.actions)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                          Expanded(
                            child: Text(action,
                                style: AppTypography.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ),
                        ],
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
