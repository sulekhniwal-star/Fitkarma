import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import 'blood_pressure_screen.dart';
import 'glucose_tracking_screen.dart';
import 'sleep_tracking_screen.dart';
import 'steps_tracking_screen.dart';

class HealthDashboardScreen extends ConsumerWidget {
  final bool showBackButton;

  const HealthDashboardScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardStateProvider);
    final bpAsync = ref.watch(latestBloodPressureStreamProvider);
    final glucoseAsync = ref.watch(latestGlucoseStreamProvider);
    final sleepAsync = ref.watch(latestSleepStreamProvider);

    final bp = bpAsync.value;
    final glucose = glucoseAsync.value;
    final sleep = sleepAsync.value;

    final bpDisplay = bp != null
        ? '${bp.primaryValue.toInt()} / ${bp.secondaryValue?.toInt() ?? 80}'
        : '-- / --';
    final glucoseDisplay = glucose != null
        ? '${glucose.primaryValue.toInt()} mg/dL'
        : '-- mg/dL';
    final sleepDisplay = sleep != null
        ? '${sleep.value.toStringAsFixed(1)} hrs'
        : '-- hrs';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: (showBackButton && Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
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
                  'Sensors Active',
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
              isGlowing: dashboard.readinessScore != null || bp != null,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingMetric(
                        value: dashboard.readinessScore != null ? '${dashboard.readinessScore}' : 'Live Hub',
                        label: dashboard.readinessLabel,
                        unit: 'Health Status',
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
                    'Biometric and sensor telemetry evaluated against Asian-Indian metabolic thresholds.',
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
                        Text('${dashboard.todaySteps}', style: AppTypography.h2),
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
                        Text(sleepDisplay, style: AppTypography.h2),
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
                        Text(bpDisplay, style: AppTypography.h2),
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
                        Text(glucoseDisplay, style: AppTypography.h2),
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
