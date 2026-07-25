// lib/shared/widgets/recovery_badge.dart
// §P0-D2 — Recovery state badge (green/amber/red).
// Rule of Two: color fill + icon (no gradient, no glow).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

enum RecoveryState { recovered, partial, fatigued, overreached }

/// A compact badge indicating the user's current recovery state.
class RecoveryBadge extends StatelessWidget {
  const RecoveryBadge({super.key, required this.state, this.compact = false});

  final RecoveryState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _resolve();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(icon, size: 13, color: color),
          if (!compact)
            Text(label, style: AppTypography.labelMd.copyWith(color: color)),
        ],
      ),
    );
  }

  (Color, IconData, String) _resolve() {
    return switch (state) {
      RecoveryState.recovered => (
          AppColorsDark.success,
          Icons.battery_full_rounded,
          'Recovered'
        ),
      RecoveryState.partial => (
          AppColorsDark.warning,
          Icons.battery_3_bar_rounded,
          'Partial Recovery'
        ),
      RecoveryState.fatigued => (
          AppColorsDark.error,
          Icons.battery_1_bar_rounded,
          'Fatigued'
        ),
      RecoveryState.overreached => (
          AppColorsDark.rose,
          Icons.battery_0_bar_rounded,
          'Overreached'
        ),
    };
  }
}
