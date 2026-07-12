import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_colors.dart';

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
    final currentLocale = Localizations.localeOf(context).languageCode;
    final isHindiActive = currentLocale == 'hi';

    // If English-only is forced or Hindi text is absent
    if (hindiText == null || hindiText!.isEmpty) {
      return Text(
        englishText,
        style: englishStyle ?? AppTypography.bodyMd.copyWith(color: AppColorsDark.textPrimary),
      );
    }

    final TextStyle baseEnglishStyle = englishStyle ?? AppTypography.bodyMd.copyWith(
      color: AppColorsDark.textPrimary,
    );

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // English primary label
        Text(
          englishText,
          style: isHindiActive 
              ? baseEnglishStyle.copyWith(color: AppColorsDark.textSecondary) // Mute English if user set Hindi
              : baseEnglishStyle,
        ),
        const SizedBox(height: 2.0),
        // Hindi secondary sub-label
        Text(
          hindiText!,
          style: AppTypography.hindi(
            size: baseEnglishStyle.fontSize != null 
                ? baseEnglishStyle.fontSize! * hindiFontSizeScale 
                : 12.0,
            weight: isHindiActive ? FontWeight.bold : FontWeight.w400,
          ).copyWith(
            color: isHindiActive 
                ? AppColorsDark.textPrimary 
                : AppColorsDark.textMuted,
          ),
        ),
      ],
    );
  }
}
