import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';

class LanguageSelectionStep extends ConsumerWidget {
  final VoidCallback onNext;

  const LanguageSelectionStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    final supportedLanguages = [
      AppLanguage.english,
      AppLanguage.hindi,
      AppLanguage.hinglish,
      AppLanguage.tamil,
      AppLanguage.telugu,
      AppLanguage.marathi,
      AppLanguage.bengali,
      AppLanguage.gujarati,
      AppLanguage.punjabi,
      AppLanguage.kannada,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.translate_rounded, color: AppColors.primaryCyan, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose Your Language', style: AppTypography.h2),
                    Text(
                      'अपनी पसंदीदा भाषा चुनें',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'FitKarma adapts voice logging, coach instructions, and meal suggestions to your chosen tongue.',
            style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: supportedLanguages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                final isSelected = currentLanguage == lang;

                return BentoCard(
                  onTap: () {
                    ref.read(appLanguageProvider.notifier).setLanguage(lang);
                  },
                  isGlowing: isSelected,
                  glowColor: AppColors.primaryCyan,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  lang.nativeLabel,
                                  style: AppTypography.h3.copyWith(
                                    color: isSelected ? AppColors.primaryCyan : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${lang.label})',
                                  style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${lang.region} • ${lang.subLabel}',
                              style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primaryCyan : AppColors.textMuted,
                        size: 22,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                foregroundColor: AppColors.textOnAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onNext,
              child: Text(
                'Continue / आगे बढ़ें',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
