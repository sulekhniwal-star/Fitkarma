import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';

class KarmaHubScreen extends StatelessWidget {
  const KarmaHubScreen({super.key});

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
          english: 'Karma & Discipline Hub',
          hindi: 'कर्म व अनुशासन केंद्र',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Karma Tier Progress Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GlowingMetric(
                        value: '2,450',
                        label: 'Total Karma Points',
                        unit: 'pts',
                        glowColor: AppColors.primaryEmerald,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryEmerald),
                        ),
                        child: Text(
                          'Karma Abhyasi',
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.70, // 2450 / 3500
                      minHeight: 10,
                      backgroundColor: AppColors.surfaceCard,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tier: Abhyasi (अभ्यासी)', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      Text('1,050 pts to Karma Yogi', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Active Habit Streaks Grid
            Text('Active Discipline Streaks', style: AppTypography.h3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.accentAmber, size: 28),
                        const SizedBox(height: 8),
                        Text('7 Days', style: AppTypography.h2),
                        Text('Daily Logging (1.25x)', style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
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
                        const Icon(Icons.fitness_center, color: AppColors.primaryCyan, size: 28),
                        const SizedBox(height: 8),
                        Text('4 Days', style: AppTypography.h2),
                        Text('Workout Consistency', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.directions_walk, color: AppColors.primaryEmerald, size: 28),
                        const SizedBox(height: 8),
                        Text('5 Days', style: AppTypography.h2),
                        Text('10k Steps Target', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
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
                        const Icon(Icons.bedtime, color: AppColors.accentPurple, size: 28),
                        const SizedBox(height: 8),
                        Text('6 Days', style: AppTypography.h2),
                        Text('Circadian Sleep', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Demographic Peer Cohort Percentile Bento
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.groups_outlined, color: AppColors.primaryCyan, size: 24),
                          const SizedBox(width: 8),
                          Text('Demographic Peer Benchmark', style: AppTypography.h3),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassHover,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Text('Indian Males 25–34', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryCyan)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPercentileStat('Top 14%', 'Weekly Tonnage', AppColors.primaryCyan),
                      _buildPercentileStat('Top 22%', 'Daily Steps', AppColors.primaryEmerald),
                      _buildPercentileStat('Top 12%', 'Adherence Index', AppColors.accentAmber),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Text(
                    'Your weekly strength volume places you in the top 14% of urban Indian lifters in your demographic cohort.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Recent Karma Activity Feed
            Text('Recent Karma Earned', style: AppTypography.h3),
            const SizedBox(height: 12),

            _buildActivityItem('Upper Body Push Workout Completed', '+62 pts (1.25x streak bonus)', 'Today, 07:45 AM', Icons.fitness_center),
            _buildActivityItem('Logged High-Protein Indian Lunch', '+25 pts', 'Today, 01:30 PM', Icons.restaurant),
            _buildActivityItem('Completed 8,420 Steps Goal', '+37 pts', 'Yesterday', Icons.directions_walk),
            _buildActivityItem('Circadian Sleep Goal Achieved (7.7 hrs)', '+31 pts', 'Yesterday', Icons.bedtime),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentileStat(String val, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: AppTypography.h2.copyWith(color: color)),
        Text(label, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildActivityItem(String title, String pts, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: BentoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryCyan),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text(time, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            Text(pts, style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
