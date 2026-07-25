// lib/shared/widgets/insight_card.dart
// §P0-D2 — AI insight display card.
// Rule of Two: gradient border + shadow (no glow/blur stacking).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// Displays a personalized AI insight from the Daily Intelligence Package.
/// Features an animated gradient border that subtly pulses.
class InsightCard extends StatefulWidget {
  const InsightCard({
    super.key,
    required this.insight,
    this.icon,
    this.accentColor,
    this.onTap,
    this.label = 'Today\'s Insight',
  });

  final String insight;
  final IconData? icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final String label;

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? AppColorsDark.secondary;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.25 * _pulse.value),
                AppColorsDark.surface0,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: accent.withOpacity(0.30 * _pulse.value),
              width: 1.2,
            ),
          ),
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon ?? Icons.auto_awesome_rounded,
                    size: 14,
                    color: AppColorsDark.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label.toUpperCase(),
                    style: AppTypography.labelMd.copyWith(
                      color: AppColorsDark.secondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.insight,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColorsDark.textPrimary,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
