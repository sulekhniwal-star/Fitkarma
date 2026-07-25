// lib/shared/widgets/trend_chip.dart
// §P0-D2 — Trend indicator chip (up/down/neutral).
// Rule of Two: gradient + icon only.

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

enum TrendDirection { up, down, neutral }

/// A compact chip showing a metric trend with directional arrow and color coding.
///
/// Usage: show alongside a metric to indicate if it's improving/declining.
class TrendChip extends StatelessWidget {
  const TrendChip({
    super.key,
    required this.direction,
    required this.label,
    this.isPositiveUp = true,
  });

  final TrendDirection direction;
  final String label;

  /// If true (default), upward trend is green; downward is red.
  /// Set to false for metrics where decline is good (e.g. weight on weight-loss program).
  final bool isPositiveUp;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _resolveStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 12, color: color),
          Text(label, style: AppTypography.labelMd.copyWith(color: color)),
        ],
      ),
    );
  }

  (IconData, Color) _resolveStyle() {
    switch (direction) {
      case TrendDirection.up:
        final color = isPositiveUp ? AppColorsDark.success : AppColorsDark.error;
        return (Icons.trending_up_rounded, color);
      case TrendDirection.down:
        final color = isPositiveUp ? AppColorsDark.error : AppColorsDark.success;
        return (Icons.trending_down_rounded, color);
      case TrendDirection.neutral:
        return (Icons.trending_flat_rounded, AppColorsDark.textSecondary);
    }
  }
}
