import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/activity_rings.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/dosha_scoring_engine.dart';
import '../../providers/onboarding_flow_provider.dart';

class DoshaQuizScreen extends ConsumerStatefulWidget {
  const DoshaQuizScreen({super.key});

  @override
  ConsumerState<DoshaQuizScreen> createState() => _DoshaQuizScreenState();
}

class _DoshaQuizScreenState extends ConsumerState<DoshaQuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, DoshaType> _answers = {};
  DoshaScoreResult? _calculatedResult;

  void _selectOption(String questionId, DoshaType dosha) {
    setState(() {
      _answers[questionId] = dosha;

      if (_currentQuestionIndex < DoshaScoringEngine.questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Compute final score
        _calculatedResult = DoshaScoringEngine.calculateScore(_answers);
        ref.read(onboardingFlowProvider.notifier).updateDosha(_calculatedResult!.primaryDosha.name);
      }
    });
  }

  void _retakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers.clear();
      _calculatedResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_calculatedResult != null) {
      return _buildResultView(_calculatedResult!);
    }

    final question = DoshaScoringEngine.questions[_currentQuestionIndex];
    final selectedDosha = _answers[question.id];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Ayurvedic Dosha Quiz',
                      regionalText: 'आयुर्वेदिक प्रकृति परीक्षण',
                    ),
                    Text(
                      '${_currentQuestionIndex + 1}/${DoshaScoringEngine.questions.length}',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Question Box
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        question.regionalQuestion,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Option Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    final isSelected = selectedDosha == option.dosha;

                    final Color doshaColor;
                    switch (option.dosha) {
                      case DoshaType.vata:
                        doshaColor = AppColors.focusBlue;
                        break;
                      case DoshaType.pitta:
                        doshaColor = AppColors.energyOrange;
                        break;
                      case DoshaType.kapha:
                        doshaColor = AppColors.karmaGreen;
                        break;
                    }

                    return BentoCard(
                      hasGlow: isSelected,
                      glowColor: doshaColor,
                      border: Border.all(
                        color: isSelected ? doshaColor : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      onTap: () => _selectOption(question.id, option.dosha),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: doshaColor.withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                            ),
                            child: Text(
                              option.dosha.name.toUpperCase(),
                              style: TextStyle(
                                color: doshaColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.text,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  option.regionalText,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
        if (_currentQuestionIndex > 0)
          TextButton(
            onPressed: () {
              setState(() => _currentQuestionIndex--);
            },
            child: Text(
              'Previous Question',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Widget _buildResultView(DoshaScoreResult result) {
    final Color primaryColor;
    switch (result.primaryDosha) {
      case DoshaType.vata:
        primaryColor = AppColors.focusBlue;
        break;
      case DoshaType.pitta:
        primaryColor = AppColors.energyOrange;
        break;
      case DoshaType.kapha:
        primaryColor = AppColors.karmaGreen;
        break;
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: 'Your Dosha Constitution',
                  regionalText: 'आपकी प्राकृतिक शारीरिक प्रकृति',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Primary Dosha Hero Card
                BentoCard(
                  hasGlow: true,
                  glowColor: primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${result.primaryDosha.name} (${result.primaryDosha.regionalName})',
                                style: AppTypography.titleLarge.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            result.primaryDosha.element,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Secondary: ${result.secondaryDosha.name}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ActivityRings(
                        size: 90,
                        rings: [
                          RingData(
                            progress: result.vataPercent,
                            color: AppColors.focusBlue,
                            strokeWidth: 6,
                          ),
                          RingData(
                            progress: result.pittaPercent,
                            color: AppColors.energyOrange,
                            strokeWidth: 6,
                          ),
                          RingData(
                            progress: result.kaphaPercent,
                            color: AppColors.karmaGreen,
                            strokeWidth: 6,
                          ),
                        ],
                        centerWidget: Icon(
                          Icons.spa_rounded,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Dosha Distribution Pills
                Row(
                  children: [
                    Expanded(
                      child: _buildDoshaBar('Vata (वात)', '${(result.vataPercent * 100).round()}%', AppColors.focusBlue),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildDoshaBar('Pitta (पित्त)', '${(result.pittaPercent * 100).round()}%', AppColors.energyOrange),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildDoshaBar('Kapha (कफ)', '${(result.kaphaPercent * 100).round()}%', AppColors.karmaGreen),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Ayurvedic Nutrition Guidance
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Ayurvedic Nutrition Guidance',
                        regionalText: 'आयुर्वेदिक आहार सुझाव',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.nutritionGuidance,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Ayurvedic Training Guidance
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Training Adaptation',
                        regionalText: 'व्यायाम अनुकूलन',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.trainingGuidance,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),

        // Confirm & Continue Button
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
                  'Continue with Dosha Profile',
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
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: _retakeQuiz,
          child: Text(
            'Retake Quiz',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildDoshaBar(String title, String percent, Color color) {
    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            percent,
            style: AppTypography.titleSmall.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
