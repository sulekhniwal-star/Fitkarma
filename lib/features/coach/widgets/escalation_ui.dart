import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/escalation_service.dart';
import '../providers/escalation_provider.dart';

/// §P3-D Elite Tier "Talk to a Human Coach" button for Coach screen AppBar
class EscalateToHumanCoachButton extends ConsumerWidget {
  const EscalateToHumanCoachButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(escalationProvider);

    if (state.isEscalated) {
      return Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 5),
              Text('Coach Notified',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.success, fontSize: 10)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: TextButton.icon(
        icon: const Icon(Icons.support_agent,
            color: AppColors.warning, size: 16),
        label: Text(
          'Human Coach',
          style: AppTypography.labelMd
              .copyWith(color: AppColors.warning, fontSize: 11),
        ),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.warning.withValues(alpha: 0.12),
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: AppColors.warning.withValues(alpha: 0.4)),
          ),
        ),
        onPressed: () => _showEscalationSheet(context, ref),
      ),
    );
  }

  Future<void> _showEscalationSheet(BuildContext ctx, WidgetRef ref) async {
    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(ctx),
        child: const _EscalationBottomSheet(),
      ),
    );
  }
}

// ── Escalation Bottom Sheet ───────────────────────────────────────────────────

class _EscalationBottomSheet extends ConsumerWidget {
  const _EscalationBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(escalationProvider);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Elite badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppColors.warning, size: 14),
                  const SizedBox(width: 5),
                  Text('ELITE TIER FEATURE',
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.warning, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Coach icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.3),
                    AppColors.warning.withValues(alpha: 0.05),
                  ],
                ),
                border:
                    Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.support_agent,
                  color: AppColors.warning, size: 32),
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              'Talk to a Human Coach',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(
              'Your health coach will review your full plan and respond within 24 hours via in-app message.',
              style: AppTypography.bodyMd.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),

            // What gets shared
            _WhatGetsSharedCard(),
            const SizedBox(height: AppSpacing.xl),

            // Error
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  state.errorMessage!,
                  style:
                      AppTypography.bodyMd.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ),

            // CTA buttons
            if (state.isPending)
              const _LoadingButton()
            else ...[
              SizedBox(
                width: double.infinity,
                child: _RequestReviewButton(
                  onTap: () async {
                    await ref
                        .read(escalationProvider.notifier)
                        .requestHumanCoach(
                          userId: 'user_current',
                          userName: 'You',
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.glassBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.buttonRadius),
                    ),
                  ),
                  child: Text(
                    'Continue with AI Coach',
                    style:
                        AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhatGetsSharedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.glassBgMid,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What your coach will receive:',
            style: AppTypography.labelLg.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...[
            '📊 7-day health summary & readiness trends',
            '🎯 Goal progress vs program milestones',
            '🍽️ Nutrition adherence & macro data',
            '💤 Sleep debt & recovery status',
            '💬 Recent AI conversation highlights',
          ].map((item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodyMd,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _RequestReviewButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RequestReviewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          gradient: const LinearGradient(
            colors: [AppColors.warning, Color(0xFFFF8C00)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warning.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '📞  Request Coach Review',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  const _LoadingButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: AppColors.glassBgMid,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.warning,
          ),
        ),
      ),
    );
  }
}

// ── Escalation Success Banner ─────────────────────────────────────────────────

class EscalationSuccessBanner extends StatelessWidget {
  final EscalationResult result;
  const EscalationSuccessBanner({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: AppColors.success, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.userNotificationTitle,
                    style:
                        AppTypography.labelLg.copyWith(color: AppColors.success)),
                Text(result.userNotificationBody, style: AppTypography.bodyMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
