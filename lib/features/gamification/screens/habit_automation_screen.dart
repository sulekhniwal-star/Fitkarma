import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/habit_automation_provider.dart';

/// §P7-C Habit Automation System Screen
/// Route: /habits
class HabitAutomationScreen extends ConsumerWidget {
  const HabitAutomationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitAutomationProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Smart Habit Automation', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header BentoCard
              BentoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contextual Smart Triggers',
                            style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text(
                          '${state.completedHabitsToday} of ${state.activeTriggers.length} habits completed today',
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const Icon(Icons.auto_awesome,
                        color: AppColors.primary, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text('Active Triggers & Context Nudges', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              for (final trigger in state.activeTriggers)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                trigger.title,
                                style: AppTypography.labelLg.copyWith(
                                  color: trigger.isTriggered
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                trigger.isTriggered
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: trigger.isTriggered
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                              onPressed: () {
                                ref
                                    .read(habitAutomationProvider.notifier)
                                    .markTriggerCompleted(trigger.id);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trigger.message,
                          style: AppTypography.bodySm.copyWith(
                            color: trigger.isTriggered
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
