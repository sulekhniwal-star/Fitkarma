import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/workout_models.dart';
import '../../domain/services/exercise_database.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;
  final List<Exercise> _exercises = [
    ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_barbell_bench_press'),
    ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_barbell_bent_row'),
    ExerciseDatabase.seededExercises.firstWhere((e) => e.id == 'ex_overhead_press'),
  ];

  late List<List<WorkoutSet>> _sessionSets;

  @override
  void initState() {
    super.initState();
    _sessionSets = _exercises.map((ex) {
      return List.generate(
        ex.defaultSets,
        (i) => WorkoutSet(
          setNumber: i + 1,
          weightKg: ex.id == 'ex_barbell_bench_press' ? 70.0 : (ex.id == 'ex_barbell_bent_row' ? 60.0 : 42.5),
          reps: ex.defaultMaxReps,
          rpe: 8,
          isCompleted: false,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentEx = _exercises[_currentExerciseIndex];
    final currentSets = _sessionSets[_currentExerciseIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Live Session Tracker',
          hindi: 'सक्रिय वर्कआउट सत्र',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryEmerald.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryEmerald),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: AppColors.primaryEmerald),
                const SizedBox(width: 4),
                Text('24:18', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
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
            // Exercise Header Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
                        style: AppTypography.label.copyWith(color: AppColors.primaryCyan),
                      ),
                      Text(
                        '${currentEx.equipment.name.toUpperCase()}',
                        style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(currentEx.name, style: AppTypography.h2),
                  Text(currentEx.nameHindi, style: AppTypography.bilingualSub),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.accentAmber, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Overload Target: Hit ${currentEx.defaultMaxReps} reps at RPE 8 to earn +2.5kg increase.',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sets Table Header
            Row(
              children: [
                SizedBox(width: 40, child: Text('SET', style: AppTypography.label.copyWith(color: AppColors.textMuted))),
                Expanded(child: Center(child: Text('KG', style: AppTypography.label.copyWith(color: AppColors.textMuted)))),
                Expanded(child: Center(child: Text('REPS', style: AppTypography.label.copyWith(color: AppColors.textMuted)))),
                Expanded(child: Center(child: Text('RPE', style: AppTypography.label.copyWith(color: AppColors.textMuted)))),
                const SizedBox(width: 48, child: Center(child: Icon(Icons.check, size: 16, color: AppColors.textMuted))),
              ],
            ),
            const SizedBox(height: 8),

            // Sets Input Rows
            ...currentSets.asMap().entries.map((entry) {
              final idx = entry.key;
              final set = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: set.isCompleted ? AppColors.primaryEmerald.withAlpha(25) : AppColors.surfaceGlassHover,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: set.isCompleted ? AppColors.primaryEmerald.withAlpha(100) : AppColors.borderGlass,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${set.setNumber}',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('${set.weightKg.toInt()}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('${set.reps}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('${set.rpe}', style: AppTypography.bodyMedium.copyWith(color: AppColors.accentAmber)),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Checkbox(
                        value: set.isCompleted,
                        activeColor: AppColors.primaryEmerald,
                        onChanged: (val) {
                          setState(() {
                            currentSets[idx] = set.copyWith(isCompleted: val ?? false);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Navigation & Finish Buttons
            Row(
              children: [
                if (_currentExerciseIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.borderGlass),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        setState(() => _currentExerciseIndex--);
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentExerciseIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentExerciseIndex < _exercises.length - 1
                          ? AppColors.primaryCyan
                          : AppColors.primaryEmerald,
                      foregroundColor: AppColors.textOnAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (_currentExerciseIndex < _exercises.length - 1) {
                        setState(() => _currentExerciseIndex++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workout session completed & saved to local database!'),
                            backgroundColor: AppColors.primaryEmerald,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      _currentExerciseIndex < _exercises.length - 1 ? 'Next Exercise' : 'Finish Workout',
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textOnAccent),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
