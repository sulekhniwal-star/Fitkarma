import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_animations.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/activity_rings.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../providers/onboarding_flow_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSignInTap;

  const WelcomeScreen({
    super.key,
    this.onSignInTap,
  });

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.lg),

            // Hero Brand Emblem with Concentric Activity Rings
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.karmaGreen.withValues(alpha: 0.25),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                const ActivityRings(
                  size: 130,
                  rings: [
                    RingData(
                      progress: 0.90,
                      color: AppColors.karmaGreen,
                      strokeWidth: 8,
                    ),
                    RingData(
                      progress: 0.75,
                      color: AppColors.focusBlue,
                      strokeWidth: 8,
                    ),
                    RingData(
                      progress: 0.60,
                      color: AppColors.energyOrange,
                      strokeWidth: 8,
                    ),
                  ],
                  centerWidget: Icon(
                    Icons.bolt_rounded,
                    color: AppColors.karmaGreen,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // App Title & Bilingual Tagline
            Text(
              'FitKarma',
              style: AppTypography.displayLarge.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const BilingualLabel(
              primaryText: "India's Intelligent Health Operating System",
              regionalText: 'भारत की बुद्धिमान स्वास्थ्य एवं कल्याण प्रणाली',
              alignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // 3 Pillar Bento Value Props
            _buildPillarCard(
              icon: Icons.psychology_rounded,
              iconColor: AppColors.focusBlue,
              title: 'Health OS Brain',
              regionalTitle: 'दैनिक स्वास्थ्य मस्तिष्क',
              description: 'A single orchestrated daily intelligence cycle that adapts your readiness, calories, and training.',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPillarCard(
              icon: Icons.restaurant_menu_rounded,
              iconColor: AppColors.energyOrange,
              title: 'Indian Nutrition Intelligence',
              regionalTitle: 'भारतीय पोषण विश्लेषण',
              description: 'Macro tracking precision for daal, rotis, regional thalis, and festive fasting modes.',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPillarCard(
              icon: Icons.auto_awesome_rounded,
              iconColor: AppColors.aiPurple,
              title: 'Adaptive AI Coaching',
              regionalTitle: 'अनुकूली एआई कोच',
              description: 'Multi-tiered Groq AI models providing real-time form, workout, and recovery guidance.',
            ),
            const SizedBox(height: AppSpacing.xl),

            // Get Started Primary CTA
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: AppRadii.radiusMd,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.karmaGreen.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                ),
                onPressed: () {
                  ref.read(onboardingFlowProvider.notifier).nextStep();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textInverse,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Secondary CTA: Sign In
            TextButton(
              onPressed: widget.onSignInTap,
              child: Text(
                'Already have an account? Sign In',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String regionalTitle,
    required String description,
  }) {
    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
              border: Border.all(color: iconColor.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BilingualLabel(
                  primaryText: title,
                  regionalText: regionalTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
