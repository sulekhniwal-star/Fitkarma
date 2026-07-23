import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Segmented progress bar shown at the top of onboarding steps 1–5.
///
/// Usage:
/// ```dart
/// OnboardingProgressIndicator(currentStep: 1, totalSteps: 5)
/// ```
class OnboardingProgressIndicator extends StatelessWidget {
  const OnboardingProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  /// Which step the user is currently on (1-indexed).
  final int currentStep;

  /// Total number of steps shown in the indicator (always 5 for onboarding).
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final inactiveColor = isDark
        ? AppColorsDark.surface2
        : AppColorsLight.surface2;
    final textColor = isDark
        ? AppColorsDark.textMuted
        : AppColorsLight.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Segmented pill track
          Row(
            children: List.generate(totalSteps, (index) {
              final segmentStep = index + 1;
              final isActive = segmentStep <= currentStep;
              final isCurrentSegment = segmentStep == currentStep;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: isCurrentSegment
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 6),

          // "N of 5" label aligned to the right
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$currentStep of $totalSteps',
              style: AppTypography.labelMd.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
