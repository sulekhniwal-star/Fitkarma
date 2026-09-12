import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';

class SleepTrackingScreen extends StatelessWidget {
  final double totalHours;
  final double deepHours;
  final double remHours;
  final double lightHours;
  final double awakeHours;
  final int sleepEfficiency;

  const SleepTrackingScreen({
    super.key,
    this.totalHours = 7.7,
    this.deepHours = 1.8,
    this.remHours = 1.9,
    this.lightHours = 3.5,
    this.awakeHours = 0.5,
    this.sleepEfficiency = 88,
  });

  @override
  Widget build(BuildContext context) {
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
          english: 'Sleep Architecture',
          hindi: 'निद्रा चक्र व विश्राम',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Sleep Duration Bento Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.accentPurple,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingMetric(
                        value: '${totalHours.toStringAsFixed(1)}h',
                        label: 'Total Asleep Time',
                        unit: 'Optimal',
                        glowColor: AppColors.accentPurple,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withAlpha(40),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accentPurple.withAlpha(100)),
                        ),
                        child: Text(
                          'Efficiency $sleepEfficiency%',
                          style: AppTypography.label.copyWith(color: AppColors.accentPurple),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Visual Stage Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 14,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (deepHours * 10).round(),
                            child: Container(color: AppColors.accentPurple),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: (remHours * 10).round(),
                            child: Container(color: AppColors.primaryCyan),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: (lightHours * 10).round(),
                            child: Container(color: AppColors.primaryEmerald.withAlpha(160)),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: (awakeHours * 10).round(),
                            child: Container(color: AppColors.accentCoral.withAlpha(180)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStageLegend('Deep', '${deepHours}h', AppColors.accentPurple),
                      _buildStageLegend('REM', '${remHours}h', AppColors.primaryCyan),
                      _buildStageLegend('Light', '${lightHours}h', AppColors.primaryEmerald),
                      _buildStageLegend('Awake', '${awakeHours}h', AppColors.accentCoral),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 16),

            // Circadian & Ayurvedic Sleep Hygiene
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.nightlight_round, color: AppColors.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text('Ayurvedic Circadian Alignment', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kapha Time (6:00 PM – 10:00 PM) is naturally heavy and conducive to deep restorative slow-wave sleep. Sleeping before 10:30 PM optimizes physical tissue repair and growth hormone secretion.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStageLegend(String name, String duration, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(name, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 2),
        Text(duration, style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}
