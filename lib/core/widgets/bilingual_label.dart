import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// BilingualLabel — Bilingual rendering widget for FitKarma UI
/// Renders English text with Hindi subtitle or localized pair per user preference.
class BilingualLabel extends StatelessWidget {
  final String english;
  final String? hindi;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showSecondary;

  const BilingualLabel({
    super.key,
    required this.english,
    this.hindi,
    this.primaryStyle,
    this.secondaryStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.showSecondary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          english,
          style: primaryStyle ?? AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (showSecondary && hindi != null && hindi!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            hindi!,
            style: secondaryStyle ?? AppTypography.bilingualSub,
          ),
        ],
      ],
    );
  }
}
