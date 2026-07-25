// lib/shared/widgets/daily_briefing_card.dart
// §P0-D2 — Daily Intelligence Package summary card.
// Rule of Two: gradient + shadow (no glow, no blur overlay).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Displays the top-level summary from the Daily Intelligence Package on the dashboard.
class DailyBriefingCard extends StatelessWidget {
  const DailyBriefingCard({
    super.key,
    required this.mission,
    required this.primaryInsight,
    required this.nutritionFocus,
    required this.recoveryFocus,
    this.onTap,
  });

  final String mission;
  final String primaryInsight;
  final String nutritionFocus;
  final String recoveryFocus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardH),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.bentoHero),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColorsDark.surface1,
              AppColorsDark.surface0,
            ],
          ),
          border: Border.all(color: AppColorsDark.glassBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColorsDark.secondary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 15, color: AppColorsDark.secondary),
                const SizedBox(width: 6),
                Text(
                  'TODAY\'S INTELLIGENCE',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColorsDark.secondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mission
            Text(
              mission,
              style: AppTypography.h2.copyWith(color: AppColorsDark.textPrimary),
            ),
            const SizedBox(height: 12),
            // Primary insight
            Text(
              primaryInsight,
              style: AppTypography.bodyMd.copyWith(
                color: AppColorsDark.textSecondary,
                height: 1.6,
              ),
            ),
            const Divider(color: AppColorsDark.divider, height: 24),
            // Focus pills
            Row(
              children: [
                _FocusPill(
                  icon: Icons.restaurant_outlined,
                  label: nutritionFocus,
                  color: AppColorsDark.accent,
                ),
                const SizedBox(width: 10),
                _FocusPill(
                  icon: Icons.bedtime_outlined,
                  label: recoveryFocus,
                  color: AppColorsDark.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusPill extends StatelessWidget {
  const _FocusPill({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(icon, size: 12, color: color),
            Flexible(
              child: Text(
                label,
                style: AppTypography.bodySm.copyWith(color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
