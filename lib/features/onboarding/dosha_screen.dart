import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/onboarding/dosha_controller.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';

class DoshaScreen extends ConsumerStatefulWidget {
  const DoshaScreen({super.key});

  @override
  ConsumerState<DoshaScreen> createState() => _DoshaScreenState();
}

class _DoshaScreenState extends ConsumerState<DoshaScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(String questionId, DoshaType type, int index) {
    final notifier = ref.read(onboardingDoshaProvider.notifier);
    notifier.selectOption(questionId, type);

    if (index < doshaQuestions.length - 1) {
      notifier.nextQuestion();
      _pageController.animateToPage(
        index + 1,
        duration: const Duration(milliseconds: 300),
        curve: AppSprings.smoothAnimationCurve,
      );
    } else {
      notifier.calculateResult();
    }
  }

  void _onBack(int index) {
    final notifier = ref.read(onboardingDoshaProvider.notifier);
    if (index > 0) {
      notifier.previousQuestion();
      _pageController.animateToPage(
        index - 1,
        duration: const Duration(milliseconds: 300),
        curve: AppSprings.smoothAnimationCurve,
      );
    } else {
      final prev = ref.read(onboardingFlowProvider.notifier).back();
      if (prev != null && mounted) {
        context.go(pathForStep(prev));
      }
    }
  }

  Future<void> _onSaveAndContinue() async {
    final db = ref.read(databaseProvider);
    final notifier = ref.read(onboardingDoshaProvider.notifier);
    
    // Save to local database with a stub user ID for onboarding
    await notifier.saveToDb(db, 'onboarding_user');
    
    if (mounted) {
      final next = ref.read(onboardingFlowProvider.notifier).advance();
      if (next != null) {
        context.go(pathForStep(next));
      } else {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  void _onSkip() {
    final next = ref.read(onboardingFlowProvider.notifier).skip();
    if (next != null && mounted) {
      context.go(pathForStep(next));
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColorsDark.bg0 : AppColorsDark.bg0; // fallback to dark
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsDark.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsDark.textSecondary;

    final quizState = ref.watch(onboardingDoshaProvider);
    final showResult = quizState.result != null;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showResult
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => _onBack(quizState.activeQuestionIndex),
              ),
        actions: [
          if (!showResult && canSkip(OnboardingStep.dosha))
            TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: AppTypography.bodyMd.copyWith(color: AppColorsDark.primary),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Onboarding funnel progress indicator
            const OnboardingProgressIndicator(
              currentStep: 3,
              totalSteps: 5,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: AppSprings.smoothAnimationCurve,
                child: showResult
                    ? _buildResultView(quizState.result!, textPrimary, textSecondary)
                    : _buildQuizView(quizState, textPrimary, textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizView(DoshaQuizState quizState, Color textPrimary, Color textSecondary) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doshaQuestions.length,
      itemBuilder: (context, index) {
        final q = doshaQuestions[index];
        final selected = quizState.answers[q.id];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Progress Indicator
              Text(
                'Question ${index + 1} of ${doshaQuestions.length}',
                style: AppTypography.labelLg.copyWith(color: AppColorsDark.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Question text
              BilingualLabel(
                englishText: q.question,
                hindiText: q.questionHindi,
                englishStyle: AppTypography.displayMd.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                alignment: CrossAxisAlignment.center,
              ),
              const SizedBox(height: 32),
              // Options list
              ...q.options.map((opt) {
                final isSelected = selected == opt.associatedDosha;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: BentoCard(
                    onTap: () => _onOptionSelected(q.id, opt.associatedDosha, index),
                    customBgColor: isSelected
                        ? AppColorsDark.primaryMuted
                        : AppColorsDark.glass,
                    hasSecondaryGlow: isSelected,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BilingualLabel(
                          englishText: opt.text,
                          hindiText: opt.textHindi,
                          englishStyle: AppTypography.h3.copyWith(
                            color: isSelected ? AppColorsDark.primary : textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultView(DoshaResult result, Color textPrimary, Color textSecondary) {
    Color dominantColor = AppColorsDark.primary;
    String displayDominant = "Vata";
    if (result.dominant == DoshaType.pitta) {
      dominantColor = AppColorsDark.primary; // Pitta: Fire -> Primary Orange
      displayDominant = "Pitta";
    } else if (result.dominant == DoshaType.kapha) {
      dominantColor = AppColorsDark.teal; // Kapha: Earth/Water -> Teal
      displayDominant = "Kapha";
    } else {
      dominantColor = AppColorsDark.secondary; // Vata: Air/Space -> Indigo
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your Ayurvedic Profile',
            style: AppTypography.h3.copyWith(color: AppColorsDark.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            displayDominant.toUpperCase(),
            style: AppTypography.heroDisplay.copyWith(
              color: dominantColor,
              shadows: [
                Shadow(
                  color: dominantColor.withValues(alpha: 0.4),
                  blurRadius: 18,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Percentage Breakdown Bento Grid
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dosha Distribution',
                  style: AppTypography.h2.copyWith(color: textPrimary),
                ),
                const SizedBox(height: 16),
                _buildDoshaBar('Vata (Air/Space)', result.vataPct, AppColorsDark.secondary),
                const SizedBox(height: 12),
                _buildDoshaBar('Pitta (Fire/Water)', result.pittaPct, AppColorsDark.primary),
                const SizedBox(height: 12),
                _buildDoshaBar('Kapha (Water/Earth)', result.kaphaPct, AppColorsDark.teal),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Guidelines Dietary
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restaurant_rounded, color: AppColorsDark.teal),
                    const SizedBox(width: 8),
                    Text(
                      'Dietary Focus',
                      style: AppTypography.h3.copyWith(color: textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.guidelines.dietaryFocus,
                  style: AppTypography.bodyMd.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Guidelines Stress
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.spa_rounded, color: AppColorsDark.secondary),
                    const SizedBox(width: 8),
                    Text(
                      'Stress Management',
                      style: AppTypography.h3.copyWith(color: textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.guidelines.stressFocus,
                  style: AppTypography.bodyMd.copyWith(color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Guidelines Spices
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColorsDark.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Recommended Spices',
                      style: AppTypography.h3.copyWith(color: textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: result.guidelines.recommendedSpices.map((spice) {
                    return Chip(
                      label: Text(spice),
                      backgroundColor: AppColorsDark.surface1,
                      labelStyle: AppTypography.labelLg.copyWith(color: textPrimary),
                      side: const BorderSide(color: AppColorsDark.glassBorder),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FitButton(
            onPressed: _onSaveAndContinue,
            child: const Text('Save and Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaBar(String label, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMd.copyWith(color: Colors.white)),
            Text('${pct.toStringAsFixed(1)}%', style: AppTypography.bodyLg.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColorsDark.surface2,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (pct / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
