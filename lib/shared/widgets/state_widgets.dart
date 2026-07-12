import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';

class FitLoadingState extends StatefulWidget {
  const FitLoadingState({
    super.key,
    this.message = 'Syncing data...',
    this.hindiMessage = 'डेटा सिंक हो रहा है...',
  });

  final String message;
  final String? hindiMessage;

  @override
  State<FitLoadingState> createState() => _FitLoadingStateState();
}

class _FitLoadingStateState extends State<FitLoadingState> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _controller,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 3.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 18,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor,
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            BilingualLabel(
              englishText: widget.message,
              hindiText: widget.hindiMessage,
              alignment: CrossAxisAlignment.center,
              englishStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FitEmptyState extends StatelessWidget {
  const FitEmptyState({
    super.key,
    required this.englishTitle,
    this.hindiTitle,
    this.englishSubtitle,
    this.hindiSubtitle,
    this.icon = Icons.inbox_rounded,
  });

  final String englishTitle;
  final String? hindiTitle;
  final String? englishSubtitle;
  final String? hindiSubtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final textMuted = isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted;
    final glassColor = isDark ? AppColorsDark.glass : AppColorsLight.glass;
    final glassBorderColor = isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: glassColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: glassBorderColor, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: textMuted,
            ),
            const SizedBox(height: 16.0),
            BilingualLabel(
              englishText: englishTitle,
              hindiText: hindiTitle,
              alignment: CrossAxisAlignment.center,
              englishStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            if (englishSubtitle != null) ...[
              const SizedBox(height: 8.0),
              BilingualLabel(
                englishText: englishSubtitle!,
                hindiText: hindiSubtitle,
                alignment: CrossAxisAlignment.center,
                englishStyle: TextStyle(
                  fontSize: 12.0,
                  color: textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FitErrorState extends StatelessWidget {
  const FitErrorState({
    super.key,
    required this.englishMessage,
    this.hindiMessage,
    required this.onRetry,
  });

  final String englishMessage;
  final String? hindiMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final errorColor = isDark ? AppColorsDark.error : AppColorsLight.error;

    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: errorColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: errorColor.withOpacity(0.3), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: errorColor,
            size: 24,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BilingualLabel(
                  englishText: englishMessage,
                  hindiText: hindiMessage,
                  englishStyle: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Please check connectivity and try again.',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          FitButton(
            onPressed: onRetry,
            type: FitButtonType.secondary,
            height: 36.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            borderRadius: AppRadius.sm,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
