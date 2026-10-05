import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/app_language.dart';
import '../localization/indian_translations.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// BilingualLabel — Multi-Regional Localized rendering widget for FitKarma UI.
/// Adapts dynamically according to the user's chosen Indian language:
/// - Supports 10 Indian regional languages (Hindi, Tamil, Telugu, Kannada, Malayalam, Marathi, Bengali, Gujarati, Punjabi, Hinglish) + English & Bilingual.
class BilingualLabel extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);

    final defaultPrimary = primaryStyle ??
        AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        );

    final defaultSecondary = secondaryStyle ?? AppTypography.bilingualSub;

    // Look up translation for current language
    final regionalText = IndianTranslations.translate(english, language) ??
        (language == AppLanguage.hindi ? (hindi ?? english) : english);

    switch (language) {
      case AppLanguage.english:
      case AppLanguage.hinglish:
        return Text(
          english,
          style: defaultPrimary,
          textAlign: crossAxisAlignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
        );

      case AppLanguage.bilingual:
        final subText = hindi ?? regionalText;
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              english,
              style: defaultPrimary,
            ),
            if (showSecondary && subText.isNotEmpty && subText != english) ...[
              const SizedBox(height: 2),
              Text(
                subText,
                style: defaultSecondary,
              ),
            ],
          ],
        );

      default:
        // Regional Indian Languages: Hindi, Tamil, Telugu, Kannada, Malayalam, Marathi, Bengali, Gujarati, Punjabi
        return Text(
          regionalText,
          style: defaultPrimary,
          textAlign: crossAxisAlignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
        );
    }
  }
}
