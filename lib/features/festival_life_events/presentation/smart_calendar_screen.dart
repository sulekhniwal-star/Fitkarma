import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/smart_calendar_models.dart';
import 'providers/smart_calendar_provider.dart';

/// Screen displaying Smart Calendar Integration, Micro-window Wellness Allocation,
/// and Cognitive Fatigue Adaptive Workout Pacing.
class SmartCalendarScreen extends ConsumerWidget {
  const SmartCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(smartCalendarProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Smart Calendar & Micro-Windows',
          regionalText: 'कैलेंडर एवं सूक्ष्म स्वास्थ्य समय',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Reset Sample Day',
            onPressed: () => ref.read(smartCalendarProvider.notifier).resetToSampleDay(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.focusBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Event Block', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddEventBottomSheet(context, ref),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Cognitive Fatigue & Meeting Load Bento Card
            _buildHeroLoadCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Pre-Meeting Nutrition & Glucose Timing Card
            _buildMealTimingCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Micro-Wellness Windows List
            const BilingualLabel(
              primaryText: 'Identified Micro-Wellness Slots',
              regionalText: 'उपलब्ध सूक्ष्म स्वास्थ्य व व्यायाम अंतराल',
            ),
            const SizedBox(height: AppSpacing.sm),
            if (report.suggestedSlots.isEmpty)
              _buildEmptySlotsCard()
            else
              ...report.suggestedSlots.map((slot) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildWellnessSlotCard(slot),
                  )),
            const SizedBox(height: AppSpacing.md),

            // 4. Scheduled Calendar Events
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BilingualLabel(
                  primaryText: 'Today\'s Calendar Blocks',
                  regionalText: 'आज की बैठकें व कार्य सूची',
                ),
                if (report.scheduledEvents.isNotEmpty)
                  TextButton(
                    onPressed: () => ref.read(smartCalendarProvider.notifier).clearAllEvents(),
                    child: const Text('Clear All', style: TextStyle(color: AppColors.alertRed, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (report.scheduledEvents.isEmpty)
              _buildEmptyEventsCard()
            else
              ...report.scheduledEvents.map((evt) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildEventBlockCard(ref, evt),
                  )),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLoadCard(SmartCalendarPlanReport report) {
    final isBurnout = report.isHighCognitiveBurnoutDay;
    final loadColor = isBurnout
        ? AppColors.alertRed
        : (report.totalCognitiveLoadScore > 35 ? AppColors.energyOrange : AppColors.karmaGreen);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: loadColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: loadColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isBurnout ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      color: loadColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBurnout ? 'HIGH COGNITIVE STRAIN' : 'BALANCED LOAD',
                      style: TextStyle(
                        color: loadColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${report.scheduledDate.day}/${report.scheduledDate.month}/${report.scheduledDate.year}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Cognitive Load',
                value: '${report.totalCognitiveLoadScore.toInt()}',
                unit: '/100',
                accentColor: loadColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              GlowingMetric(
                label: 'Meeting Hours',
                value: '${report.totalMeetingHours}',
                unit: 'hrs',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Daily Workout Pacing:',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.recommendedWorkoutPacing,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimingCard(SmartCalendarPlanReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timer_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Pre-Meeting Nutrition & Glucose Timing',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.preMeetingMealTimingTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.regionalPreMeetingMealTimingTip,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessSlotCard(SuggestedWellnessSlot slot) {
    final startStr = '${slot.startTime.hour}:${slot.startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${slot.endTime.hour}:${slot.endTime.minute.toString().padLeft(2, '0')}';

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.karmaGreen.withValues(alpha: 0.15),
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: Text(
                      '$startStr - $endStr (${slot.durationMinutes} min)',
                      style: const TextStyle(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              if (slot.isOptimalTime)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.focusBlue.withValues(alpha: 0.15),
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: const Text(
                    'Optimal Window',
                    style: TextStyle(color: AppColors.focusBlue, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            slot.activityName,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            slot.regionalActivityName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            slot.rationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
              fontSize: 11,
            ),
          ),
          Text(
            slot.regionalRationale,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBlockCard(WidgetRef ref, CalendarEventBlock evt) {
    final startStr = '${evt.startTime.hour}:${evt.startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${evt.endTime.hour}:${evt.endTime.minute.toString().padLeft(2, '0')}';

    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: const Icon(Icons.event_note, color: AppColors.focusBlue, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evt.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$startStr - $endStr (${evt.durationMinutes} min) • ${evt.type.name}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 16),
            onPressed: () => ref.read(smartCalendarProvider.notifier).removeEvent(evt.eventId),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlotsCard() {
    return BentoCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            'No free micro-windows identified in the current schedule.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyEventsCard() {
    return BentoCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            'No events scheduled. Tap "+ Add Event Block" below to parse schedule.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  void _showAddEventBottomSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    CalendarEventType selectedType = CalendarEventType.routineWorkBlock;
    int startHour = 10;
    int endHour = 11;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualLabel(
                    primaryText: 'Add Calendar Event Block',
                    regionalText: 'नया कैलेंडर ब्लॉक जोड़ें',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Event / Meeting Title',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: AppRadii.radiusSm,
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Event Category / Stress Type:', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  DropdownButton<CalendarEventType>(
                    value: selectedType,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceElevated,
                    items: CalendarEventType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type.name,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedType = val);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Hour (24h)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                            DropdownButton<int>(
                              value: startHour,
                              dropdownColor: AppColors.surfaceElevated,
                              items: List.generate(24, (i) => i).map((h) {
                                return DropdownMenuItem(value: h, child: Text('$h:00', style: const TextStyle(color: AppColors.textPrimary)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() {
                                    startHour = val;
                                    if (endHour <= startHour) endHour = startHour + 1;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Hour (24h)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                            DropdownButton<int>(
                              value: endHour,
                              dropdownColor: AppColors.surfaceElevated,
                              items: List.generate(24, (i) => i).where((h) => h > startHour).map((h) {
                                return DropdownMenuItem(value: h, child: Text('$h:00', style: const TextStyle(color: AppColors.textPrimary)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => endHour = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.focusBlue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.radiusMd,
                        ),
                      ),
                      onPressed: () {
                        final title = titleController.text.trim().isEmpty ? 'Meeting Block' : titleController.text.trim();
                        final now = DateTime.now();
                        final newEvent = CalendarEventBlock(
                          eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          startTime: DateTime(now.year, now.month, now.day, startHour, 0),
                          endTime: DateTime(now.year, now.month, now.day, endHour, 0),
                          type: selectedType,
                        );
                        ref.read(smartCalendarProvider.notifier).addEvent(newEvent);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add to Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPhilosophyModal(BuildContext context) {
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
                primaryText: 'Smart Calendar Wellness Integration',
                regionalText: 'कैलेंडर आधारित सूक्ष्म स्वास्थ्य विज्ञान',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma parses your busy schedule to find micro-movement windows (5 to 30 mins) such as post-lunch Shatapadi digestive strolls, pre-meeting vagus nerve box breathing buffers, and adapts workout pacing from high-intensity hypertrophy to restorative yoga when cognitive fatigue is elevated.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
