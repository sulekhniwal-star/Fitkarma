import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../../recovery_os/domain/sleep_intelligence_engine.dart';
import '../../recovery_os/presentation/sleep_intelligence_card.dart';

final sleepSessionProvider = StateProvider<SleepSessionData>((ref) {
  final now = DateTime.now();
  return SleepSessionData(
    sleepStart: DateTime(now.year, now.month, now.day - 1, 23, 15),
    sleepEnd: DateTime(now.year, now.month, now.day, 7, 0),
    deepSleepMinutes: 95,
    remSleepMinutes: 105,
    lightSleepMinutes: 245,
    awakeMinutes: 20,
    latencyMinutes: 12,
    userSleepNeedHours: 8,
  );
});

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sleepSessionProvider);
    final analysis = SleepIntelligenceEngine.evaluateSleep(session: session);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Sleep & Recovery Architecture',
          regionalText: 'नींद एवं रिकवरी विश्लेषण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Sleep Card
              SleepIntelligenceCard(session: session),
              const SizedBox(height: AppSpacing.md),

              // 2. Stage Breakdown Architecture
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Sleep Stage Architecture',
                      regionalText: 'नींद के विभिन्न चरण',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildStageTile('Deep Sleep (गहरी नींद)', '${session.deepSleepMinutes} min', '${(analysis.deepSleepPercent * 100).round()}%', AppColors.focusBlue, 'Physical repair & growth hormone release'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageTile('REM Sleep (सपनों की नींद)', '${session.remSleepMinutes} min', '${(analysis.remSleepPercent * 100).round()}%', AppColors.aiPurple, 'Neuroplasticity & cognitive restoration'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageTile('Light Sleep (हल्की नींद)', '${session.lightSleepMinutes} min', '${((session.lightSleepMinutes / session.actualAsleepMinutes) * 100).round()}%', AppColors.energyOrange, 'Base rest and muscle recovery'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageTile('Awake / Latency (जागने का समय)', '${session.awakeMinutes} min', '${session.latencyMinutes}m latency', AppColors.alertRed, 'Micro-awakenings and sleep onset latency'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 7-Day Sleep Debt & Bedtime Guidance
              BentoCard(
                hasGlow: analysis.sleepDebtHours > 1.0,
                glowColor: AppColors.energyOrange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Sleep Debt & Circadian Bedtime',
                      regionalText: 'नींद का कर्ज एवं सोने का समय',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: '7-Day Sleep Debt',
                          value: '${analysis.sleepDebtHours.toStringAsFixed(1)}h',
                          unit: 'accumulated',
                          accentColor: analysis.sleepDebtHours > 1.0 ? AppColors.energyOrange : AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Optimal Bedtime',
                          value: analysis.optimalBedtimeWindow,
                          accentColor: AppColors.aiPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Actionable Sleep Hygiene Protocol
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.nightlight_round, color: AppColors.aiPurple, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Wind-Down Protocols',
                            regionalText: 'शाम की शांत दिनचर्या',
                          ),
                          const SizedBox(height: 6),
                          ...analysis.windDownProtocols.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.aiPurple, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      p,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageTile(String title, String duration, String percentage, Color color, String purpose) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                ],
              ),
              Row(
                children: [
                  Text(duration, style: AppTypography.titleSmall.copyWith(color: color, fontSize: 13)),
                  const SizedBox(width: 6),
                  Text('($percentage)', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(purpose, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
