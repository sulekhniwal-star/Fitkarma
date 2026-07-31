import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Health score ring widget (v1.0)
class HealthScoreRing extends StatelessWidget {
  final int score; // 0 to 100
  final double size;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 120.0,
  });

  Color get _scoreColor {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
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
            strokeWidth: size * 0.08,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.surface2.withOpacity(0.3),
            color: _scoreColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score',
              style: AppTypography.displayMd.copyWith(
                fontSize: size * 0.32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'HEALTH',
              style: AppTypography.labelMd.copyWith(
                fontSize: size * 0.08,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
