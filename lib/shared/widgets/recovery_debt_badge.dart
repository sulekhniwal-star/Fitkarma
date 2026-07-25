// lib/shared/widgets/recovery_debt_badge.dart
// §P0-D2 (NEW v1) — Cumulative fatigue (recovery debt) indicator.
// Rule of Two: color + icon (no gradient, no glow).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Indicates cumulative recovery debt — how many high-load days the user
/// has accumulated without adequate recovery.
class RecoveryDebtBadge extends StatelessWidget {
  const RecoveryDebtBadge({
    super.key,
    required this.debtDays,
    this.compact = false,
  });

  /// Number of days of unresolved recovery debt (0 = no debt).
  final int debtDays;
  final bool compact;

  bool get _hasDebt => debtDays > 0;

  Color get _color {
    if (debtDays >= 5) return AppColorsDark.error;
    if (debtDays >= 3) return AppColorsDark.warning;
    if (debtDays >= 1) return AppColorsDark.accent;
    return AppColorsDark.success;
  }

  String get _label {
    if (debtDays == 0) return 'Recovered';
    if (debtDays == 1) return '1-day debt';
    return '${debtDays}-day debt';
  }

  IconData get _icon {
    if (debtDays >= 5) return Icons.warning_amber_rounded;
    if (debtDays >= 1) return Icons.hourglass_bottom_rounded;
    return Icons.check_circle_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(_icon, size: 13, color: color),
          if (!compact)
            Text(_label, style: AppTypography.labelMd.copyWith(color: color)),
        ],
      ),
    );
  }
}
