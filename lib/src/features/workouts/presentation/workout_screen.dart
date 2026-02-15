import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../domain/workout_model.dart';
import '../data/workout_repository.dart';
import '../application/workout_controller.dart';
import '../../auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  late WorkoutController _controller;
  Timer? _timer;

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
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller.incrementTime();
      if (mounted) setState(() {});
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Check if there's an active workout
    if (_controller.activeWorkout != null) {
      return _buildActiveWorkoutScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
          _buildCategoryChip(WorkoutCategory.yoga, '🧘 Yoga'),
          _buildCategoryChip(WorkoutCategory.bollywood, '💃 Bollywood'),
          _buildCategoryChip(WorkoutCategory.desi, '🏠 Desi'),
          _buildCategoryChip(WorkoutCategory.hiit, '⚡ HIIT'),
          _buildCategoryChip(WorkoutCategory.cardio, '🏃 Cardio'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(WorkoutCategory? category, String label) {
    final isSelected = _controller.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _controller.selectCategory(category),
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    final workouts = _controller.filteredWorkouts;

    if (workouts.isEmpty) {
      return const Center(
        child: Text('No workouts found'),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showWorkoutDetails(workout),
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.titleHindi,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(Icons.timer_outlined, workout.durationDisplay),
                        const SizedBox(width: 12),
                        _buildInfoChip(Icons.local_fire_department, '${workout.caloriesBurned} kcal'),
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
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                      color: Colors.grey[300],
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
                  ),
                ),
                Text(
                  workout.titleHindi,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(Icons.timer_outlined, workout.durationDisplay),
                    const SizedBox(width: 16),
                    _buildInfoChip(Icons.local_fire_department, '${workout.caloriesBurned} kcal'),
                    const SizedBox(width: 16),
                    _buildInfoChip(Icons.fitness_center, workout.difficultyDisplayName),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  workout.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                if (workout.benefits.isNotEmpty) ...[
                  const Text(
                    'Benefits',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: workout.benefits
                        .map((b) => Chip(
                              label: Text(b, style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.green.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                ],
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    _startTimer();
    setState(() {});
  }

  Widget _buildActiveWorkoutScreen() {
    final workout = _controller.activeWorkout!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(workout.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _stopTimer();
            _controller.resetWorkout();
            setState(() {});
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
                  _controller.formattedTime,
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
              workout.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${workout.durationDisplay}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '${workout.caloriesBurned} calories',
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(height: 60),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pause/Resume button
                ElevatedButton.icon(
                  onPressed: () {
                    _controller.toggleWorkoutPause();
                    if (_controller.isWorkoutRunning) {
                      _startTimer();
                    } else {
                      _stopTimer();
                    }
                    setState(() {});
                  },
                  icon: Icon(_controller.isWorkoutRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_controller.isWorkoutRunning ? 'Pause' : 'Resume'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                // Complete button
                ElevatedButton.icon(
                  onPressed: () {
                    _stopTimer();
                    _controller.completeWorkout();
                    _showCompletionDialog();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    int rating = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('🎉 Workout Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Great job! How was your workout?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setDialogState(() => rating = index + 1),
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '${_controller.activeWorkout?.caloriesBurned ?? 0} calories burned',
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
              onPressed: () async {
                Navigator.pop(context);
                // Get current user and log workout
                final user = ref.read(authControllerProvider).value;
                if (user != null) {
                  await _controller.logCompletedWorkout(
                    oderId: user.id,
                    rating: rating,
                  );
                }
                _controller.resetWorkout();
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
