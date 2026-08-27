import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/sleep_intelligence_engine.dart';
import 'sleep_intelligence_card.dart';

class SleepDetailScreen extends StatelessWidget {
  final SleepSessionData session;

  const SleepDetailScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final analysis = SleepIntelligenceEngine.evaluateSleep(session: session);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Sleep Analysis & Stages',
          regionalText: 'नींद की स्थिति एवं चरण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Sleep Card
              SleepIntelligenceCard(session: session),
              const SizedBox(height: AppSpacing.md),

              // Stage Breakdown Details
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Sleep Architecture',
                      regionalText: 'नींद के विभिन्न चरण',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildStageRow('Deep Sleep (गहरी नींद)', '${session.deepSleepMinutes} min', '${(analysis.deepSleepPercent * 100).round()}%', AppColors.focusBlue, 'Physical repair & GH release'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageRow('REM Sleep (सपनों की नींद)', '${session.remSleepMinutes} min', '${(analysis.remSleepPercent * 100).round()}%', AppColors.aiPurple, 'Memory consolidation & mental recovery'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageRow('Light Sleep (हल्की नींद)', '${session.lightSleepMinutes} min', '${((session.lightSleepMinutes / session.actualAsleepMinutes) * 100).round()}%', AppColors.energyOrange, 'Base rest and muscle relaxation'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStageRow('Awake / Latency (जागने का समय)', '${session.awakeMinutes} min', '${session.latencyMinutes}m latency', AppColors.alertRed, 'Nighttime awakenings'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Efficiency Metrics
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GlowingMetric(
                      label: 'Sleep Efficiency',
                      value: '${(session.sleepEfficiency * 100).round()}%',
                      accentColor: AppColors.karmaGreen,
                    ),
                    GlowingMetric(
                      label: 'Sleep Latency',
                      value: '${session.latencyMinutes}m',
                      accentColor: AppColors.focusBlue,
                    ),
                    GlowingMetric(
                      label: 'Sleep Need',
                      value: '${session.userSleepNeedHours}h',
                      accentColor: AppColors.energyOrange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Wind-Down Protocols
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bedtime_rounded, color: AppColors.aiPurple, size: 20),
                        SizedBox(width: 8),
                        BilingualLabel(
                          primaryText: 'Circadian Wind-Down Rituals',
                          regionalText: 'सोने से पहले की तैयारी',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...analysis.windDownProtocols.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: AppColors.karmaGreen, size: 16),
                            const SizedBox(width: 6),
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
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageRow(String stage, String duration, String percent, Color color, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(stage, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            Text('$duration ($percent)', style: AppTypography.bodySmall.copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, top: 2),
          child: Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
        ),
      ],
    );
  }
}
