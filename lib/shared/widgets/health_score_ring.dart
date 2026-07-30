import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Health score ring widget with color punctuation
class HealthScoreRing extends StatelessWidget {
  final int score; // 0 to 100
  final double size;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 120.0,
  });

  Color get _scoreColor {
    if (score >= 80) return AppColors.primaryEmerald;
    if (score >= 50) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: score / 100.0,
            strokeWidth: 10.0,
            backgroundColor: AppColors.bgSecondary,
            color: _scoreColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score',
              style: AppTypography.displayLarge.copyWith(fontSize: size * 0.3),
            ),
            Text('SCORE', style: AppTypography.labelSmall),
          ],
        ),
      ],
    );
  }
}
