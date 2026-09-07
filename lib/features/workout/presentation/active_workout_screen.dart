import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/workout_models.dart';
import '../providers/workout_provider.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late Timer _sessionStopwatchTimer;
  int _elapsedSeconds = 28 * 60 + 14; // Default starting simulated time: 28m 14s

  Timer? _restCountdownTimer;
  int _restSecondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _sessionStopwatchTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _sessionStopwatchTimer.cancel();
    _restCountdownTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer(int seconds) {
    _restCountdownTimer?.cancel();
    setState(() => _restSecondsRemaining = seconds);

    _restCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 1) {
        if (mounted) setState(() => _restSecondsRemaining--);
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _restSecondsRemaining = 0);
          ref.read(workoutProvider.notifier).clearRestTimer();
        }
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showFinishWorkoutSummary(BuildContext context, WorkoutSession session) {
    final totalTonnage = session.totalVolumeTonnage;
    final completedSetsCount = session.plannedExercises.fold<int>(
      0,
      (sum, e) => sum + e.completedSets.where((s) => s.isCompleted).length,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceElevated,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.karmaGlow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events_rounded, color: AppColors.karmaGreen, size: 24),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: BilingualLabel(
                  primaryText: 'Workout Complete!',
                  regionalText: 'कसरत सफलतापूर्वक संपन्न!',
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(session.title, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GlowingMetric(
                    label: 'Duration',
                    value: _formatDuration(_elapsedSeconds),
                    unit: 'time',
                    accentColor: AppColors.energyOrange,
                  ),
                  GlowingMetric(
                    label: 'Volume',
                    value: '${totalTonnage.round()}',
                    unit: 'kg',
                    isHero: true,
                    accentColor: AppColors.karmaGreen,
                  ),
                  GlowingMetric(
                    label: 'Sets Done',
                    value: '$completedSetsCount',
                    unit: 'sets',
                    accentColor: AppColors.focusBlue,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: AppColors.karmaGreen, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Day Strain: 14.8 / 21.0 (Optimal Overload Zone). Muscle protein synthesis primed for the next 36 hours.',
                        style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.karmaGreen,
                foregroundColor: AppColors.textInverse,
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                ref.read(workoutProvider.notifier).completeWorkout();
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Save & Finish / सहेजें', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutProvider);
    final session = workoutState.todaysSession;
    final totalTonnage = session.totalVolumeTonnage;

    // Trigger rest timer if provider requested it
    if (workoutState.activeRestTimerSeconds != null && _restSecondsRemaining == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startRestTimer(workoutState.activeRestTimerSeconds!);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BilingualLabel(
          primaryText: session.title,
          regionalText: session.regionalTitle,
          alignment: CrossAxisAlignment.center,
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.check_circle_rounded, color: AppColors.karmaGreen, size: 18),
            label: const Text('Finish', style: TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.w800)),
            onPressed: () => _showFinishWorkoutSummary(context, session),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Live Workout Stopwatch & Volume Banner
                  BentoCard(
                    hasGlow: true,
                    glowColor: AppColors.energyOrange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Elapsed Time',
                          value: _formatDuration(_elapsedSeconds),
                          unit: 'live',
                          isHero: true,
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Current Volume',
                          value: '${totalTonnage.round()}',
                          unit: 'kg lifted',
                          accentColor: AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Split',
                          value: session.splitCategory.split(' ')[0],
                          unit: 'Phase',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Exercise Set Logging Cards
                  ...List.generate(session.plannedExercises.length, (exIdx) {
                    final planned = session.plannedExercises[exIdx];
                    final ex = planned.exercise;
                    final isDesi = ex.equipment == EquipmentType.traditionalIndian;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: BentoCard(
                        backgroundColor: AppColors.surfaceElevated,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Exercise Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.name,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
                                      ),
                                      Text(
                                        ex.regionalName,
                                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isDesi ? AppColors.energyOrange : AppColors.focusBlue).withValues(alpha: 0.15),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Text(
                                    ex.equipment.name,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isDesi ? AppColors.energyOrange : AppColors.focusBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Set Logging Table Header
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: 32, child: Text('SET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
                                  Expanded(flex: 3, child: Center(child: Text('PREVIOUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)))),
                                  Expanded(flex: 3, child: Center(child: Text('KG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)))),
                                  Expanded(flex: 3, child: Center(child: Text('REPS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)))),
                                  SizedBox(width: 40, child: Center(child: Text('DONE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)))),
                                ],
                              ),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 8),

                            // Set Rows
                            ...List.generate(planned.completedSets.length, (setIdx) {
                              final currentSet = planned.completedSets[setIdx];

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: currentSet.isCompleted ? AppColors.karmaGreen.withValues(alpha: 0.08) : AppColors.surface,
                                    borderRadius: AppRadii.radiusSm,
                                    border: Border.all(
                                      color: currentSet.isCompleted ? AppColors.karmaGreen.withValues(alpha: 0.4) : AppColors.glassBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Set Number
                                      SizedBox(
                                        width: 28,
                                        child: Text(
                                          '${currentSet.setNumber}',
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textPrimary),
                                        ),
                                      ),
                                      // Previous Ghost Target
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            '${(planned.suggestedWeightKg > 0 ? '${planned.suggestedWeightKg}kg' : 'BW')} × ${planned.targetRepsMin}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                        ),
                                      ),
                                      // Weight Input Display
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: const BoxDecoration(color: AppColors.surfaceElevated, borderRadius: AppRadii.radiusSm),
                                            child: Text(
                                              '${currentSet.weightKg} kg',
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textPrimary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Reps Input Display
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: const BoxDecoration(color: AppColors.surfaceElevated, borderRadius: AppRadii.radiusSm),
                                            child: Text(
                                              '${currentSet.reps} reps',
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textPrimary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Checkmark Done Button
                                      SizedBox(
                                        width: 36,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            currentSet.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                            color: currentSet.isCompleted ? AppColors.karmaGreen : AppColors.textMuted,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            ref.read(workoutProvider.notifier).toggleSetCompletion(exIdx, setIdx);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 6),
                            // Add Set Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.add_rounded, color: AppColors.focusBlue, size: 16),
                                label: const Text('+ Add Set', style: TextStyle(color: AppColors.focusBlue, fontSize: 11, fontWeight: FontWeight.w700)),
                                onPressed: () {
                                  ref.read(workoutProvider.notifier).addSet(exIdx);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // 3. Floating Rest Timer Pill
            if (_restSecondsRemaining > 0)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: BentoCard(
                  hasGlow: true,
                  glowColor: AppColors.focusBlue,
                  backgroundColor: AppColors.surfaceElevatedHigh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer_rounded, color: AppColors.focusBlue, size: 22),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('REST TIMER (विश्राम समय)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                              Text(
                                _formatDuration(_restSecondsRemaining),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.focusBlue),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.glassBorder),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => setState(() => _restSecondsRemaining += 30),
                            child: const Text('+30s', style: TextStyle(color: AppColors.textPrimary, fontSize: 11)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textMuted,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              _restCountdownTimer?.cancel();
                              setState(() => _restSecondsRemaining = 0);
                              ref.read(workoutProvider.notifier).clearRestTimer();
                            },
                            child: const Text('Skip', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
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
