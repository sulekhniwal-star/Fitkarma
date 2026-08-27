import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../domain/onboarding_flow_step.dart';
import '../providers/onboarding_flow_provider.dart';

class OnboardingContainerScreen extends ConsumerWidget {
  final Widget content;

  const OnboardingContainerScreen({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingFlowProvider);
    final currentStep = onboardingState.currentStep;
    final progress = currentStep.progressPercentage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep != OnboardingFlowStep.welcome
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                onPressed: () => ref.read(onboardingFlowProvider.notifier).previousStep(),
              )
            : null,
        title: Text(
          'Step ${currentStep.index + 1} of ${OnboardingFlowStep.values.length}',
          style: AppTypography.titleSmall,
        ),
        centerTitle: true,
        actions: [
          if (currentStep.canSkip)
            TextButton(
              onPressed: () => ref.read(onboardingFlowProvider.notifier).skipStep(),
              child: Text(
                'Skip',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.focusBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: ClipRRect(
              borderRadius: AppRadii.radiusFull,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceElevated,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.karmaGreen),
                minHeight: 4,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: content,
        ),
      ),
    );
  }
}
