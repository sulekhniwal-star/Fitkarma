import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/medication_tracker_engine.dart';

final medicationListProvider = StateProvider<List<MedicationSchedule>>((ref) {
  return [
    MedicationSchedule(
      localId: 'm1',
      medicationName: 'Glycomet 500mg (Metformin)',
      dosage: '1 Tablet Daily',
      scheduledTimes: ['08:00', '20:00'],
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      startDate: DateTime(2026, 1, 1),
      requiresFood: true,
      rxcui: '22501',
    ),
    MedicationSchedule(
      localId: 'm2',
      medicationName: 'Atorva 10mg (Atorvastatin)',
      dosage: '1 Tablet Bedtime',
      scheduledTimes: ['22:00'],
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      startDate: DateTime(2026, 1, 1),
      requiresFood: false,
      rxcui: '83367',
    ),
  ];
});

final currentMealSnapshotProvider = Provider<MealSnapshot>((ref) {
  return const MealSnapshot(
    mealName: 'Lunch Thali',
    carbsGrams: 92.0, // High simple carbs >80g
    foodItems: ['White Rice', 'Dal Fry', 'Grapefruit Juice'],
  );
});

final proposedWorkoutLevelProvider = Provider<WorkoutIntensityLevel>((ref) {
  return WorkoutIntensityLevel.high;
});

final activeInteractionWarningsProvider =
    Provider<List<InteractionWarning>>((ref) {
  final service = const RxNavInteractionService();
  final meds = ref.watch(medicationListProvider);
  final meal = ref.watch(currentMealSnapshotProvider);
  final workout = ref.watch(proposedWorkoutLevelProvider);
  return service.fetchInteractionsOffline(meds, meal, workout);
});

/// §P10-I Medication Tracker & Interaction Warning Screen
/// Route: /medications
class MedicationTrackerScreen extends ConsumerWidget {
  const MedicationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medicationListProvider);
    final warnings = ref.watch(activeInteractionWarningsProvider);

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
        title: Text('💊 Medication Tracker', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Adding new scheduled medication...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Warnings Section
              if (warnings.isNotEmpty) ...[
                Text('⚠️ Interaction Warnings (Real-Time)',
                    style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                for (final warn in warnings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: warn.severity == InteractionSeverity.high
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: warn.severity == InteractionSeverity.high
                              ? AppColors.error.withValues(alpha: 0.3)
                              : AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${warn.severity == InteractionSeverity.high ? "🔴 High Conflict" : "🟡 Moderate Conflict"}: ${warn.sourceMedication}',
                                style: AppTypography.labelLg.copyWith(
                                  color:
                                      warn.severity == InteractionSeverity.high
                                          ? AppColors.error
                                          : AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(warn.message,
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Scheduled Medications List Section
              Text('Scheduled Medications', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              for (final med in meds)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: BentoCard(
                    child: Row(
                      children: [
                        const Icon(Icons.medication_liquid_outlined,
                            color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(med.medicationName,
                                  style: AppTypography.labelLg),
                              const SizedBox(height: 2),
                              Text(
                                  'Dosage: ${med.dosage} • Times: ${med.scheduledTimes.join(", ")}',
                                  style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary)),
                              if (med.requiresFood)
                                Text('• Take with food',
                                    style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.teal,
                                        fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        if (med.rxcui != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.bg1,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('RxCUI: ${med.rxcui}',
                                style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textMuted, fontSize: 10)),
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // NIH RxNav API Sync Badge Card
              GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_done_outlined,
                        color: AppColors.teal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'NIH RxNav Service Active: Local Indian brand dictionary mapped to RxNorm concept IDs.',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.teal, fontSize: 11),
                      ),
                    ),
                  ],
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
