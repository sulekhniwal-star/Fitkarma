import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../core/brain/habit_identity_engine.dart';
import 'bento_card.dart';

/// §P8-C "You Are Becoming" Card UI Widget
class YouAreBecomingCard extends StatelessWidget {
  final IdentityEvolution evolution;

  const YouAreBecomingCard({
    super.key,
    required this.evolution,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events,
                      color: AppColors.warning, size: 22),
                  const SizedBox(width: 8),
                  Text('🏆 Identity Evolution', style: AppTypography.h3),
                ],
              ),
              if (evolution.isUnlocked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '+${evolution.xpBonus} XP Bonus',
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You are becoming:',
            style:
                AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '🏋️ ${evolution.title}',
            style: AppTypography.h2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            evolution.milestoneText,
            style: AppTypography.bodySm
                .copyWith(color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.md),
          if (evolution.evidenceList.isNotEmpty) ...[
            Text('Evidence:', style: AppTypography.labelLg),
            const SizedBox(height: 4),
            for (final ev in evolution.evidenceList)
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text('  • $ev',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textSecondary)),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bg0,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evolution.quote,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.teal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Next evolution: ${evolution.nextEvolutionPrompt}',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
