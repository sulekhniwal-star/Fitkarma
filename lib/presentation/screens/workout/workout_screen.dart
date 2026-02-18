import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/workout_entity.dart';
import '../../providers/workout/workout_bloc.dart';
import '../../providers/auth/auth_bloc.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _titleController = TextEditingController(text: 'Morning Workout');
  final List<ExerciseEntity> _exercises = [];

  void _addExercise() {
    setState(() {
      _exercises.add(const ExerciseEntity(name: 'Push Ups', sets: 3, reps: 12));
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as Authenticated).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Log Workout')),
      body: BlocConsumer<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Workout logged! Earned Karma points.'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Workout Title'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Exercises',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.indianGreen,
                      ),
                      onPressed: _addExercise,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(
                          '${exercise.sets} sets x ${exercise.reps} reps',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            setState(() {
                              _exercises.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _exercises.isEmpty || state is WorkoutLoading
                        ? null
                        : () {
                            final workout = WorkoutEntity(
                              id: '',
                              userId: user.id,
                              title: _titleController.text,
                              exercises: _exercises,
                              date: DateTime.now(),
                              durationMinutes: 30, // Default for now
                            );
                            context.read<WorkoutBloc>().add(
                              LogWorkoutRequested(workout),
                            );
                          },
                    child: state is WorkoutLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Workout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
