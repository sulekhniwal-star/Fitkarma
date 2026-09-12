import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // Glowing App Icon / Emblem
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.readinessGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withAlpha(120),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                size: 54,
                color: AppColors.background,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'FITKARMA',
            textAlign: TextAlign.center,
            style: AppTypography.heroMetric.copyWith(
              letterSpacing: 4.0,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: BilingualLabel(
              english: "India's Intelligent Health Operating System",
              hindi: 'भारत का संपूर्ण बुद्धिमान स्वास्थ्य ऑपरेटिंग सिस्टम',
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          const SizedBox(height: 36),
          // Value Propositions Bento
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureRow(Icons.offline_bolt_rounded, '100% Offline-First Resilience', 'बिना इंटरनेट के भी संपूर्ण डेटा ट्रैकिंग'),
                const Divider(height: 20),
                _buildFeatureRow(Icons.restaurant_menu_rounded, '500+ Indian Nutrition Database', 'भारतीय आहार और आयुर्वेदिक सामंजस्य'),
                const Divider(height: 20),
                _buildFeatureRow(Icons.auto_awesome_rounded, 'Daily Intelligence Package (DIP)', 'दैनिक अनुकूलित स्वास्थ्य योजना'),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: Text(
              'Get Started  •  शुरुआत करें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryCyan, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: BilingualLabel(
            english: title,
            hindi: subtitle,
            primaryStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            secondaryStyle: AppTypography.bilingualSub,
          ),
        ),
      ],
    );
  }
}
