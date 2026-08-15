import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../core/brain/calendar_intelligence_engine.dart';
import '../../lifestyle/providers/calendar_provider.dart';

/// §P12-F Calendar-Aware Daily Briefing Card
class CalendarIntelligenceCard extends ConsumerWidget {
  final DayCalendarInsight insight;

  const CalendarIntelligenceCard({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final isConfirmed = calendarState.isPlanConfirmed;
    final isOriginalKept = calendarState.useOriginalPlan;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: 📅 Calendar Intelligence — Today
          Row(
            children: [
              const Text('📅 ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Text(
                  'Calendar Intelligence — Today',
                  style: AppTypography.h3.copyWith(color: AppColors.teal),
                ),
              ),
              if (insight.specialEvent != null &&
                  insight.specialEvent != SpecialEvent.none)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Text(
                    insight.specialEvent!.displayName,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.warning,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Meeting metrics subtitle: 8 meetings · 6.5 hours of calls
          Text(
            insight.summaryHeader,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Workout Adaptation Section
          if (insight.workoutRecommendation.isAdapted) ...[
            Text(
              'Your workout has been adapted:',
              style: AppTypography.labelLg.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.glassBgMid,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Standard: ',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textMuted),
                      ),
                      Text(
                        insight.workoutRecommendation.standardType,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Today:    ',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          insight.workoutRecommendation.type,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.workoutRecommendation.rationale,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Workout: ${insight.workoutRecommendation.type}',
              style:
                  AppTypography.labelLg.copyWith(color: AppColors.textPrimary),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Nutrition Note Section
          Text(
            'Nutrition note:',
            style: AppTypography.labelLg.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            insight.nutritionNote,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Decision Status or Action Buttons
          if (isConfirmed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.success, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Adapted Plan Confirmed',
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (isOriginalKept) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Center(
                child: Text(
                  'Original Plan Retained',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.secondary),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => ref
                        .read(calendarProvider.notifier)
                        .confirmAdaptedPlan(),
                    child: const Text(
                      'Confirm Adapted Plan',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () =>
                        ref.read(calendarProvider.notifier).keepOriginalPlan(),
                    child: const Text(
                      'Keep Original Plan',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
