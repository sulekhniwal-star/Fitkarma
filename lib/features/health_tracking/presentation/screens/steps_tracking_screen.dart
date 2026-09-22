import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/core/widgets/bilingual_label.dart';
import 'package:fitkarma/core/widgets/glowing_metric.dart';
import 'package:fitkarma/features/health_os/presentation/providers/dashboard_providers.dart';

class StepsTrackingScreen extends ConsumerStatefulWidget {
  final int stepCount;
  final int stepGoal;
  final String primarySource;

  const StepsTrackingScreen({
    super.key,
    this.stepCount = 0,
    this.stepGoal = 10000,
    this.primarySource = 'Wearable Synced',
  });

  @override
  ConsumerState<StepsTrackingScreen> createState() => _StepsTrackingScreenState();
}

class _StepsTrackingScreenState extends ConsumerState<StepsTrackingScreen> {
  Future<void> _logSteps(int additionalSteps) async {
    final userId = ref.read(activeUserIdProvider);
    final repo = ref.read(healthTrackingRepositoryProvider);

    await repo.recordWearableSample(
      userId: userId,
      source: 'fitkarma_tracker',
      metric: 'steps',
      value: additionalSteps.toDouble(),
      unit: 'count',
      timestamp: DateTime.now(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+$additionalSteps steps recorded & synced!'),
          backgroundColor: AppColors.primaryEmerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardStateProvider);
    final currentSteps = dashboard.todaySteps > 0 ? dashboard.todaySteps : widget.stepCount;
    final stepGoal = widget.stepGoal;
    final progress = (currentSteps / stepGoal).clamp(0.0, 1.0);
    final distanceKm = (currentSteps * 0.00075).toStringAsFixed(2);
    final caloriesKcal = (currentSteps * 0.04).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Step Intelligence',
          hindi: 'दैनिक कदम व गतिशीलता',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Hero Progress Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingMetric(
                        value: '$currentSteps',
                        label: 'Steps Today',
                        unit: '/ $stepGoal',
                        glowColor: AppColors.primaryEmerald,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassHover,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.watch, size: 14, color: AppColors.primaryCyan),
                            const SizedBox(width: 6),
                            Text(
                              widget.primarySource,
                              style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: AppColors.surfaceCard,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% completed',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.primaryEmerald),
                      ),
                      Text(
                        '${stepGoal - currentSteps > 0 ? stepGoal - currentSteps : 0} steps left',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 16),

            // Distance & Calories Bento
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.straighten, color: AppColors.primaryCyan, size: 24),
                        const SizedBox(height: 12),
                        Text('$distanceKm km', style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text('Distance Covered', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.accentAmber, size: 24),
                        const SizedBox(height: 12),
                        Text('$caloriesKcal kcal', style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text('Active Burn', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Shatapadi Post-Meal Walking Recommendation
            BentoCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCyan.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_walk, color: AppColors.primaryCyan, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BilingualLabel(
                          english: 'Shatapadi Protocol',
                          hindi: 'शतपदी (भोजनोपरांत १०० कदम)',
                          primaryStyle: AppTypography.h3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A 15-minute gentle walk immediately after heavy meals blunts post-prandial glucose spike by up to 28%.',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Quick Step Logging Buttons
            Text('Quick Step Log', style: AppTypography.h3),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryEmerald,
                      side: const BorderSide(color: AppColors.primaryEmerald),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+1,000 Walk'),
                    onPressed: () => _logSteps(1000),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryCyan,
                      side: const BorderSide(color: AppColors.primaryCyan),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+2,500 Walk'),
                    onPressed: () => _logSteps(2500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
