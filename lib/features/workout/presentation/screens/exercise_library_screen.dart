import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/workout_models.dart';
import '../../domain/services/exercise_database.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final _searchController = TextEditingController();
  MuscleGroup? _selectedGroup;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var exercises = ExerciseDatabase.seededExercises;

    if (_selectedGroup != null) {
      exercises = exercises.where((e) => e.primaryMuscle == _selectedGroup || e.secondaryMuscles.contains(_selectedGroup)).toList();
    }

    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase().trim();
      exercises = exercises.where((e) => e.name.toLowerCase().contains(q) || e.nameHindi.contains(q)).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Exercise Intelligence Library',
          hindi: 'व्यायाम निर्देशिका व बायोमैकेनिक्स',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassHover,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: AppColors.textMuted),
                  hintText: 'Search movements (e.g. Squat, Deadlift, Desi Dand)...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _query = val),
              ),
            ),
          ),

          // Muscle Group Filter Chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedGroup == null,
                    selectedColor: AppColors.primaryCyan,
                    backgroundColor: AppColors.surfaceGlassHover,
                    onSelected: (val) {
                      if (val) setState(() => _selectedGroup = null);
                    },
                  ),
                ),
                ...MuscleGroup.values.map((group) {
                  final isSelected = _selectedGroup == group;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        group.name[0].toUpperCase() + group.name.substring(1),
                        style: AppTypography.label.copyWith(
                          color: isSelected ? AppColors.textOnAccent : AppColors.textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryCyan,
                      backgroundColor: AppColors.surfaceGlassHover,
                      onSelected: (val) {
                        setState(() => _selectedGroup = val ? group : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Exercise Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ex.name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(ex.equipment.name.toUpperCase(), style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryCyan)),
                            ),
                          ],
                        ),
                        Text(ex.nameHindi, style: AppTypography.bilingualSub),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('${ex.defaultSets} Sets × ${ex.defaultMinReps}-${ex.defaultMaxReps} Reps', style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
                            const SizedBox(width: 12),
                            const Text('•', style: TextStyle(color: AppColors.textMuted)),
                            const SizedBox(width: 12),
                            Text('${ex.defaultRestSeconds}s Rest', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                          ],
                        ),
                        const Divider(color: AppColors.borderGlass, height: 16),
                        Text('Form Cues & Joint Protection:', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        ...ex.formCues.map((cue) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.primaryCyan)),
                                  Expanded(
                                    child: Text(cue, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
