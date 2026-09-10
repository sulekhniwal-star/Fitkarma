import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/ai_roast_models.dart';
import 'providers/ai_roast_provider.dart';

/// Screen displaying AI Roast Mode, Persona Selection,
/// Situational Scenario Testing, and Tough Love Accountability.
class AiRoastScreen extends ConsumerWidget {
  const AiRoastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(aiRoastProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'AI Roast & Tough Love Mode',
          regionalText: 'देसी डांट एवं रोस्ट मोड',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSafetyGuidelinesModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Persona Selector Horizontal Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: RoastPersona.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final p = RoastPersona.values[index];
                  final isSelected = report.activePersona == p;
                  return ChoiceChip(
                    label: Text(
                      p.name.split('(').first.trim(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.alertRed,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (_) =>
                        ref.read(aiRoastProvider.notifier).updatePersona(p),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2. Hero Roast Artifact Card
            _buildHeroRoastCard(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 3. Situational Scenario Trigger Simulator
            const BilingualLabel(
              primaryText: 'Simulate Daily Scenario Triggers',
              regionalText: 'दैनिक बहाने व परिस्थितियां टेस्ट करें',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildScenarioGrid(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 4. Intensity Selector
            const BilingualLabel(
              primaryText: 'Roast Severity & Intensity',
              regionalText: 'डांट एवं व्यंग्य की तीव्रता',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildIntensitySelector(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 5. Accountability Vault Stats
            _buildVaultStatsCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroRoastCard(
    BuildContext context,
    WidgetRef ref,
    AiRoastSystemReport report,
  ) {
    final roast = report.currentRoast;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.alertRed.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.alertRed, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.alertRed, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report.activeIntensity.name.split('(').first.trim(),
                      style: const TextStyle(
                        color: AppColors.alertRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Roast Mode',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: report.isRoastModeEnabled,
                    activeThumbColor: AppColors.alertRed,
                    onChanged: (val) {
                      ref.read(aiRoastProvider.notifier).toggleRoastMode(val);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '"${report.activePersona.catchphrase}"',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.gold,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            roast.headlinePunchline,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.alertRed.withValues(alpha: 0.08),
              borderRadius: AppRadii.radiusSm,
              border:
                  Border.all(color: AppColors.alertRed.withValues(alpha: 0.25)),
            ),
            child: Text(
              roast.fullRoastEnglish,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            roast.fullRoastHindi,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Action Challenge Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.karmaGreen.withValues(alpha: 0.1),
              borderRadius: AppRadii.radiusSm,
              border: Border.all(
                  color: AppColors.karmaGreen.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bolt, color: AppColors.karmaGreen, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Redemption Challenge:',
                        style: TextStyle(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        roast.actionableActionChallenge,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        roast.regionalActionChallenge,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioGrid(
    BuildContext context,
    WidgetRef ref,
    AiRoastSystemReport report,
  ) {
    return BentoCard(
      child: Column(
        children: RoastTriggerEvent.values.map((trigger) {
          final isCurrent = report.currentRoast.trigger == trigger;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 0),
              dense: true,
              tileColor: isCurrent
                  ? AppColors.alertRed.withValues(alpha: 0.1)
                  : AppColors.surfaceElevated,
              shape:
                  const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
              leading: Icon(
                _getTriggerIcon(trigger),
                color: isCurrent ? AppColors.alertRed : AppColors.focusBlue,
                size: 18,
              ),
              title: Text(
                trigger.name,
                style: AppTypography.bodySmall.copyWith(
                  color: isCurrent
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 12, color: AppColors.textSecondary),
              onTap: () {
                ref
                    .read(aiRoastProvider.notifier)
                    .triggerScenarioRoast(trigger);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getTriggerIcon(RoastTriggerEvent trigger) {
    switch (trigger) {
      case RoastTriggerEvent.missedWorkout:
        return Icons.alarm_off;
      case RoastTriggerEvent.lateNightJunkOrder:
        return Icons.fastfood;
      case RoastTriggerEvent.sedentarySlump:
        return Icons.chair;
      case RoastTriggerEvent.skippedWaterHydration:
        return Icons.water_drop_outlined;
      case RoastTriggerEvent.smashingGoals:
        return Icons.emoji_events;
    }
  }

  Widget _buildIntensitySelector(
    BuildContext context,
    WidgetRef ref,
    AiRoastSystemReport report,
  ) {
    return BentoCard(
      child: Column(
        children: RoastIntensity.values.map((intensity) {
          final isSelected = report.activeIntensity == intensity;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: InkWell(
              borderRadius: AppRadii.radiusSm,
              onTap: () =>
                  ref.read(aiRoastProvider.notifier).updateIntensity(intensity),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.alertRed.withValues(alpha: 0.1)
                      : AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(
                    color: isSelected ? AppColors.alertRed : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.alertRed
                          : AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intensity.name,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            intensity.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVaultStatsCard(AiRoastSystemReport report) {
    return BentoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlowingMetric(
            label: 'Roasts Survived',
            value: '${report.totalRoastsSurvived}',
            accentColor: AppColors.alertRed,
          ),
          GlowingMetric(
            label: 'Excuse Debunk Rate',
            value: '${report.excuseDebunkRatePercent.toInt()}%',
            accentColor: AppColors.karmaGreen,
          ),
          GlowingMetric(
            label: 'Active Persona',
            value: report.activePersona.name.split(' ').first,
            accentColor: AppColors.focusBlue,
          ),
        ],
      ),
    );
  }

  void _showSafetyGuidelinesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'AI Roast Mode Safety & Ethics',
                regionalText: 'रोस्ट मोड सुरक्षा एवं आचार संहिता',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma AI Roast Mode is engineered for entertaining, culturally authentic tough love and accountability. It strictly follows guardrails:',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '• Zero hate speech, body shaming, or derogatory slurs.\n• Strictly behavioral: targets habits, procrastination, and excuses.\n• Always pairs roasts with positive physical redemption challenges.\n• Can be toggled off at any moment.',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.alertRed,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understand & Close',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
