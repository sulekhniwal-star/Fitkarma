import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../constants/app_colors.dart';
import '../domain/workout_model.dart';
import '../data/workout_repository.dart';
import '../application/workout_controller.dart';

class WorkoutsTabScreen extends ConsumerStatefulWidget {
  const WorkoutsTabScreen({super.key});

  @override
  ConsumerState<WorkoutsTabScreen> createState() => _WorkoutsTabScreenState();
}

class _WorkoutsTabScreenState extends ConsumerState<WorkoutsTabScreen> {
  late WorkoutController _controller;
  WorkoutCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final pb = PocketBase('http://127.0.0.1:8090');
    final repository = WorkoutRepository(pb);
    _controller = WorkoutController(repository);
    await _controller.loadWorkouts();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<WorkoutModel> get _filteredWorkouts {
    if (_selectedCategory == null) return _controller.workouts;
    return _controller.workouts
        .where((w) => w.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Open workout schedule
            },
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: _buildWorkoutList(),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip(null, 'All'),
          const SizedBox(width: 8),
          _buildCategoryChip(WorkoutCategory.yoga, '🧘 Yoga'),
          const SizedBox(width: 8),
          _buildCategoryChip(WorkoutCategory.bollywood, '💃 Bollywood'),
          const SizedBox(width: 8),
          _buildCategoryChip(WorkoutCategory.desi, '🏠 Desi'),
          const SizedBox(width: 8),
          _buildCategoryChip(WorkoutCategory.hiit, '⚡ HIIT'),
          const SizedBox(width: 8),
          _buildCategoryChip(WorkoutCategory.cardio, '🏃 Cardio'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(WorkoutCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildWorkoutList() {
    final workouts = _filteredWorkouts;

    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No workouts found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        return _buildWorkoutCard(workouts[index]);
      },
    );
  }

  Widget _buildWorkoutCard(WorkoutModel workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showWorkoutDetails(workout);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(workout.category),
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Workout info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (workout.titleHindi.isNotEmpty)
                      Text(
                        workout.titleHindi,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(Icons.timer_outlined, workout.durationDisplay),
                        const SizedBox(width: 12),
                        _buildInfoChip(Icons.local_fire_department,
                            '${workout.caloriesBurned} kcal'),
                      ],
                    ),
                  ],
                ),
              ),
              // Start button
              ElevatedButton(
                onPressed: () => _startWorkout(workout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(WorkoutCategory category) {
    switch (category) {
      case WorkoutCategory.yoga:
        return Icons.self_improvement;
      case WorkoutCategory.bollywood:
        return Icons.music_note;
      case WorkoutCategory.desi:
        return Icons.home;
      case WorkoutCategory.hiit:
        return Icons.flash_on;
      case WorkoutCategory.gym:
        return Icons.fitness_center;
      case WorkoutCategory.sports:
        return Icons.sports_cricket;
      case WorkoutCategory.cardio:
        return Icons.directions_run;
    }
  }

  void _showWorkoutDetails(WorkoutModel workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  workout.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (workout.titleHindi.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    workout.titleHindi,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(Icons.timer_outlined, workout.durationDisplay),
                    const SizedBox(width: 16),
                    _buildInfoChip(Icons.local_fire_department,
                        '${workout.caloriesBurned} kcal'),
                    const SizedBox(width: 16),
                    _buildInfoChip(
                        Icons.fitness_center, workout.difficultyDisplayName),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  workout.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startWorkout(workout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Start Workout',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startWorkout(WorkoutModel workout) {
    _controller.startWorkout(workout);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ActiveWorkoutScreen(controller: _controller),
      ),
    );
  }
}

// Active workout screen widget
class _ActiveWorkoutScreen extends StatefulWidget {
  final WorkoutController controller;

  const _ActiveWorkoutScreen({required this.controller});

  @override
  State<_ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<_ActiveWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final workout = widget.controller.activeWorkout;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(workout?.title ?? 'Workout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.controller.resetWorkout();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer display
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                border: Border.all(color: AppColors.primary, width: 4),
              ),
              child: Center(
                child: Text(
                  widget.controller.formattedTime,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Workout info
            Text(
              workout?.title ?? '',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${workout?.durationDisplay ?? ""}',
              style:
                  const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '${workout?.caloriesBurned ?? 0} calories',
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(height: 60),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.controller.toggleWorkoutPause();
                    setState(() {});
                  },
                  icon: Icon(widget.controller.isWorkoutRunning
                      ? Icons.pause
                      : Icons.play_arrow),
                  label: Text(
                      widget.controller.isWorkoutRunning ? 'Pause' : 'Resume'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.controller.completeWorkout();
                    _showCompletionDialog();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('🎉 Workout Complete!',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Great job!',
                style: TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              '${widget.controller.activeWorkout?.caloriesBurned ?? 0} calories burned',
              style: const TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 4),
            const Text(
              '+20 Karma Points earned!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.controller.resetWorkout();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close workout screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
