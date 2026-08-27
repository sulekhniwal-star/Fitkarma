import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum BilingualLayout {
  inline,  // Primary / Regional side by side
  stacked, // Primary on top, Regional below
}

class BilingualLabel extends StatelessWidget {
  final String primaryText; // e.g. "Readiness Score"
  final String regionalText; // e.g. "तैयारी स्कोर"
  final TextStyle? primaryStyle;
  final TextStyle? regionalStyle;
  final BilingualLayout layout;
  final CrossAxisAlignment alignment;

  const BilingualLabel({
    super.key,
    required this.primaryText,
    required this.regionalText,
    this.primaryStyle,
    this.regionalStyle,
    this.layout = BilingualLayout.stacked,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrimaryStyle = primaryStyle ?? AppTypography.titleMedium;
    final effectiveRegionalStyle = regionalStyle ??
        AppTypography.bodySmall.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w400,
        );

    if (layout == BilingualLayout.inline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(primaryText, style: effectivePrimaryStyle),
          const SizedBox(width: 6),
          Text('($regionalText)', style: effectiveRegionalStyle),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Text(primaryText, style: effectivePrimaryStyle),
        const SizedBox(height: 2),
        Text(regionalText, style: effectiveRegionalStyle),
      ],
    );
  }
}
