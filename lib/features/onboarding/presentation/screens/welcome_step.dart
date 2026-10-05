import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/indian_translations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class WelcomeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Glowing App Icon / Emblem
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.readinessGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withAlpha(120),
                    blurRadius: 28,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                size: 48,
                color: AppColors.background,
              ),
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),

          Text(
            'FITKARMA',
            textAlign: TextAlign.center,
            style: AppTypography.heroMetric.copyWith(
              letterSpacing: 4.0,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 6),

          const Center(
            child: BilingualLabel(
              english: "India's Intelligent Health Operating System",
              hindi: 'भारत का संपूर्ण बुद्धिमान स्वास्थ्य ऑपरेटिंग सिस्टम',
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          const SizedBox(height: 24),

          // 1. Language Selection Bento Card
          BentoCard(
            isGlowing: true,
            glowColor: AppColors.primaryCyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language_rounded, color: AppColors.primaryCyan, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Choose Your App Language',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'भाषा चुनें • You can change this anytime',
                  style: AppTypography.label.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 14),

                // Language Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: AppLanguage.values.map((lang) {
                    final isSelected = currentLanguage == lang;
                    return InkWell(
                      onTap: () {
                        ref.read(appLanguageProvider.notifier).setLanguage(lang);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryCyan.withAlpha(35)
                              : AppColors.surfaceGlass,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryCyan
                                : AppColors.borderGlass,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang.flag, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.nativeLabel,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primaryCyan
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    lang.subLabel,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primaryCyan.withAlpha(200)
                                          : AppColors.textMuted,
                                      fontSize: 9,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: AppColors.primaryCyan,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 16),

          // 2. Value Propositions Bento
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureRow(
                  Icons.offline_bolt_rounded,
                  '100% Offline-First Resilience',
                  'बिना इंटरनेट के भी संपूर्ण डेटा ट्रैकिंग',
                ),
                const Divider(height: 18, color: AppColors.borderGlass),
                _buildFeatureRow(
                  Icons.restaurant_menu_rounded,
                  '500+ Indian Nutrition Database',
                  'भारतीय आहार और आयुर्वेदिक सामंजस्य',
                ),
                const Divider(height: 18, color: AppColors.borderGlass),
                _buildFeatureRow(
                  Icons.auto_awesome_rounded,
                  'Daily Intelligence Package (DIP)',
                  'दैनिक अनुकूलित स्वास्थ्य योजना',
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: Text(
              '${IndianTranslations.translate('Get Started', currentLanguage) ?? 'Get Started'}  →',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryCyan, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: BilingualLabel(
            english: title,
            hindi: subtitle,
            primaryStyle: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            secondaryStyle: AppTypography.bilingualSub,
          ),
        ),
      ],
    );
  }
}
