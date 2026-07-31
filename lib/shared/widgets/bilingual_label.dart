import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';

class BilingualLabel extends StatelessWidget {
  final String englishText;
  final String? hindiText;
  final TextStyle? englishStyle;
  final double hindiFontSizeScale;
  final CrossAxisAlignment alignment;

  const BilingualLabel({
    super.key,
    required this.englishText,
    this.hindiText,
    this.englishStyle,
    this.hindiFontSizeScale = 0.85,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    // For now, let's assume english is primary unless specified. 
    // In a real app, we would use Localizations.localeOf(context).
    const isHindiActive = false; 

    if (hindiText == null || hindiText!.isEmpty) {
      return Text(
        englishText,
        style: englishStyle ?? AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
      );
    }

    final TextStyle baseEnglishStyle = englishStyle ?? AppTypography.bodyMd.copyWith(
      color: AppColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          englishText,
          style: isHindiActive 
              ? baseEnglishStyle.copyWith(color: AppColors.textSecondary)
              : baseEnglishStyle,
        ),
        const SizedBox(height: 2.0),
        Text(
          hindiText!,
          style: AppTypography.hindi(
            size: baseEnglishStyle.fontSize != null 
                ? baseEnglishStyle.fontSize! * hindiFontSizeScale 
                : 12.0,
            weight: isHindiActive ? FontWeight.bold : FontWeight.w400,
          ).copyWith(
            color: isHindiActive 
                ? AppColors.textPrimary 
                : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
