// lib/shared/widgets/empty_state.dart
// §P0-D2 — Empty state with illustration + CTA.
// Rule of Two: gradient + shadow (no glow, no blur).
// Anti-pattern: never show before first data load — use ShimmerLoader during load.

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Empty state display with an icon illustration, title, body text, and optional CTA button.
/// Only show AFTER data has loaded and returned empty — never as a loading placeholder.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCta,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColorsDark.textMuted;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustrated icon with subtle circle background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.12),
                    color.withOpacity(0.04),
                  ],
                ),
              ),
              child: Icon(icon, size: 36, color: color.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTypography.h2.copyWith(color: AppColorsDark.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: AppTypography.bodyMd.copyWith(
                color: AppColorsDark.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onCta,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColorsDark.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(ctaLabel!, style: AppTypography.h3.copyWith(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
