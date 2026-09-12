import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import 'blood_pressure_screen.dart';
import 'glucose_tracking_screen.dart';
import 'sleep_tracking_screen.dart';
import 'steps_tracking_screen.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

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
          english: 'Health Intelligence Hub',
          hindi: 'स्वास्थ्य व बायोमार्कर डैशबोर्ड',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryEmerald.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryEmerald.withAlpha(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryEmerald,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Wearables Synced',
                  style: AppTypography.label.copyWith(color: AppColors.primaryEmerald),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Cardiovascular & Metabolic Health Bento
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GlowingMetric(
                        value: 'Optimal',
                        label: 'Preventive Health Index',
                        unit: 'Low Risk',
                        glowColor: AppColors.primaryEmerald,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user, color: AppColors.primaryEmerald, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'All vital markers within physiological targets for Asian-Indian metabolic profile.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            Text('Trackers & Biomarkers', style: AppTypography.h3),
            const SizedBox(height: 12),

            // 2x2 Bento Navigation Grid
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const StepsTrackingScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.directions_walk, color: AppColors.primaryEmerald, size: 28),
                        const SizedBox(height: 12),
                        Text('8,420', style: AppTypography.h2),
                        Text('Steps Today', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SleepTrackingScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.bedtime, color: AppColors.accentPurple, size: 28),
                        const SizedBox(height: 12),
                        Text('7.7 hrs', style: AppTypography.h2),
                        Text('Sleep & Recovery', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BloodPressureScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.favorite_outline, color: AppColors.accentCoral, size: 28),
                        const SizedBox(height: 12),
                        Text('122 / 78', style: AppTypography.h2),
                        Text('Blood Pressure', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GlucoseTrackingScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.water_drop_outlined, color: AppColors.primaryCyan, size: 28),
                        const SizedBox(height: 12),
                        Text('108 mg/dL', style: AppTypography.h2),
                        Text('Fasting Glucose', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
