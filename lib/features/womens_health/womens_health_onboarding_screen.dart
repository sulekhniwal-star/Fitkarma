import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/womens_health/womens_health_controller.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/widgets/onboarding_progress_indicator.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WomensHealthOnboardingScreen extends ConsumerStatefulWidget {
  const WomensHealthOnboardingScreen({super.key});

  @override
  ConsumerState<WomensHealthOnboardingScreen> createState() =>
      _WomensHealthOnboardingScreenState();
}

class _WomensHealthOnboardingScreenState
    extends ConsumerState<WomensHealthOnboardingScreen> {
  void _onBack() {
    final prev = ref.read(onboardingFlowProvider.notifier).back();
    if (prev != null && mounted) {
      context.go(pathForStep(prev));
    }
  }

  Future<void> _onSave() async {
    final db = ref.read(databaseProvider);
    final notifier = ref.read(onboardingWomensHealthProvider.notifier);
    await notifier.saveToDb(db, 'onboarding_user');

    if (mounted) {
      final next = ref.read(onboardingFlowProvider.notifier).advance();
      if (next != null) {
        context.go(pathForStep(next));
      } else {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  Future<void> _onSkip() async {
    final db = ref.read(databaseProvider);
    await db.updateUserProfile(
      userId: 'onboarding_user',
      isCycleTrackingEnabled: false,
    );
    if (mounted) {
      final next = ref.read(onboardingFlowProvider.notifier).skip();
      if (next != null) {
        context.go(pathForStep(next));
      } else {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 45)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColorsDark.primary,
              onPrimary: Colors.white,
              surface: AppColorsDark.surface1,
              onSurface: AppColorsDark.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      ref
          .read(onboardingWomensHealthProvider.notifier)
          .setLastPeriodDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColorsDark.bg0 : AppColorsDark.bg0;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsDark.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsDark.textSecondary;

    final healthState = ref.watch(onboardingWomensHealthProvider);

    // Compute estimated phase if last period date is set
    DynamicCycleState? estCycle;
    WorkoutAdaptation? workoutAdapt;
    if (healthState.isCycleTrackingEnabled &&
        healthState.lastPeriodDate != null) {
      const calibrator = DynamicCycleCalibrator();
      final log = MenstrualSymptomLogWrapper(
        logDate: healthState.lastPeriodDate!,
        hasMenstrualFlow: true,
        physicalSymptoms: const [],
      );
      estCycle = calibrator.recalibratePhase(
        symptomLogs: [log],
        defaultCycleLengthDays: healthState.averageCycleLength,
      );
      workoutAdapt = const CycleAwareTrainingAdapter().adaptForCyclePhase(
        estCycle.currentPhase,
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: _onBack,
        ),
        actions: [
          TextButton(
            onPressed: _onSkip,
            child: Text(
              'Skip',
              style: AppTypography.bodyMd.copyWith(
                color: AppColorsDark.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingProgressIndicator(currentStep: 4, totalSteps: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BilingualLabel(
                      englishText: "Women's Health Sync",
                      hindiText: 'महिला स्वास्थ्य सिंक',
                      englishStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      alignment: CrossAxisAlignment.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optimize workouts and nutrition based on your menstrual cycle phases.',
                      style: AppTypography.bodyMd.copyWith(
                        color: textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Enable/Disable Card
                    BentoCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Cycle Syncing',
                                  style: AppTypography.h3.copyWith(
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Adapts workouts/diet recommendations',
                                  style: AppTypography.bodySm.copyWith(
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: healthState.isCycleTrackingEnabled,
                            activeColor: AppColorsDark.rose,
                            activeTrackColor: AppColorsDark.rose.withOpacity(
                              0.3,
                            ),
                            onChanged: (val) {
                              ref
                                  .read(onboardingWomensHealthProvider.notifier)
                                  .setTrackingEnabled(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (healthState.isCycleTrackingEnabled) ...[
                      // Cycle Length Card
                      BentoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average Cycle Length',
                              style: AppTypography.h3.copyWith(
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Typically 21 to 40 days',
                              style: AppTypography.bodySm.copyWith(
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${healthState.averageCycleLength} Days',
                                  style: AppTypography.h2.copyWith(
                                    color: AppColorsDark.rose,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: healthState.averageCycleLength
                                        .toDouble(),
                                    min: 21,
                                    max: 40,
                                    divisions: 19,
                                    activeColor: AppColorsDark.rose,
                                    inactiveColor: AppColorsDark.surface2,
                                    onChanged: (val) {
                                      ref
                                          .read(
                                            onboardingWomensHealthProvider
                                                .notifier,
                                          )
                                          .setAverageCycleLength(val.round());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Last Period Card
                      BentoCard(
                        onTap: () =>
                            _selectDate(context, healthState.lastPeriodDate),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Period Start Date',
                                  style: AppTypography.h3.copyWith(
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  healthState.lastPeriodDate == null
                                      ? 'Not selected'
                                      : _formatDate(
                                          healthState.lastPeriodDate!,
                                        ),
                                  style: AppTypography.bodyLg.copyWith(
                                    color: healthState.lastPeriodDate == null
                                        ? textSecondary
                                        : AppColorsDark.rose,
                                    fontWeight:
                                        healthState.lastPeriodDate == null
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: AppColorsDark.rose,
                            ),
                          ],
                        ),
                      ),
                      if (estCycle != null && workoutAdapt != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Estimated Current Phase:',
                          style: AppTypography.h3.copyWith(color: textPrimary),
                        ),
                        const SizedBox(height: 12),
                        BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: AppColorsDark.rose,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    estCycle.currentPhase.name.toUpperCase(),
                                    style: AppTypography.h2.copyWith(
                                      color: AppColorsDark.rose,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Day ${estCycle.currentCycleDay} of ${estCycle.projectedCycleLength}',
                                style: AppTypography.labelLg.copyWith(
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                workoutAdapt.rationale,
                                style: AppTypography.bodyMd.copyWith(
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 32),
                    FitButton(
                      onPressed: _onSave,
                      child: const Text('Save and Continue'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
